using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using System.Linq;

namespace MotoShop.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeApiController : ControllerBase
    {
        private readonly IProductService _productService;
        private readonly ICategoryService _categoryService;
        private readonly ICartService _cartService;
        private readonly UserManager<IdentityUser> _userManager;

        public HomeApiController(
            IProductService productService, 
            ICategoryService categoryService,
            ICartService cartService,
            UserManager<IdentityUser> userManager)
        {
            _productService = productService;
            _categoryService = categoryService;
            _cartService = cartService;
            _userManager = userManager;
        }

        [HttpGet("featured")]
        public async Task<IActionResult> GetFeaturedProducts()
        {
            var products = await _productService.GetFeaturedProductsAsync(8);
            if (products == null || !System.Linq.Enumerable.Any(products))
            {
                var allProducts = await _productService.GetPagedProductsAsync(1, 8);
                products = allProducts; 
            }
            return Ok(products);
        }

        [HttpGet("categories")]
        public async Task<IActionResult> GetCategories()
        {
            var categories = await _categoryService.GetAllAsync();
            var topCategories = categories
                .OrderByDescending(c => c.ProductCount)
                .Take(5)
                .ToList();
                
            return Ok(topCategories);
        }

        [HttpGet("cart-count")]
        public async Task<IActionResult> GetCartCount()
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Ok(new { count = 0 });

            var cart = await _cartService.GetCartAsync(userId);
            return Ok(new { count = cart.Sum(i => i.Quantity) });
        }

        [HttpGet("promotions")]
        public async Task<IActionResult> GetPromotionProducts()
        {
            var products = await _productService.GetFeaturedProductsAsync(12); 
            return Ok(products);
        }
    }
}
