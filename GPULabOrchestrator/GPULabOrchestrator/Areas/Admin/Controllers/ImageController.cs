using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Policy = "RequireSystemAdmin")]
public class ImageController(IContainerImageService imageService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var images = await imageService.GetAllAsync();
        return View(images);
    }

    [HttpPost]
    public async Task<IActionResult> Approve(Guid id)
    {
        var userId = userManager.GetUserId(User)!;
        await imageService.ApproveImageAsync(id, userId);
        TempData["Success"] = "Image approved.";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    public async Task<IActionResult> Reject(Guid id)
    {
        var userId = userManager.GetUserId(User)!;
        await imageService.RejectImageAsync(id, userId);
        TempData["Success"] = "Image rejected.";
        return RedirectToAction(nameof(Index));
    }
}
