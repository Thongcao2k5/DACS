using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Business.DTOs;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Models;
using MotoShop.Data.Interfaces;
using System;

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
            decimal? minPrice,
            decimal? maxPrice,
            bool? inStock,
            bool? onSale,
            string? sort,
            int page = 1,
            int pageSize = 12)
        {
            // 1. Gọi Service lấy dữ liệu lọc thực tế
            var pagedProducts = await _productService.GetPagedProductsAsync(
                searchTerm, categoryId, brandId, sort, page, pageSize, minPrice, maxPrice, inStock, onSale
            );

            // 2. Lấy dữ liệu cho các bộ lọc (Sidebar)
            var categories = await _categoryService.GetAllAsync();
            var brands = await _productService.GetAllBrandsAsync();

            // 3. Chuẩn bị SelectList
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
            
            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = (sort == "newest" || string.IsNullOrEmpty(sort)) },
                new SelectListItem { Value = "price_asc", Text = "Giá thấp đến cao", Selected = (sort == "price_asc") },
                new SelectListItem { Value = "price_desc", Text = "Giá cao đến thấp", Selected = (sort == "price_desc") },
                new SelectListItem { Value = "az", Text = "Tên A-Z", Selected = (sort == "az") },
                new SelectListItem { Value = "za", Text = "Tên Z-A", Selected = (sort == "za") }
            };

            // 4. Tính toán số lượng hiển thị (FIX 5)
            int from = pagedProducts.TotalCount > 0 ? (page - 1) * pageSize + 1 : 0;
            int to = Math.Min(page * pageSize, pagedProducts.TotalCount);
            ViewBag.From = from;
            ViewBag.To = to;
            ViewBag.TotalProducts = pagedProducts.TotalCount;

            // 5. Tiêu đề động (FIX 1)
            var currentCat = categories.FirstOrDefault(c => c.CategoryId == categoryId);
            var currentBrand = brands.FirstOrDefault(b => b.BrandId == brandId);
            ViewBag.CategoryName = currentCat?.CategoryName;
            ViewBag.BrandName = currentBrand?.BrandName;

            // 6. Giá lớn nhất cho Slider
            ViewBag.MaxPriceLimit = await _productService.GetMaxProductPriceAsync();
            ViewBag.SelectedMinPrice = minPrice ?? 0;
            ViewBag.SelectedMaxPrice = maxPrice ?? ViewBag.MaxPriceLimit;

            // 7. Gợi ý từ khóa nếu không có kết quả (TÍNH NĂNG 7)
            if (pagedProducts.TotalCount == 0 && !string.IsNullOrEmpty(searchTerm))
            {
                // Logic đơn giản: lấy các từ khóa phổ biến
                ViewBag.Suggestions = new List<string> { "Nhớt Motul", "Vỏ xe", "Nhông sên dĩa" }; 
            }

            // Giữ lại các tham số lọc
            ViewBag.SearchTerm = searchTerm;
            ViewBag.CurrentCategoryId = categoryId;
            ViewBag.CurrentBrandId = brandId;
            ViewBag.Sort = sort;
            ViewBag.InStock = inStock;
            ViewBag.OnSale = onSale;

            if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            {
                return PartialView("_ProductGridPartial", pagedProducts);
            }

            return View(pagedProducts);
        }

        [HttpGet]
        public async Task<IActionResult> SearchSuggestions(string term)
        {
            if (string.IsNullOrWhiteSpace(term) || term.Length < 2)
                return Json(new { products = new List<object>(), categories = new List<object>(), brands = new List<object>() });

            var search = term.Trim().ToLower();

            var products = await _unitOfWork.Repository<Product>().Find(p => p.IsActive && p.ProductName.ToLower().Contains(search))
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .Take(5)
                .Select(p => new {
                    p.ProductId,
                    p.ProductName,
                    p.Slug,
                    ImageUrl = p.Images.Where(i => i.IsPrimary).Select(i => i.ImageUrl).FirstOrDefault() ?? p.Images.Select(i => i.ImageUrl).FirstOrDefault(),
                    MinPrice = p.Variants.Any() ? p.Variants.Min(v => v.Price) : 0
                })
                .ToListAsync();

            var categories = await _unitOfWork.Repository<Category>().Find(c => c.CategoryName.ToLower().Contains(search))
                .Take(3)
                .Select(c => new {
                    c.CategoryId,
                    c.CategoryName,
                    Count = _unitOfWork.Repository<Product>().Find(p => p.CategoryId == c.CategoryId && p.IsActive).Count()
                })
                .ToListAsync();

            var brands = await _unitOfWork.Repository<Brand>().Find(b => b.BrandName.ToLower().Contains(search))
                .Take(3)
                .Select(b => new {
                    b.BrandId,
                    b.BrandName,
                    Count = _unitOfWork.Repository<Product>().Find(p => p.BrandId == b.BrandId && p.IsActive).Count()
                })
                .ToListAsync();

            return Json(new { products, categories, brands });
        }

        [HttpGet]
        public async Task<IActionResult> QuickView(string slug)
        {
            var product = await _productService.GetProductBySlugAsync(slug);
            if (product == null) return NotFound();

            return PartialView("_QuickViewPartial", product);
        }

        public async Task<IActionResult> Compare(string ids)
        {
            if (string.IsNullOrEmpty(ids)) return RedirectToAction("Index");
            
            var idList = ids.Split(',').Select(int.Parse).ToList();
            var products = new List<ProductDto>();
            foreach (var id in idList)
            {
                var p = await _unitOfWork.Repository<Product>().Find(x => x.ProductId == id)
                    .Include(x => x.Variants).FirstOrDefaultAsync();
                if (p != null) products.Add(new ProductDto { /* map manually or use mapper */ });
            }
            // Implementation of comparison view...
            return View(products);
        }

        public IActionResult Category(int id)
        {
            return RedirectToAction("Index", new { categoryId = id });
        }

        public async Task<IActionResult> Details(string slug)
        {
            var product = await _productService.GetProductBySlugAsync(slug);
            if (product == null) return NotFound();

            ViewBag.AttributeGroups = product.Variants
                .SelectMany(v => v.VariantAttributeValues)
                .GroupBy(av => av.AttributeName ?? "Thuộc tính")
                .ToDictionary(
                    g => g.Key,
                    g => g.Select(av => av.Value).Distinct().ToList()
                );

            ViewBag.DefaultVariant = product.Variants
                .OrderByDescending(v => v.StockQuantity > 0)
                .FirstOrDefault() ?? product.Variants.FirstOrDefault();

            ViewBag.MaxStock = product.Variants.Max(v => (int?)v.StockQuantity) ?? 0;

            var userId = _userManager.GetUserId(User);
            
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
