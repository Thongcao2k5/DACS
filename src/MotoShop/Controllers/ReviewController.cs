using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Constants;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Text.RegularExpressions;

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
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);

            if (customer == null) return Json(new { success = false, message = "Không tìm thấy thông tin khách hàng." });
            if (rating < 1 || rating > 5) return Json(new { success = false, message = "Số sao không hợp lệ." });

            // [L2-FIX] Strip HTML tags để ngăn stored XSS
            var sanitizedComment = Regex.Replace(comment ?? "", "<.*?>", " ", RegexOptions.Singleline).Trim();
            sanitizedComment = Regex.Replace(sanitizedComment, @"\s{2,}", " ");

            if (string.IsNullOrWhiteSpace(sanitizedComment) || sanitizedComment.Length < 10)
                return Json(new { success = false, message = "Nội dung đánh giá tối thiểu 10 ký tự." });

            var completedStatuses = new[] { OrderStatusConst.Completed, OrderStatusConst.DaHoanThanh };
            var hasPurchased = await _context.Orders
                .AnyAsync(o => o.CustomerId == customer.CustomerId
                    && completedStatuses.Contains(o.Status!)
                    && o.OrderItems.Any(oi => oi.ProductVariant != null
                        && oi.ProductVariant.ProductId == productId
                        && (!variantId.HasValue || oi.ProductVariantId == variantId.Value)));
            if (!hasPurchased)
                return Json(new { success = false, message = "Bạn chỉ có thể đánh giá sản phẩm đã mua trong đơn hàng hoàn thành." });

            var existed = await _context.ProductReviews
                .AnyAsync(r => r.CustomerId == customer.CustomerId
                    && r.ProductId == productId
                    && r.ProductVariantId == variantId);
            if (existed)
                return Json(new { success = false, message = "Bạn đã đánh giá sản phẩm này rồi." });

            _context.ProductReviews.Add(new ProductReview
            {
                ProductId = productId,
                ProductVariantId = variantId,
                CustomerId = customer.CustomerId,
                Rating = rating,
                Comment = sanitizedComment,
                CreatedDate = DateTime.Now,
                Status = ReviewStatusConst.Pending
            });

            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Cảm ơn bạn đã đánh giá sản phẩm!" });
        }
    }
}
