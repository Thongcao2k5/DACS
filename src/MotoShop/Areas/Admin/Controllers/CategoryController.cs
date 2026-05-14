using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Microsoft.AspNetCore.Authorization.Authorize(Roles = "Admin")]
    public class CategoryController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly Microsoft.Extensions.Caching.Memory.IMemoryCache _cache;

        public CategoryController(MotoShopDbContext context, Microsoft.Extensions.Caching.Memory.IMemoryCache cache)
        {
            _context = context;
            _cache = cache;
        }

        private void ClearHomeCache()
        {
            _cache.Remove(MotoShop.Data.Constants.CacheKeys.HomeCategories);
            _cache.Remove(MotoShop.Data.Constants.CacheKeys.HomeCategoryProducts);
        }

        // GET: Admin/Category
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

        // GET: Admin/Category/GetCategory/5
        [HttpGet]
        public async Task<IActionResult> GetCategory(int id)
        {
            var category = await _context.Categories.FindAsync(id);
            if (category == null) return NotFound();
            return Json(new { 
                categoryId = category.CategoryId, 
                categoryName = category.CategoryName, 
                parentId = category.ParentId,
                description = category.Description,
                imageUrl = category.ImageUrl
            });
        }

        // POST: Admin/Category/Upsert
        [HttpPost]
        public async Task<IActionResult> Upsert(int? CategoryId, string CategoryName, int? ParentId, string Description, string ImageUrl)
        {
            if (string.IsNullOrEmpty(CategoryName)) 
                return Json(new { success = false, message = "Tên danh mục không được để trống!" });

            try 
            {
                if (CategoryId == null || CategoryId == 0) // Thêm mới
                {
                    var category = new Category 
                    { 
                        CategoryName = CategoryName, 
                        ParentId = ParentId == 0 ? null : ParentId,
                        Description = Description,
                        ImageUrl = ImageUrl,
                        Slug = CategoryName.ToLower().Replace(" ", "-").Replace("đ", "d").Replace("/", "-")
                    };
                    _context.Categories.Add(category);
                }
                else // Cập nhật
                {
                    var category = await _context.Categories.FindAsync(CategoryId);
                    if (category == null) return Json(new { success = false, message = "Không tìm thấy danh mục!" });
                    
                    category.CategoryName = CategoryName;
                    category.ParentId = ParentId == 0 ? null : ParentId;
                    category.Description = Description;
                    category.ImageUrl = ImageUrl;
                    category.Slug = CategoryName.ToLower().Replace(" ", "-").Replace("đ", "d").Replace("/", "-");
                    _context.Categories.Update(category);
                }

                await _context.SaveChangesAsync();
                ClearHomeCache();
                return Json(new { success = true, message = "Lưu danh mục thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Có lỗi xảy ra: " + ex.Message });
            }
        }

        // POST: Admin/Category/Delete/5
        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var category = await _context.Categories
                .Include(c => c.SubCategories)
                .Include(c => c.Products)
                .FirstOrDefaultAsync(c => c.CategoryId == id);

            if (category == null) return Json(new { success = false, message = "Không tìm thấy danh mục!" });

            if (category.SubCategories.Any())
                return Json(new { success = false, message = "Không thể xóa danh mục này vì đang có chứa danh mục con!" });

            if (category.Products.Any())
                return Json(new { success = false, message = "Không thể xóa danh mục này vì đang có sản phẩm thuộc về nó!" });

            _context.Categories.Remove(category);
            await _context.SaveChangesAsync();
            ClearHomeCache();
            return Json(new { success = true, message = "Đã xóa danh mục thành công!" });
        }
    }
}
