using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
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

        public async Task<IActionResult> Index(string? searchTerm, int? categoryId)
        {
            var query = _context.Blogs.Include(b => b.Category)
                .Where(b => b.Status == 1); // Chỉ lấy bài viết đã đăng

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(b => b.Title.Contains(searchTerm));
            }

            if (categoryId.HasValue)
            {
                query = query.Where(b => b.CategoryId == categoryId.Value);
            }

            var blogs = await query.OrderByDescending(b => b.CreatedDate).ToListAsync();
            
            // Lấy danh sách danh mục để hiển thị ở Sidebar
            ViewBag.Categories = await _context.BlogCategories
                .Select(c => new { 
                    c.Id, 
                    c.Name, 
                    Count = c.Blogs.Count(b => b.Status == 1) 
                }).ToListAsync();

            ViewBag.RecentPosts = await _context.Blogs
                .Where(b => b.Status == 1)
                .OrderByDescending(b => b.CreatedDate)
                .Take(5)
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.CurrentCategoryId = categoryId;

            return View(blogs);
        }

        public async Task<IActionResult> Detail(string slug)
        {
            if (string.IsNullOrEmpty(slug)) return NotFound();

            var blog = await _context.Blogs
                .Include(b => b.Category)
                .FirstOrDefaultAsync(b => b.Slug == slug && b.Status == 1);

            if (blog == null) return NotFound();

            // Lấy bài viết liên quan
            ViewBag.RelatedPosts = await _context.Blogs
                .Where(b => b.CategoryId == blog.CategoryId && b.Id != blog.Id && b.Status == 1)
                .Take(3)
                .ToListAsync();

            return View(blog);
        }
    }
}
