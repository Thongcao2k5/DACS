using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Services;

namespace MotoShop.Controllers.Api;

[ApiController]
[Route("api/shipping")]
[IgnoreAntiforgeryToken]
public class ShippingApiController : ControllerBase
{
    private readonly IGhnService _ghn;
    private readonly IConfiguration _config;

    public ShippingApiController(IGhnService ghn, IConfiguration config)
    {
        _ghn = ghn;
        _config = config;
    }

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
                string label = fee.EstimatedDays <= 1
                    ? "Giao hôm nay hoặc ngày mai"
                    : $"Dự kiến {fee.EstimatedDays} ngày";

                results.Add(new
                {
                    serviceId,
                    serviceName,
                    fee              = displayFee,
                    estimatedDays    = fee.EstimatedDays,
                    estimatedLabel   = label,
                    isExpress        = false,
                    isFree,
                    freeShipRemaining  = remaining,
                    unavailableReason  = (string?)null
                });
            }
        }

        // === KIỂM TRA ĐIỀU KIỆN HỎA TỐC ===
        var expressConfig = _config.GetSection("ExpressDelivery");
        bool expressEnabled = expressConfig.GetValue<bool>("IsEnabled");

        if (expressEnabled)
        {
            var supportedIds = expressConfig
                .GetSection("SupportedDistrictIds")
                .Get<List<int>>() ?? new List<int>();

            int maxWeight  = expressConfig.GetValue<int>("MaxWeightGram", 10000);
            int maxItems   = expressConfig.GetValue<int>("MaxItemCount", 10);
            int startHour  = expressConfig.GetValue<int>("StartHour", 7);
            int endHour    = expressConfig.GetValue<int>("EndHour", 21);
            decimal price  = expressConfig.GetValue<decimal>("PriceFixed", 50000);

            int currentHour = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(
                DateTime.UtcNow, "SE Asia Standard Time").Hour;

            bool districtOk = supportedIds.Contains(req.ToDistrictId);
            bool weightOk   = req.WeightGram <= maxWeight;
            bool itemsOk    = req.ItemCount  <= maxItems;
            bool timeOk     = currentHour >= startHour && currentHour < endHour;

            if (districtOk && weightOk && itemsOk && timeOk)
            {
                bool isFreeExpress = req.FreeShipThreshold > 0
                                     && req.OrderTotal >= req.FreeShipThreshold;
                results.Insert(0, new
                {
                    serviceId         = 0,
                    serviceName       = "Hỏa tốc 2H",
                    fee               = isFreeExpress ? 0 : price,
                    estimatedDays     = 0,
                    estimatedLabel    = "Giao trong 2 giờ",
                    isExpress         = true,
                    isFree            = isFreeExpress,
                    freeShipRemaining = (decimal?)null,
                    unavailableReason = (string?)null
                });
            }
            else if (districtOk && (!weightOk || !itemsOk))
            {
                results.Insert(0, new
                {
                    serviceId         = 0,
                    serviceName       = "Hỏa tốc 2H",
                    fee               = price,
                    estimatedDays     = 0,
                    estimatedLabel    = "Giao trong 2 giờ",
                    isExpress         = true,
                    isFree            = false,
                    freeShipRemaining = (decimal?)null,
                    unavailableReason = !weightOk
                        ? $"Đơn vượt {maxWeight / 1000}kg — không áp dụng hỏa tốc"
                        : $"Đơn vượt {maxItems} sản phẩm — không áp dụng hỏa tốc"
                });
            }
            else if (districtOk && !timeOk)
            {
                results.Insert(0, new
                {
                    serviceId         = 0,
                    serviceName       = "Hỏa tốc 2H",
                    fee               = price,
                    estimatedDays     = 0,
                    estimatedLabel    = "Giao trong 2 giờ",
                    isExpress         = true,
                    isFree            = false,
                    freeShipRemaining = (decimal?)null,
                    unavailableReason = $"Chỉ nhận đơn hỏa tốc {startHour}h–{endHour}h"
                });
            }
            // Nếu !districtOk → không hiện hỏa tốc
        }

        // Fallback khi GHN chưa có ApiKey thật hoặc API lỗi
        if (!results.Any())
        {
            results.Add(new
            {
                serviceId         = 0,
                serviceName       = "Tiêu chuẩn",
                fee               = (decimal)30000,
                estimatedDays     = 3,
                estimatedLabel    = "Dự kiến 3 ngày",
                isExpress         = false,
                isFree            = false,
                freeShipRemaining = (decimal?)null,
                unavailableReason = (string?)null
            });
        }

        return Ok(results);
    }
}

public record ShippingCalcRequest(
    int ToDistrictId,
    string ToWardCode,
    int WeightGram,
    int ItemCount,
    decimal OrderTotal,
    decimal FreeShipThreshold
);
