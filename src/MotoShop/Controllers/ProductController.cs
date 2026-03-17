using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;

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
        public async Task<IActionResult> Index(int page = 1, int pageSize = 12)
        {
            var pagedProducts = await _productService.GetPagedProductsAsync(page, pageSize);
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
