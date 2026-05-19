using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
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
    private readonly IPromotionService _promotionService;
    private readonly IMemoryCache _cache;
    private readonly MotoShopDbContext _context;

    public HomeController(ILogger<HomeController> logger, IProductService productService, ICategoryService categoryService, IPromotionService promotionService, IMemoryCache cache, MotoShopDbContext context)
    {
        _logger = logger;
        _productService = productService;
        _categoryService = categoryService;
        _promotionService = promotionService;
        _cache = cache;
        _context = context;
    }

    public async Task<IActionResult> Index()
    {
        var categories = await _cache.GetOrCreateAsync(MotoShop.Data.Constants.CacheKeys.HomeCategories, e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(1);
            return _categoryService.GetAllAsync();
        }) ?? await _categoryService.GetAllAsync();

        var featuredProducts = await _cache.GetOrCreateAsync(MotoShop.Data.Constants.CacheKeys.HomeFeatured, e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
            return _productService.GetRandomProductsAsync(8);
        }) ?? await _productService.GetRandomProductsAsync(8);

        var bestSellingProducts = await _cache.GetOrCreateAsync(MotoShop.Data.Constants.CacheKeys.HomeBestSelling, e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
            return _productService.GetRandomProductsAsync(4);
        }) ?? await _productService.GetRandomProductsAsync(4);

        var newProducts = await _cache.GetOrCreateAsync(MotoShop.Data.Constants.CacheKeys.HomeNewProducts, e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5);
            return _productService.GetPagedProductsAsync(null, null, null, "newest", 1, 4);
        }) ?? await _productService.GetPagedProductsAsync(null, null, null, "newest", 1, 4);

        var brandProducts = await _cache.GetOrCreateAsync(MotoShop.Data.Constants.CacheKeys.HomeBrandProducts, e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(15);
            return _productService.GetBrandWithProductsAsync(4, 6);
        }) ?? await _productService.GetBrandWithProductsAsync(4, 6);

        var categoryProducts = await _cache.GetOrCreateAsync(MotoShop.Data.Constants.CacheKeys.HomeCategoryProducts, e => {
            e.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(15);
            return _productService.GetCategoryWithProductsAsync(4, 4);
        }) ?? await _productService.GetCategoryWithProductsAsync(4, 4);

        var topCategories = categories
            .OrderByDescending(c => c.ProductCount)
            .Take(5)
            .ToList();

        ViewBag.BrandWithProducts = brandProducts;
        ViewBag.CategoryWithProducts = categoryProducts;

        var model = new HomeViewModel
        {
            FeaturedProducts = featuredProducts,
            BestSellingProducts = bestSellingProducts,
            NewProducts = newProducts,
            TopCategories = topCategories
        };

        var sliders = await _context.Sliders
            .Where(s => s.IsActive)
            .OrderBy(s => s.Position)
            .ToListAsync();

        var banners = await _context.Banners
            .Where(b => b.IsActive)
            .OrderBy(b => b.DisplayOrder)
            .ToListAsync();

        var recentBlogs = await _context.Blogs
            .Where(b => b.IsPublished)
            .OrderByDescending(b => b.CreatedDate)
            .Take(3)
            .ToListAsync();

        ViewBag.Sliders     = sliders;
        ViewBag.Banners     = banners;
        ViewBag.RecentBlogs = recentBlogs;

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
