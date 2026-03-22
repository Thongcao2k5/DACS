using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class ReviewController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ReviewController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var reviews = await _context.ProductReviews
                .Include(r => r.Product)
                .Include(r => r.Customer)
                .OrderByDescending(r => r.CreatedDate)
                .ToListAsync();
            return View(reviews);
        }

        [HttpPost]
        public async Task<IActionResult> Approve(int id)
        {
            var review = await _context.ProductReviews.FindAsync(id);
            if (review == null) return Json(new { success = false });

            review.IsApproved = true;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> Hide(int id)
        {
            var review = await _context.ProductReviews.FindAsync(id);
            if (review == null) return Json(new { success = false });

            review.IsApproved = false;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }
    }
}
