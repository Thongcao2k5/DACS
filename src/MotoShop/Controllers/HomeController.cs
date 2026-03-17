using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Models;
using MotoShop.Models;
using MotoShop.Models.ViewModels;
using System.Diagnostics;
using System.Threading.Tasks;

namespace MotoShop.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly IProductService _productService;

    public HomeController(ILogger<HomeController> logger, IProductService productService)
    {
        _logger = logger;
        _productService = productService;
    }

    public async Task<IActionResult> Index()
    {
        var model = new HomeViewModel
        {
            FeaturedProducts = await _productService.GetFeaturedProductsAsync(8),
            BestSellingProducts = await _productService.GetFeaturedProductsAsync(4), // Demo: use same service for now
            NewProducts = await _productService.GetFeaturedProductsAsync(4) // Demo: use same service for now
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
