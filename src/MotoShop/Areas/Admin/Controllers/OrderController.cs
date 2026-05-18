using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Business.Interfaces;
using MotoShop.Business.Services;
using System.Linq;
using System.Threading.Tasks;
using System.Security.Claims;
using ClosedXML.Excel;
using System.IO;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Microsoft.AspNetCore.Authorization.Authorize(Roles = "Admin")]
    public class OrderController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IOrderService _orderService;
        private readonly IEmailService _emailService;
        private readonly ILogger<OrderController> _logger;
        private readonly IAuditLogService _auditLogService;

        public OrderController(MotoShopDbContext context, IOrderService orderService, IEmailService emailService, ILogger<OrderController> logger, IAuditLogService auditLogService)
        {
            _context = context;
            _orderService = orderService;
            _emailService = emailService;
            _logger = logger;
            _auditLogService = auditLogService;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? status, DateTime? fromDate, DateTime? toDate, string? paymentMethod, int page = 1, int pageSize = 10)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var query = GetFilteredOrdersQuery(searchTerm, status, fromDate, toDate, paymentMethod);

            // 5. Phân trang
            var totalItems = await query.CountAsync();
            var orders = await query
                .OrderByDescending(o => o.OrderDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            ViewBag.FromDate = fromDate?.ToString("yyyy-MM-dd");
            ViewBag.ToDate = toDate?.ToString("yyyy-MM-dd");
            ViewBag.PaymentMethod = paymentMethod;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(orders);
        }

        private IQueryable<Order> GetFilteredOrdersQuery(string? searchTerm, string? status, DateTime? fromDate, DateTime? toDate, string? paymentMethod)
        {
            var query = _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.Payments)
                .AsNoTracking()
                .AsQueryable();

            // 1. Tìm kiếm (OrderCode, Tên khách, SĐT)
            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(o => (o.OrderCode != null && o.OrderCode.Contains(searchTerm)) || 
                                       (o.Customer != null && o.Customer.FullName != null && o.Customer.FullName.Contains(searchTerm)) ||
                                       (o.Customer != null && o.Customer.Phone != null && o.Customer.Phone.Contains(searchTerm)));
            }

            // 2. Lọc theo trạng thái
            if (!string.IsNullOrEmpty(status))
            {
                query = query.Where(o => o.Status == status);
            }

            // 3. Lọc theo khoảng ngày
            if (fromDate.HasValue)
            {
                var startDate = fromDate.Value.Date;
                query = query.Where(o => o.OrderDate >= startDate);
            }
            if (toDate.HasValue)
            {
                var endDate = toDate.Value.Date.AddDays(1).AddTicks(-1);
                query = query.Where(o => o.OrderDate <= endDate);
            }

            // 4. Lọc theo phương thức thanh toán
            if (!string.IsNullOrEmpty(paymentMethod))
            {
                query = query.Where(o => o.Payments.Any(p => p.PaymentMethod == paymentMethod));
            }

            return query;
        }

        public async Task<IActionResult> ExportExcel(string? searchTerm, string? status, DateTime? fromDate, DateTime? toDate, string? paymentMethod)
        {
            var orders = await GetFilteredOrdersQuery(searchTerm, status, fromDate, toDate, paymentMethod)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Danh sách đơn hàng");
                var currentRow = 1;

                // Header
                worksheet.Cell(currentRow, 1).Value = "Mã đơn";
                worksheet.Cell(currentRow, 2).Value = "Khách hàng";
                worksheet.Cell(currentRow, 3).Value = "Số điện thoại";
                worksheet.Cell(currentRow, 4).Value = "Ngày đặt";
                worksheet.Cell(currentRow, 5).Value = "Tổng tiền";
                worksheet.Cell(currentRow, 6).Value = "Trạng thái";
                worksheet.Cell(currentRow, 7).Value = "Thanh toán";
                worksheet.Cell(currentRow, 8).Value = "Địa chỉ nhận hàng";

                // Format Header
                var headerRange = worksheet.Range(1, 1, 1, 8);
                headerRange.Style.Font.Bold = true;
                headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#E24B4A");
                headerRange.Style.Font.FontColor = XLColor.White;

                // Data
                foreach (var order in orders)
                {
                    currentRow++;
                    worksheet.Cell(currentRow, 1).Value = "#" + order.OrderCode;
                    worksheet.Cell(currentRow, 2).Value = order.Customer?.FullName ?? "Khách lẻ";
                    worksheet.Cell(currentRow, 3).Value = order.Customer?.Phone ?? "N/A";
                    worksheet.Cell(currentRow, 4).Value = order.OrderDate.ToString("dd/MM/yyyy HH:mm");
                    worksheet.Cell(currentRow, 5).Value = order.TotalAmount;
                    worksheet.Cell(currentRow, 5).Style.NumberFormat.Format = "#,##0";
                    worksheet.Cell(currentRow, 6).Value = order.Status;
                    worksheet.Cell(currentRow, 7).Value = order.PaymentStatus;
                    worksheet.Cell(currentRow, 8).Value = order.ShippingAddress;
                }

                worksheet.Columns().AdjustToContents();

                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();
                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"Danh_sach_don_hang_{DateTime.Now:yyyyMMddHHmm}.xlsx");
                }
            }
        }

        public async Task<IActionResult> Details(int id)
        {
            var order = await _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant!)
                        .ThenInclude(pv => pv.Product!)
                .Include(o => o.StatusHistories)
                .FirstOrDefaultAsync(o => o.OrderId == id);

            if (order == null) return NotFound();

            return View(order);
        }

        private static readonly Dictionary<string, List<string>> ValidTransitions = new()
        {
            { "Pending", new[] { "Confirmed", "Cancelled" }.ToList() },
            { "Confirmed", new[] { "Shipping", "Cancelled" }.ToList() },
            { "Shipping", new[] { "Completed", "Cancelled" }.ToList() },
            { "Completed", new List<string>() },
            { "Cancelled", new List<string>() }
        };

        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int id, string status)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order == null) return Json(new { success = false, message = "Không tìm thấy đơn hàng" });

            var currentStatus = order.Status ?? "Pending";
            if (!ValidTransitions.ContainsKey(currentStatus) || !ValidTransitions[currentStatus].Contains(status))
            {
                return Json(new { success = false, message = $"Không thể chuyển từ {currentStatus} sang {status}" });
            }

            if (status == "Cancelled")
            {
                // Sử dụng service để có logic hoàn tồn kho
                var customer = _context.Customers.FirstOrDefault(c => c.CustomerId == order.CustomerId);
                var identityUserId = customer?.UserId ?? "";
                var success = await _orderService.CancelOrderAsync(id, identityUserId);
                if (!success) return Json(new { success = false, message = "Lỗi khi hoàn tồn kho" });
            }
            else
            {
                try
                {
                    var strategy = _context.Database.CreateExecutionStrategy();
                    await strategy.ExecuteAsync(async () =>
                    {
                        using var tx = await _context.Database.BeginTransactionAsync();
                        order.Status = status;
                        await _context.SaveChangesAsync();
                        // Cập nhật SoldCount khi đơn hoàn thành — trong cùng transaction
                        if (status == "Completed" || status == "DaHoanThanh")
                            await _orderService.CompleteOrderAsync(id);
                        await tx.CommitAsync();
                    });
                }
                catch (System.Exception ex)
                {
                    _logger.LogError(ex, "UpdateStatus transaction failed for order {OrderId} → {Status}", id, ex.Message);
                    return Json(new { success = false, message = "Lỗi cập nhật trạng thái đơn hàng." });
                }
            }

            _context.OrderStatusHistory.Add(new MotoShop.Data.Models.OrderStatusHistory
            {
                OrderId = id,
                Status = status,
                ChangedDate = DateTime.Now
            });
            await _context.SaveChangesAsync();

            // Gửi email thông báo trạng thái đơn hàng
            if (status == "Shipping" || status == "Completed")
            {
                try
                {
                    var orderForEmail = await _context.Orders
                        .Include(o => o.Customer)
                        .Include(o => o.OrderItems)
                            .ThenInclude(oi => oi.ProductVariant)
                                .ThenInclude(v => v!.Product)
                        .Include(o => o.ShippingMethod)
                        .AsNoTracking()
                        .FirstOrDefaultAsync(o => o.OrderId == id);

                    if (orderForEmail?.Customer?.Email != null)
                    {
                        if (status == "Shipping")
                            await _emailService.SendOrderShippingAsync(orderForEmail);
                        else
                            await _emailService.SendOrderCompletedAsync(orderForEmail);
                    }
                }
                catch (System.Exception ex)
                {
                    _logger.LogError(ex, "Status email failed for order {OrderId} → {Status}", id, status);
                }
            }

            await _auditLogService.LogActionAsync(
                User.FindFirstValue(ClaimTypes.NameIdentifier),
                "STATUS_CHANGE", "Order", id.ToString(),
                currentStatus, status,
                HttpContext.Connection.RemoteIpAddress?.ToString());

            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> Cancel(int id)
        {
            return await UpdateStatus(id, "Cancelled");
        }

        [HttpPost]
        public async Task<IActionResult> BulkDelete([FromBody] int[] ids)
        {
            if (ids == null || ids.Length == 0) return Json(new { success = false });
            
            var orders = await _context.Orders.Where(o => ids.Contains(o.OrderId)).ToListAsync();
            var deletableStatuses = new[] { "Cancelled", "DaHuy" };
            var blocked = orders.Where(o => !deletableStatuses.Contains(o.Status)).Select(o => o.OrderId).ToList();
            if (blocked.Any())
                return Json(new { success = false, message = "Chỉ được xóa đơn đã hủy. Đơn không hợp lệ: " + string.Join(", ", blocked) });

            _context.Orders.RemoveRange(orders);
            await _context.SaveChangesAsync();
            
            return Json(new { success = true, message = $"Đã xóa {orders.Count} đơn hàng" });
        }
    }
}

