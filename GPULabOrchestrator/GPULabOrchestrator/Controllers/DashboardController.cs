using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Controllers;

[Authorize]
public class DashboardController(IDashboardService dashboardService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var userId = userManager.GetUserId(User)!;
        var dashboard = await dashboardService.GetResearcherDashboardAsync(userId);
        return View(dashboard);
    }
}
