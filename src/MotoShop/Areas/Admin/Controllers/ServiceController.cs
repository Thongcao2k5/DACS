using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;
using ClosedXML.Excel;
using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class ServiceController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IWebHostEnvironment _env;

        public ServiceController(MotoShopDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? status, int page = 1, int pageSize = 10)
        {
            var query = _context.Services.AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
                query = query.Where(s => s.ServiceName.Contains(searchTerm));

            if (!string.IsNullOrEmpty(status))
            {
                bool isActive = status == "Active";
                query = query.Where(s => s.IsActive == isActive);
            }

            var totalItems = await query.CountAsync();
            var services = await query
                .OrderBy(s => s.ServiceName)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(services);
        }

        [HttpPost]
        public async Task<IActionResult> Save(Service service, IFormFile? imageFile, bool IsActive = false)
        {
            service.IsActive = IsActive;
            if (service.ServiceId == 0)
            {
                if (imageFile != null)
                {
                    string uploadsFolder = Path.Combine(_env.WebRootPath, "uploads/services");
                    if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);
                    
                    string uniqueFileName = Guid.NewGuid().ToString() + "_" + imageFile.FileName;
                    string filePath = Path.Combine(uploadsFolder, uniqueFileName);
                    using (var fileStream = new FileStream(filePath, FileMode.Create))
                    {
                        await imageFile.CopyToAsync(fileStream);
                    }
                    service.ImageUrl = "/uploads/services/" + uniqueFileName;
                }
                
                // Tự động tạo Slug nếu chưa có
                if (string.IsNullOrEmpty(service.Slug)) 
                    service.Slug = service.ServiceName.ToLower().Replace(" ", "-");

                _context.Services.Add(service);
            }
            else
            {
                var existing = await _context.Services.FindAsync(service.ServiceId);
                if (existing == null) return Json(new { success = false, message = "Không tìm thấy dịch vụ" });

                existing.ServiceName = service.ServiceName;
                existing.Price = service.Price;
                existing.Description = service.Description;
                existing.IsActive = IsActive;

                if (imageFile != null)
                {
                    string uploadsFolder = Path.Combine(_env.WebRootPath, "uploads/services");
                    if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);
                    
                    string uniqueFileName = Guid.NewGuid().ToString() + "_" + imageFile.FileName;
                    string filePath = Path.Combine(uploadsFolder, uniqueFileName);
                    using (var fileStream = new FileStream(filePath, FileMode.Create))
                    {
                        await imageFile.CopyToAsync(fileStream);
                    }
                    existing.ImageUrl = "/uploads/services/" + uniqueFileName;
                }
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Lưu dịch vụ thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var service = await _context.Services.FindAsync(id);
            if (service == null) return Json(new { success = false });

            _context.Services.Remove(service);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Xóa thành công" });
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
                    ws.Cell(row, 3).Value = s.IsActive ? "Đang cung cấp" : "Tạm ngừng";
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
