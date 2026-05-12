using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using MotoShop.Business.Interfaces;
using MotoShop.Models;
using MotoShop.Models.ViewModels;
using System;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Linq;
using System.Collections.Generic;

namespace MotoShop.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly IProductService _productService;
    private readonly ICategoryService _categoryService;
    private readonly IMemoryCache _cache;

    public HomeController(ILogger<HomeController> logger, IProductService productService, ICategoryService categoryService, IMemoryCache cache)
    {
        _logger = logger;
        _productService = productService;
        _categoryService = categoryService;
        _cache = cache;
    }

    public async Task<IActionResult> Index()
    {
        var categories = await _cache.GetOrCreateAsync("home_categories", e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1);
            return _categoryService.GetAllAsync();
        }) ?? await _categoryService.GetAllAsync();

        var featuredProducts = await _cache.GetOrCreateAsync("home_featured_8", e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
            return _productService.GetRandomProductsAsync(8);
        }) ?? await _productService.GetRandomProductsAsync(8);

        var bestSellingProducts = await _cache.GetOrCreateAsync("home_bestselling_4", e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
            return _productService.GetRandomProductsAsync(4);
        }) ?? await _productService.GetRandomProductsAsync(4);

        var newProducts = await _cache.GetOrCreateAsync("home_new_products", e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5);
            return _productService.GetPagedProductsAsync(null, null, null, "newest", 1, 4);
        }) ?? await _productService.GetPagedProductsAsync(null, null, null, "newest", 1, 4);

        var flashSale = await _cache.GetOrCreateAsync("home_flash_sale", e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(2);
            return _productService.GetActiveFlashSaleAsync();
        });

        var brandProducts = await _cache.GetOrCreateAsync("home_brand_products", e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(15);
            return _productService.GetBrandWithProductsAsync(4, 6);
        }) ?? await _productService.GetBrandWithProductsAsync(4, 6);

        var categoryProducts = await _cache.GetOrCreateAsync("home_category_products", e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(15);
            return _productService.GetCategoryWithProductsAsync(4, 4);
        }) ?? await _productService.GetCategoryWithProductsAsync(4, 4);

        var topCategories = categories
            .OrderByDescending(c => c.ProductCount)
            .Take(5)
            .ToList();

        ViewBag.FlashSale = flashSale;
        ViewBag.BrandWithProducts = brandProducts;
        ViewBag.CategoryWithProducts = categoryProducts;

        var model = new HomeViewModel
        {
            FeaturedProducts = featuredProducts,
            BestSellingProducts = bestSellingProducts,
            NewProducts = newProducts,
            TopCategories = topCategories
        };
        return View(model);
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    [Route("Home/Error/{statusCode?}")]
    public IActionResult Error(int? statusCode)
    {
        if (statusCode == 404)
        {
            return View("Page404");
        }
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
