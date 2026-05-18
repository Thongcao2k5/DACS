using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Constants;
using MotoShop.Data.Data;
using MotoShop.Data.Models;

namespace MotoShop.Controllers
{
    public class ProductReviewAddonController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;

        public ProductReviewAddonController(MotoShopDbContext context, UserManager<IdentityUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SubmitReview([FromBody] ReviewRequest request)
        {
            if (request == null)
                return Json(new { success = false, message = "Dữ liệu đánh giá không hợp lệ." });

            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId))
                return Json(new { success = false, message = "Bạn cần đăng nhập để đánh giá." });

            if (request.Rating < 1 || request.Rating > 5)
                return Json(new { success = false, message = "Đánh giá phải từ 1 đến 5 sao." });

            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null)
                return Json(new { success = false, message = "Không tìm thấy thông tin khách hàng." });

            var completedStatuses = new[] { OrderStatusConst.Completed, OrderStatusConst.DaHoanThanh };
            var orderContainsProduct = await _context.Orders
                .AnyAsync(o => o.OrderId == request.OrderId
                    && o.CustomerId == customer.CustomerId
                    && completedStatuses.Contains(o.Status!)
                    && o.OrderItems.Any(oi => oi.ProductVariant != null
                        && oi.ProductVariant.ProductId == request.ProductId));
            if (!orderContainsProduct)
                return Json(new { success = false, message = "Bạn chỉ có thể đánh giá sản phẩm trong đơn hàng đã hoàn thành." });

            var existed = await _context.ProductReviews
                .AnyAsync(r => r.CustomerId == customer.CustomerId && r.ProductId == request.ProductId);
            if (existed)
                return Json(new { success = false, message = "Bạn đã đánh giá sản phẩm này rồi." });

            _context.ProductReviews.Add(new ProductReview
            {
                ProductId = request.ProductId,
                CustomerId = customer.CustomerId,
                Rating = request.Rating,
                Comment = request.Comment ?? string.Empty,
                CreatedDate = DateTime.Now,
                Status = ReviewStatusConst.Pending
            });
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Cảm ơn bạn đã đánh giá sản phẩm!" });
        }

        public class ReviewRequest
        {
            public int OrderId { get; set; }
            public int ProductId { get; set; }
            public int Rating { get; set; }
            public string? Comment { get; set; }
        }
    }
}
