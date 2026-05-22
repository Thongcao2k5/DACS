using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Controllers;

public class AccountController(SignInManager<ApplicationUser> signInManager,
    UserManager<ApplicationUser> userManager) : Controller
{
    public IActionResult Login(string? returnUrl = null)
    {
        ViewBag.ReturnUrl = returnUrl;
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Login(string email, string password,
        bool rememberMe, string? returnUrl = null)
    {
        var result = await signInManager.PasswordSignInAsync(email, password, rememberMe, lockoutOnFailure: true);

        if (result.Succeeded)
            return LocalRedirect(returnUrl ?? "/Dashboard");

        if (result.IsLockedOut)
            ModelState.AddModelError(string.Empty, "Account locked. Try again in 15 minutes.");
        else
            ModelState.AddModelError(string.Empty, "Invalid email or password.");

        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Logout()
    {
        await signInManager.SignOutAsync();
        return RedirectToAction("Login");
    }

    public IActionResult AccessDenied() => View();
}
