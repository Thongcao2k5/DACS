using GPULabOrchestrator.Business.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GPULabOrchestrator.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Policy = "RequireSystemAdmin")]
public class AuditController(IAuditService auditService) : Controller
{
    public async Task<IActionResult> Index(string? actorId, string? entityType,
        DateTime? from, DateTime? to)
    {
        var logs = await auditService.FilterAsync(actorId, entityType, from, to);
        return View(logs);
    }
}
