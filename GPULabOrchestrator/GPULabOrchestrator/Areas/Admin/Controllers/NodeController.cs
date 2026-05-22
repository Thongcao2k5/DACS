using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Policy = "RequireSystemAdmin")]
public class NodeController(INodeService nodeService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var nodes = await nodeService.GetAllAsync();
        return View(nodes);
    }

    public IActionResult Create() => View();

    [HttpPost]
    public async Task<IActionResult> Create(string hostname, string ipAddress)
    {
        var userId = userManager.GetUserId(User)!;
        await nodeService.AddNodeAsync(hostname, ipAddress, userId);
        TempData["Success"] = $"Node {hostname} added.";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    public async Task<IActionResult> Remove(Guid id)
    {
        var userId = userManager.GetUserId(User)!;
        await nodeService.RemoveNodeAsync(id, userId, drain: true);
        TempData["Success"] = "Node removed.";
        return RedirectToAction(nameof(Index));
    }
}
