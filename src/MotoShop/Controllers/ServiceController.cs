using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class ServiceController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ServiceController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var services = await _context.Services.Where(s => s.IsActive).ToListAsync();
            var combos = await _context.ServiceCombos
                .Include(c => c.ComboItems)
                .ThenInclude(ci => ci.Service)
                .Where(c => c.IsActive)
                .ToListAsync();

            ViewBag.Services = services;
            ViewBag.Combos = combos;

            return View();
        }

        public async Task<IActionResult> Detail(int? id, bool isCombo = false)
        {
            if (id == null) return NotFound();

            if (isCombo)
            {
                var combo = await _context.ServiceCombos
                    .Include(c => c.ComboItems)
                    .ThenInclude(ci => ci.Service)
                    .FirstOrDefaultAsync(c => c.ComboId == id);
                if (combo == null) return NotFound();
                return View("ComboDetail", combo);
            }
            else
            {
                var service = await _context.Services.FindAsync(id);
                if (service == null) return NotFound();
                return View("ServiceDetail", service);
            }
        }
    }
}
