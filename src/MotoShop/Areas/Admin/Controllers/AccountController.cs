using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class AccountController : Controller
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly MotoShopDbContext _context;

        public AccountController(UserManager<IdentityUser> userManager, MotoShopDbContext context)
        {
            _userManager = userManager;
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return NotFound();

            // Lấy thông tin Staff/Admin từ database nếu cần
            var staff = await _context.Staffs
                .Include(s => s.Store)
                .FirstOrDefaultAsync(s => s.UserId == user.Id);

            ViewBag.User = user;
            return View(staff);
        }

        [HttpGet]
        public IActionResult Profile()
        {
            return RedirectToAction("Index");
        }
    }
}
