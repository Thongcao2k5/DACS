using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using System.Threading.Tasks;

namespace MotoShop.Controllers.Api
{
    [Route("api/promotions")]
    [ApiController]
    public class PromotionsApiController : ControllerBase
    {
        private readonly IPromotionService _promotionService;

        public PromotionsApiController(IPromotionService promotionService)
        {
            _promotionService = promotionService;
        }

        [HttpGet("active")]
        public async Task<IActionResult> GetActive()
        {
            return Ok(await _promotionService.GetActivePromotionsAsync());
        }

        [HttpGet("flash-sale")]
        public async Task<IActionResult> GetFlashSale()
        {
            return Ok(await _promotionService.GetFlashSalesAsync());
        }

        public class ApplyVoucherRequest
        {
            public string Code { get; set; } = string.Empty;
            public decimal OrderTotal { get; set; }
        }

        // Chỉ VALIDATE — không gọi ApplyVoucherAsync để tránh double-increment UsedCount
        // ApplyVoucherAsync được gọi đúng một lần khi tạo đơn trong OrderService.CreateOrderAsync
        [Authorize]
        [HttpPost("apply-voucher")]
        public async Task<IActionResult> ApplyVoucher([FromBody] ApplyVoucherRequest request)
        {
            var validation = await _promotionService.ValidateVoucherAsync(request.Code, request.OrderTotal);
            var finalTotal = validation.IsValid
                ? request.OrderTotal - validation.DiscountAmount
                : request.OrderTotal;

            return Ok(new
            {
                success = validation.IsValid,
                message = validation.Message,
                discountAmount = validation.DiscountAmount,
                finalTotal
            });
        }
    }
}
