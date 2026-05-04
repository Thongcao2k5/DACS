using System.Net;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text;

namespace MotoShop.Business.Services
{
    public class VnPayLibrary
    {
    private readonly SortedList<string, string> _requestData = new SortedList<string, string>(new VnPayCompare());
    private readonly SortedList<string, string> _responseData = new SortedList<string, string>(new VnPayCompare());

    public void AddRequestData(string key, string value)
    {
        if (!string.IsNullOrEmpty(value))
        {
            _requestData.Add(key, value);
        }
    }

    public string CreateRequestUrl(string baseUrl, string vnp_HashSecret)
    {
        var data = new StringBuilder();
        foreach (var kv in _requestData)
        {
            if (!string.IsNullOrEmpty(kv.Value))
            {
                data.Append(WebUtility.UrlEncode(kv.Key) + "=" + WebUtility.UrlEncode(kv.Value) + "&");
            }
        }
        var querystring = data.ToString();
        if (querystring.Length > 0)
        {
            querystring = querystring.Remove(data.Length - 1, 1);
        }
        
        var vnp_SecureHash = HmacSHA512(vnp_HashSecret, querystring);
        baseUrl += "?" + querystring + "&vnp_SecureHash=" + vnp_SecureHash;

        return baseUrl;
    }

    public void AddResponseData(string key, string value)
    {
        if (!string.IsNullOrEmpty(value))
        {
            _responseData.Add(key, value);
        }
    }

    public string GetResponseData(string key)
    {
        return _responseData.TryGetValue(key, out var val) ? val : string.Empty;
    }

    public bool ValidateSignature(string inputHash, string secretKey)
    {
        var data = new StringBuilder();
        foreach (var kv in _responseData)
        {
            if (!string.IsNullOrEmpty(kv.Key) && kv.Key.StartsWith("vnp_") && kv.Key != "vnp_SecureHash" && kv.Key != "vnp_SecureHashType")
            {
                data.Append(WebUtility.UrlEncode(kv.Key) + "=" + WebUtility.UrlEncode(kv.Value) + "&");
            }
        }

        if (data.Length > 0)
        {
            data.Remove(data.Length - 1, 1);
        }

        string checkSum = HmacSHA512(secretKey, data.ToString());
        return checkSum.Equals(inputHash, StringComparison.InvariantCultureIgnoreCase);
    }

    // Helper tạo mã băm
    private string HmacSHA512(string key, string inputData)
    {
        var hash = new StringBuilder();
        byte[] keyBytes = Encoding.UTF8.GetBytes(key);
        byte[] inputBytes = Encoding.UTF8.GetBytes(inputData);
        using (var hmac = new HMACSHA512(keyBytes))
        {
            byte[] hashValue = hmac.ComputeHash(inputBytes);
            foreach (var theByte in hashValue)
            {
                hash.Append(theByte.ToString("x2"));
            }
        }
        return hash.ToString();
    }
}

// Class hỗ trợ sắp xếp key theo chuẩn VNPay
public class VnPayCompare : IComparer<string>
{
    public int Compare(string? x, string? y)
    {
        if (x == y) return 0;
        if (x == null) return -1;
        if (y == null) return 1;
        var vnpCompare = string.CompareOrdinal(x, y);
        return vnpCompare;
    }
}
}