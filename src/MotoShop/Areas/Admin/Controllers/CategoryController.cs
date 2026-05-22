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

            var resolvedParentId = ParentId == 0 ? null : ParentId;

            try
            {
                if (CategoryId == null || CategoryId == 0) // Thêm mới
                {
                    var slug = await MakeUniqueSlugAsync(CategoryName, excludeId: 0);
                    var category = new Category
                    {
                        CategoryName = CategoryName,
                        ParentId = resolvedParentId,
                        Description = Description,
                        ImageUrl = ImageUrl,
                        Slug = slug
                    };
                    _context.Categories.Add(category);
                }
                else // Cập nhật
                {
                    var category = await _context.Categories.FindAsync(CategoryId);
                    if (category == null) return Json(new { success = false, message = "Không tìm thấy danh mục!" });

                    // Kiểm tra circular reference: không được đặt cha là chính mình hoặc con cháu của mình
                    if (resolvedParentId.HasValue)
                    {
                        if (resolvedParentId == CategoryId)
                            return Json(new { success = false, message = "Danh mục không thể là cha của chính nó!" });

                        // Duyệt lên từ proposed parent, nếu gặp CategoryId hiện tại thì có vòng lặp
                        var checkId = resolvedParentId;
                        var visited = new System.Collections.Generic.HashSet<int>();
                        while (checkId.HasValue)
                        {
                            if (checkId == CategoryId.Value)
                                return Json(new { success = false, message = "Không thể chọn danh mục cha này vì tạo vòng lặp trong cây danh mục!" });
                            if (!visited.Add(checkId.Value)) break; // Chống loop trong data cũ bị hỏng
                            checkId = await _context.Categories
                                .Where(c => c.CategoryId == checkId.Value)
                                .Select(c => c.ParentId)
                                .FirstOrDefaultAsync();
                        }
                    }

                    category.CategoryName = CategoryName;
                    category.ParentId = resolvedParentId;
                    category.Description = Description;
                    category.ImageUrl = ImageUrl;
                    category.Slug = await MakeUniqueSlugAsync(CategoryName, excludeId: CategoryId.Value);
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

        // Tạo slug duy nhất: nếu đã tồn tại thì tự thêm hậu tố -2, -3, ...
        private async Task<string> MakeUniqueSlugAsync(string name, int excludeId)
        {
            var baseSlug = name.ToLower()
                .Replace("đ", "d").Replace("Đ", "d")
                .Replace("/", "-").Replace(" ", "-");

            var slug = baseSlug;
            var suffix = 2;
            while (await _context.Categories.AnyAsync(c => c.Slug == slug && c.CategoryId != excludeId))
            {
                slug = $"{baseSlug}-{suffix++}";
            }
            return slug;
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
