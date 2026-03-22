using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class UnitController : Controller
    {
        private readonly MotoShopDbContext _context;

        public UnitController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var units = await _context.Units.ToListAsync();
            return View(units);
        }

        [HttpPost]
        public async Task<IActionResult> Upsert(int? id, string name, string symbol)
        {
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(symbol))
                return Json(new { success = false, message = "Thông tin không đầy đủ" });

            if (id == null || id == 0)
            {
                var unit = new Unit { UnitName = name, Symbol = symbol };
                _context.Units.Add(unit);
            }
            else
            {
                var unit = await _context.Units.FindAsync(id);
                if (unit == null) return Json(new { success = false });
                unit.UnitName = name;
                unit.Symbol = symbol;
                _context.Units.Update(unit);
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }
    }
}
