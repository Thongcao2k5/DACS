using Microsoft.AspNetCore.Mvc;

namespace MotoShop.Controllers
{
    public class OrderController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Detail(string id)
        {
            return View();
        }

        public IActionResult Tracking()
        {
            return View();
        }
    }
}
