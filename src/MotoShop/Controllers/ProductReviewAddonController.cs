using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Authorization;
using System.Threading.Tasks;
using System;

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
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId))
                return Json(new { success = false, message = "Bạn cần đăng nhập để đánh giá" });

            if (request.Rating < 1 || request.Rating > 5)
                return Json(new { success = false, message = "Đánh giá phải từ 1 đến 5 sao." });

            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null)
                return Json(new { success = false, message = "Không tìm thấy thông tin khách hàng." });

            // IDOR: orderId phải thuộc về khách hàng hiện tại
            var orderBelongsToUser = await _context.Orders
                .AnyAsync(o => o.OrderId == request.OrderId && o.CustomerId == customer.CustomerId);
            if (!orderBelongsToUser)
                return Json(new { success = false, message = "Đơn hàng không hợp lệ." });

            // Duplicate check dùng SqlQueryRaw (trả về kết quả query, khác ExecuteSqlRawAsync trả về rows affected)
            var existCount = await _context.Database.SqlQueryRaw<int>(
                "SELECT 1 AS Value FROM ProductReviewsNew WHERE OrderId = {0} AND ProductId = {1}",
                request.OrderId, request.ProductId).ToListAsync();
            if (existCount.Count > 0)
                return Json(new { success = false, message = "Bạn đã đánh giá sản phẩm này trong đơn hàng này rồi." });

            string sql = "INSERT INTO ProductReviewsNew (OrderId, ProductId, CustomerId, Rating, Comment, CreatedAt) VALUES ({0}, {1}, {2}, {3}, {4}, {5})";
            await _context.Database.ExecuteSqlRawAsync(sql,
                request.OrderId, request.ProductId, customer.CustomerId,
                request.Rating, request.Comment ?? "", DateTime.Now);

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
