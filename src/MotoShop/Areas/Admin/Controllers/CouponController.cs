using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;
using ClosedXML.Excel;
using System.IO;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class CouponController : Controller
    {
        private readonly MotoShopDbContext _context;

        public CouponController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? status, int page = 1, int pageSize = 10)
        {
            var query = GetFilteredCouponsQuery(searchTerm, status);

            var totalItems = await query.CountAsync();
            var coupons = await query
                .OrderByDescending(c => c.ExpiryDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(coupons);
        }

        private IQueryable<Coupon> GetFilteredCouponsQuery(string? searchTerm, string? status)
        {
            var query = _context.Coupons.AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(c => c.Code.Contains(searchTerm));
            }

            if (!string.IsNullOrEmpty(status))
            {
                var now = DateTime.Now;
                query = status switch
                {
                    "Valid" => query.Where(c => c.IsActive && c.ExpiryDate >= now && (c.UsageLimit == 0 || c.UsedCount < c.UsageLimit)),
                    "Expired" => query.Where(c => c.ExpiryDate < now),
                    "OutOfUses" => query.Where(c => c.UsageLimit > 0 && c.UsedCount >= c.UsageLimit),
                    _ => query
                };
            }

            return query;
        }

        [HttpPost]
        public async Task<IActionResult> Save(Coupon coupon)
        {
            coupon.Code = coupon.Code.ToUpper();
            
            if (coupon.Id == 0)
            {
                if (await _context.Coupons.AnyAsync(c => c.Code == coupon.Code))
                {
                    return Json(new { success = false, message = "Mã code đã tồn tại" });
                }
                _context.Coupons.Add(coupon);
            }
            else
            {
                var existing = await _context.Coupons.FindAsync(coupon.Id);
                if (existing == null) return Json(new { success = false, message = "Không tìm thấy mã" });

                existing.Code = coupon.Code;
                existing.DiscountType = coupon.DiscountType;
                existing.DiscountValue = coupon.DiscountValue;
                existing.MinOrderValue = coupon.MinOrderValue;
                existing.UsageLimit = coupon.UsageLimit;
                existing.ExpiryDate = coupon.ExpiryDate;
                existing.IsActive = coupon.IsActive;
                // UsedCount remains unchanged
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = coupon.Id == 0 ? "Thêm thành công" : "Cập nhật thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var coupon = await _context.Coupons.FindAsync(id);
            if (coupon == null) return Json(new { success = false });

            _context.Coupons.Remove(coupon);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Xóa thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> BulkDelete(int[] ids)
        {
            if (ids == null || ids.Length == 0) return Json(new { success = false });
            var coupons = await _context.Coupons.Where(c => ids.Contains(c.Id)).ToListAsync();
            _context.Coupons.RemoveRange(coupons);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = $"Đã xóa {coupons.Count} mã giảm giá" });
        }

        public async Task<IActionResult> ExportExcel(string? searchTerm, string? status)
        {
            var coupons = await GetFilteredCouponsQuery(searchTerm, status).ToListAsync();

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("MaGiamGia");
                var currentRow = 1;

                string[] headers = { "Mã Code", "Loại giảm", "Giá trị", "Đã dùng", "Giới hạn", "Ngày hết hạn", "Trạng thái" };
                for (int i = 0; i < headers.Length; i++) worksheet.Cell(1, i + 1).Value = headers[i];

                var headerRange = worksheet.Range(1, 1, 1, headers.Length);
                headerRange.Style.Font.Bold = true;
                headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#E24B4A");
                headerRange.Style.Font.FontColor = XLColor.White;

                foreach (var c in coupons)
                {
                    currentRow++;
                    worksheet.Cell(currentRow, 1).Value = c.Code;
                    worksheet.Cell(currentRow, 2).Value = c.DiscountType == "Percentage" ? "Phần trăm" : "Tiền mặt";
                    worksheet.Cell(currentRow, 3).Value = c.DiscountType == "Percentage" ? c.DiscountValue + "%" : c.DiscountValue.ToString("N0") + "đ";
                    worksheet.Cell(currentRow, 4).Value = c.UsedCount;
                    worksheet.Cell(currentRow, 5).Value = c.UsageLimit == 0 ? "Không giới hạn" : c.UsageLimit.ToString();
                    worksheet.Cell(currentRow, 6).Value = c.ExpiryDate.ToString("dd/MM/yyyy");
                    
                    var now = DateTime.Now;
                    var statusText = c.ExpiryDate < now ? "Hết hạn" : (c.UsageLimit > 0 && c.UsedCount >= c.UsageLimit ? "Hết lượt" : "Còn hiệu lực");
                    worksheet.Cell(currentRow, 7).Value = statusText;
                }

                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream()) {
                    workbook.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"MaGiamGia_{DateTime.Now:yyyyMMdd}.xlsx");
                }
            }
        }
    }
}
