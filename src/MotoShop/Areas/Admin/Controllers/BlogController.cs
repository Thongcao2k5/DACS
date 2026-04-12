using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class BlogController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IWebHostEnvironment _env;

        public BlogController(MotoShopDbContext context, IWebHostEnvironment env)
        {
            _context = context;
            _env = env;
        }

        #region Blog Posts
        public async Task<IActionResult> Index(string? searchTerm, int? categoryId, bool? isPublished, int page = 1, int pageSize = 10)
        {
            var query = _context.Blogs.Include(b => b.Category).AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
                query = query.Where(b => b.Title.Contains(searchTerm));
            
            if (categoryId.HasValue)
                query = query.Where(b => b.CategoryId == categoryId);

            if (isPublished.HasValue)
                query = query.Where(b => b.IsPublished == isPublished.Value);

            var totalItems = await query.CountAsync();
            var blogs = await query
                .OrderByDescending(b => b.CreatedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.Categories = await _context.BlogCategories.ToListAsync();
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(blogs);
        }

        public async Task<IActionResult> Upsert(int? id)
        {
            ViewBag.Categories = await _context.BlogCategories.ToListAsync();
            if (id == null) return View(new Blog { CreatedDate = DateTime.Now });

            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return NotFound();
            return View(blog);
        }

        [HttpPost]
        public async Task<IActionResult> Upsert(Blog blog, IFormFile? thumbFile)
        {
            if (blog.Id == 0)
            {
                if (thumbFile != null)
                {
                    string folder = Path.Combine(_env.WebRootPath, "uploads/blogs");
                    if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                    string fileName = Guid.NewGuid().ToString() + "_" + thumbFile.FileName;
                    using (var fs = new FileStream(Path.Combine(folder, fileName), FileMode.Create))
                    {
                        await thumbFile.CopyToAsync(fs);
                    }
                    blog.Thumbnail = "/uploads/blogs/" + fileName;
                }
                _context.Blogs.Add(blog);
            }
            else
            {
                var existing = await _context.Blogs.FindAsync(blog.Id);
                if (existing == null) return NotFound();

                existing.Title = blog.Title;
                existing.Slug = blog.Slug;
                existing.Content = blog.Content;
                existing.CategoryId = blog.CategoryId;
                existing.IsPublished = blog.IsPublished;

                if (thumbFile != null)
                {
                    string folder = Path.Combine(_env.WebRootPath, "uploads/blogs");
                    if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                    string fileName = Guid.NewGuid().ToString() + "_" + thumbFile.FileName;
                    using (var fs = new FileStream(Path.Combine(folder, fileName), FileMode.Create))
                    {
                        await thumbFile.CopyToAsync(fs);
                    }
                    existing.Thumbnail = "/uploads/blogs/" + fileName;
                }
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return Json(new { success = false });
            _context.Blogs.Remove(blog);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa bài viết" });
        }
        #endregion

        #region Blog Categories
        public async Task<IActionResult> Categories()
        {
            var categories = await _context.BlogCategories.Include(c => c.Blogs).ToListAsync();
            return View(categories);
        }

        [HttpPost]
        public async Task<IActionResult> SaveCategory(BlogCategory category)
        {
            if (category.Id == 0) _context.BlogCategories.Add(category);
            else _context.Update(category);
            
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Lưu danh mục thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteCategory(int id)
        {
            var cat = await _context.BlogCategories.FindAsync(id);
            if (cat == null) return Json(new { success = false });
            _context.BlogCategories.Remove(cat);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa danh mục" });
        }
        #endregion
    }
}
