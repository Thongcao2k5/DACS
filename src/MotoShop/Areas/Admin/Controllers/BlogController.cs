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
    public class BlogController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IWebHostEnvironment _hostEnvironment;

        public BlogController(MotoShopDbContext context, IWebHostEnvironment hostEnvironment)
        {
            _context = context;
            _hostEnvironment = hostEnvironment;
        }

        public async Task<IActionResult> Index(string searchTerm, int? categoryId, int? status)
        {
            var query = _context.Blogs.Include(b => b.Category).AsQueryable();
            if (!string.IsNullOrEmpty(searchTerm)) query = query.Where(b => b.Title.Contains(searchTerm));
            if (categoryId.HasValue) query = query.Where(b => b.CategoryId == categoryId.Value);
            if (status.HasValue) query = query.Where(b => b.Status == status.Value);

            var blogs = await query.OrderByDescending(b => b.CreatedDate).ToListAsync();
            ViewBag.Categories = new SelectList(_context.BlogCategories, "Id", "Name", categoryId);
            ViewBag.SearchTerm = searchTerm;
            ViewBag.Status = status;
            return View(blogs);
        }

        public async Task<IActionResult> Details(int? id)
        {
            if (id == null) return NotFound();
            var blog = await _context.Blogs.Include(b => b.Category).FirstOrDefaultAsync(m => m.Id == id);
            if (blog == null) return NotFound();
            return View(blog);
        }

        public IActionResult Create()
        {
            ViewBag.CategoryId = new SelectList(_context.BlogCategories, "Id", "Name");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Blog blog, IFormFile? thumbnailFile)
        {
            if (ModelState.IsValid)
            {
                if (string.IsNullOrEmpty(blog.Slug)) blog.Slug = GenerateSlug(blog.Title);
                if (thumbnailFile != null) blog.Thumbnail = await SaveImage(thumbnailFile);
                
                blog.CreatedDate = DateTime.Now;
                _context.Add(blog);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewBag.CategoryId = new SelectList(_context.BlogCategories, "Id", "Name", blog.CategoryId);
            return View(blog);
        }

        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null) return NotFound();
            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return NotFound();
            ViewBag.CategoryId = new SelectList(_context.BlogCategories, "Id", "Name", blog.CategoryId);
            return View(blog);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Blog blog, IFormFile? thumbnailFile)
        {
            if (id != blog.Id) return NotFound();

            if (ModelState.IsValid)
            {
                try
                {
                    var existingBlog = await _context.Blogs.AsNoTracking().FirstOrDefaultAsync(b => b.Id == id);
                    if (existingBlog == null) return NotFound();

                    blog.CreatedDate = existingBlog.CreatedDate;
                    blog.UpdatedDate = DateTime.Now;

                    if (string.IsNullOrEmpty(blog.Slug)) blog.Slug = GenerateSlug(blog.Title);

                    if (thumbnailFile != null)
                    {
                        if (!string.IsNullOrEmpty(existingBlog.Thumbnail)) DeleteImage(existingBlog.Thumbnail);
                        blog.Thumbnail = await SaveImage(thumbnailFile);
                    }
                    else
                    {
                        blog.Thumbnail = existingBlog.Thumbnail;
                    }

                    _context.Update(blog);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!_context.Blogs.Any(e => e.Id == blog.Id)) return NotFound();
                    else throw;
                }
                return RedirectToAction(nameof(Index));
            }
            ViewBag.CategoryId = new SelectList(_context.BlogCategories, "Id", "Name", blog.CategoryId);
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
