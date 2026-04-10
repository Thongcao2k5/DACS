    using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;

namespace MotoShop.Controllers
{
    public class ProductController : Controller
    {
        private readonly IProductService _productService;

        public ProductController(IProductService productService)
        {
            _productService = productService;
        }

        // Danh sách sản phẩm
        public async Task<IActionResult> Index(
            string searchTerm,
            int? categoryId,
            int? brandId,
            string sort,
            int page = 1,
            int pageSize = 12)
        {
            var pagedProducts = await _productService.GetPagedProductsAsync(
                searchTerm, categoryId, brandId, sort, page, pageSize
            );

            // Dropdown Category
            ViewBag.CategoryList = new SelectList(
                await _productService.GetAllCategoriesAsync(),
                "CategoryId",
                "CategoryName",
                categoryId
            );

            // Dropdown Brand
            ViewBag.BrandList = new SelectList(
                await _productService.GetAllBrandsAsync(),
                "BrandId",
                "BrandName",
                brandId
            );

            // Dropdown Sort
            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "", Text = "-- Sắp xếp --" },
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = string.IsNullOrEmpty(sort) || sort == "newest" },
                new SelectListItem { Value = "az", Text = "Tên A-Z", Selected = sort == "az" },
                new SelectListItem { Value = "za", Text = "Tên Z-A", Selected = sort == "za" },
                new SelectListItem { Value = "price_asc", Text = "Giá thấp đến cao", Selected = sort == "price_asc" },
                new SelectListItem { Value = "price_desc", Text = "Giá cao đến thấp", Selected = sort == "price_desc" }
            };

            return View(pagedProducts);
        }

        // Chi tiết sản phẩm
        public async Task<IActionResult> Details(string slug)
        {
            var product = await _productService.GetProductBySlugAsync(slug);
            if (product == null) return NotFound();
            return View(product);
        }

        // Sản phẩm theo thương hiệu
        public IActionResult Brand()
        {
            return View();
        }

        // Sản phẩm theo danh mục
        public IActionResult Category()
        {
            return View();
        }

        // Kết quả tìm kiếm
        public IActionResult Search()
        {
            return View();
        }

        // Sản phẩm yêu thích
        public IActionResult Wishlist()
        {
            return View();
        }

        // Chương trình khuyến mãi
        public IActionResult Promotion()
        {
            return View();
        }
    }
}
