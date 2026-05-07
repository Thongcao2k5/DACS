using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Text.RegularExpressions;
using System.Text;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class BlogController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;

        public BlogController(MotoShopDbContext context, IWebHostEnvironment hostEnvironment)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;
        }

        public async Task<IActionResult> Index(string? searchTerm, int? categoryId, bool? isPublished)
        {
            var query = _context.Blogs.Include(b => b.Category).AsQueryable();
            if (!string.IsNullOrEmpty(searchTerm)) query = query.Where(b => b.Title.Contains(searchTerm));
            if (categoryId.HasValue) query = query.Where(b => b.CategoryId == categoryId.Value);
            if (isPublished.HasValue) query = query.Where(b => b.IsPublished == isPublished.Value);

            var blogs = await query.OrderByDescending(b => b.CreatedDate).ToListAsync();
            ViewBag.Categories = await _context.BlogCategories.ToListAsync();
            ViewBag.SearchTerm = searchTerm;
            return View(blogs);
        }

        public async Task<IActionResult> Upsert(int? id)
        {
            ViewBag.Categories = await _context.BlogCategories.ToListAsync();

            if (id == null || id == 0) return View(new Blog());

            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return NotFound();
            return View(blog);
        }

        // Action bổ trợ để tương thích với các link cũ
        public IActionResult Create()
        {
            return RedirectToAction(nameof(Upsert));
        }

        public IActionResult Edit(int id)
        {
            return RedirectToAction(nameof(Upsert), new { id = id });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Upsert(Blog blog, IFormFile? thumbFile)
        {
            if (ModelState.IsValid)
            {
                if (string.IsNullOrEmpty(blog.Slug)) blog.Slug = GenerateSlug(blog.Title);

                if (thumbFile != null)
                {
                    if (!string.IsNullOrEmpty(blog.Thumbnail)) DeleteImage(blog.Thumbnail);
                    blog.Thumbnail = await SaveImage(thumbFile);
                }

                if (blog.Id == 0)
                {
                    blog.CreatedDate = DateTime.Now;
                    _context.Add(blog);
                }
                else
                {
                    _context.Update(blog);
                }

                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewBag.Categories = await _context.BlogCategories.ToListAsync();
            return View(blog);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return Json(new { success = false, message = "Không tìm thấy bài viết" });
            if (!string.IsNullOrEmpty(blog.Thumbnail)) DeleteImage(blog.Thumbnail);
            _context.Blogs.Remove(blog);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Xóa bài viết thành công" });
        }

        private async Task<string> SaveImage(IFormFile file)
        {
            string wwwRootPath = _hostEnvironment.WebRootPath;
            string fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            string uploadDir = Path.Combine(wwwRootPath, "uploads", "blog");

            if (!Directory.Exists(uploadDir)) Directory.CreateDirectory(uploadDir);

            string filePath = Path.Combine(uploadDir, fileName);
            using (var fileStream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(fileStream);
            }
            return "/uploads/blog/" + fileName;
        }

        private void DeleteImage(string imagePath)
        {
            if (string.IsNullOrEmpty(imagePath) || imagePath.StartsWith("http")) return;
            string fullPath = Path.Combine(_hostEnvironment.WebRootPath, imagePath.TrimStart('/'));
            if (System.IO.File.Exists(fullPath)) System.IO.File.Delete(fullPath);
        }

        private string GenerateSlug(string phrase)
        {
            string str = RemoveAccent(phrase).ToLower();
            str = Regex.Replace(str, @"[^a-z0-9\s-]", "");
            str = Regex.Replace(str, @"\s+", " ").Trim();
            str = str.Substring(0, str.Length <= 45 ? str.Length : 45).Trim();
            str = Regex.Replace(str, @"\s", "-");
            return str;
        }

        private string RemoveAccent(string text)
        {
            if (string.IsNullOrWhiteSpace(text)) return text;
            text = text.Normalize(NormalizationForm.FormD);
            char[] chars = text.Where(c => char.GetUnicodeCategory(c) != System.Globalization.UnicodeCategory.NonSpacingMark).ToArray();
            string result = new string(chars).Normalize(NormalizationForm.FormC);
            return result.Replace('đ', 'd').Replace('Đ', 'D');
        }
    }
}
