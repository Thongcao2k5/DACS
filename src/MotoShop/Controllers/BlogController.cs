using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Business.DTOs;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class BlogController : Controller
    {
        private readonly MotoShopDbContext _context;

        public BlogController(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string? searchTerm, int? categoryId, int page = 1)
        {
            const int pageSize = 6;

            var query = _context.Blogs
                .Include(b => b.Category)
                .Where(b => b.IsPublished || b.Status == 1)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                query = query.Where(b => b.Title.Contains(searchTerm));
            }

            if (categoryId.HasValue)
            {
                query = query.Where(b => b.CategoryId == categoryId.Value);
            }

            var totalItems = await query.CountAsync();
            var blogs = await query
                .OrderByDescending(b => b.CreatedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Sử dụng DTO thay vì kiểu nặc danh
            ViewBag.Categories = await _context.BlogCategories
                .Select(c => new BlogCategoryDto { 
                    Id = c.Id, 
                    Name = c.Name, 
                    BlogCount = c.Blogs.Count(b => b.IsPublished || b.Status == 1) 
                })
                .ToListAsync();

            ViewBag.RecentPosts = await _context.Blogs
                .Where(b => b.IsPublished || b.Status == 1)
                .OrderByDescending(b => b.CreatedDate)
                .Take(5)
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.CurrentCategoryId = categoryId;
            ViewBag.CurrentCategory = categoryId;
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(blogs);
        }

        public async Task<IActionResult> Detail(string slug)
        {
            if (string.IsNullOrWhiteSpace(slug)) return NotFound();

            var blog = await _context.Blogs
                .Include(b => b.Category)
                .FirstOrDefaultAsync(b => b.Slug == slug && (b.IsPublished || b.Status == 1));

            if (blog == null) return NotFound();

            var relatedBlogs = await _context.Blogs
                .Where(b => b.CategoryId == blog.CategoryId && b.Id != blog.Id && (b.IsPublished || b.Status == 1))
                .OrderByDescending(b => b.CreatedDate)
                .Take(3)
                .ToListAsync();

            ViewBag.RelatedBlogs = relatedBlogs;
            ViewBag.RelatedPosts = relatedBlogs;
            
            // Sử dụng DTO thay vì kiểu nặc danh
            ViewBag.Categories = await _context.BlogCategories
                .Select(c => new BlogCategoryDto { 
                    Id = c.Id, 
                    Name = c.Name, 
                    BlogCount = c.Blogs.Count(b => b.IsPublished || b.Status == 1) 
                })
                .ToListAsync();

            return View(blog);
        }
    }
}
