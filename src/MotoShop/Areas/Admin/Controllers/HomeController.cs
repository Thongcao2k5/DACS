using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin,Staff")]
    public class HomeController : Controller
    {
        private readonly MotoShopDbContext _context;

        public HomeController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var now = DateTime.Now;
            var today = now.Date;
            var yesterday = today.AddDays(-1);
            var firstDayOfMonth = new DateTime(now.Year, now.Month, 1);

            // Card 1: Revenue Today & vs Yesterday
            var revenueToday = await _context.Orders
                .Where(o => o.OrderDate.Date == today && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;

            var revenueYesterday = await _context.Orders
                .Where(o => o.OrderDate.Date == yesterday && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;

            ViewBag.RevenueToday = revenueToday;
            ViewBag.RevenueVsYesterday = revenueYesterday > 0 
                ? (double)((revenueToday - revenueYesterday) / revenueYesterday * 100) 
                : (revenueToday > 0 ? 100 : 0);

            // Card 2: Orders Today
            var ordersTodayQuery = _context.Orders.Where(o => o.OrderDate.Date == today);
            ViewBag.TotalOrdersToday = await ordersTodayQuery.CountAsync();
            ViewBag.CompletedOrdersToday = await ordersTodayQuery.Where(o => o.Status == "Completed" || o.Status == "Delivered").CountAsync();
            ViewBag.PendingOrdersToday = await ordersTodayQuery.Where(o => o.Status == "Pending" || o.Status == "Processing").CountAsync();

            // Card 3: Customers
            ViewBag.TotalCustomers = await _context.Customers.CountAsync();
            ViewBag.NewCustomersToday = await _context.Customers.Where(c => c.CreatedDate.Date == today).CountAsync();

            // Card 4: Products
            ViewBag.ActiveProducts = await _context.Products.Where(p => p.IsActive).CountAsync();

            // Card 5: Monthly Invoices
            var monthlyOrdersQuery = _context.Orders.Where(o => o.OrderDate >= firstDayOfMonth);
            ViewBag.TotalOrdersMonth = await monthlyOrdersQuery.CountAsync();
            ViewBag.CompletedOrdersMonth = await monthlyOrdersQuery.Where(o => o.Status == "Completed" || o.Status == "Delivered").CountAsync();
            ViewBag.PendingOrdersMonth = await monthlyOrdersQuery.Where(o => o.Status == "Pending" || o.Status == "Processing").CountAsync();
            
            // Recent Orders for the table
            var recentOrders = await _context.Orders
                .Include(o => o.Customer)
                .OrderByDescending(o => o.OrderDate)
                .Take(5)
                .ToListAsync();

            return View(recentOrders);
        }
    }
}
