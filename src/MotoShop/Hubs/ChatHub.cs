using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Hubs
{
    public class ChatHub : Hub
    {
        private readonly MotoShopDbContext _context;

        public ChatHub(MotoShopDbContext context)
        {
            _context = context;
        }

        // Người dùng tham gia vào cuộc hội thoại của họ
        public async Task JoinConversation(int conversationId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"Conversation_{conversationId}");
        }

        // Admin tham gia để nhận thông báo cập nhật danh sách
        public async Task AdminJoinDashboard()
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, "AdminDashboard");
        }

        // Admin tham gia vào một cuộc hội thoại cụ thể
        public async Task AdminJoinConversation(int conversationId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"Conversation_{conversationId}");
        }

        // Gửi tin nhắn từ phía Admin
        public async Task AdminSendMessage(int conversationId, string message, string adminName)
        {
            if (string.IsNullOrWhiteSpace(message)) return;

            var conversation = await _context.ChatConversations.FindAsync(conversationId);
            if (conversation == null) return;

            var chatMessage = new ChatMessage
            {
                ConversationId = conversationId,
                Message = message.Trim(),
                SenderType = "Admin",
                SenderName = adminName,
                CreatedAt = DateTime.Now,
                IsRead = true
            };

            conversation.LastMessage = chatMessage.Message;
            conversation.LastMessageAt = chatMessage.CreatedAt;
            conversation.UnreadByCustomerCount++;
            conversation.UpdatedAt = DateTime.Now;

            _context.ChatMessages.Add(chatMessage);
            await _context.SaveChangesAsync();

            // Gửi realtime cho các bên trong group Conversation
            await Clients.Group($"Conversation_{conversationId}").SendAsync("ReceiveMessage", new {
                chatMessage.Id,
                chatMessage.ConversationId,
                chatMessage.Message,
                chatMessage.SenderType,
                chatMessage.SenderName,
                chatMessage.CreatedAt
            });

            // Cập nhật Dashboard Admin
            await Clients.Group("AdminDashboard").SendAsync("ConversationUpdated", new {
                Id = conversation.Id,
                conversation.LastMessage,
                conversation.LastMessageAt,
                conversation.UnreadByAdminCount,
                conversation.CustomerName
            });
        }

        // Gửi tin nhắn từ phía Người dùng
        public async Task UserSendMessage(int conversationId, string message, string customerName)
        {
            if (string.IsNullOrWhiteSpace(message)) return;

            var conversation = await _context.ChatConversations.FindAsync(conversationId);
            if (conversation == null) return;

            var chatMessage = new ChatMessage
            {
                ConversationId = conversationId,
                Message = message.Trim(),
                SenderType = "Customer",
                SenderName = customerName,
                CreatedAt = DateTime.Now,
                IsRead = false
            };

            conversation.LastMessage = chatMessage.Message;
            conversation.LastMessageAt = chatMessage.CreatedAt;
            conversation.UnreadByAdminCount++;
            conversation.UpdatedAt = DateTime.Now;

            _context.ChatMessages.Add(chatMessage);
            await _context.SaveChangesAsync();

            await Clients.Group($"Conversation_{conversationId}").SendAsync("ReceiveMessage", new {
                chatMessage.Id,
                chatMessage.ConversationId,
                chatMessage.Message,
                chatMessage.SenderType,
                chatMessage.SenderName,
                chatMessage.CreatedAt
            });

            await Clients.Group("AdminDashboard").SendAsync("ConversationUpdated", new {
                Id = conversation.Id,
                conversation.LastMessage,
                conversation.LastMessageAt,
                conversation.UnreadByAdminCount,
                conversation.CustomerName
            });
        }

        // Đánh dấu đã đọc
        public async Task MarkAsRead(int conversationId, string senderType)
        {
            var conversation = await _context.ChatConversations.FindAsync(conversationId);
            if (conversation != null)
            {
                if (senderType == "Admin")
                {
                    conversation.UnreadByAdminCount = 0;
                    var unread = await _context.ChatMessages.Where(m => m.ConversationId == conversationId && m.SenderType == "Customer" && !m.IsRead).ToListAsync();
                    foreach (var m in unread) m.IsRead = true;
                }
                else
                {
                    conversation.UnreadByCustomerCount = 0;
                    var unread = await _context.ChatMessages.Where(m => m.ConversationId == conversationId && m.SenderType == "Admin" && !m.IsRead).ToListAsync();
                    foreach (var m in unread) m.IsRead = true;
                }
                await _context.SaveChangesAsync();
                await Clients.Group("AdminDashboard").SendAsync("ConversationRead", conversationId);
            }
        }
    }
}
