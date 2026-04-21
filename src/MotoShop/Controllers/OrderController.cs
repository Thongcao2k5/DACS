using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    [Authorize]
    public class OrderController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly UserManager<IdentityUser> _userManager;

        public OrderController(IUnitOfWork unitOfWork, UserManager<IdentityUser> userManager)
        {
            _unitOfWork = unitOfWork;
            _userManager = userManager;
        }

        public IActionResult Index()
        {
            return RedirectToAction("Orders", "Account");
        }

        [HttpGet("Order/Detail/{id}")]
        [HttpGet("Order/Details/{id}")]
        public async Task<IActionResult> Detail(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var user = await _userManager.GetUserAsync(User);
            if (user == null) return RedirectToAction("Login", "Account");

            var customerIds = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == user.Id)
                .Select(c => c.CustomerId)
                .ToListAsync();

            if (!customerIds.Any()) return NotFound();

            var orderQuery = _unitOfWork.Repository<Order>()
                .Find(o => customerIds.Contains(o.CustomerId ?? 0))
                .Include(o => o.OrderItems)
                    .ThenInclude(i => i.ProductVariant)
                        .ThenInclude(v => v.Product)
                .Include(o => o.Payments)
                .Include(o => o.Customer)
                .Include(o => o.ShippingMethod)
                .Include(o => o.Coupon);

            Order? order = null;
            if (int.TryParse(id, out var orderId))
            {
                order = await orderQuery.FirstOrDefaultAsync(o => o.OrderId == orderId);
            }

            if (order == null)
            {
                order = await orderQuery.FirstOrDefaultAsync(o => o.OrderCode == id);
            }

            if (order == null) return NotFound();

            return View(order);
        }

        [HttpGet]
        public IActionResult Tracking()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> Tracking(int id)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return RedirectToAction("Login", "Account");

            var customerIds = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == user.Id)
                .Select(c => c.CustomerId)
                .ToListAsync();

            if (!customerIds.Any()) return NotFound();

            var order = await _unitOfWork.Repository<Order>()
                .Find(o => o.OrderId == id && customerIds.Contains(o.CustomerId ?? 0))
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant)
                        .ThenInclude(pv => pv.Product)
                .Include(o => o.ShippingMethod)
                .Include(o => o.Coupon)
                .Include(o => o.Payments)
                .FirstOrDefaultAsync();

            if (order == null) return NotFound();

            return View(order);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateShipping(int id, string fullName, string phone, string address)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Json(new { success = false, message = "Phiên đăng nhập hết hạn." });

            var customerIds = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == user.Id)
                .Select(c => c.CustomerId)
                .ToListAsync();

            var order = await _unitOfWork.Repository<Order>()
                .Find(o => o.OrderId == id && customerIds.Contains(o.CustomerId ?? 0))
                .FirstOrDefaultAsync();

            if (order == null || order.Status != "Pending")
            {
                return Json(new { success = false, message = "Không thể cập nhật thông tin lúc này." });
            }

            order.ShippingAddress = $"{fullName} | {phone} | {address}";
            _unitOfWork.Repository<Order>().Update(order);
            await _unitOfWork.CompleteAsync();

            return Json(new { success = true, message = "Đã cập nhật thông tin giao hàng thành công." });
        }

        [HttpPost]
        public async Task<IActionResult> CancelOrder(int id, string? reason)
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return Json(new { success = false, message = "Phiên đăng nhập hết hạn." });

            var customerIds = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == user.Id)
                .Select(c => c.CustomerId)
                .ToListAsync();

            var order = await _unitOfWork.Repository<Order>()
                .Find(o => o.OrderId == id && customerIds.Contains(o.CustomerId ?? 0))
                .FirstOrDefaultAsync();

            if (order == null || order.Status != "Pending")
            {
                return Json(new { success = false, message = "Không thể hủy đơn hàng này." });
            }

            order.Status = "Cancelled";
            if (!string.IsNullOrWhiteSpace(reason))
            {
                order.Note = string.IsNullOrWhiteSpace(order.Note)
                    ? $"Lý do hủy: {reason}"
                    : $"{order.Note}\nLý do hủy: {reason}";
            }

            _unitOfWork.Repository<Order>().Update(order);
            await _unitOfWork.CompleteAsync();

            return Json(new { success = true, message = "Đã hủy đơn hàng thành công." });
        }
    }
}
