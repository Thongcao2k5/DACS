using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    [Authorize]
    public class ReviewController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;

        public ReviewController(MotoShopDbContext context, UserManager<IdentityUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SubmitReview(int productId, int? variantId, int rating, string comment)
        {
            var userId = _userManager.GetUserId(User);
            var customer = await Microsoft.EntityFrameworkCore.EntityFrameworkQueryableExtensions.FirstOrDefaultAsync(_context.Customers, c => c.UserId == userId);

            if (customer == null) return Json(new { success = false, message = "Không tìm thấy thông tin khách hàng." });

            if (rating < 1 || rating > 5) return Json(new { success = false, message = "Số sao không hợp lệ." });
            if (string.IsNullOrWhiteSpace(comment) || comment.Length < 10) return Json(new { success = false, message = "Nội dung đánh giá tối thiểu 10 ký tự." });

            var review = new ProductReview
            {
                ProductId = productId,
                ProductVariantId = variantId,
                CustomerId = customer.CustomerId,
                Rating = rating,
                Comment = comment,
                CreatedDate = DateTime.Now,
                Status = "Approved" // Tự động duyệt hoặc để "Pending" nếu muốn kiểm duyệt
            };

            _context.ProductReviews.Add(review);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Cảm ơn bạn đã đánh giá sản phẩm!" });
        }
    }
}
