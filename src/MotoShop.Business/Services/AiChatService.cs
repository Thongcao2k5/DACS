using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MotoShop.Business.Interfaces;
using System;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class AiChatService : IAiChatService
    {
        private readonly HttpClient _http;
        private readonly string _apiKey;
        private readonly ILogger<AiChatService> _logger;

        private const string SystemPrompt =
            "Bạn là trợ lý tư vấn của cửa hàng phụ tùng xe máy MotoShop. " +
            "Nhiệm vụ của bạn là hỗ trợ khách hàng khi nhân viên chưa trực tuyến. " +
            "Hãy trả lời thân thiện, ngắn gọn bằng tiếng Việt. " +
            "Có thể tư vấn về phụ tùng xe máy, dịch vụ sửa chữa, cách đặt hàng, thanh toán, vận chuyển. " +
            "Nếu câu hỏi quá phức tạp, hãy nhắn khách chờ nhân viên hỗ trợ.";

        public AiChatService(IConfiguration configuration, ILogger<AiChatService> logger)
        {
            _apiKey = configuration["AI:AnthropicApiKey"] ?? "";
            _logger = logger;
            _http = new HttpClient();
        }

        public async Task<string> GetReplyAsync(string userMessage, string conversationHistory)
        {
            if (string.IsNullOrEmpty(_apiKey))
            {
                _logger.LogWarning("AnthropicApiKey chưa được cấu hình.");
                return "Nhân viên đang bận, vui lòng để lại tin nhắn chúng tôi sẽ phản hồi sớm nhất!";
            }

            try
            {
                _http.DefaultRequestHeaders.Clear();
                _http.DefaultRequestHeaders.Add("x-api-key", _apiKey);
                _http.DefaultRequestHeaders.Add("anthropic-version", "2023-06-01");

                // Ghép lịch sử chat vào message để AI có ngữ cảnh
                var fullMessage = string.IsNullOrEmpty(conversationHistory)
                    ? userMessage
                    : $"Lịch sử trò chuyện:\n{conversationHistory}\n\nTin nhắn mới nhất của khách: {userMessage}";

                var body = new
                {
                    model = "claude-haiku-4-5-20251001",
                    max_tokens = 300,
                    system = SystemPrompt,
                    messages = new[]
                    {
                        new { role = "user", content = fullMessage }
                    }
                };

                var response = await _http.PostAsJsonAsync("https://api.anthropic.com/v1/messages", body);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("AI API trả về lỗi: {StatusCode}", response.StatusCode);
                    return "Nhân viên đang bận, vui lòng để lại tin nhắn chúng tôi sẽ phản hồi sớm nhất!";
                }

                var result = await response.Content.ReadFromJsonAsync<JsonElement>();
                return result
                    .GetProperty("content")[0]
                    .GetProperty("text")
                    .GetString() ?? "Xin lỗi, tôi chưa hiểu câu hỏi. Nhân viên sẽ hỗ trợ bạn sớm!";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Lỗi khi gọi AI API");
                return "Nhân viên đang bận, vui lòng để lại tin nhắn chúng tôi sẽ phản hồi sớm nhất!";
            }
        }
    }
}
