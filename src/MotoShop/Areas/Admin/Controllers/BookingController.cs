using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
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

        public async Task<IActionResult> Index(string? searchTerm, string? status, DateTime? fromDate, DateTime? toDate, int? staffId, int page = 1, int pageSize = 10)
        {
            var query = _context.ServiceBookings
                .Include(b => b.Customer)
                .Include(b => b.Service)
                .Include(b => b.AssignedStaff)
                .AsNoTracking()
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
                query = query.Where(b => (b.BookingCode != null && b.BookingCode.Contains(searchTerm)) || (b.Customer != null && b.Customer.FullName != null && b.Customer.FullName.Contains(searchTerm)));

            if (!string.IsNullOrEmpty(status))
                query = query.Where(b => b.Status == status);

            if (fromDate.HasValue) query = query.Where(b => b.ServiceDate >= fromDate);
            if (toDate.HasValue) query = query.Where(b => b.ServiceDate <= toDate);
            if (staffId.HasValue) query = query.Where(b => b.AssignedStaffId == staffId);

            var totalItems = await query.CountAsync();
            var bookings = await query
                .OrderByDescending(b => b.BookingDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.Staffs = await _context.Staffs.ToListAsync();
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(bookings);
        }

        [HttpPost]
        public async Task<IActionResult> AssignStaff(int bookingId, int staffId, string? notes)
        {
            var booking = await _context.ServiceBookings.FindAsync(bookingId);
            if (booking == null) return Json(new { success = false });

            booking.AssignedStaffId = staffId;
            booking.Notes = notes;
            booking.Status = "Processing"; // Khi phân công thì tự động chuyển sang Đang thực hiện
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Phân công thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int bookingId, string status, string? notes)
        {
            var booking = await _context.ServiceBookings.FindAsync(bookingId);
            if (booking == null) return Json(new { success = false });

            booking.Status = status;
            if (!string.IsNullOrEmpty(notes)) booking.Notes = notes;
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Cập nhật trạng thái thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> ApproveDeposit(int bookingId)
        {
            var booking = await _context.ServiceBookings.FindAsync(bookingId);
            if (booking == null) return Json(new { success = false });

            booking.Status = "Confirmed";
            booking.DepositStatus = "Paid";
            booking.ConfirmedAt = DateTime.Now;
            await _context.SaveChangesAsync();
            
            // TODO: Gửi Email/SMS thông báo
            
            return Json(new { success = true, message = "Duyệt cọc thành công!" });
        }

        [HttpPost]
        public async Task<IActionResult> RejectDeposit(int bookingId, string reason)
        {
            var booking = await _context.ServiceBookings.FindAsync(bookingId);
            if (booking == null) return Json(new { success = false });

            booking.Status = "Cancelled";
            booking.CancelReason = reason;
            booking.DepositStatus = "Rejected";
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Đã từ chối cọc và hủy lịch." });
        }
    }
}
