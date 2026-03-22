using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class BrandController : Controller
    {
        private readonly MotoShopDbContext _context;

        public BrandController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var brands = await _context.Brands
                .Include(b => b.Products)
                .OrderBy(b => b.BrandName)
                .ToListAsync();
            return View(brands);
        }

        [HttpPost]
        public async Task<IActionResult> Upsert(int? id, string name, string logoUrl, string description)
        {
            if (string.IsNullOrEmpty(name)) return Json(new { success = false, message = "Tên thương hiệu không được để trống" });

            if (id == null || id == 0) // Create
            {
                var brand = new Brand { 
                    BrandName = name, 
                    LogoUrl = logoUrl,
                    Description = description
                };
                _context.Brands.Add(brand);
            }
            else // Update
            {
                var brand = await _context.Brands.FindAsync(id);
                if (brand == null) return Json(new { success = false, message = "Không tìm thấy thương hiệu" });
                
                brand.BrandName = name;
                brand.LogoUrl = logoUrl;
                brand.Description = description;
                _context.Brands.Update(brand);
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var brand = await _context.Brands.Include(b => b.Products).FirstOrDefaultAsync(b => b.BrandId == id);
            if (brand == null) return Json(new { success = false, message = "Không tìm thấy thương hiệu" });

            if (brand.Products.Any())
                return Json(new { success = false, message = "Không thể xóa thương hiệu này vì đang có sản phẩm thuộc thương hiệu này" });

            _context.Brands.Remove(brand);
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }
    }
}
