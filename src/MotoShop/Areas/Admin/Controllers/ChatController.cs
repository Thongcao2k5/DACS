using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class ChatController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ChatController(MotoShopDbContext context)
        {
            _context = context;
        }

        // Trang chính quản lý Chat
        public IActionResult Index()
        {
            return View();
        }

        // Lấy danh sách các cuộc hội thoại gần đây
        [HttpGet]
        public async Task<IActionResult> GetSessions()
        {
            var sessions = await _context.Database.SqlQueryRaw<ChatSessionDto>(@"
                SELECT SessionId, MAX(CreatedAt) as LastMsgTime, 
                (SELECT TOP 1 Message FROM ChatMessages WHERE SessionId = t.SessionId ORDER BY CreatedAt DESC) as LastMessage,
                (SELECT COUNT(*) FROM ChatMessages WHERE SessionId = t.SessionId AND IsRead = 0 AND IsFromAdmin = 0) as UnreadCount
                FROM ChatMessages t
                GROUP BY SessionId
                ORDER BY LastMsgTime DESC").ToListAsync();

            return Json(sessions);
        }

        // Lấy nội dung chat của một session cụ thể
        [HttpGet]
        public async Task<IActionResult> GetMessages(string sessionId)
        {
            if (string.IsNullOrEmpty(sessionId)) return Json(new List<ChatMessageDto>());

            var messages = await _context.Database.SqlQueryRaw<ChatMessageDto>(
                "SELECT Message, CreatedAt, IsFromAdmin FROM ChatMessages WHERE SessionId = {0} ORDER BY CreatedAt ASC", 
                sessionId).ToListAsync();

            // Đánh dấu đã đọc
            await _context.Database.ExecuteSqlRawAsync("UPDATE ChatMessages SET IsRead = 1 WHERE SessionId = {0} AND IsFromAdmin = 0", sessionId);

            return Json(messages);
        }

        // Admin trả lời tin nhắn
        [HttpPost]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> Reply([FromBody] ReplyRequest request)
        {
            if (string.IsNullOrEmpty(request.SessionId) || string.IsNullOrEmpty(request.Message))
                return Json(new { success = false });

            string sql = "INSERT INTO ChatMessages (SessionId, Message, CreatedAt, IsFromAdmin, IsRead) VALUES ({0}, {1}, {2}, 1, 1)";
            object[] parameters = new object[] { request.SessionId, request.Message, DateTime.Now };
            
            await _context.Database.ExecuteSqlRawAsync(sql, parameters);

            return Json(new { success = true });
        }

        public class ChatSessionDto { public string SessionId { get; set; } = ""; public DateTime LastMsgTime { get; set; } public string LastMessage { get; set; } = ""; public int UnreadCount { get; set; } }
        public class ChatMessageDto { public string Message { get; set; } = ""; public DateTime CreatedAt { get; set; } public bool IsFromAdmin { get; set; } }
        public class ReplyRequest { public string? SessionId { get; set; } public string? Message { get; set; } }
    }
}
