using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Manager.Controllers;

[Area("Manager")]
[Authorize(Policy = "RequireLabManager")]
public class PreemptionController(IInstanceService instanceService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var running = (await instanceService.GetAllAsync())
            .Where(i => i.Status == InstanceStatus.Running);
        return View(running);
    }

    [HttpPost]
    public async Task<IActionResult> Execute(Guid instanceId)
    {
        var userId = userManager.GetUserId(User)!;
        await instanceService.TransitionStatusAsync(instanceId, InstanceStatus.Checkpointing, userId);
        TempData["Success"] = "Preemption initiated. Instance is being checkpointed.";
        return RedirectToAction(nameof(Index));
    }
}
