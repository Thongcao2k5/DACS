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
    [Microsoft.AspNetCore.Authorization.Authorize(Roles = "Admin")]
    public class ReviewController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ReviewController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? status, int? stars, int page = 1, int pageSize = 10)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var query = GetFilteredReviewsQuery(searchTerm, status, stars);

            var totalItems = await query.CountAsync();
            var reviews = await query
                .OrderByDescending(r => r.CreatedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            ViewBag.Stars = stars;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(reviews);
        }

        private IQueryable<ProductReview> GetFilteredReviewsQuery(string? searchTerm, string? status, int? stars)
        {
            var query = _context.ProductReviews
                .Include(r => r.Product)
                .Include(r => r.Customer)
                .Include(r => r.Images)
                .AsNoTracking()
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(r => (r.Product != null && r.Product.ProductName.Contains(searchTerm)) || 
                                       (r.Customer != null && r.Customer.FullName.Contains(searchTerm)));
            }

            if (!string.IsNullOrEmpty(status))
            {
                query = query.Where(r => r.Status == status);
            }

            if (stars.HasValue)
            {
                query = query.Where(r => r.Rating == stars.Value);
            }

            return query;
        }

        [HttpPost]
        public async Task<IActionResult> UpdateStatus(int id, string status)
        {
            var review = await _context.ProductReviews.FindAsync(id);
            if (review == null) return Json(new { success = false });

            review.Status = status;
            await _context.SaveChangesAsync();

            string msg = status == MotoShop.Data.Constants.ReviewStatusConst.Approved ? "Đã duyệt đánh giá" : "Đã ẩn đánh giá";
            return Json(new { success = true, message = msg });
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var review = await _context.ProductReviews
                .Include(r => r.Images)
                .FirstOrDefaultAsync(r => r.ReviewId == id);
            if (review == null) return Json(new { success = false });

            _context.ProductReviewImages.RemoveRange(review.Images);
            _context.ProductReviews.Remove(review);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Xóa đánh giá thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> BulkAction([FromBody] BulkActionModel model)
        {
            if (model.Ids == null || model.Ids.Length == 0) return Json(new { success = false });

            var reviews = await _context.ProductReviews
                .Include(r => r.Images)
                .Where(r => model.Ids.Contains(r.ReviewId))
                .ToListAsync();
            
            if (model.Action == "Delete")
            {
                _context.ProductReviewImages.RemoveRange(reviews.SelectMany(r => r.Images));
                _context.ProductReviews.RemoveRange(reviews);
            }
            else
            {
                foreach (var r in reviews) r.Status = model.Action;
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Thao tác hàng loạt thành công" });
        }

        public class BulkActionModel 
        { 
            public required int[] Ids { get; set; } 
            public required string Action { get; set; } 
        }

        public async Task<IActionResult> ExportExcel(string? searchTerm, string? status, int? stars)
        {
            var reviews = await GetFilteredReviewsQuery(searchTerm, status, stars).ToListAsync();

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("DanhGia");
                var currentRow = 1;
                string[] headers = { "Sản phẩm", "Khách hàng", "Số sao", "Nội dung", "Ngày đánh giá", "Trạng thái" };
                for (int i = 0; i < headers.Length; i++) worksheet.Cell(1, i + 1).Value = headers[i];

                var headerRange = worksheet.Range(1, 1, 1, headers.Length);
                headerRange.Style.Font.Bold = true;
                headerRange.Style.Fill.BackgroundColor = XLColor.FromHtml("#E24B4A");
                headerRange.Style.Font.FontColor = XLColor.White;

                foreach (var r in reviews)
                {
                    currentRow++;
                    worksheet.Cell(currentRow, 1).Value = r.Product?.ProductName;
                    worksheet.Cell(currentRow, 2).Value = r.Customer?.FullName;
                    worksheet.Cell(currentRow, 3).Value = r.Rating;
                    worksheet.Cell(currentRow, 4).Value = r.Comment;
                    worksheet.Cell(currentRow, 5).Value = r.CreatedDate.ToString("dd/MM/yyyy");
                    worksheet.Cell(currentRow, 6).Value = r.Status;
                }

                worksheet.Columns().AdjustToContents();
                using (var stream = new MemoryStream()) {
                    workbook.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"DanhGia_{DateTime.Now:yyyyMMdd}.xlsx");
                }
            }
        }
    }
}

