using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Manager.Controllers;

[Area("Manager")]
[Authorize(Policy = "RequireLabManager")]
public class QuotaRequestController(IQuotaService quotaService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var requests = await quotaService.GetPendingRequestsAsync();
        return View(requests);
    }

    [HttpPost]
    public async Task<IActionResult> Approve(Guid id)
    {
        var userId = userManager.GetUserId(User)!;
        await quotaService.ApproveRequestAsync(id, userId);
        TempData["Success"] = "Request approved.";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    public async Task<IActionResult> Reject(Guid id, string reason)
    {
        var userId = userManager.GetUserId(User)!;
        await quotaService.RejectRequestAsync(id, userId, reason);
        TempData["Success"] = "Request rejected.";
        return RedirectToAction(nameof(Index));
    }
}
