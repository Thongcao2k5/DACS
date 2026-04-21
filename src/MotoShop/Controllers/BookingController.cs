using Microsoft.AspNetCore.Mvc;

namespace MotoShop.Controllers
{
    public class BookingController : Controller
    {
        // Chuyển hướng các request từ /Booking/Create?id=X sang /Service/Booking?serviceId=X
        public IActionResult Create(int? id)
        {
            return RedirectToAction("Booking", "Service", new { serviceId = id });
        }
    }
}
