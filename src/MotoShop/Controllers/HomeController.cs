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
        // Lấy tất cả danh mục và sắp xếp theo số lượng sản phẩm giảm dần, lấy top 5
        var categories = await _categoryService.GetAllAsync();
        var topCategories = categories
            .OrderByDescending(c => c.ProductCount)
            .Take(5)
            .ToList();

        // Lấy sản phẩm mới nhất (thực sự mới)
        var newProducts = await _productService.GetPagedProductsAsync(null, null, null, "newest", 1, 4);

        var model = new HomeViewModel
        {
            FeaturedProducts = await _productService.GetRandomProductsAsync(8),
            BestSellingProducts = await _productService.GetRandomProductsAsync(4), 
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
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
