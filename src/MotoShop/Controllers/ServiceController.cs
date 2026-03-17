using Microsoft.AspNetCore.Mvc;

namespace MotoShop.Controllers
{
    public class ServiceController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Detail(string slug)
        {
            return View();
        }

        public IActionResult Booking()
        {
            return View();
        }

        public IActionResult BookingSuccess()
        {
            return View();
        }
    }
}
