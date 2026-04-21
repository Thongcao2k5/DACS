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

            var customer = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == user.Id)
                .FirstOrDefaultAsync();

            if (customer == null)
            {
                customer = new Customer
                {
                    UserId = user.Id,
                    FullName = user.UserName ?? "Khach hang",
                    Email = user.Email,
                    Phone = user.PhoneNumber,
                    CreatedDate = DateTime.Now
                };
                await _unitOfWork.Repository<Customer>().AddAsync(customer);
                await _unitOfWork.CompleteAsync();
            }

            var customerIds = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == user.Id)
                .Select(c => c.CustomerId)
                .ToListAsync();

            var orderQuery = _unitOfWork.Repository<Order>()
                .Find(o => customerIds.Contains(o.CustomerId ?? 0))
                .Include(o => o.OrderItems)
                    .ThenInclude(i => i.ProductVariant)
                        .ThenInclude(v => v.Product)
                .Include(o => o.Payments)
                .Include(o => o.Customer);

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

        public IActionResult Tracking()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> CancelOrder(int id)
        {
            var user = await _userManager.GetUserAsync(User);
            var customer = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == user!.Id)
                .FirstOrDefaultAsync();

            if (customer == null)
            {
                return Json(new { success = false, message = "Khong tim thay thong tin khach hang." });
            }

            var order = await _unitOfWork.Repository<Order>()
                .Find(o => o.OrderId == id && o.CustomerId == customer.CustomerId)
                .FirstOrDefaultAsync();

            if (order == null || order.Status != "Pending")
            {
                return Json(new { success = false, message = "Khong the huy don hang nay." });
            }

            order.Status = "Cancelled";
            _unitOfWork.Repository<Order>().Update(order);
            await _unitOfWork.CompleteAsync();

            return Json(new { success = true, message = "Da huy don hang thanh cong." });
        }
    }
}
