using Microsoft.AspNetCore.Mvc;

namespace MotoShop.Controllers
{
    public class CartController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Checkout()
        {
            return View();
        }

        public IActionResult Success()
        {
            return View();
        }
    }
}
