using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.ViewComponents
{
    public class CategoryMenuViewComponent : ViewComponent
    {
        private readonly MotoShopDbContext _context;

        public CategoryMenuViewComponent(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var parentCategories = await _context.Categories
                .Where(c => c.ParentId == null)
                .Include(c => c.SubCategories)
                .OrderBy(c => c.CategoryName)
                .ToListAsync();

            return View(parentCategories);
        }
    }
}
