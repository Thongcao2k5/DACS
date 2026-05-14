using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;

namespace MotoShop.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChatController : ControllerBase
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;

        public ChatController(MotoShopDbContext context, UserManager<IdentityUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        // POST api/chat/send
        [HttpPost("send")]
        public async Task<IActionResult> SendMessage([FromBody] SendMessageRequest request)
        {
            if (string.IsNullOrWhiteSpace(request.Message)) return BadRequest("Message cannot be empty.");

            var userId = _userManager.GetUserId(User);
            ChatConversation? conversation = null;

            if (!string.IsNullOrEmpty(userId))
            {
                conversation = await _context.ChatConversations.FirstOrDefaultAsync(c => c.UserId == userId && !c.IsClosed);
            }
            else if (!string.IsNullOrEmpty(request.GuestSessionId))
            {
                conversation = await _context.ChatConversations.FirstOrDefaultAsync(c => c.GuestSessionId == request.GuestSessionId && !c.IsClosed);
            }

            if (conversation == null)
            {
                conversation = new ChatConversation
                {
                    UserId = userId,
                    GuestSessionId = string.IsNullOrEmpty(userId) ? request.GuestSessionId : null,
                    CustomerName = User.Identity?.IsAuthenticated == true ? User.Identity.Name : "Khách vãng lai",
                    CreatedAt = DateTime.Now,
                    UpdatedAt = DateTime.Now
                };
                _context.ChatConversations.Add(conversation);
                await _context.SaveChangesAsync();
            }

            var chatMessage = new ChatMessage
            {
                ConversationId = conversation.Id,
                SenderType = "Customer",
                SenderId = userId,
                SenderName = conversation.CustomerName,
                Message = request.Message.Trim(),
                IsRead = false,
                CreatedAt = DateTime.Now
            };

            conversation.LastMessage = chatMessage.Message;
            conversation.LastMessageAt = chatMessage.CreatedAt;
            conversation.UnreadByAdminCount++;
            conversation.UpdatedAt = DateTime.Now;

            _context.ChatMessages.Add(chatMessage);
            await _context.SaveChangesAsync();

            return Ok(new { 
                success = true, 
                conversationId = conversation.Id,
                message = new {
                    chatMessage.Id,
                    chatMessage.ConversationId,
                    chatMessage.SenderType,
                    chatMessage.SenderName,
                    chatMessage.Message,
                    chatMessage.CreatedAt
                }
            });
        }

        // GET api/chat/messages?guestSessionId=...
        [HttpGet("messages")]
        public async Task<IActionResult> GetMessages(string? guestSessionId)
        {
            var userId = _userManager.GetUserId(User);
            ChatConversation? conversation = null;

            if (!string.IsNullOrEmpty(userId))
            {
                conversation = await _context.ChatConversations.FirstOrDefaultAsync(c => c.UserId == userId && !c.IsClosed);
            }
            else if (!string.IsNullOrEmpty(guestSessionId))
            {
                conversation = await _context.ChatConversations.FirstOrDefaultAsync(c => c.GuestSessionId == guestSessionId && !c.IsClosed);
            }

            if (conversation == null) return Ok(new { success = true, data = new List<object>() });

            var messages = await _context.ChatMessages
                .Where(m => m.ConversationId == conversation.Id)
                .OrderBy(m => m.CreatedAt)
                .Select(m => new {
                    m.Id,
                    m.Message,
                    m.SenderType,
                    m.SenderName,
                    m.CreatedAt
                })
                .ToListAsync();

            return Ok(new { success = true, data = messages, conversationId = conversation.Id });
        }

        // POST api/chat/read
        [HttpPost("read")]
        public async Task<IActionResult> MarkAsRead(string? guestSessionId)
        {
            var userId = _userManager.GetUserId(User);
            ChatConversation? conversation = null;

            if (!string.IsNullOrEmpty(userId))
            {
                conversation = await _context.ChatConversations.FirstOrDefaultAsync(c => c.UserId == userId && !c.IsClosed);
            }
            else if (!string.IsNullOrEmpty(guestSessionId))
            {
                conversation = await _context.ChatConversations.FirstOrDefaultAsync(c => c.GuestSessionId == guestSessionId && !c.IsClosed);
            }

            if (conversation != null)
            {
                conversation.UnreadByCustomerCount = 0;
                var unreadMessages = await _context.ChatMessages
                    .Where(m => m.ConversationId == conversation.Id && m.SenderType == "Admin" && !m.IsRead)
                    .ToListAsync();
                foreach (var msg in unreadMessages) msg.IsRead = true;
                await _context.SaveChangesAsync();
            }
            return Ok(new { success = true });
        }

        public class SendMessageRequest
        {
            public string? GuestSessionId { get; set; }
            public string Message { get; set; } = string.Empty;
        }
    }
}
