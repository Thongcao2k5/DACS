using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using System.Linq;

namespace MotoShop.Controllers
{
    public class ProductController : Controller
    {
        private readonly IProductService _productService;
        private readonly ICategoryService _categoryService;

        public ProductController(IProductService productService, ICategoryService categoryService)
        {
            _productService = productService;
            _categoryService = categoryService;
        }

        // Danh sách sản phẩm (Trang cửa hàng chính)
        public async Task<IActionResult> Index(
            string? searchTerm,
            int[]? categoryIds,
            int[]? brandIds,
            decimal? minPrice,
            decimal? maxPrice,
            string? sort,
            int page = 1,
            int pageSize = 12)
        {
            // 1. Gọi Service lấy dữ liệu lọc thực tế
            var pagedProducts = await _productService.GetPagedProductsAsync(
                searchTerm, categoryIds, brandIds, minPrice, maxPrice, sort, page, pageSize
            );

            // 2. Lấy dữ liệu cho các bộ lọc (Sidebar)
            var categories = await _categoryService.GetAllAsync();
            var brands = await _productService.GetAllBrandsAsync();

            // 3. Chuẩn bị dữ liệu cho View
            ViewBag.Categories = categories;
            ViewBag.Brands = brands;
            
            // 4. Chuẩn bị Danh sách sắp xếp
            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = (sort == "newest" || string.IsNullOrEmpty(sort)) },
                new SelectListItem { Value = "price_asc", Text = "Giá thấp đến cao", Selected = (sort == "price_asc") },
                new SelectListItem { Value = "price_desc", Text = "Giá cao đến thấp", Selected = (sort == "price_desc") },
                new SelectListItem { Value = "az", Text = "Tên A-Z", Selected = (sort == "az") },
                new SelectListItem { Value = "za", Text = "Tên Z-A", Selected = (sort == "za") }
            };

            // 5. Giữ lại các tham số lọc để hiển thị trên UI
            ViewBag.SearchTerm = searchTerm;
            ViewBag.SelectedCategoryIds = categoryIds ?? Array.Empty<int>();
            ViewBag.SelectedBrandIds = brandIds ?? Array.Empty<int>();
            ViewBag.MinPrice = minPrice;
            ViewBag.MaxPrice = maxPrice;
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
            return View(product);
        }

        // Trang khuyến mãi
        public IActionResult Promotion()
        {
            return View();
        }

        // Danh sách yêu thích
        public IActionResult Wishlist()
        {
            return View();
        }
    }
}
