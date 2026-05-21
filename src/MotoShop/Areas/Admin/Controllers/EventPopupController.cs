using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;

namespace MotoShop.Areas.Admin.Controllers;

[Area("Admin")]
[Authorize(Roles = "Admin")]
public class EventPopupController : Controller
{
    private readonly MotoShopDbContext _context;
    public EventPopupController(MotoShopDbContext context) => _context = context;

    public async Task<IActionResult> Index()
    {
        var popups = await _context.EventPopups
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync();
        return View(popups);
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Save([FromBody] EventPopup model)
    {
        if (model.Id == 0)
        {
            model.CreatedAt = DateTime.Now;
            _context.EventPopups.Add(model);
        }
        else
        {
            var existing = await _context.EventPopups.FindAsync(model.Id);
            if (existing == null) return NotFound();
            existing.EventType   = model.EventType;
            existing.Title       = model.Title;
            existing.Subtitle    = model.Subtitle;
            existing.Description = model.Description;
            existing.Conditions  = model.Conditions;
            existing.CouponCode  = model.CouponCode;
            existing.CtaText     = model.CtaText;
            existing.CtaUrl      = model.CtaUrl;
            existing.StartDate   = model.StartDate;
            existing.EndDate     = model.EndDate;
            existing.TotalQty    = model.TotalQty;
            existing.IsEnabled   = model.IsEnabled;
        }
        await _context.SaveChangesAsync();
        return Ok(new { success = true });
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Toggle(int id)
    {
        var popup = await _context.EventPopups.FindAsync(id);
        if (popup == null) return NotFound();
        popup.IsEnabled = !popup.IsEnabled;
        await _context.SaveChangesAsync();
        return Ok(new { isEnabled = popup.IsEnabled });
    }

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var popup = await _context.EventPopups.FindAsync(id);
        if (popup == null) return NotFound();
        _context.EventPopups.Remove(popup);
        await _context.SaveChangesAsync();
        return Ok(new { success = true });
    }
}
