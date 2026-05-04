using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;

namespace MotoShop.Controllers
{
    public class ChatController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;

        public ChatController(MotoShopDbContext context, UserManager<IdentityUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        // Khách gửi tin nhắn
        [HttpPost]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> SendMessage([FromBody] ChatMessageRequest request)
        {
            var userId = _userManager.GetUserId(User);
            string sessionId = userId ?? Request.Cookies["ChatSessionId"] ?? Guid.NewGuid().ToString();
            
            if (userId == null && !Request.Cookies.ContainsKey("ChatSessionId"))
            {
                Response.Cookies.Append("ChatSessionId", sessionId, new Microsoft.AspNetCore.Http.CookieOptions { Expires = DateTime.Now.AddDays(7) });
            }

            string sql = "INSERT INTO ChatMessages (SenderId, SessionId, Message, CreatedAt, IsFromAdmin) VALUES ({0}, {1}, {2}, {3}, 0)";
            object[] parameters = new object[] { userId ?? (object)DBNull.Value, sessionId, request.Message ?? "", DateTime.Now };
            
            await _context.Database.ExecuteSqlRawAsync(sql, parameters);

            return Json(new { success = true });
        }

        // Lấy lịch sử chat
        [HttpGet]
        public async Task<IActionResult> GetMessages()
        {
            var userId = _userManager.GetUserId(User);
            string? sessionId = userId ?? Request.Cookies["ChatSessionId"];
            
            if (string.IsNullOrEmpty(sessionId)) return Json(new List<ChatMessageView>());

            // Sử dụng FromSqlRaw để lấy dữ liệu thay vì SqlQueryRaw nếu gặp lỗi mapping
            var messages = await _context.Database.SqlQueryRaw<ChatMessageView>(
                "SELECT Message, CreatedAt, IsFromAdmin FROM ChatMessages WHERE SenderId = {0} OR SessionId = {1} ORDER BY CreatedAt ASC", 
                userId ?? (object)DBNull.Value, sessionId).ToListAsync();

            return Json(messages);
        }

        public class ChatMessageRequest { public string? Message { get; set; } }
        public class ChatMessageView { public string Message { get; set; } = ""; public DateTime CreatedAt { get; set; } public bool IsFromAdmin { get; set; } }
    }
}
