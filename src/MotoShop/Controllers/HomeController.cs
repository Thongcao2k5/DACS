using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Models;
using MotoShop.Models.ViewModels;
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

    public HomeController(ILogger<HomeController> logger, IProductService productService, ICategoryService categoryService)
    {
        _logger = logger;
        _productService = productService;
        _categoryService = categoryService;
    }

    public async Task<IActionResult> Index()
    {
        // Thực hiện tuần tự để tránh lỗi DbContext concurrency (A second operation was started...)
        var categories = await _categoryService.GetAllAsync();
        var featuredProducts = await _productService.GetRandomProductsAsync(8);
        var bestSellingProducts = await _productService.GetRandomProductsAsync(4);
        var newProducts = await _productService.GetPagedProductsAsync(null, null, null, "newest", 1, 4);
        
        // CÁC TÍNH NĂNG MỚI
        var flashSale = await _productService.GetActiveFlashSaleAsync();
        var brandProducts = await _productService.GetBrandWithProductsAsync(4, 6);
        var categoryProducts = await _productService.GetCategoryWithProductsAsync(4, 4);

        var topCategories = categories
            .OrderByDescending(c => c.ProductCount)
            .Take(5)
            .ToList();

        // Gán dữ liệu cho ViewBag
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
