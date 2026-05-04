using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using Microsoft.AspNetCore.Identity;
using System.Threading.Tasks;
using System;
using System.Linq;

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
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> SubmitReview([FromBody] ReviewRequest request)
        {
            var userId = _userManager.GetUserId(User);
            if (string.IsNullOrEmpty(userId)) return Json(new { success = false, message = "Bạn cần đăng nhập để đánh giá" });

            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return Json(new { success = false });

            // Kiểm tra xem đã đánh giá chưa
            var existed = await _context.Database.ExecuteSqlRawAsync(
                "SELECT COUNT(*) FROM ProductReviewsNew WHERE OrderId = {0} AND ProductId = {1}", 
                request.OrderId, request.ProductId);

            string sql = "INSERT INTO ProductReviewsNew (OrderId, ProductId, CustomerId, Rating, Comment, CreatedAt) VALUES ({0}, {1}, {2}, {3}, {4}, {5})";
            await _context.Database.ExecuteSqlRawAsync(sql, request.OrderId, request.ProductId, customer.CustomerId, request.Rating, request.Comment ?? "", DateTime.Now);

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
