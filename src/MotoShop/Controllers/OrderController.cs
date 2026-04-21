using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class OrderController : Controller
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IOrderService _orderService;

        public OrderController(IUnitOfWork unitOfWork, IOrderService orderService)
        {
            _unitOfWork = unitOfWork;
            _orderService = orderService;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> Tracking(int id)
        {
            var order = await _unitOfWork.Repository<Order>()
                .Find(o => o.OrderId == id)
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
        public async Task<IActionResult> CancelOrder(int id, string reason)
        {
            var success = await _orderService.CancelOrderAsync(id, reason);
            if (success) return Json(new { success = true, message = "Đã hủy đơn hàng thành công." });
            return Json(new { success = false, message = "Không thể hủy đơn hàng vào lúc này." });
        }

        [HttpPost]
        public async Task<IActionResult> UpdateShipping(int id, string fullName, string phone, string address)
        {
            var order = await _unitOfWork.Repository<Order>().GetByIdAsync(id);
            if (order == null || order.Status != "Pending") 
                return Json(new { success = false, message = "Không thể cập nhật thông tin lúc này." });

            order.ShippingAddress = $"{fullName} | {phone} | {address}";
            _unitOfWork.Repository<Order>().Update(order);
            await _unitOfWork.CompleteAsync();

            return Json(new { success = true, message = "Đã cập nhật thông tin giao hàng thành công." });
        }
    }
}
