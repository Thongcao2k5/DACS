using GPULabOrchestrator.Business.DTOs;
using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Controllers;

[Authorize]
public class QuotaController(IQuotaService quotaService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var userId = userManager.GetUserId(User)!;
        var quota = await quotaService.GetBalanceAsync(userId);
        var requests = await quotaService.GetMyRequestsAsync(userId);
        ViewBag.Requests = requests;
        return View(quota);
    }

    public IActionResult Request() => View();

    [HttpPost]
    public async Task<IActionResult> Request(QuotaRequestCreateDto dto)
    {
        if (!ModelState.IsValid) return View(dto);

        var userId = userManager.GetUserId(User)!;
        var result = await quotaService.SubmitRequestAsync(userId, dto);

        TempData["Success"] = result.Status == QuotaRequestStatus.AutoApproved
            ? $"Request auto-approved! +{dto.RequestedHours}h added to your quota."
            : "Request submitted. Awaiting Lab Manager approval.";

        return RedirectToAction(nameof(Index));
    }
}
