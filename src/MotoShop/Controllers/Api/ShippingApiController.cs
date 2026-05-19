using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Services;

namespace MotoShop.Controllers.Api;

[ApiController]
[Route("api/shipping")]
[IgnoreAntiforgeryToken]
public class ShippingApiController : ControllerBase
{
    private readonly IGhnService _ghn;

    public ShippingApiController(IGhnService ghn) => _ghn = ghn;

    [HttpGet("provinces")]
    public async Task<IActionResult> Provinces()
        => Ok(await _ghn.GetProvincesAsync());

    [HttpGet("districts")]
    public async Task<IActionResult> Districts([FromQuery] int provinceId)
        => Ok(await _ghn.GetDistrictsAsync(provinceId));

    [HttpGet("wards")]
    public async Task<IActionResult> Wards([FromQuery] int districtId)
        => Ok(await _ghn.GetWardsAsync(districtId));

    [HttpPost("calculate")]
    public async Task<IActionResult> Calculate([FromBody] ShippingCalcRequest req)
    {
        if (req.ToDistrictId <= 0 || string.IsNullOrWhiteSpace(req.ToWardCode))
            return BadRequest(new { error = "Vui lòng chọn đầy đủ quận/huyện và phường/xã" });

        var services = await _ghn.GetAvailableServicesAsync(req.ToDistrictId);
        var results = new List<object>();

        foreach (var (serviceId, serviceName) in services)
        {
            var fee = await _ghn.CalculateFeeAsync(req.ToDistrictId, req.ToWardCode, req.WeightGram, serviceId);
            if (fee.Success)
            {
                bool isFree = req.FreeShipThreshold > 0 && req.OrderTotal >= req.FreeShipThreshold;
                decimal displayFee = isFree ? 0 : fee.Total;
                decimal? remaining = (req.FreeShipThreshold > 0 && !isFree)
                    ? req.FreeShipThreshold - req.OrderTotal
                    : (decimal?)null;

                results.Add(new
                {
                    serviceId,
                    serviceName,
                    fee           = displayFee,
                    estimatedDays = fee.EstimatedDays,
                    isFree,
                    freeShipRemaining = remaining
                });
            }
        }

        // Fallback khi GHN chưa có ApiKey thật hoặc API lỗi
        if (!results.Any())
        {
            results.Add(new
            {
                serviceId = 0,
                serviceName = "Tiêu chuẩn",
                fee = (decimal)30000,
                estimatedDays = 3,
                isFree = false,
                freeShipRemaining = (decimal?)null
            });
        }

        return Ok(results);
    }
}

public record ShippingCalcRequest(
    int ToDistrictId,
    string ToWardCode,
    int WeightGram,
    decimal OrderTotal,
    decimal FreeShipThreshold
);
