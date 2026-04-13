using Microsoft.AspNetCore.Mvc;

namespace MotoShop.Controllers
{
    public class ServiceController : Controller
    {
        public IActionResult Index()
        {
            // Trong thực tế, bạn có thể lấy danh sách dịch vụ từ Database tại đây
            return View();
        }
    }
}
