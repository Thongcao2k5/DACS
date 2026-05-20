using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Business.Interfaces;
using System.Text.RegularExpressions;
using System.Text;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class BlogController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IFileService _fileService;

        public BlogController(MotoShopDbContext context, IFileService fileService)
        {
            _context = context;
            _fileService = fileService;
        }

        public async Task<IActionResult> Index(string? searchTerm, int? categoryId, int? status, bool? isPublished)
        {
            var query = _context.Blogs.Include(b => b.Category).AsQueryable();
            if (!string.IsNullOrEmpty(searchTerm)) query = query.Where(b => b.Title.Contains(searchTerm));
            if (categoryId.HasValue) query = query.Where(b => b.CategoryId == categoryId.Value);
            if (status.HasValue) query = query.Where(b => b.Status == status.Value);
            if (isPublished.HasValue) query = query.Where(b => b.IsPublished == isPublished.Value);

            var blogs = await query.OrderByDescending(b => b.CreatedDate).ToListAsync();
            ViewBag.Categories = await _context.BlogCategories.ToListAsync();
            ViewBag.SearchTerm = searchTerm;
            ViewBag.CategoryId = categoryId;
            ViewBag.Status = status;
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

        public async Task<IActionResult> Edit(int id)
        {
            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return NotFound();

            ViewBag.CategoryId = new SelectList(await _context.BlogCategories.ToListAsync(), "Id", "Name", blog.CategoryId);
            return View(blog);
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
                    var uploadResult = await _fileService.SaveFileAsync(thumbFile, "blog");
                    if (!uploadResult.IsSuccess)
                    {
                        ModelState.AddModelError("Thumbnail", uploadResult.ErrorMessage!);
                        ViewBag.Categories = await _context.BlogCategories.ToListAsync();
                        return View(blog);
                    }
                    if (!string.IsNullOrEmpty(blog.Thumbnail)) _fileService.DeleteFile(blog.Thumbnail);
                    blog.Thumbnail = uploadResult.FilePath;
                }

                SyncPublishState(blog);

                if (blog.Id == 0)
                {
                    blog.CreatedDate = DateTime.Now;
                    _context.Add(blog);
                }
                else
                {
                    blog.UpdatedDate = DateTime.Now;
                    _context.Update(blog);
                }

                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewBag.Categories = await _context.BlogCategories.ToListAsync();
            return View(blog);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(Blog blog, IFormFile? thumbnailFile)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.CategoryId = new SelectList(await _context.BlogCategories.ToListAsync(), "Id", "Name", blog.CategoryId);
                return View(blog);
            }

            var existing = await _context.Blogs.FindAsync(blog.Id);
            if (existing == null) return NotFound();

            if (string.IsNullOrWhiteSpace(blog.Slug))
            {
                blog.Slug = GenerateSlug(blog.Title);
            }

            existing.Title = blog.Title.Trim();
            existing.Slug = GenerateSlug(blog.Slug);
            existing.Content = blog.Content;
            existing.CategoryId = blog.CategoryId;
            existing.Status = blog.Status;
            existing.IsPublished = blog.IsPublished;
            existing.MetaTitle = blog.MetaTitle;
            existing.MetaDescription = blog.MetaDescription;
            existing.UpdatedDate = DateTime.Now;
            SyncPublishState(existing);

            if (thumbnailFile != null)
            {
                var uploadResult = await _fileService.SaveFileAsync(thumbnailFile, "blog");
                if (!uploadResult.IsSuccess)
                {
                    ModelState.AddModelError("Thumbnail", uploadResult.ErrorMessage!);
                    ViewBag.CategoryId = new SelectList(await _context.BlogCategories.ToListAsync(), "Id", "Name", blog.CategoryId);
                    return View(blog);
                }

                if (!string.IsNullOrEmpty(existing.Thumbnail))
                {
                    _fileService.DeleteFile(existing.Thumbnail);
                }
                existing.Thumbnail = uploadResult.FilePath;
            }

            await _context.SaveChangesAsync();
            TempData["Success"] = "Cập nhật bài viết thành công.";
            return RedirectToAction(nameof(Details), new { id = existing.Id });
        }

        public async Task<IActionResult> Details(int id)
        {
            var blog = await _context.Blogs
                .Include(b => b.Category)
                .FirstOrDefaultAsync(b => b.Id == id);

            if (blog == null) return NotFound();
            return View(blog);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleStatus(int id)
        {
            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return Json(new { success = false, message = "Không tìm thấy bài viết." });

            blog.IsPublished = !blog.IsPublished;
            blog.Status = blog.IsPublished ? 1 : 0;
            blog.UpdatedDate = DateTime.Now;
            await _context.SaveChangesAsync();

            return Json(new
            {
                success = true,
                message = blog.IsPublished ? "Đã đăng bài viết." : "Đã chuyển bài viết về bản nháp.",
                status = blog.Status,
                isPublished = blog.IsPublished
            });
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var blog = await _context.Blogs.FindAsync(id);
            if (blog == null) return Json(new { success = false, message = "Không tìm thấy bài viết" });
            if (!string.IsNullOrEmpty(blog.Thumbnail)) _fileService.DeleteFile(blog.Thumbnail);
            _context.Blogs.Remove(blog);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Xóa bài viết thành công" });
        }

        private static void SyncPublishState(Blog blog)
        {
            if (blog.Status == 1 || blog.IsPublished)
            {
                blog.Status = 1;
                blog.IsPublished = true;
            }
            else
            {
                blog.Status = 0;
                blog.IsPublished = false;
            }
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
