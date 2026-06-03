using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Constants;
using MotoShop.Data.Data;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class HomeController : Controller
    {
        private readonly MotoShopDbContext _context;

        public HomeController(MotoShopDbContext context)
        {
            _context = context;
        }

        private static readonly string[] CompletedBookingStatuses =
        {
            BookingStatusConst.Completed,
            BookingStatusConst.DaHoanThanh
        };

        private IQueryable<ServiceRevenueRow> CompletedServiceRevenue()
        {
            return
                from b in _context.ServiceBookings
                join s0 in _context.Services on b.ServiceId equals s0.ServiceId into serviceJoin
                from s in serviceJoin.DefaultIfEmpty()
                join c0 in _context.ServiceCombos on b.ComboId equals c0.ComboId into comboJoin
                from c in comboJoin.DefaultIfEmpty()
                where CompletedBookingStatuses.Contains(b.Status!)
                      && b.CompletedAt.HasValue
                select new ServiceRevenueRow
                {
                    CompletedAt = b.CompletedAt!.Value,
                    Amount = b.RevenueAmount > 0
                        ? b.RevenueAmount
                        : s != null
                        ? s.Price
                        : c != null
                            ? (c.DiscountPrice > 0 ? c.DiscountPrice : c.TotalPrice)
                            : 0m
                };
        }

        public async Task<IActionResult> Index()
        {
            var now = DateTime.Now;
            var today = now.Date;
            var yesterday = today.AddDays(-1);
            var firstDayOfMonth = new DateTime(now.Year, now.Month, 1);
            var firstDayOfLastMonth = firstDayOfMonth.AddMonths(-1);

            // Card 1: Revenue Today & vs Yesterday (Orders Completed + Service Completed)
            var orderRevenueToday = await _context.Orders
                .Where(o => o.OrderDate.Date == today && o.Status == "Completed")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;
            var svcRevenueToday = await CompletedServiceRevenue()
                .Where(s => s.CompletedAt.Date == today)
                .SumAsync(s => (decimal?)s.Amount) ?? 0;
            var revenueToday = orderRevenueToday + svcRevenueToday;

            var orderRevenueYesterday = await _context.Orders
                .Where(o => o.OrderDate.Date == yesterday && o.Status == "Completed")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;
            var svcRevenueYesterday = await CompletedServiceRevenue()
                .Where(s => s.CompletedAt.Date == yesterday)
                .SumAsync(s => (decimal?)s.Amount) ?? 0;
            var revenueYesterday = orderRevenueYesterday + svcRevenueYesterday;

            ViewBag.RevenueToday = revenueToday;
            ViewBag.RevenueVsYesterday = revenueYesterday > 0
                ? (double)((revenueToday - revenueYesterday) / revenueYesterday * 100)
                : (revenueToday > 0 ? 100 : 0);

            // Monthly Revenue & Growth (chỉ Completed)
            var orderThisMonth = await _context.Orders
                .Where(o => o.OrderDate >= firstDayOfMonth && o.Status == "Completed")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;
            var svcThisMonth = await CompletedServiceRevenue()
                .Where(s => s.CompletedAt >= firstDayOfMonth)
                .SumAsync(s => (decimal?)s.Amount) ?? 0;
            var revenueThisMonth = orderThisMonth + svcThisMonth;

            var orderLastMonth = await _context.Orders
                .Where(o => o.OrderDate >= firstDayOfLastMonth && o.OrderDate < firstDayOfMonth && o.Status == "Completed")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;
            var svcLastMonth = await CompletedServiceRevenue()
                .Where(s => s.CompletedAt >= firstDayOfLastMonth && s.CompletedAt < firstDayOfMonth)
                .SumAsync(s => (decimal?)s.Amount) ?? 0;
            var revenueLastMonth = orderLastMonth + svcLastMonth;

            ViewBag.RevenueThisMonth = revenueThisMonth;
            ViewBag.RevenueGrowth = revenueLastMonth > 0
                ? Math.Round((double)((revenueThisMonth - revenueLastMonth) / revenueLastMonth * 100), 1)
                : (revenueThisMonth > 0 ? 100.0 : 0.0);

            // Card 2: Orders Today
            var ordersTodayQuery = _context.Orders.Where(o => o.OrderDate.Date == today);
            ViewBag.TotalOrdersToday = await ordersTodayQuery.CountAsync();
            ViewBag.CompletedOrdersToday = await ordersTodayQuery.Where(o => o.Status == "Completed" || o.Status == "DaHoanThanh" || o.Status == "Delivered").CountAsync();
            ViewBag.PendingOrdersToday = await ordersTodayQuery.Where(o => o.Status == "Pending" || o.Status == "Processing" || o.Status == "DangXuLy").CountAsync();

            // Card 3: Customers
            ViewBag.TotalCustomers = await _context.Customers.CountAsync();
            ViewBag.NewCustomersMonth = await _context.Customers.Where(c => c.CreatedDate >= firstDayOfMonth).CountAsync();
            ViewBag.NewCustomersToday = await _context.Customers.Where(c => c.CreatedDate.Date == today).CountAsync();

            // Card 4: Products
            ViewBag.ActiveProducts = await _context.Products.Where(p => p.IsActive).CountAsync();

            // Card 5: Monthly Invoices
            var monthlyOrdersQuery = _context.Orders.Where(o => o.OrderDate >= firstDayOfMonth);
            ViewBag.TotalOrdersMonth = await monthlyOrdersQuery.CountAsync();
            ViewBag.CompletedOrdersMonth = await monthlyOrdersQuery.Where(o => o.Status == "Completed" || o.Status == "DaHoanThanh" || o.Status == "Delivered").CountAsync();
            ViewBag.PendingOrdersMonth = await monthlyOrdersQuery.Where(o => o.Status == "Pending" || o.Status == "Processing" || o.Status == "DangXuLy").CountAsync();
            
            // Recent Orders for the table
            var recentOrders = await _context.Orders
                .Include(o => o.Customer)
                .OrderByDescending(o => o.OrderDate)
                .Take(5)
                .ToListAsync();

            return View(recentOrders);
        }

        private sealed class ServiceRevenueRow
        {
            public DateTime CompletedAt { get; set; }
            public decimal Amount { get; set; }
        }
    }
}
