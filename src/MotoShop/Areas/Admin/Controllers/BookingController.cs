using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Constants;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Microsoft.AspNetCore.Authorization.Authorize(Roles = "Admin")]
    public class BookingController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IEmailService _emailService;
        private readonly IAuditLogService _auditLogService;

        public BookingController(MotoShopDbContext context, IEmailService emailService, IAuditLogService auditLogService)
        {
            _context = context;
            _emailService = emailService;
            _auditLogService = auditLogService;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? status, DateTime? fromDate, DateTime? toDate, int page = 1, int pageSize = 10)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var query = _context.ServiceBookings
                .Include(b => b.Customer)
                .Include(b => b.Service)
                .AsNoTracking()
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
                query = query.Where(b => (b.BookingCode != null && b.BookingCode.Contains(searchTerm)) || (b.Customer != null && b.Customer.FullName != null && b.Customer.FullName.Contains(searchTerm)));

            if (!string.IsNullOrEmpty(status))
                query = query.Where(b => b.Status == status);

            if (fromDate.HasValue) query = query.Where(b => b.ServiceDate >= fromDate);
            if (toDate.HasValue) query = query.Where(b => b.ServiceDate <= toDate);

            var totalItems = await query.CountAsync();
            var bookings = await query
                .OrderByDescending(b => b.BookingDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(bookings);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int bookingId, string status, string? notes)
        {
            var booking = await _context.ServiceBookings.FindAsync(bookingId);
            if (booking == null) return Json(new { success = false });

            var oldStatus = booking.Status;
            booking.Status = status;
            if ((status == BookingStatusConst.Completed || status == BookingStatusConst.DaHoanThanh) && !booking.CompletedAt.HasValue)
                booking.CompletedAt = DateTime.Now;
            if (!string.IsNullOrEmpty(notes)) booking.Notes = notes;
            await _context.SaveChangesAsync();

            await _auditLogService.LogActionAsync(
                User.FindFirstValue(ClaimTypes.NameIdentifier),
                "STATUS_CHANGE", "Booking", bookingId.ToString(),
                oldStatus, status,
                HttpContext.Connection.RemoteIpAddress?.ToString());

            return Json(new { success = true, message = "Cập nhật trạng thái thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> ApproveDeposit(int bookingId)
        {
            var booking = await _context.ServiceBookings
                .Include(b => b.Service)
                .FirstOrDefaultAsync(b => b.BookingId == bookingId);
            if (booking == null) return Json(new { success = false });

            booking.Status = BookingStatusConst.Confirmed;
            booking.DepositStatus = DepositStatusConst.Paid;
            booking.ConfirmedAt = DateTime.Now;
            await _context.SaveChangesAsync();

            if (!string.IsNullOrEmpty(booking.CustomerEmail))
            {
                var serviceName = booking.Service?.ServiceName ?? "Dịch vụ";
                var serviceDate = booking.ServiceDate?.ToString("dd/MM/yyyy HH:mm") ?? "Chưa xác định";
                var subject = $"[MotoShop] Xác nhận đặt cọc thành công - {booking.BookingCode}";
                var body = $@"
<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;border:1px solid #eee;border-radius:8px;overflow:hidden'>
  <div style='background:#E24B4A;padding:20px;text-align:center'>
    <h2 style='color:#fff;margin:0'>Đặt cọc được xác nhận!</h2>
  </div>
  <div style='padding:30px'>
    <p>Xin chào <b>{booking.CustomerFullName}</b>,</p>
    <p>Cửa hàng <b>MotoShop</b> đã xác nhận khoản đặt cọc của bạn. Chi tiết lịch hẹn:</p>
    <table style='width:100%;border-collapse:collapse;margin:16px 0'>
      <tr style='background:#f8f8f8'><td style='padding:10px;border:1px solid #ddd;font-weight:bold'>Mã lịch hẹn</td><td style='padding:10px;border:1px solid #ddd'>{booking.BookingCode}</td></tr>
      <tr><td style='padding:10px;border:1px solid #ddd;font-weight:bold'>Dịch vụ</td><td style='padding:10px;border:1px solid #ddd'>{serviceName}</td></tr>
      <tr style='background:#f8f8f8'><td style='padding:10px;border:1px solid #ddd;font-weight:bold'>Ngày hẹn</td><td style='padding:10px;border:1px solid #ddd'>{serviceDate}</td></tr>
      <tr><td style='padding:10px;border:1px solid #ddd;font-weight:bold'>Số tiền đặt cọc</td><td style='padding:10px;border:1px solid #ddd;color:#E24B4A;font-weight:bold'>{booking.DepositAmount:N0}₫</td></tr>
    </table>
    <p>Vui lòng có mặt đúng giờ. Mang theo xe và mã lịch hẹn khi đến cửa hàng.</p>
    <p style='color:#888;font-size:13px'>Nếu cần hỗ trợ, liên hệ hotline của cửa hàng.</p>
    <p>Trân trọng,<br/><b>Đội ngũ MotoShop</b></p>
  </div>
</div>";
                try { await _emailService.SendEmailAsync(booking.CustomerEmail, subject, body); }
                catch { /* Không để lỗi email ảnh hưởng đến luồng xác nhận cọc */ }
            }

            await _auditLogService.LogActionAsync(
                User.FindFirstValue(ClaimTypes.NameIdentifier),
                "APPROVE_DEPOSIT", "Booking", bookingId.ToString(),
                null, $"Duyệt cọc booking #{bookingId}",
                HttpContext.Connection.RemoteIpAddress?.ToString());

            return Json(new { success = true, message = "Duyệt cọc thành công!" });
        }

        [HttpPost]
        public async Task<IActionResult> RejectDeposit(int bookingId, string reason)
        {
            var booking = await _context.ServiceBookings.FindAsync(bookingId);
            if (booking == null) return Json(new { success = false });

            booking.Status = MotoShop.Data.Constants.BookingStatusConst.Cancelled;
            booking.CancelReason = reason;
            booking.DepositStatus = DepositStatusConst.Rejected;
            await _context.SaveChangesAsync();

            await _auditLogService.LogActionAsync(
                User.FindFirstValue(ClaimTypes.NameIdentifier),
                "REJECT_DEPOSIT", "Booking", bookingId.ToString(),
                null, $"Từ chối cọc: {reason}",
                HttpContext.Connection.RemoteIpAddress?.ToString());

            return Json(new { success = true, message = "Đã từ chối cọc và hủy lịch." });
        }
    }
}

