using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    [Route("Admin/[controller]")]
    public class ChatController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ChatController(MotoShopDbContext context)
        {
            _context = context;
        }

        // Trang chính quản lý Chat (View)
        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        // ── ADMIN API ───────────────────────────────────────────

        // GET /api/admin/chat/conversations
        [HttpGet("/api/admin/chat/conversations")]
        public async Task<IActionResult> GetConversations()
        {
            var conversations = await _context.ChatConversations
                .Where(c => !c.IsClosed)
                .OrderByDescending(c => c.LastMessageAt)
                .Select(c => new {
                    c.Id,
                    c.CustomerName,
                    c.LastMessage,
                    c.LastMessageAt,
                    c.UnreadByAdminCount,
                    c.IsClosed
                })
                .ToListAsync();

            return Ok(new { success = true, data = conversations });
        }

        // GET /api/admin/chat/conversations/{id}/messages
        [HttpGet("/api/admin/chat/conversations/{id}/messages")]
        public async Task<IActionResult> GetMessages(int id)
        {
            var messages = await _context.ChatMessages
                .Where(m => m.ConversationId == id)
                .OrderBy(m => m.CreatedAt)
                .Select(m => new {
                    m.Id,
                    m.ConversationId,
                    m.Message,
                    m.SenderType,
                    m.SenderName,
                    m.IsRead,
                    m.CreatedAt
                })
                .ToListAsync();

            return Ok(new { success = true, data = messages });
        }

        // POST /api/admin/chat/conversations/{id}/read
        [HttpPost("/api/admin/chat/conversations/{id}/read")]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            var conversation = await _context.ChatConversations.FindAsync(id);
            if (conversation != null)
            {
                conversation.UnreadByAdminCount = 0;
                var unreadMessages = await _context.ChatMessages
                    .Where(m => m.ConversationId == id && m.SenderType == "Customer" && !m.IsRead)
                    .ToListAsync();
                foreach (var msg in unreadMessages) msg.IsRead = true;
                await _context.SaveChangesAsync();
            }
            return Ok(new { success = true });
        }

        // DELETE /api/admin/chat/conversations/{id}
        [HttpDelete("/api/admin/chat/conversations/{id}")]
        public async Task<IActionResult> CloseConversation(int id)
        {
            var conversation = await _context.ChatConversations.FindAsync(id);
            if (conversation == null) return NotFound();
            
            conversation.IsClosed = true;
            await _context.SaveChangesAsync();
            return Ok(new { success = true });
        }
    }
}
