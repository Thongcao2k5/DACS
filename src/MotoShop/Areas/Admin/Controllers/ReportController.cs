using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class ReportController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ReportController(MotoShopDbContext context)
        {
            _context = context;
        }

        // ───────────────────────── Helpers ─────────────────────────

        private static (DateTime start, DateTime end, DateTime prevStart, DateTime prevEnd)
            ResolvePeriod(string period, DateTime? fromDate, DateTime? toDate)
        {
            var today = DateTime.Today;
            DateTime start, end;
            switch (period)
            {
                case "30d":
                    start = today.AddDays(-29);
                    end   = today.AddDays(1).AddTicks(-1);
                    break;
                case "3m":
                    start = today.AddMonths(-3);
                    end   = today.AddDays(1).AddTicks(-1);
                    break;
                case "ytd":
                    start = new DateTime(today.Year, 1, 1);
                    end   = today.AddDays(1).AddTicks(-1);
                    break;
                case "custom" when fromDate.HasValue:
                    start = fromDate.Value.Date;
                    end   = (toDate ?? today).Date.AddDays(1).AddTicks(-1);
                    break;
                default: // 7d
                    start = today.AddDays(-6);
                    end   = today.AddDays(1).AddTicks(-1);
                    break;
            }
            int span      = Math.Max(1, (int)(end - start).TotalDays);
            var prevStart = start.AddDays(-span);
            var prevEnd   = start.AddTicks(-1);
            return (start, end, prevStart, prevEnd);
        }

        private static FileContentResult CsvFile(StringBuilder sb, string fileName)
        {
            var bytes = Encoding.UTF8.GetPreamble()
                .Concat(Encoding.UTF8.GetBytes(sb.ToString()))
                .ToArray();
            return new FileContentResult(bytes, "text/csv; charset=utf-8")
            { FileDownloadName = fileName };
        }

        private void SetPeriodBag(string period, DateTime? fromDate, DateTime? toDate, DateTime start, DateTime end)
        {
            ViewBag.Period   = period;
            ViewBag.FromDate = fromDate?.ToString("yyyy-MM-dd");
            ViewBag.ToDate   = toDate?.ToString("yyyy-MM-dd");
            ViewBag.Start    = start;
            ViewBag.End      = end;
        }

        private static List<(string label, decimal amount)> BuildChart(
            List<(DateTime date, decimal amount)> data, string period, DateTime start, DateTime end)
        {
            if (period == "ytd")
            {
                var months = new List<(string, decimal)>();
                for (int m = 1; m <= end.Month; m++)
                    months.Add(($"T{m}", data.Where(d => d.date.Month == m).Sum(d => d.amount)));
                return months;
            }
            if (period == "3m")
            {
                var weeks = new List<(string, decimal)>();
                for (var ws = start.Date; ws <= end.Date; ws = ws.AddDays(7))
                {
                    var we = ws.AddDays(6) > end.Date ? end.Date : ws.AddDays(6);
                    weeks.Add((ws.ToString("dd/MM"), data.Where(d => d.date.Date >= ws && d.date.Date <= we).Sum(d => d.amount)));
                }
                return weeks;
            }
            var days = new List<(string, decimal)>();
            for (var d = start.Date; d <= end.Date; d = d.AddDays(1))
                days.Add((d.ToString("dd/MM"), data.Where(x => x.date.Date == d).Sum(x => x.amount)));
            return days;
        }

        // ───────────────────────── TAB 1: Doanh thu ─────────────────────────

        public async Task<IActionResult> Revenue(string period = "7d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, prevStart, prevEnd) = ResolvePeriod(period, fromDate, toDate);

            // Fixed KPI cards (always today/month/year)
            var now           = DateTime.Now;
            var startOfMonth  = new DateTime(now.Year, now.Month, 1);
            var startOfYear   = new DateTime(now.Year, 1, 1);
            var lastMonStart  = startOfMonth.AddMonths(-1);
            var lastMonEnd    = startOfMonth.AddTicks(-1);

            ViewBag.RevenueToday = await _context.Orders
                .Where(o => o.OrderDate.Date == now.Date && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0m;
            ViewBag.RevenueMonth = await _context.Orders
                .Where(o => o.OrderDate >= startOfMonth && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0m;
            ViewBag.RevenueYear = await _context.Orders
                .Where(o => o.OrderDate >= startOfYear && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0m;
            decimal revLastMon = await _context.Orders
                .Where(o => o.OrderDate >= lastMonStart && o.OrderDate <= lastMonEnd && o.Status != "Cancelled")
                .SumAsync(o => (decimal?)o.TotalAmount) ?? 0m;
            ViewBag.GrowthMonth = revLastMon > 0
                ? (double)(((decimal)ViewBag.RevenueMonth - revLastMon) / revLastMon * 100) : 0.0;

            // Period comparison KPIs
            var curRows = await _context.Orders
                .Where(o => o.Status != "Cancelled" && o.OrderDate >= start && o.OrderDate <= end)
                .Select(o => new { o.TotalAmount, o.OrderDate })
                .ToListAsync();
            var prevRows = await _context.Orders
                .Where(o => o.Status != "Cancelled" && o.OrderDate >= prevStart && o.OrderDate <= prevEnd)
                .Select(o => new { o.TotalAmount })
                .ToListAsync();

            decimal totalRevenue = curRows.Sum(o => o.TotalAmount);
            int     totalOrders  = curRows.Count;
            decimal aov          = totalOrders > 0 ? totalRevenue / totalOrders : 0m;
            decimal prevRevenue  = prevRows.Sum(o => o.TotalAmount);
            int     prevOrders   = prevRows.Count;
            decimal prevAov      = prevOrders > 0 ? prevRevenue / prevOrders : 0m;

            ViewBag.TotalRevenue  = totalRevenue;
            ViewBag.TotalOrders   = totalOrders;
            ViewBag.AOV           = aov;
            ViewBag.RevenueGrowth = prevRevenue > 0
                ? (double)((totalRevenue - prevRevenue) / prevRevenue * 100) : 0.0;
            ViewBag.OrderGrowth   = prevOrders > 0
                ? (double)((totalOrders  - prevOrders)  / (double)prevOrders * 100) : 0.0;
            ViewBag.AovGrowth     = prevAov > 0
                ? (double)((aov - prevAov) / prevAov * 100) : 0.0;

            var chartPts = BuildChart(
                curRows.Select(o => (o.OrderDate, o.TotalAmount)).ToList(), period, start, end);
            ViewBag.ChartLabels = chartPts.Select(p => p.label).ToList();
            ViewBag.ChartValues = chartPts.Select(p => p.amount).ToList();

            var orders = await _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.OrderItems).ThenInclude(oi => oi.ProductVariant)
                .Where(o => o.OrderDate >= start && o.OrderDate <= end)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            SetPeriodBag(period, fromDate, toDate, start, end);
            return View(orders);
        }

        public async Task<IActionResult> ExportRevenue(string period = "7d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, _, _) = ResolvePeriod(period, fromDate, toDate);
            var orders = await _context.Orders
                .Include(o => o.Customer)
                .Where(o => o.OrderDate >= start && o.OrderDate <= end)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            var sb = new StringBuilder();
            sb.AppendLine("Mã đơn,Khách hàng,SĐT,Tổng tiền,Ngày đặt,Trạng thái");
            foreach (var o in orders)
                sb.AppendLine($"{o.OrderCode},\"{o.Customer?.FullName ?? ""}\",{o.Customer?.Phone},{o.TotalAmount},{o.OrderDate:dd/MM/yyyy HH:mm},{o.Status}");
            return CsvFile(sb, $"doanh-thu-{DateTime.Now:yyyyMMdd}.csv");
        }

        // ───────────────────────── TAB 2: Sản phẩm bán chạy ─────────────────────────

        public async Task<IActionResult> TopProducts(string period = "30d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, _, _) = ResolvePeriod(period, fromDate, toDate);

            // Step 1: aggregate qty + revenue per ProductId
            var agg = await (
                from oi in _context.OrderItems
                join o  in _context.Orders         on oi.OrderId          equals o.OrderId
                join pv in _context.ProductVariants on oi.ProductVariantId equals pv.ProductVariantId
                where o.Status == "Completed"
                   && o.OrderDate >= start && o.OrderDate <= end
                   && pv.ProductId != null
                group new { oi } by pv.ProductId into g
                select new
                {
                    ProductId    = g.Key ?? 0,
                    TotalQty     = g.Sum(x => x.oi.Quantity),
                    TotalRevenue = g.Sum(x => (decimal)x.oi.Quantity * x.oi.Price)
                }
            ).ToListAsync();

            agg = agg.Where(a => a.ProductId != 0).ToList();

            // Step 2: enrich in-memory with product details
            var productIds = agg.Select(a => a.ProductId).ToList();
            var products = productIds.Any()
                ? await _context.Products
                    .Include(p => p.Category)
                    .Include(p => p.Images)
                    .Where(p => productIds.Contains(p.ProductId))
                    .ToListAsync()
                : new List<Product>();

            var enriched = agg.Select(a =>
            {
                var p   = products.FirstOrDefault(pr => pr.ProductId == a.ProductId);
                var img = p?.Images?.FirstOrDefault(i => i.IsPrimary)?.ImageUrl
                       ?? p?.Images?.FirstOrDefault()?.ImageUrl;
                return new ReportProductRow(
                    a.ProductId,
                    p?.ProductName ?? "N/A",
                    p?.Category?.CategoryName ?? "—",
                    img,
                    a.TotalQty,
                    a.TotalRevenue);
            }).ToList();

            ViewBag.TopByQty     = enriched.OrderByDescending(x => x.TotalQty).Take(10).ToList();
            ViewBag.TopByRevenue = enriched.OrderByDescending(x => x.TotalRevenue).Take(10).ToList();
            SetPeriodBag(period, fromDate, toDate, start, end);
            return View();
        }

        public async Task<IActionResult> ExportTopProducts(string period = "30d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, _, _) = ResolvePeriod(period, fromDate, toDate);
            var data = await (
                from oi in _context.OrderItems
                join o  in _context.Orders         on oi.OrderId          equals o.OrderId
                join pv in _context.ProductVariants on oi.ProductVariantId equals pv.ProductVariantId
                join p  in _context.Products        on pv.ProductId        equals p.ProductId
                join c  in _context.Categories      on p.CategoryId        equals c.CategoryId into cj
                from c in cj.DefaultIfEmpty()
                where o.Status == "Completed" && o.OrderDate >= start && o.OrderDate <= end
                group new { oi, p, c } by new { p.ProductId, p.ProductName, Cat = c != null ? c.CategoryName : "" } into g
                select new
                {
                    g.Key.ProductName,
                    g.Key.Cat,
                    TotalQty     = g.Sum(x => x.oi.Quantity),
                    TotalRevenue = g.Sum(x => (decimal)x.oi.Quantity * x.oi.Price)
                }
            ).OrderByDescending(x => x.TotalQty).ToListAsync();

            var sb = new StringBuilder();
            sb.AppendLine("Tên sản phẩm,Danh mục,Số lượng bán,Doanh thu (VNĐ)");
            foreach (var x in data)
                sb.AppendLine($"\"{x.ProductName}\",\"{x.Cat}\",{x.TotalQty},{x.TotalRevenue}");
            return CsvFile(sb, $"san-pham-ban-chay-{DateTime.Now:yyyyMMdd}.csv");
        }

        // ───────────────────────── TAB 3: Đơn hàng ─────────────────────────

        public async Task<IActionResult> Orders(string period = "30d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, _, _) = ResolvePeriod(period, fromDate, toDate);

            var rows = await _context.Orders
                .Where(o => o.OrderDate >= start && o.OrderDate <= end)
                .Select(o => new { o.Status, o.TotalAmount, o.OrderId })
                .ToListAsync();

            int total     = rows.Count;
            int completed = rows.Count(o => o.Status == "Completed");
            int cancelled = rows.Count(o => o.Status == "Cancelled");

            var statusGroups = rows
                .GroupBy(o => o.Status ?? "Khác")
                .Select(g => new ReportStatusGroup(
                    g.Key,
                    g.Count(),
                    g.Sum(x => x.TotalAmount),
                    total > 0 ? g.Count() * 100.0 / total : 0.0))
                .OrderByDescending(g => g.Count)
                .ToList();

            // Average processing time: order created → status "Completed" in history
            var procData = await (
                from o  in _context.Orders
                join sh in _context.OrderStatusHistory on o.OrderId equals sh.OrderId
                where o.OrderDate >= start && o.OrderDate <= end && sh.Status == "Completed"
                select new { o.OrderDate, sh.ChangedDate }
            ).ToListAsync();
            double avgHours = procData.Any()
                ? procData.Average(x => Math.Max(0, (x.ChangedDate - x.OrderDate).TotalHours))
                : 0.0;

            ViewBag.StatusGroups   = statusGroups;
            ViewBag.TotalOrders    = total;
            ViewBag.Completed      = completed;
            ViewBag.Cancelled      = cancelled;
            ViewBag.CompletionRate = total > 0 ? completed * 100.0 / total : 0.0;
            ViewBag.CancelRate     = total > 0 ? cancelled * 100.0 / total : 0.0;
            ViewBag.AvgHours       = avgHours;
            ViewBag.ChartLabels    = statusGroups.Select(g => g.Status).ToList();
            ViewBag.ChartValues    = statusGroups.Select(g => g.Count).ToList();
            SetPeriodBag(period, fromDate, toDate, start, end);
            return View();
        }

        public async Task<IActionResult> ExportOrders(string period = "30d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, _, _) = ResolvePeriod(period, fromDate, toDate);
            var orders = await _context.Orders
                .Include(o => o.Customer)
                .Where(o => o.OrderDate >= start && o.OrderDate <= end)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            var sb = new StringBuilder();
            sb.AppendLine("Mã đơn,Khách hàng,Tổng tiền,Ngày đặt,Trạng thái,Thanh toán");
            foreach (var o in orders)
                sb.AppendLine($"{o.OrderCode},\"{o.Customer?.FullName ?? ""}\",{o.TotalAmount},{o.OrderDate:dd/MM/yyyy HH:mm},{o.Status},{o.PaymentStatus}");
            return CsvFile(sb, $"don-hang-{DateTime.Now:yyyyMMdd}.csv");
        }

        // ───────────────────────── TAB 4: Khách hàng ─────────────────────────

        public async Task<IActionResult> Customers(string period = "30d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, prevStart, prevEnd) = ResolvePeriod(period, fromDate, toDate);

            int newCus     = await _context.Customers.CountAsync(c => c.CreatedDate >= start && c.CreatedDate <= end);
            int prevNewCus = await _context.Customers.CountAsync(c => c.CreatedDate >= prevStart && c.CreatedDate <= prevEnd);

            // Returning = ordered in period AND created before period start
            var cusInPeriod = await _context.Orders
                .Where(o => o.OrderDate >= start && o.OrderDate <= end && o.CustomerId.HasValue)
                .Select(o => o.CustomerId!.Value)
                .Distinct()
                .ToListAsync();
            int returning = await _context.Customers
                .Where(c => c.CreatedDate < start && cusInPeriod.Contains(c.CustomerId))
                .CountAsync();

            // Top 10 spenders — step 1: aggregate in SQL (anonymous type only)
            var spenderAgg = await _context.Orders
                .Where(o => o.Status != "Cancelled"
                         && o.OrderDate >= start && o.OrderDate <= end
                         && o.CustomerId.HasValue)
                .GroupBy(o => o.CustomerId)
                .Select(g => new
                {
                    CustomerId = g.Key,
                    TotalSpent = g.Sum(o => o.TotalAmount),
                    OrderCount = g.Count()
                })
                .OrderByDescending(x => x.TotalSpent)
                .Take(10)
                .ToListAsync();

            // Step 2: enrich with customer details in-memory
            var spenderIds = spenderAgg
                .Where(x => x.CustomerId.HasValue)
                .Select(x => x.CustomerId!.Value)
                .ToList();
            var spenderCus = await _context.Customers
                .Where(c => spenderIds.Contains(c.CustomerId))
                .ToListAsync();
            var topSpenders = spenderAgg.Select(x =>
            {
                var c = spenderCus.FirstOrDefault(cu => cu.CustomerId == x.CustomerId);
                return new ReportSpender(
                    x.CustomerId,
                    c?.FullName ?? "N/A",
                    c?.Email,
                    c?.Phone,
                    c?.AvatarUrl,
                    x.TotalSpent,
                    x.OrderCount);
            }).ToList();

            // Weekly chart (in-memory after single fetch)
            var allOrders = await _context.Orders
                .Where(o => o.OrderDate >= start && o.OrderDate <= end && o.CustomerId.HasValue)
                .Select(o => new { o.OrderDate, CustomerId = o.CustomerId!.Value })
                .ToListAsync();
            var cusMap = await _context.Customers
                .Select(c => new { c.CustomerId, c.CreatedDate })
                .ToDictionaryAsync(c => c.CustomerId, c => c.CreatedDate);

            var weekLabels    = new List<string>();
            var weekNew       = new List<int>();
            var weekReturning = new List<int>();
            for (var ws = start.Date; ws <= end.Date; ws = ws.AddDays(7))
            {
                var we   = ws.AddDays(6) > end.Date ? end.Date : ws.AddDays(6);
                var uIds = allOrders.Where(o => o.OrderDate.Date >= ws && o.OrderDate.Date <= we)
                                    .Select(o => o.CustomerId).Distinct().ToList();
                weekLabels.Add(ws.ToString("dd/MM"));
                weekNew.Add(uIds.Count(id => cusMap.TryGetValue(id, out var cd) && cd.Date >= start.Date));
                weekReturning.Add(uIds.Count(id => cusMap.TryGetValue(id, out var cd) && cd.Date < start.Date));
            }

            ViewBag.NewCus      = newCus;
            ViewBag.PrevNewCus  = prevNewCus;
            ViewBag.NewGrowth   = prevNewCus > 0 ? (newCus - prevNewCus) * 100.0 / prevNewCus : 0.0;
            ViewBag.Returning   = returning;
            ViewBag.TopSpenders = topSpenders;
            ViewBag.WeekLabels  = weekLabels;
            ViewBag.WeekNew     = weekNew;
            ViewBag.WeekRet     = weekReturning;
            SetPeriodBag(period, fromDate, toDate, start, end);
            return View();
        }

        public async Task<IActionResult> ExportCustomers(string period = "30d",
            DateTime? fromDate = null, DateTime? toDate = null)
        {
            var (start, end, _, _) = ResolvePeriod(period, fromDate, toDate);
            var data = await (
                from o in _context.Orders
                join c in _context.Customers on o.CustomerId equals c.CustomerId
                where o.Status != "Cancelled" && o.OrderDate >= start && o.OrderDate <= end
                group new { o, c } by new { o.CustomerId, c.FullName, c.Email, c.Phone } into g
                select new
                {
                    g.Key.FullName,
                    g.Key.Email,
                    g.Key.Phone,
                    TotalSpent = g.Sum(x => x.o.TotalAmount),
                    OrderCount = g.Count()
                }
            ).OrderByDescending(x => x.TotalSpent).ToListAsync();

            var sb = new StringBuilder();
            sb.AppendLine("Khách hàng,Email,SĐT,Tổng chi tiêu,Số đơn");
            foreach (var x in data)
                sb.AppendLine($"\"{x.FullName ?? ""}\",{x.Email},{x.Phone},{x.TotalSpent},{x.OrderCount}");
            return CsvFile(sb, $"khach-hang-{DateTime.Now:yyyyMMdd}.csv");
        }
    }

    // ───────────────────────── View DTOs ─────────────────────────

    public sealed record ReportProductRow(
        int ProductId, string ProductName, string CategoryName,
        string? ImageUrl, int TotalQty, decimal TotalRevenue);

    public sealed record ReportStatusGroup(
        string Status, int Count, decimal Revenue, double Pct);

    public sealed record ReportSpender(
        int? CustomerId, string FullName, string? Email,
        string? Phone, string? AvatarUrl, decimal TotalSpent, int OrderCount);
}
