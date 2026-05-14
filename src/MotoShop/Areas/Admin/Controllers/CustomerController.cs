using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;
using ClosedXML.Excel;
using System.IO;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Microsoft.AspNetCore.Authorization.Authorize(Roles = "Admin")]
    public class CustomerController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IAuditLogService _auditLogService;
        private readonly UserManager<IdentityUser> _userManager;

        public CustomerController(MotoShopDbContext context, IAuditLogService auditLogService, UserManager<IdentityUser> userManager)
        {
            _context = context;
            _auditLogService = auditLogService;
            _userManager = userManager;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? status, int page = 1, int pageSize = 10)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);
            
            var query = GetFilteredCustomersQuery(searchTerm, status);

            var totalItems = await query.CountAsync();
            var customers = await query
                .OrderByDescending(c => c.CreatedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(customers);
        }

        private IQueryable<Customer> GetFilteredCustomersQuery(string? searchTerm, string? status)
        {
            var query = _context.Customers
                .Include(c => c.Orders)
                .AsNoTracking()
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(c => c.FullName.Contains(searchTerm) ||
                                       (c.Email != null && c.Email.Contains(searchTerm)) ||
                                       (c.Phone != null && c.Phone.Contains(searchTerm)));
            }

            if (!string.IsNullOrEmpty(status))
            {
                bool isLocked = status == "Locked";
                query = query.Where(c => c.IsLocked == isLocked);
            }

            return query;
        }

        public async Task<IActionResult> Details(int id)
        {
            var customer = await _context.Customers
                .Include(c => c.Addresses)
                .Include(c => c.Orders).ThenInclude(o => o.OrderItems)
                .FirstOrDefaultAsync(c => c.CustomerId == id);

            if (customer == null) return NotFound();

            // Lấy lịch sử dịch vụ (nếu có bảng ServiceBookings liên kết)
            var serviceHistory = await _context.ServiceBookings
                .Include(s => s.Service)
                .Where(s => s.CustomerId == id)
                .OrderByDescending(s => s.BookingDate)
                .ToListAsync();

            ViewBag.ServiceHistory = serviceHistory;
            
            // Thống kê
            ViewBag.TotalSpend = customer.Orders.Where(o => o.Status != "Cancelled").Sum(o => o.TotalAmount);
            ViewBag.CompletedOrders = customer.Orders.Count(o => o.Status == "Completed");

            return View(customer);
        }

        [HttpPost]
        public async Task<IActionResult> ToggleStatus(int id)
        {
            var customer = await _context.Customers.FindAsync(id);
            if (customer == null) return Json(new { success = false });

            customer.IsLocked = !customer.IsLocked;
            await _context.SaveChangesAsync();

            var action = customer.IsLocked ? "Lock" : "Unlock";
            var adminId = _userManager.GetUserId(User);
            await _auditLogService.LogActionAsync(adminId, action, "User", id.ToString(),
                null, $"{(customer.IsLocked ? "Khóa" : "Mở khóa")} tài khoản: {customer.FullName}",
                HttpContext.Connection.RemoteIpAddress?.ToString());

            string msg = customer.IsLocked ? "Đã khóa tài khoản" : "Đã mở khóa tài khoản";
            return Json(new { success = true, message = msg, isLocked = customer.IsLocked });
        }

        public async Task<IActionResult> ExportExcel(string? searchTerm, string? status)
        {
            var customers = await GetFilteredCustomersQuery(searchTerm, status).ToListAsync();

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("KhachHang");
                var currentRow = 1;
                string[] headers = { "Họ tên", "Email", "SĐT", "Ngày đăng ký", "Tổng đơn", "Trạng thái" };
                for (int i = 0; i < headers.Length; i++) worksheet.Cell(1, i + 1).Value = headers[i];

                var headerRange = worksheet.Range(1, 1, 1, headers.Length);
                headerRange.Style.Font.Bold = true;
                headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#E24B4A");
                headerRange.Style.Font.FontColor = XLColor.White;

                foreach (var c in customers)
                {
                    currentRow++;
                    worksheet.Cell(currentRow, 1).Value = c.FullName;
                    worksheet.Cell(currentRow, 2).Value = c.Email;
                    worksheet.Cell(currentRow, 3).Value = c.Phone;
                    worksheet.Cell(currentRow, 4).Value = c.CreatedDate.ToString("dd/MM/yyyy");
                    worksheet.Cell(currentRow, 5).Value = c.Orders.Count;
                    worksheet.Cell(currentRow, 6).Value = c.IsLocked ? "Bị khóa" : "Hoạt động";
                }

                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream()) {
                    workbook.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"KhachHang_{DateTime.Now:yyyyMMdd}.xlsx");
                }
            }
        }
    }
}

