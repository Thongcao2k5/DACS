using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Microsoft.AspNetCore.Authorization.Authorize(Roles = "Admin")]
    public class ProductUsageController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly Microsoft.Extensions.Caching.Memory.IMemoryCache _cache;

        public ProductUsageController(MotoShopDbContext context, Microsoft.Extensions.Caching.Memory.IMemoryCache cache)
        {
            _context = context;
            _cache = cache;
        }

        public async Task<IActionResult> Index()
        {
            var usages = await _context.ProductUsages
                .Include(u => u.ProductProductUsages)
                .OrderBy(u => u.Name)
                .ToListAsync();

            return View(usages);
        }

        [HttpGet]
        public async Task<IActionResult> Get(int id)
        {
            var usage = await _context.ProductUsages.FindAsync(id);
            if (usage == null) return NotFound();

            return Json(new
            {
                usage.Id,
                usage.Name,
                usage.Slug,
                usage.Description,
                usage.IsActive
            });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Upsert(int? id, string name, string? slug, string? description, bool isActive = true)
        {
            if (string.IsNullOrWhiteSpace(name))
                return Json(new { success = false, message = "Tên công dụng không được để trống." });

            slug = string.IsNullOrWhiteSpace(slug) ? GenerateSlug(name) : GenerateSlug(slug);
            var isDuplicate = await _context.ProductUsages.AnyAsync(u => u.Slug == slug && (!id.HasValue || u.Id != id.Value));
            if (isDuplicate)
                return Json(new { success = false, message = "Slug công dụng đã tồn tại." });

            if (!id.HasValue || id.Value == 0)
            {
                _context.ProductUsages.Add(new ProductUsage
                {
                    Name = name.Trim(),
                    Slug = slug,
                    Description = description,
                    IsActive = isActive
                });
            }
            else
            {
                var usage = await _context.ProductUsages.FindAsync(id.Value);
                if (usage == null) return Json(new { success = false, message = "Không tìm thấy công dụng." });

                usage.Name = name.Trim();
                usage.Slug = slug;
                usage.Description = description;
                usage.IsActive = isActive;
            }

            await _context.SaveChangesAsync();
            ClearCaches();
            return Json(new { success = true, message = "Đã lưu công dụng sản phẩm." });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Toggle(int id)
        {
            var usage = await _context.ProductUsages.FindAsync(id);
            if (usage == null) return Json(new { success = false, message = "Không tìm thấy công dụng." });

            usage.IsActive = !usage.IsActive;
            await _context.SaveChangesAsync();
            ClearCaches();
            return Json(new { success = true, message = "Đã cập nhật trạng thái." });
        }

        private void ClearCaches()
        {
            _cache.Remove(MotoShop.Data.Constants.CacheKeys.HomeFeatured);
            _cache.Remove(MotoShop.Data.Constants.CacheKeys.HomeBestSelling);
            _cache.Remove(MotoShop.Data.Constants.CacheKeys.HomeNewProducts);
        }

        private static string GenerateSlug(string text)
        {
            text = RemoveAccent(text ?? string.Empty).ToLowerInvariant();
            text = Regex.Replace(text, @"[^a-z0-9\s-]", string.Empty);
            text = Regex.Replace(text, @"\s+", " ").Trim();
            return Regex.Replace(text, @"\s", "-");
        }

        private static string RemoveAccent(string text)
        {
            var normalized = text.Normalize(NormalizationForm.FormD);
            var chars = normalized.Where(c => CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark).ToArray();
            return new string(chars).Normalize(NormalizationForm.FormC).Replace('đ', 'd').Replace('Đ', 'D');
        }
    }
}
