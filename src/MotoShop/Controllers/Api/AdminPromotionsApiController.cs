using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;

namespace MotoShop.Controllers.Api
{
    [Route("api/admin/promotions")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class AdminPromotionsApiController : ControllerBase
    {
        private readonly IPromotionService _promotionService;

        public AdminPromotionsApiController(IPromotionService promotionService)
        {
            _promotionService = promotionService;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            return Ok(await _promotionService.GetAllAsync());
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] PromotionDto dto)
        {
            var created = await _promotionService.CreateAsync(dto);
            return Ok(new { success = true, data = created });
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, [FromBody] PromotionDto dto)
        {
            var updated = await _promotionService.UpdateAsync(id, dto);
            return Ok(new { success = updated });
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _promotionService.DeleteAsync(id);
            return Ok(new { success = deleted });
        }

        [HttpPatch("{id:int}/toggle")]
        public async Task<IActionResult> Toggle(int id)
        {
            var toggled = await _promotionService.ToggleActiveAsync(id);
            return Ok(new { success = toggled });
        }
    }
}
