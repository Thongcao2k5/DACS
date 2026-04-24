using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Models;
using MotoShop.Data.Interfaces;

namespace MotoShop.Controllers
{
    public class ProductController : Controller
    {
        private readonly IProductService _productService;
        private readonly ICategoryService _categoryService;
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserManager<IdentityUser> _userManager;

        public ProductController(
            IProductService productService, 
            ICategoryService categoryService,
            IUnitOfWork unitOfWork,
            UserManager<IdentityUser> userManager)
        {
            _productService = productService;
            _categoryService = categoryService;
            _unitOfWork = unitOfWork;
            _userManager = userManager;
        }

        // Danh sách sản phẩm (Trang cửa hàng chính)
        public async Task<IActionResult> Index(
            string? searchTerm,
            int? categoryId,
            int? brandId,
            string? sort,
            int page = 1,
            int pageSize = 12)
        {
            // 1. Gọi Service lấy dữ liệu lọc thực tế
            var pagedProducts = await _productService.GetPagedProductsAsync(
                searchTerm, categoryId, brandId, sort, page, pageSize
            );

            // 2. Lấy dữ liệu cho các bộ lọc (Sidebar)
            var categories = await _categoryService.GetAllAsync();
            var brands = await _productService.GetAllBrandsAsync();

            // 3. Chuẩn bị SelectList cho Dropdown (Hiển thị kèm số lượng sản phẩm)
            var categoryItems = categories.Select(c => new {
                CategoryId = c.CategoryId,
                CategoryNameWithCount = $"{c.CategoryName} ({c.ProductCount})"
            });
            ViewBag.CategoryList = new SelectList(categoryItems, "CategoryId", "CategoryNameWithCount", categoryId);
            
            var brandItems = brands.Select(b => new {
                BrandId = b.BrandId,
                BrandNameWithCount = $"{b.BrandName} ({b.ProductCount})"
            });
            ViewBag.BrandList = new SelectList(brandItems, "BrandId", "BrandNameWithCount", brandId);
            
            // 4. Chuẩn bị Danh sách sắp xếp
            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = (sort == "newest" || string.IsNullOrEmpty(sort)) },
                new SelectListItem { Value = "price_asc", Text = "Giá thấp đến cao", Selected = (sort == "price_asc") },
                new SelectListItem { Value = "price_desc", Text = "Giá cao đến thấp", Selected = (sort == "price_desc") },
                new SelectListItem { Value = "az", Text = "Tên A-Z", Selected = (sort == "az") },
                new SelectListItem { Value = "za", Text = "Tên Z-A", Selected = (sort == "za") }
            };

            // 5. Truyền tên danh mục hiện tại để hiển thị tiêu đề
            var currentCat = categories.FirstOrDefault(c => c.CategoryId == categoryId);
            ViewBag.CurrentCategoryName = currentCat?.CategoryName ?? "Tất cả sản phẩm";
            ViewBag.CurrentCategoryId = categoryId;
            
            // 6. Giữ lại các tham số lọc cho phân trang và form
            ViewBag.SearchTerm = searchTerm;
            ViewBag.CurrentBrandId = brandId;
            ViewBag.Sort = sort;

            return View(pagedProducts);
        }

        // Chuyển hướng cho Menu danh mục
        public IActionResult Category(int id)
        {
            return RedirectToAction("Index", new { categoryId = id });
        }

        // Xem chi tiết sản phẩm
        public async Task<IActionResult> Details(string slug)
        {
            var product = await _productService.GetProductBySlugAsync(slug);
            if (product == null) return NotFound();

            // Nhóm thuộc tính từ danh sách VariantAttributeDto đã có trong ProductDto
            ViewBag.AttributeGroups = product.Variants
                .SelectMany(v => v.VariantAttributeValues)
                .GroupBy(av => av.AttributeName ?? "Thuộc tính")
                .ToDictionary(
                    g => g.Key,
                    g => g.Select(av => av.Value).Distinct().ToList()
                );

            // Variant mặc định (đầu tiên còn hàng)
            ViewBag.DefaultVariant = product.Variants
                .OrderByDescending(v => v.StockQuantity > 0)
                .FirstOrDefault() ?? product.Variants.FirstOrDefault();

            // Tồn kho tối đa cho input qty
            ViewBag.MaxStock = product.Variants.Max(v => (int?)v.StockQuantity) ?? 0;

            var userId = _userManager.GetUserId(User);
            
            // Kiểm tra trạng thái yêu thích
            bool isWishlisted = false;
            if (!string.IsNullOrEmpty(userId))
            {
                var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == userId).FirstOrDefaultAsync();
                if (customer != null)
                {
                    isWishlisted = await _unitOfWork.Repository<WishlistNew>().Find(w => w.UserId == customer.CustomerId && w.ProductId == product.ProductId).AnyAsync();
                }
            }
            ViewBag.IsWishlisted = isWishlisted;

            // Kiểm tra đánh giá
            bool canReview = !string.IsNullOrEmpty(userId) && await _productService.CanUserReviewProductAsync(userId, product.ProductId);
            bool hasReviewed = false;
            if (!string.IsNullOrEmpty(userId))
            {
                var customer = await _unitOfWork.Repository<Customer>().Find(c => c.UserId == userId).FirstOrDefaultAsync();
                if (customer != null)
                {
                    hasReviewed = await _unitOfWork.Repository<ProductReview>().Find(r => r.CustomerId == customer.CustomerId && r.ProductId == product.ProductId).AnyAsync();
                }
            }
            ViewBag.CanReview = canReview;
            ViewBag.HasReviewed = hasReviewed;
            ViewBag.IsLoggedIn = !string.IsNullOrEmpty(userId);

            var relatedProducts = await _productService.GetRelatedProductsAsync(
                product.ProductId, 
                product.CategoryId ?? 0, 
                product.BrandId ?? 0, 
                8);

            var vouchers = await _productService.GetVouchersForProductAsync(product.ProductId);

            ViewBag.RelatedProducts = relatedProducts;
            ViewBag.Vouchers = vouchers;

            return View(product);
        }

        // Trang khuyến mãi
        public async Task<IActionResult> Promotion()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GetPromotionProductsJson(int count = 12)
        {
            var products = await _productService.GetPromotionProductsAsync(count);
            return Json(products);
        }
    }
}
