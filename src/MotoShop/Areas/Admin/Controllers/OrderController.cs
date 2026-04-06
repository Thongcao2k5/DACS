using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class OrderController : Controller
    {
        private readonly MotoShopDbContext _context;

        public OrderController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? date, int? month, int? year, string? status)
        {
            var query = _context.Orders
                .Include(o => o.Customer)
                .AsQueryable();

            if (!string.IsNullOrEmpty(date) && DateTime.TryParse(date, out DateTime parsedDate))
            {
                query = query.Where(o => o.OrderDate.Date == parsedDate.Date);
                ViewBag.FilterDate = date;
            }

            if (month.HasValue && year.HasValue)
            {
                query = query.Where(o => o.OrderDate.Month == month.Value && o.OrderDate.Year == year.Value);
                ViewBag.FilterMonth = month;
                ViewBag.FilterYear = year;
            }

            if (!string.IsNullOrEmpty(status))
            {
                query = query.Where(o => o.Status == status);
                ViewBag.FilterStatus = status;
            }

            var orders = await query
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            return View(orders);
        }

        public async Task<IActionResult> Details(int id)
        {
            var order = await _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant)
                        .ThenInclude(pv => pv.Product)
                .FirstOrDefaultAsync(o => o.OrderId == id);

            if (order == null) return NotFound();

            return View(order);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int id, string status)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order == null) return Json(new { success = false });

            order.Status = status;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }
    }
}
