using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class AccountController : Controller
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly MotoShopDbContext _context;
        private readonly IAuditLogService _auditLogService;

        public AccountController(UserManager<IdentityUser> userManager, MotoShopDbContext context, IAuditLogService auditLogService)
        {
            _userManager = userManager;
            _context = context;
            _auditLogService = auditLogService;
        }

        public async Task<IActionResult> Index()
        {
            var user = await _userManager.GetUserAsync(User);
            if (user == null) return NotFound();

            // Log Admin Login / Profile Access
            await _auditLogService.LogActionAsync(user.Id, "AdminAccess", "Account", null, null, null, HttpContext.Connection.RemoteIpAddress?.ToString());

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
