using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Business.Interfaces;
using System.Linq;
using System.Threading.Tasks;
using ClosedXML.Excel;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;
using System.Globalization;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class ServiceController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IFileService _fileService;

        public ServiceController(MotoShopDbContext context, IFileService fileService)
        {
            _context = context;
            _fileService = fileService;
        }

        public async Task<IActionResult> Index(string? searchTerm, int? categoryId, string? status, int page = 1, int pageSize = 10)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var query = _context.Services
                .AsNoTracking()
                .Include(s => s.ServiceCategory)
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
                query = query.Where(s => s.ServiceName.Contains(searchTerm));

            if (categoryId.HasValue)
                query = query.Where(s => s.CategoryId == categoryId.Value);

            if (!string.IsNullOrEmpty(status))
            {
                bool isActive = status == "Active";
                query = query.Where(s => s.IsActive == true == isActive);
            }

            var totalItems = await query.CountAsync();
            var services = await query
                .OrderByDescending(s => s.ServiceId)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.Categories = await _context.ServiceCategories.ToListAsync();
            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(services);
        }

        [HttpPost]
        public async Task<IActionResult> Save(Service service, IFormFile? imageFile, bool IsActive = false)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(service.ServiceName))
                    return Json(new { success = false, message = "Vui lòng nhập tên dịch vụ" });

                if (service.CategoryId == null || service.CategoryId <= 0)
                    return Json(new { success = false, message = "Vui lòng chọn danh mục dịch vụ" });

                if (service.Price < 0)
                    return Json(new { success = false, message = "Giá dịch vụ không hợp lệ" });

                service.ServiceName = service.ServiceName.Trim();
                service.Description = service.Description?.Trim();
                service.Duration ??= 30;
                service.WarrantyDays ??= 30;
                service.TotalBookings ??= 0;
                service.IsActive = IsActive;

                if (service.ServiceId == 0)
                {
                    if (imageFile != null)
                    {
                        var uploadResult = await _fileService.SaveFileAsync(imageFile, "services");
                        if (!uploadResult.IsSuccess) return Json(new { success = false, message = uploadResult.ErrorMessage });
                        service.ImageUrl = uploadResult.FilePath;
                    }

                    service.Slug = await CreateUniqueSlugAsync(service.ServiceName);
                    _context.Services.Add(service);
                }
                else
                {
                    var existing = await _context.Services.FindAsync(service.ServiceId);
                    if (existing == null) return Json(new { success = false, message = "Không tìm thấy dịch vụ" });

                    existing.ServiceName = service.ServiceName;
                    existing.Price = service.Price;
                    existing.Duration = service.Duration;
                    existing.WarrantyDays = service.WarrantyDays;
                    existing.CategoryId = service.CategoryId;
                    existing.Description = service.Description;
                    existing.IsActive = IsActive;
                    existing.Slug = await CreateUniqueSlugAsync(service.ServiceName, existing.ServiceId);

                    if (imageFile != null)
                    {
                        var uploadResult = await _fileService.SaveFileAsync(imageFile, "services");
                        if (!uploadResult.IsSuccess) return Json(new { success = false, message = uploadResult.ErrorMessage });
                        if (!string.IsNullOrEmpty(existing.ImageUrl)) _fileService.DeleteFile(existing.ImageUrl);
                        existing.ImageUrl = uploadResult.FilePath;
                    }
                }

                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Lưu dịch vụ thành công" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = $"Không thể lưu dịch vụ: {ex.GetBaseException().Message}" });
            }
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null) return Json(new { success = false });

            if (!string.IsNullOrEmpty(service.ImageUrl))
            {
                _fileService.DeleteFile(service.ImageUrl);
            }

            _context.Services.Remove(service);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Xóa thành công" });
        }

        private async Task<string> CreateUniqueSlugAsync(string name, int? currentServiceId = null)
        {
            var baseSlug = GenerateSlug(name);
            if (string.IsNullOrWhiteSpace(baseSlug))
                baseSlug = $"dich-vu-{DateTime.Now:yyyyMMddHHmmss}";

            var slug = baseSlug;
            var index = 2;
            while (await _context.Services.AnyAsync(s => s.Slug == slug && (!currentServiceId.HasValue || s.ServiceId != currentServiceId.Value)))
            {
                slug = $"{baseSlug}-{index++}";
            }

            return slug;
        }

        private static string GenerateSlug(string input)
        {
            var normalized = input.ToLowerInvariant().Normalize(NormalizationForm.FormD);
            var builder = new StringBuilder();

            foreach (var ch in normalized)
            {
                var category = CharUnicodeInfo.GetUnicodeCategory(ch);
                if (category != UnicodeCategory.NonSpacingMark)
                    builder.Append(ch == '\u0111' ? 'd' : ch);
            }

            var slug = builder.ToString().Normalize(NormalizationForm.FormC);
            slug = Regex.Replace(slug, @"[^a-z0-9\s-]", "");
            slug = Regex.Replace(slug, @"\s+", "-").Trim('-');
            slug = Regex.Replace(slug, @"-+", "-");
            return slug;
        }

        public async Task<IActionResult> ExportExcel()
        {
            var services = await _context.Services.ToListAsync();
            using (var workbook = new XLWorkbook())
            {
                var ws = workbook.Worksheets.Add("DichVu");
                ws.Cell(1, 1).Value = "Tên dịch vụ";
                ws.Cell(1, 2).Value = "Giá";
                ws.Cell(1, 3).Value = "Trạng thái";
                var header = ws.Range(1, 1, 1, 3);
                header.Style.Font.Bold = true;
                header.Style.Fill.BackgroundColor = XLColor.FromHtml("#E24B4A");
                header.Style.Font.FontColor = XLColor.White;

                int row = 2;
                foreach (var s in services)
                {
                    ws.Cell(row, 1).Value = s.ServiceName;
                    ws.Cell(row, 2).Value = s.Price;
                    ws.Cell(row, 3).Value = s.IsActive == true ? "Đang cung cấp" : "Tạm ngừng";
                    row++;
                }
                ws.Columns().AdjustToContents();
                using (var stream = new MemoryStream()) {
                    workbook.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "DanhSachDichVu.xlsx");
                }
            }
        }
    }
}
