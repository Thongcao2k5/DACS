using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Microsoft.AspNetCore.Authorization.Authorize(Roles = "Admin")]
    public class BrandController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IWebHostEnvironment _env;

        public BrandController(MotoShopDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        public async Task<IActionResult> Index()
        {
            var brands = await _context.Brands.OrderBy(b => b.BrandName).ToListAsync();
            return View(brands);
        }

        [HttpPost]
        public async Task<IActionResult> Create(Brand brand, IFormFile? logoFile)
        {
            if (ModelState.IsValid)
            {
                brand.LogoUrl = await SaveLogoAsync(logoFile, brand.LogoUrl);
                _context.Brands.Add(brand);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Thêm thương hiệu thành công!" });
            }
            return Json(new { success = false, message = "Dữ liệu không hợp lệ!" });
        }

        [HttpPost]
        public async Task<IActionResult> Edit(Brand brand, IFormFile? logoFile)
        {
            if (ModelState.IsValid)
            {
                var existing = await _context.Brands.FindAsync(brand.BrandId);
                if (existing == null)
                    return Json(new { success = false, message = "Không tìm thấy thương hiệu!" });

                existing.BrandName  = brand.BrandName;
                existing.Description = brand.Description;
                existing.LogoUrl    = await SaveLogoAsync(logoFile, brand.LogoUrl) ?? existing.LogoUrl;

                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Cập nhật thương hiệu thành công!" });
            }
            return Json(new { success = false, message = "Cập nhật thất bại!" });
        }

        [HttpGet]
        public async Task<IActionResult> GetBrand(int id)
        {
            var brand = await _context.Brands.FindAsync(id);
            if (brand == null) return NotFound();
            return Json(brand);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var brand = await _context.Brands.FindAsync(id);
            if (brand == null)
                return Json(new { success = false, message = "Không tìm thấy thương hiệu!" });

            var hasProducts = await _context.Products.AnyAsync(p => p.BrandId == id);
            if (hasProducts)
                return Json(new { success = false, message = "Không thể xóa thương hiệu này vì đang có sản phẩm thuộc về nó!" });

            _context.Brands.Remove(brand);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa thương hiệu!" });
        }

        // Lưu file ảnh upload, trả về path local; hoặc giữ nguyên URL nếu không upload file
        private async Task<string?> SaveLogoAsync(IFormFile? file, string? fallbackUrl)
        {
            if (file == null || file.Length == 0)
                return string.IsNullOrWhiteSpace(fallbackUrl) ? null : fallbackUrl;

            var uploadDir = Path.Combine(_env.WebRootPath, "uploads", "brands");
            if (!Directory.Exists(uploadDir))
                Directory.CreateDirectory(uploadDir);

            var ext      = Path.GetExtension(file.FileName).ToLowerInvariant();
            var fileName = $"{Path.GetFileNameWithoutExtension(file.FileName).ToLowerInvariant().Replace(" ", "-")}_{System.DateTime.Now.Ticks}{ext}";
            var filePath = Path.Combine(uploadDir, fileName);

            using var stream = new FileStream(filePath, FileMode.Create);
            await file.CopyToAsync(stream);

            return $"/uploads/brands/{fileName}";
        }
    }
}
