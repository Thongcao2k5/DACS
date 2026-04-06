using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin,Staff")]
    public class ReportController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ReportController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Revenue(DateTime? fromDate, DateTime? toDate, int? month, int? year)
        {
            var now = DateTime.Now;
            var today = now.Date;
            var startOfMonth = new DateTime(now.Year, now.Month, 1);
            var startOfYear = new DateTime(now.Year, 1, 1);

            // 1. Thống kê KPI
            ViewBag.RevenueToday = await _context.Orders
                .Where(o => o.OrderDate.Date == today && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;

            ViewBag.RevenueMonth = await _context.Orders
                .Where(o => o.OrderDate >= startOfMonth && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;

            ViewBag.RevenueYear = await _context.Orders
                .Where(o => o.OrderDate >= startOfYear && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;

            // Tính tăng trưởng so với tháng trước (ví dụ đơn giản)
            var startOfLastMonth = startOfMonth.AddMonths(-1);
            var endOfLastMonth = startOfMonth.AddDays(-1);
            var revenueLastMonth = await _context.Orders
                .Where(o => o.OrderDate >= startOfLastMonth && o.OrderDate <= endOfLastMonth && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0;

            ViewBag.GrowthMonth = revenueLastMonth > 0 
                ? (double)((ViewBag.RevenueMonth - revenueLastMonth) / revenueLastMonth * 100) 
                : 0;

            // 2. Lọc dữ liệu cho bảng và biểu đồ
            var query = _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.ProductVariant)
                .Where(o => o.Status != "Cancelled")
                .AsQueryable();

            if (fromDate.HasValue) query = query.Where(o => o.OrderDate >= fromDate.Value);
            if (toDate.HasValue) query = query.Where(o => o.OrderDate <= toDate.Value.AddDays(1).AddTicks(-1));
            
            if (month.HasValue && year.HasValue)
                query = query.Where(o => o.OrderDate.Month == month.Value && o.OrderDate.Year == year.Value);
            else if (year.HasValue)
                query = query.Where(o => o.OrderDate.Year == year.Value);

            var orders = await query.OrderByDescending(o => o.OrderDate).ToListAsync();

            // 3. Dữ liệu cho biểu đồ (Doanh thu 7 ngày gần nhất)
            var last7Days = Enumerable.Range(0, 7)
                .Select(i => today.AddDays(-i))
                .OrderBy(d => d)
                .ToList();

            var chartData = last7Days.Select(d => new {
                Date = d.ToString("dd/MM"),
                Amount = _context.Orders
                    .Where(o => o.OrderDate.Date == d && o.Status != "Cancelled")
                    .Sum(o => (decimal?)o.TotalAmount) ?? 0
            }).ToList();

            ViewBag.ChartLabels = chartData.Select(c => c.Date).ToList();
            ViewBag.ChartValues = chartData.Select(c => c.Amount).ToList();

            ViewBag.FromDate = fromDate?.ToString("yyyy-MM-dd");
            ViewBag.ToDate = toDate?.ToString("yyyy-MM-dd");
            ViewBag.Month = month;
            ViewBag.Year = year;

            return View(orders);
        }
    }
}
