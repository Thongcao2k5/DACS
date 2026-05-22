using GPULabOrchestrator.Business.DTOs;
using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Controllers;

[Authorize]
public class InstanceController(IInstanceService instanceService,
    IGpuService gpuService,
    IContainerImageService imageService,
    UserManager<ApplicationUser> userManager) : Controller
{
    public async Task<IActionResult> Index()
    {
        var userId = userManager.GetUserId(User)!;
        var instances = await instanceService.GetByOwnerAsync(userId);
        return View(instances);
    }

    public async Task<IActionResult> Create()
    {
        ViewBag.Images = await imageService.GetAllAsync(approvedOnly: true);
        ViewBag.GpuModels = new[] { "RTX 4090", "RTX 3090", "A100" };
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Create(InstanceCreateDto dto)
    {
        if (!ModelState.IsValid)
        {
            ViewBag.Images = await imageService.GetAllAsync(approvedOnly: true);
            ViewBag.GpuModels = new[] { "RTX 4090", "RTX 3090", "A100" };
            return View(dto);
        }

        try
        {
            var userId = userManager.GetUserId(User)!;
            var (instanceId, status, queuePos) = await instanceService.CreateInstanceAsync(userId, dto);

            TempData["Success"] = status == InstanceStatus.Queued
                ? $"Instance queued. Position: {queuePos}"
                : "Instance is being allocated. Check status shortly.";

            return RedirectToAction(nameof(Detail), new { id = instanceId });
        }
        catch (InvalidOperationException ex)
        {
            ModelState.AddModelError(string.Empty, ex.Message);
            ViewBag.Images = await imageService.GetAllAsync(approvedOnly: true);
            ViewBag.GpuModels = new[] { "RTX 4090", "RTX 3090", "A100" };
            return View(dto);
        }
    }

    public async Task<IActionResult> Detail(Guid id)
    {
        var detail = await instanceService.GetDetailAsync(id);
        if (detail is null) return NotFound();
        return View(detail);
    }

    [HttpPost]
    public async Task<IActionResult> Stop(Guid id)
    {
        var userId = userManager.GetUserId(User)!;
        await instanceService.StopInstanceAsync(id, userId);
        TempData["Success"] = "Instance stopped.";
        return RedirectToAction(nameof(Index));
    }

    [HttpPost]
    public async Task<IActionResult> Start(Guid id)
    {
        var userId = userManager.GetUserId(User)!;
        await instanceService.StartInstanceAsync(id, userId);
        TempData["Success"] = "Instance starting...";
        return RedirectToAction(nameof(Detail), new { id });
    }

    [HttpPost]
    public async Task<IActionResult> Destroy(Guid id)
    {
        var userId = userManager.GetUserId(User)!;
        await instanceService.DestroyInstanceAsync(id, userId);
        TempData["Success"] = "Instance destroyed.";
        return RedirectToAction(nameof(Index));
    }
}
