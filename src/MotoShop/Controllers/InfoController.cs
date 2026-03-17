using Microsoft.AspNetCore.Mvc;

namespace MotoShop.Controllers
{
    public class InfoController : Controller
    {
        public IActionResult AboutUs()
        {
            return View();
        }

        public IActionResult Contact()
        {
            return View();
        }

        public IActionResult Branches()
        {
            return View();
        }

        public IActionResult PrivacyPolicy()
        {
            return View();
        }

        public IActionResult ReturnPolicy()
        {
            return View();
        }

        public IActionResult ShippingPolicy()
        {
            return View();
        }

        public IActionResult TermsOfService()
        {
            return View();
        }

        public IActionResult WarrantyPolicy()
        {
            return View();
        }

        public IActionResult Page404()
        {
            return View();
        }
    }
}
