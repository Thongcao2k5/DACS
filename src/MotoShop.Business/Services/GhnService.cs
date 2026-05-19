using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace MotoShop.Business.Services;

public record GhnProvinceDto(int ProvinceId, string ProvinceName);
public record GhnDistrictDto(int DistrictId, string DistrictName, int ProvinceId);
public record GhnWardDto(string WardCode, string WardName, int DistrictId);
public record GhnShippingFeeResult(decimal Total, decimal ServiceFee, int EstimatedDays, bool Success, string? ErrorMessage);

public interface IGhnService
{
    Task<List<GhnProvinceDto>> GetProvincesAsync();
    Task<List<GhnDistrictDto>> GetDistrictsAsync(int provinceId);
    Task<List<GhnWardDto>> GetWardsAsync(int districtId);
    Task<GhnShippingFeeResult> CalculateFeeAsync(int toDistrictId, string toWardCode, int weightGram, int serviceId = 2);
    Task<List<(int ServiceId, string ServiceName)>> GetAvailableServicesAsync(int toDistrictId);
}

public class GhnService : IGhnService
{
    private readonly HttpClient _http;
    private readonly ILogger<GhnService> _logger;
    private readonly string _apiKey;
    private readonly int _shopId;
    private readonly int _fromDistrictId;
    private readonly JsonSerializerOptions _jsonOpts = new() { PropertyNameCaseInsensitive = true };

    public GhnService(HttpClient http, IConfiguration config, ILogger<GhnService> logger)
    {
        _http = http;
        _logger = logger;
        _apiKey = config["GHN:ApiKey"] ?? "YOUR_GHN_API_KEY_HERE";
        _shopId = config.GetValue<int>("GHN:ShopId");
        _fromDistrictId = config.GetValue<int>("GHN:FromDistrictId");

        _http.BaseAddress = new Uri(config["GHN:BaseUrl"] ?? "https://online-gateway.ghn.vn");
        _http.DefaultRequestHeaders.Add("Token", _apiKey);

        _logger.LogInformation("[GHN] Init — BaseUrl={Base} ShopId={Shop} FromDistrict={From} ApiKey={Key}",
            _http.BaseAddress, _shopId, _fromDistrictId,
            _apiKey.Length > 8 ? _apiKey[..8] + "..." : "(empty)");
    }

    public async Task<List<GhnProvinceDto>> GetProvincesAsync()
    {
        const string url = "/shiip/public-api/master-data/province";
        _logger.LogInformation("[GHN] GET {Url}", _http.BaseAddress + url.TrimStart('/'));
        try
        {
            var res = await _http.GetAsync(url);
            var raw = await res.Content.ReadAsStringAsync();
            _logger.LogInformation("[GHN] Status={Status} Body={Body}",
                (int)res.StatusCode, raw.Length > 500 ? raw[..500] : raw);

            var doc = JsonDocument.Parse(raw);
            var root = doc.RootElement;

            if (!root.TryGetProperty("data", out var dataEl))
            {
                _logger.LogWarning("[GHN] Province response có no 'data' field");
                return new List<GhnProvinceDto>();
            }

            var body = JsonSerializer.Deserialize<List<JsonElement>>(dataEl.GetRawText(), _jsonOpts)
                       ?? new List<JsonElement>();

            var result = body.Select(p => new GhnProvinceDto(
                p.GetProperty("ProvinceID").GetInt32(),
                p.GetProperty("ProvinceName").GetString() ?? ""
            )).OrderBy(p => p.ProvinceName).ToList();

            _logger.LogInformation("[GHN] Loaded {Count} provinces", result.Count);
            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[GHN] GetProvincesAsync failed");
            return new List<GhnProvinceDto>();
        }
    }

    public async Task<List<GhnDistrictDto>> GetDistrictsAsync(int provinceId)
    {
        try
        {
            var res = await _http.GetAsync($"/shiip/public-api/master-data/district?province_id={provinceId}");
            var body = await ParseResponse<List<JsonElement>>(res);
            return body.Select(d => new GhnDistrictDto(
                d.GetProperty("DistrictID").GetInt32(),
                d.GetProperty("DistrictName").GetString() ?? "",
                provinceId
            )).OrderBy(d => d.DistrictName).ToList();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[GHN] GetDistrictsAsync({ProvinceId}) failed", provinceId);
            return new List<GhnDistrictDto>();
        }
    }

    public async Task<List<GhnWardDto>> GetWardsAsync(int districtId)
    {
        try
        {
            var res = await _http.GetAsync($"/shiip/public-api/master-data/ward?district_id={districtId}");
            var body = await ParseResponse<List<JsonElement>>(res);
            return body.Select(w => new GhnWardDto(
                w.GetProperty("WardCode").GetString() ?? "",
                w.GetProperty("WardName").GetString() ?? "",
                districtId
            )).OrderBy(w => w.WardName).ToList();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[GHN] GetWardsAsync({DistrictId}) failed", districtId);
            return new List<GhnWardDto>();
        }
    }

    public async Task<List<(int ServiceId, string ServiceName)>> GetAvailableServicesAsync(int toDistrictId)
    {
        try
        {
            var payload = JsonSerializer.Serialize(new
            {
                shop_id = _shopId,
                from_district = _fromDistrictId,
                to_district = toDistrictId
            });
            var req = new HttpRequestMessage(HttpMethod.Post, "/shiip/public-api/v2/shipping-order/available-services")
            {
                Content = new StringContent(payload, Encoding.UTF8, "application/json")
            };
            var res = await _http.SendAsync(req);
            var body = await ParseResponse<List<JsonElement>>(res);
            return body.Select(s => (
                s.GetProperty("service_id").GetInt32(),
                s.GetProperty("short_name").GetString() ?? "Tiêu chuẩn"
            )).ToList();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[GHN] GetAvailableServicesAsync({DistrictId}) failed", toDistrictId);
            return new List<(int, string)>();
        }
    }

    public async Task<GhnShippingFeeResult> CalculateFeeAsync(int toDistrictId, string toWardCode, int weightGram, int serviceId = 53320)
    {
        var clampedWeight = Math.Clamp(weightGram, 1, 50000);
        var payload = JsonSerializer.Serialize(new
        {
            service_id = serviceId,
            insurance_value = 0,
            from_district_id = _fromDistrictId,
            to_district_id = toDistrictId,
            to_ward_code = toWardCode,
            height = 20,
            length = 30,
            weight = clampedWeight,
            width = 20
        });

        var req = new HttpRequestMessage(HttpMethod.Post, "/shiip/public-api/v2/shipping-order/fee")
        {
            Content = new StringContent(payload, Encoding.UTF8, "application/json")
        };
        req.Headers.Add("ShopId", _shopId.ToString());

        try
        {
            var res = await _http.SendAsync(req);
            var json = await res.Content.ReadAsStringAsync();
            var doc = JsonDocument.Parse(json);
            var root = doc.RootElement;

            if (root.GetProperty("code").GetInt32() != 200)
                return new GhnShippingFeeResult(0, 0, 3, false, root.GetProperty("message").GetString());

            var data = root.GetProperty("data");
            return new GhnShippingFeeResult(
                data.GetProperty("total").GetDecimal(),
                data.GetProperty("service_fee").GetDecimal(),
                data.TryGetProperty("expected_delivery_time", out var edt) ? CalculateDays(edt.GetString()) : 3,
                true,
                null
            );
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "[GHN] CalculateFeeAsync failed");
            return new GhnShippingFeeResult(0, 0, 3, false, ex.Message);
        }
    }

    private async Task<T> ParseResponse<T>(HttpResponseMessage res)
    {
        var json = await res.Content.ReadAsStringAsync();
        var doc = JsonDocument.Parse(json);
        var data = doc.RootElement.GetProperty("data");
        return JsonSerializer.Deserialize<T>(data.GetRawText(), _jsonOpts)
            ?? throw new Exception("GHN API trả về dữ liệu trống");
    }

    private static int CalculateDays(string? isoDate)
    {
        if (DateTime.TryParse(isoDate, out var dt))
            return Math.Max(1, (dt.Date - DateTime.Today).Days);
        return 3;
    }
}
