using GPULabOrchestrator.Business.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Policy = "RequireSystemAdmin")]
public class ReportController(IInstanceService instanceService,
    IGpuService gpuService) : Controller
{
    public async Task<IActionResult> Index()
    {
        var instances = await instanceService.GetAllAsync();
        var gpus = await gpuService.GetAllAsync();
        ViewBag.TotalInstances = instances.Count();
        ViewBag.TotalGpus = gpus.Count();
        return View(instances);
    }
}
