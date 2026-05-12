using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class AuditLogController : Controller
    {
        private readonly MotoShopDbContext _context;

        public AuditLogController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(
            string? action,
            string? entityName,
            string? userId,
            DateTime? fromDate,
            DateTime? toDate,
            int page = 1,
            int pageSize = 20)
        {
            var query = _context.AuditLogs.AsQueryable();

            if (!string.IsNullOrEmpty(action))
                query = query.Where(l => l.Action == action);

            if (!string.IsNullOrEmpty(entityName))
                query = query.Where(l => l.EntityName == entityName);

            if (!string.IsNullOrEmpty(userId))
                query = query.Where(l => l.UserId != null && l.UserId.Contains(userId));

            if (fromDate.HasValue)
                query = query.Where(l => l.CreatedAt >= fromDate.Value.Date);

            if (toDate.HasValue)
                query = query.Where(l => l.CreatedAt < toDate.Value.Date.AddDays(1));

            var totalItems = await query.CountAsync();

            var logs = await query
                .OrderByDescending(l => l.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.Actions  = await _context.AuditLogs.Select(l => l.Action).Distinct().OrderBy(a => a).ToListAsync();
            ViewBag.Entities = await _context.AuditLogs.Select(l => l.EntityName).Distinct().OrderBy(e => e).ToListAsync();

            ViewBag.FilterAction = action;
            ViewBag.FilterEntity = entityName;
            ViewBag.FilterUser   = userId;
            ViewBag.FromDate     = fromDate?.ToString("yyyy-MM-dd");
            ViewBag.ToDate       = toDate?.ToString("yyyy-MM-dd");
            ViewBag.CurrentPage  = page;
            ViewBag.PageSize     = pageSize;
            ViewBag.TotalItems   = totalItems;
            ViewBag.TotalPages   = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(logs);
        }

        [HttpPost]
        public async Task<IActionResult> Clear(int keepDays = 90)
        {
            var cutoff = DateTime.Now.AddDays(-keepDays);
            var old = await _context.AuditLogs.Where(l => l.CreatedAt < cutoff).ToListAsync();
            _context.AuditLogs.RemoveRange(old);
            await _context.SaveChangesAsync();
            TempData["Success"] = $"Đã xóa {old.Count} bản ghi cũ hơn {keepDays} ngày.";
            return RedirectToAction("Index");
        }
    }
}
