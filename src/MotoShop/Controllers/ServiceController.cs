using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Business.Helpers;
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

        // Action to list services with paging
        public async Task<IActionResult> Index(string searchTerm, int page = 1, int pageSize = 6)
        {
            var query = _context.Services.AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(s => s.ServiceName.Contains(searchTerm) || (s.Description != null && s.Description.Contains(searchTerm)));
            }

            var count = await query.CountAsync();
            var items = await query.Skip((page - 1) * pageSize).Take(pageSize).ToListAsync();

            var pagedServices = new PagedList<Service>(items, count, page, pageSize);

            return View(pagedServices);
        }

        public async Task<IActionResult> Details(int id)
        {
            var service = await _context.Services.FirstOrDefaultAsync(s => s.ServiceId == id);
            if (service == null) return NotFound();
            return View(service);
        }

        public async Task<IActionResult> Booking(int? serviceId)
        {
            if (serviceId.HasValue)
            {
                var service = await _context.Services.FirstOrDefaultAsync(s => s.ServiceId == serviceId.Value);
                ViewBag.SelectedService = service;
            }
            return View();
        }

        public IActionResult BookingSuccess()
        {
            return View();
        }
    }
}
