using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Policy = "RequireSystemAdmin")]
public class UserController(UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var users = userManager.Users.ToList();
        return View(users);
    }

    [HttpPost]
    public async Task<IActionResult> ChangeRole(string userId, UserRole newRole)
    {
        var user = await userManager.FindByIdAsync(userId);
        if (user is null) return NotFound();

        user.Role = newRole;

        // Update identity role
        var currentRoles = await userManager.GetRolesAsync(user);
        await userManager.RemoveFromRolesAsync(user, currentRoles);
        await userManager.AddToRoleAsync(user, newRole.ToString());
        await userManager.UpdateAsync(user);

        TempData["Success"] = $"Role updated for {user.Email}.";
        return RedirectToAction(nameof(Index));
    }
}
