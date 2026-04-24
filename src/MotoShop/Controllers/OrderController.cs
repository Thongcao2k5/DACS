using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    [Authorize]
    public class OrderController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IOrderService _orderService;
        private readonly ICartService _cartService;

        public OrderController(
            MotoShopDbContext context, 
            UserManager<IdentityUser> userManager,
            IOrderService orderService,
            ICartService cartService)
        {
            _context = context;
            _userManager = userManager;
            _orderService = orderService;
            _cartService = cartService;
        }

        private async Task<int> GetCurrentCustomerIdAsync()
        {
            var identityUserId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == identityUserId);
            return customer?.CustomerId ?? 0;
        }

        private string GetUserId() => _userManager.GetUserId(User)!;

        [HttpGet]
        public async Task<IActionResult> Index(string status = "all", int page = 1)
        {
            int customerId = await GetCurrentCustomerIdAsync();
            if (customerId == 0) return RedirectToAction("Login", "Account");

            int pageSize = 5; // Yêu cầu 5 đơn/trang

            var query = _context.Orders
                .Where(o => o.CustomerId == customerId)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant)
                        .ThenInclude(pv => pv.Product)
                .OrderByDescending(o => o.OrderDate)
                .AsQueryable();

            if (status != "all")
            {
                // Hỗ trợ lọc cả 2 định danh trạng thái để tránh sót dữ liệu
                if (status == "DangXuLy")
                    query = query.Where(o => o.Status == "DangXuLy" || o.Status == "Pending");
                else if (status == "DangGiao")
                    query = query.Where(o => o.Status == "DangGiao" || o.Status == "Shipping");
                else if (status == "DaHoanThanh")
                    query = query.Where(o => o.Status == "DaHoanThanh" || o.Status == "Completed");
                else if (status == "DaHuy")
                    query = query.Where(o => o.Status == "DaHuy" || o.Status == "Cancelled");
                else
                    query = query.Where(o => o.Status == status);
            }

            var totalItems = await query.CountAsync();
            var orders = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var model = new OrderListViewModel
            {
                CurrentStatus = status,
                CurrentPage = page,
                TotalCount = totalItems,
                TotalPages = (int)Math.Ceiling((double)totalItems / pageSize),
                Orders = orders.Select(o => MapToOrderCard(o)).ToList()
            };

            return View(model);
        }

        private OrderCardViewModel MapToOrderCard(Order o)
        {
            var card = new OrderCardViewModel
            {
                Id = o.OrderId,
                OrderCode = o.OrderCode ?? $"MS-{o.OrderId}",
                OrderDate = o.OrderDate,
                Status = o.Status ?? "DangXuLy",
                TotalAmount = o.TotalAmount,
                PaymentStatus = o.PaymentStatus,
                PaymentMethod = o.Payments?.FirstOrDefault()?.PaymentMethod ?? "Tiền mặt (COD)",
                Note = o.Note,
                Items = o.OrderItems.Take(2).Select(oi => new OrderItemViewModel
                {
                    ProductName = oi.ProductVariant?.VariantName ?? "Sản phẩm đã xóa",
                    ProductImage = oi.ProductVariant?.ImageUrl ?? "/assets/img/elements/18.jpg",
                    Quantity = oi.Quantity,
                    UnitPrice = oi.Price
                }).ToList()
            };

            // Gán Label và Badge class (PHẦN 3)
            switch (card.Status)
            {
                case "DangXuLy":
                case "Pending":
                    card.StatusLabel = "Đang xử lý";
                    card.StatusBadgeClass = "badge-warning";
                    card.CanCancel = true;
                    break;
                case "DangGiao":
                case "Shipping":
                    card.StatusLabel = "Đang giao hàng";
                    card.StatusBadgeClass = "badge-info";
                    card.CanTrack = true;
                    break;
                case "DaHoanThanh":
                case "Completed":
                    card.StatusLabel = "Đã hoàn thành";
                    card.StatusBadgeClass = "badge-success";
                    card.CanReorder = true;
                    break;
                case "DaHuy":
                case "Cancelled":
                    card.StatusLabel = "Đã hủy";
                    card.StatusBadgeClass = "badge-danger";
                    break;
                default:
                    card.StatusLabel = card.Status;
                    card.StatusBadgeClass = "badge-secondary";
                    break;
            }

            return card;
        }

        [HttpGet]
        public async Task<IActionResult> Detail(int id)
        {
            int customerId = await GetCurrentCustomerIdAsync();
            
            var order = await _context.Orders
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant)
                        .ThenInclude(pv => pv.Product)
                .Include(o => o.ShippingMethod)
                .Include(o => o.Coupon)
                .Include(o => o.StatusHistories)
                .FirstOrDefaultAsync(o => o.OrderId == id && o.CustomerId == customerId);

            if (order == null) return NotFound();

            var model = new OrderDetailViewModel
            {
                OrderInfo = MapToOrderCard(order),
                ShippingAddress = order.ShippingAddress ?? "",
                ShippingFee = order.ShippingMethod?.Cost ?? 0,
                VoucherCode = order.Coupon?.Code,
                Discount = order.DiscountAmount,
                Timeline = order.StatusHistories.Select(h => new OrderStatusStepViewModel
                {
                    Status = h.Status ?? "",
                    ChangedDate = h.ChangedDate,
                    IsCompleted = true,
                    Description = GetStatusDescription(h.Status ?? "")
                }).OrderBy(h => h.ChangedDate).ToList()
            };

            return View(model);
        }

        private string GetStatusDescription(string status)
        {
            return status switch
            {
                "Pending" or "DangXuLy" => "Đơn hàng đã được tiếp nhận và đang chờ xử lý.",
                "Confirmed" => "Đơn hàng đã được xác nhận.",
                "Shipping" or "DangGiao" => "Đơn hàng đang được vận chuyển đến bạn.",
                "Completed" or "DaHoanThanh" => "Đơn hàng đã được giao thành công.",
                "Cancelled" or "DaHuy" => "Đơn hàng đã bị hủy.",
                _ => "Trạng thái đơn hàng đã thay đổi."
            };
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Cancel(int id, string reason)
        {
            int customerId = await GetCurrentCustomerIdAsync();
            var order = await _context.Orders.FirstOrDefaultAsync(o => o.OrderId == id && o.CustomerId == customerId);

            if (order == null) return Json(new { success = false, message = "Không tìm thấy đơn hàng" });

            if (order.Status != "Pending" && order.Status != "DangXuLy")
            {
                return Json(new { success = false, message = "Không thể hủy đơn đang giao hoặc đã hoàn thành" });
            }

            var success = await _orderService.CancelOrderAsync(id, reason);
            if (success)
            {
                return Json(new { success = true, message = "Đã hủy đơn hàng thành công" });
            }

            return Json(new { success = false, message = "Có lỗi xảy ra khi hủy đơn hàng" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Reorder(int id)
        {
            int customerId = await GetCurrentCustomerIdAsync();
            var order = await _context.Orders
                .Include(o => o.OrderItems)
                .FirstOrDefaultAsync(o => o.OrderId == id && o.CustomerId == customerId);

            if (order == null) return Json(new { success = false, message = "Không tìm thấy đơn hàng" });

            string userId = GetUserId();
            int count = 0;

            foreach (var item in order.OrderItems)
            {
                if (item.ProductVariantId.HasValue)
                {
                    // Thêm vào giỏ hàng
                    var success = await _cartService.AddToCartAsync(userId, item.ProductVariantId.Value, item.Quantity);
                    if (success) count++;
                }
            }

            int cartCount = await _cartService.GetCartCountAsync(userId);

            return Json(new { 
                success = true, 
                cartCount = cartCount, 
                message = $"Đã thêm {count} sản phẩm vào giỏ hàng",
                redirectUrl = "/Cart" 
            });
        }

        [HttpPost]
        public IActionResult Tracking(int id)
        {
            // Trả về thông tin theo dõi đơn hàng (PHẦN 3)
            return Json(new { success = true, message = "Đơn hàng đang trên đường giao. Dự kiến giao trong 2-3 ngày tới." });
        }
    }
}
