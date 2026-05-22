using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Controllers;

[Authorize]
public class SnapshotController(ISnapshotService snapshotService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index(Guid instanceId)
    {
        var snapshots = await snapshotService.GetByInstanceAsync(instanceId);
        ViewBag.InstanceId = instanceId;
        return View(snapshots);
    }

    [HttpPost]
    public async Task<IActionResult> Create(Guid instanceId, string? label)
    {
        var userId = userManager.GetUserId(User)!;
        await snapshotService.CreateSnapshotAsync(instanceId, userId, label);
        TempData["Success"] = "Snapshot created.";
        return RedirectToAction(nameof(Index), new { instanceId });
    }

    [HttpPost]
    public async Task<IActionResult> Delete(Guid id, Guid instanceId)
    {
        var userId = userManager.GetUserId(User)!;
        await snapshotService.DeleteSnapshotAsync(id, userId);
        TempData["Success"] = "Snapshot deleted.";
        return RedirectToAction(nameof(Index), new { instanceId });
    }
}
