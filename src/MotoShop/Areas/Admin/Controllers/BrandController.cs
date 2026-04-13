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

        // GET: Admin/Brand
        public async Task<IActionResult> Index()
        {
            var brands = await _context.Brands.OrderBy(b => b.BrandName).ToListAsync();
            return View(brands);
        }

        // POST: Admin/Brand/Create
        [HttpPost]
        public async Task<IActionResult> Create(Brand brand)
        {
            if (ModelState.IsValid)
            {
                _context.Brands.Add(brand);
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Thêm thương hiệu thành công!" });
            }
            return Json(new { success = false, message = "Dữ liệu không hợp lệ!" });
        }

        // POST: Admin/Brand/Edit
        [HttpPost]
        public async Task<IActionResult> Edit(Brand brand)
        {
            if (ModelState.IsValid)
            {
                _context.Entry(brand).State = EntityState.Modified;
                await _context.SaveChangesAsync();
                return Json(new { success = true, message = "Cập nhật thương hiệu thành công!" });
            }
            return Json(new { success = false, message = "Cập nhật thất bại!" });
        }

        // GET: Admin/Brand/GetBrand/5
        [HttpGet]
        public async Task<IActionResult> GetBrand(int id)
        {
            var brand = await _context.Brands.FindAsync(id);
            if (brand == null) return NotFound();
            return Json(brand);
        }

        // POST: Admin/Brand/Delete/5
        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var brand = await _context.Brands.FindAsync(id);
            if (brand == null) return Json(new { success = false, message = "Không tìm thấy thương hiệu!" });

            // Kiểm tra xem thương hiệu có đang chứa sản phẩm nào không
            var hasProducts = await _context.Products.AnyAsync(p => p.BrandId == id);
            if (hasProducts)
            {
                return Json(new { success = false, message = "Không thể xóa thương hiệu này vì đang có sản phẩm thuộc về nó!" });
            }

            _context.Brands.Remove(brand);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa thương hiệu!" });
        }
    }
}
