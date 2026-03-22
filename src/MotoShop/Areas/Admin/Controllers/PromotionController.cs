using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class PromotionController : Controller
    {
        private readonly MotoShopDbContext _context;

        public PromotionController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var promotions = await _context.Promotions.ToListAsync();
            return View(promotions);
        }

        [HttpPost]
        public async Task<IActionResult> Upsert(Promotion promotion)
        {
            if (ModelState.IsValid)
            {
                if (promotion.PromotionId == 0)
                    _context.Promotions.Add(promotion);
                else
                    _context.Promotions.Update(promotion);

                await _context.SaveChangesAsync();
                return Json(new { success = true });
            }
            return Json(new { success = false });
        }
    }
}
