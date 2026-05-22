using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Controllers;

[Authorize]
public class GpuController(IGpuService gpuService) : Controller
{
    public async Task<IActionResult> Index(string? model, string? status)
    {
        GpuStatus? statusFilter = Enum.TryParse<GpuStatus>(status, out var s) ? s : null;
        var gpus = await gpuService.GetAllAsync(model, statusFilter);

        ViewBag.Models = new[] { "RTX 4090", "RTX 3090", "A100" };
        ViewBag.SelectedModel = model;
        ViewBag.SelectedStatus = status;

        return View(gpus);
    }
}
