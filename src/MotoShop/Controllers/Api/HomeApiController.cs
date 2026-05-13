using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;
using System.Linq;
using System;
using System.Collections.Generic;

namespace MotoShop.Controllers.Api
{
    [Route("api/[controller]")]
    [ApiController]
    public class HomeApiController : ControllerBase
    {
        private readonly IProductService _productService;
        private readonly ICategoryService _categoryService;
        private readonly ICartService _cartService;
        private readonly IFlashSaleService _flashSaleService;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly MotoShopDbContext _context;

        public HomeApiController(
            IProductService productService, 
            ICategoryService categoryService,
            ICartService cartService,
            IFlashSaleService flashSaleService,
            UserManager<IdentityUser> userManager,
            MotoShopDbContext context)
        {
            _productService = productService;
            _categoryService = categoryService;
            _cartService = cartService;
            _flashSaleService = flashSaleService;
            _userManager = userManager;
            _context = context;
        }

        [HttpGet("featured")]
        public async Task<IActionResult> GetFeaturedProducts()
        {
            var products = await _productService.GetFeaturedProductsAsync(8);
            return Ok(products);
        }

        [HttpGet("flash-sale")]
        public async Task<IActionResult> GetFlashSale()
        {
            var mainSale = await _productService.GetActiveFlashSaleAsync();
            return Ok(mainSale);
        }

        [HttpGet("products/discount")]
        public async Task<IActionResult> GetDiscountProducts(int pageNumber = 1, int pageSize = 12, string sort = "newest")
        {
            pageNumber = Math.Max(1, pageNumber);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var pagedResult = await _productService.GetPagedDiscountProductsAsync(pageNumber, pageSize, sort);

            return Ok(new {
                items = pagedResult,
                pageNumber = pagedResult.CurrentPage,
                pageCount = pagedResult.TotalPages,
                totalCount = pagedResult.TotalCount
            });
        }

        [HttpGet("promotions")]
        public async Task<IActionResult> GetPromotionProducts()
        {
            var activeSales = await _flashSaleService.GetActiveFlashSalesAsync();
            return Ok(activeSales);
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
    }
}
