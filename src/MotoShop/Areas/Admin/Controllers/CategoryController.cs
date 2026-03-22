using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class CategoryController : Controller
    {
        private readonly MotoShopDbContext _context;

        public CategoryController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var categories = await _context.Categories
                .Include(c => c.ParentCategory)
                .Include(c => c.Products)
                .OrderBy(c => c.ParentId)
                .ToListAsync();

            ViewBag.ParentCategories = await _context.Categories.Where(c => c.ParentId == null).ToListAsync();
            return View(categories);
        }

        [HttpPost]
        public async Task<IActionResult> Upsert(int? id, string name, int? parentId)
        {
            if (string.IsNullOrEmpty(name)) return Json(new { success = false, message = "Tên danh mục không được để trống" });

            if (id == null || id == 0) // Create
            {
                var category = new Category { 
                    CategoryName = name, 
                    ParentId = parentId,
                    Slug = name.ToLower().Replace(" ", "-") 
                };
                _context.Categories.Add(category);
            }
            else // Update
            {
                var category = await _context.Categories.FindAsync(id);
                if (category == null) return Json(new { success = false, message = "Không tìm thấy danh mục" });
                
                category.CategoryName = name;
                category.ParentId = parentId;
                category.Slug = name.ToLower().Replace(" ", "-");
                _context.Categories.Update(category);
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var category = await _context.Categories.Include(c => c.SubCategories).FirstOrDefaultAsync(c => c.CategoryId == id);
            if (category == null) return Json(new { success = false, message = "Không tìm thấy danh mục" });

            if (category.SubCategories.Any())
                return Json(new { success = false, message = "Không thể xóa danh mục này vì có chứa danh mục con" });

            _context.Categories.Remove(category);
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }
    }
}
