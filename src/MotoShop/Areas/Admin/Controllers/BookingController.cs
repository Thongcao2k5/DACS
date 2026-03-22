using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class BookingController : Controller
    {
        private readonly MotoShopDbContext _context;

        public BookingController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var bookings = await _context.ServiceBookings
                .Include(b => b.Customer)
                .Include(b => b.Service)
                .OrderByDescending(b => b.BookingDate)
                .ToListAsync();
            return View(bookings);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int id, string status)
        {
            var booking = await _context.ServiceBookings.FindAsync(id);
            if (booking == null) return Json(new { success = false });

            booking.Status = status;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }
    }
}
