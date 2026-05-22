using GPULabOrchestrator.Business.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Manager.Controllers;

[Area("Manager")]
[Authorize(Policy = "RequireLabManager")]
public class HomeController(IGpuService gpuService, IInstanceService instanceService) : Controller
{
    public async Task<IActionResult> Index()
    {
        var gpus = await gpuService.GetAllAsync();
        var instances = await instanceService.GetAllAsync();
        ViewBag.TotalGpus = gpus.Count();
        ViewBag.RunningInstances = instances.Count(i =>
            i.Status == Data.Models.InstanceStatus.Running);
        return View();
    }
}
