using Microsoft.AspNetCore.Mvc;

namespace MotoShop.Controllers
{
    public class BlogController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Detail(string slug)
        {
            return View();
        }
    }
}
