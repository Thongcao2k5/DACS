using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;
using ClosedXML.Excel;
using System.IO;

using MotoShop.Business.DTOs;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class PromotionController : Controller
    {
        private readonly MotoShopDbContext _context;

        public PromotionController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? status, decimal? minDiscount, string? discountUnit, int page = 1, int pageSize = 10)
        {
            var query = GetFilteredPromotionsQuery(searchTerm, status, minDiscount, discountUnit);

            var totalItems = await query.CountAsync();
            var now = DateTime.Now;

            var promotions = await query
                .OrderByDescending(p => p.StartDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(p => new PromotionDto
                {
                    PromotionId = p.PromotionId,
                    PromotionName = p.PromotionName,
                    Description = p.Description,
                    DiscountType = p.DiscountType,
                    DiscountPercentage = p.DiscountPercentage,
                    DiscountAmount = p.DiscountAmount,
                    MinOrderValue = p.MinOrderValue,
                    MinQuantity = p.MinQuantity,
                    StartDate = p.StartDate.ToString("yyyy-MM-dd"),
                    EndDate = p.EndDate.ToString("yyyy-MM-dd"),
                    IsActive = p.IsActive,
                    ProductCount = p.PromotionProducts.Count,
                    StatusText = !p.IsActive ? "Tạm dừng" : (p.StartDate > now ? "Sắp diễn ra" : (p.EndDate < now ? "Đã kết thúc" : "Đang áp dụng")),
                    StatusClass = !p.IsActive ? "badge-paused" : (p.StartDate > now ? "badge-upcoming" : (p.EndDate < now ? "badge-expired" : "badge-active"))
                })
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            ViewBag.MinDiscount = minDiscount;
            ViewBag.DiscountUnit = discountUnit ?? "Amount"; // Mặc định là VNĐ
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(promotions);
        }

        private IQueryable<Promotion> GetFilteredPromotionsQuery(string? searchTerm, string? status, decimal? minDiscount, string? discountUnit)
        {
            var query = _context.Promotions.AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(p => p.PromotionName.Contains(searchTerm));
            }

            if (minDiscount.HasValue)
            {
                var val = minDiscount.Value;
                if (discountUnit == "Percentage")
                {
                    query = query.Where(p => p.DiscountType == "Percentage" && p.DiscountPercentage >= val);
                }
                else
                {
                    query = query.Where(p => p.DiscountType == "FixedAmount" && p.DiscountAmount >= val);
                }
            }

            if (!string.IsNullOrEmpty(status))
            {
                var now = DateTime.Now;
                query = status switch
                {
                    "Active" => query.Where(p => p.IsActive && p.StartDate <= now && p.EndDate >= now),
                    "Upcoming" => query.Where(p => p.IsActive && p.StartDate > now),
                    "Expired" => query.Where(p => p.EndDate < now),
                    "Paused" => query.Where(p => !p.IsActive),
                    _ => query
                };
            }

            return query;
        }

        [HttpPost]
        public async Task<IActionResult> Save(Promotion promotion)
        {
            if (promotion.DiscountType == "Percentage")
            {
                promotion.DiscountAmount = 0;
            }
            else
            {
                promotion.DiscountPercentage = 0;
            }

            if (promotion.PromotionId == 0)
            {
                _context.Promotions.Add(promotion);
            }
            else
            {
                var existing = await _context.Promotions.FindAsync(promotion.PromotionId);
                if (existing == null) return Json(new { success = false, message = "Không tìm thấy chương trình" });

                existing.PromotionName = promotion.PromotionName;
                existing.Description = promotion.Description;
                existing.DiscountType = promotion.DiscountType;
                existing.DiscountPercentage = promotion.DiscountPercentage;
                existing.DiscountAmount = promotion.DiscountAmount;
                existing.MinOrderValue = promotion.MinOrderValue;
                existing.MinQuantity = promotion.MinQuantity;
                existing.StartDate = promotion.StartDate;
                existing.EndDate = promotion.EndDate;
                existing.IsActive = promotion.IsActive;
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = promotion.PromotionId == 0 ? "Thêm thành công" : "Cập nhật thành công" });
        }

        [HttpGet]
        public async Task<IActionResult> GetProducts(int promotionId, string? searchTerm, int? categoryId)
        {
            var promotion = await _context.Promotions.FindAsync(promotionId);
            if (promotion == null) return NotFound();

            var assignedProductIds = await _context.PromotionProducts
                .Where(pp => pp.PromotionId == promotionId)
                .Select(pp => pp.ProductId)
                .ToListAsync();

            var productsQuery = _context.Products
                .Include(p => p.Variants)
                .Where(p => !p.IsDeleted)
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
                productsQuery = productsQuery.Where(p => p.ProductName.Contains(searchTerm));
            
            if (categoryId.HasValue)
                productsQuery = productsQuery.Where(p => p.CategoryId == categoryId);

            var products = await productsQuery.Select(p => new {
                p.ProductId,
                p.ProductName,
                IsAssigned = assignedProductIds.Contains(p.ProductId),
                BasePrice = p.Variants.OrderBy(v => v.Price).Select(v => v.Price).FirstOrDefault(),
                Stock = p.Variants.Sum(v => v.StockQuantity)
            }).ToListAsync();

            // Tính toán giá sau giảm ở phía Client hoặc Server
            var result = products.Select(p => new {
                p.ProductId,
                p.ProductName,
                p.IsAssigned,
                p.BasePrice,
                p.Stock,
                DiscountedPrice = CalculateDiscount(p.BasePrice, promotion)
            });

            return Json(result);
        }

        private static decimal CalculateDiscount(decimal price, Promotion p)
        {
            if (p.DiscountType == "Percentage")
                return price * (1 - p.DiscountPercentage / 100);
            return Math.Max(0, price - p.DiscountAmount);
        }

        [HttpPost]
        public async Task<IActionResult> BulkDelete(int[] ids)
        {
            if (ids == null || ids.Length == 0) return Json(new { success = false });
            var promos = await _context.Promotions.Where(p => ids.Contains(p.PromotionId)).ToListAsync();
            _context.Promotions.RemoveRange(promos);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = $"Đã xóa {promos.Count} chương trình" });
        }

        public async Task<IActionResult> ExportExcel(string? searchTerm, string? status, decimal? minDiscount, string? discountUnit)
        {
            var promotions = await GetFilteredPromotionsQuery(searchTerm, status, minDiscount, discountUnit)
                .Include(p => p.PromotionProducts)
                .ToListAsync();

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("Khuyến mãi");
                var currentRow = 1;

                string[] headers = { "Tên chương trình", "Loại giảm", "Giá trị", "Bắt đầu", "Kết thúc", "Sản phẩm áp dụng", "Trạng thái" };
                for (int i = 0; i < headers.Length; i++) worksheet.Cell(1, i + 1).Value = headers[i];

                var headerRange = worksheet.Range(1, 1, 1, headers.Length);
                headerRange.Style.Font.Bold = true;
                headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#E24B4A");
                headerRange.Style.Font.FontColor = XLColor.White;

                foreach (var p in promotions)
                {
                    currentRow++;
                    worksheet.Cell(currentRow, 1).Value = p.PromotionName;
                    worksheet.Cell(currentRow, 2).Value = p.DiscountType == "Percentage" ? "Phần trăm" : "Tiền mặt";
                    worksheet.Cell(currentRow, 3).Value = p.DiscountType == "Percentage" ? p.DiscountPercentage + "%" : p.DiscountAmount.ToString("N0") + "đ";
                    worksheet.Cell(currentRow, 4).Value = p.StartDate.ToString("dd/MM/yyyy");
                    worksheet.Cell(currentRow, 5).Value = p.EndDate.ToString("dd/MM/yyyy");
                    worksheet.Cell(currentRow, 6).Value = p.PromotionProducts.Count;

                    var now = DateTime.Now;
                    var statusText = !p.IsActive ? "Tạm dừng" : (p.StartDate > now ? "Sắp diễn ra" : (p.EndDate < now ? "Hết hạn" : "Đang hoạt động"));
                    worksheet.Cell(currentRow, 7).Value = statusText;
                }

                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"KhuyenMai_{DateTime.Now:yyyyMMdd}.xlsx");
                }
            }
        }

        [HttpPost]
        public async Task<IActionResult> AssignProducts(int promotionId, int[] productIds)
        {
            var existing = _context.PromotionProducts.Where(pp => pp.PromotionId == promotionId);
            _context.PromotionProducts.RemoveRange(existing);
            if (productIds != null)
            {
                foreach (var pid in productIds)
                    _context.PromotionProducts.Add(new PromotionProduct { PromotionId = promotionId, ProductId = pid });
            }
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Cập nhật sản phẩm áp dụng thành công" });
        }
    }
}
