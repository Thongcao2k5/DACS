using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Route("Admin/[controller]/[action]")]
    [Route("Admin/Shipping")]
    public class ShippingMethodController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ShippingMethodController(MotoShopDbContext context)
        {
            _context = context;
        }

        [Route("")]
        public async Task<IActionResult> Index()
        {
            var methods = await _context.ShippingMethods.OrderByDescending(m => m.Id).ToListAsync();
            return View(methods);
        }

        [HttpPost]
        public async Task<IActionResult> Save(ShippingMethod method)
        {
            if (method.Id == 0)
            {
                _context.ShippingMethods.Add(method);
            }
            else
            {
                _context.Update(method);
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Lưu thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> ToggleStatus(int id)
        {
            var method = await _context.ShippingMethods.FindAsync(id);
            if (method == null) return Json(new { success = false });

            method.IsActive = !method.IsActive;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var method = await _context.ShippingMethods.FindAsync(id);
            if (method == null) return Json(new { success = false });

            _context.ShippingMethods.Remove(method);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa phương thức vận chuyển" });
        }
    }
}
