using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace MotoShop.Hubs
{
    public class ChatHub : Hub
    {
        private readonly MotoShopDbContext _context;
        private readonly IAiChatService _aiChatService;

        // Theo dõi admin đang xem conversation nào: conversationId -> danh sách connectionId admin
        private static readonly ConcurrentDictionary<int, HashSet<string>> _adminInConversation = new();
        private static readonly object _lock = new();

        public ChatHub(MotoShopDbContext context, IAiChatService aiChatService)
        {
            _context = context;
            _aiChatService = aiChatService;
        }

        public async Task JoinConversation(int conversationId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, $"Conversation_{conversationId}");
        }

        public async Task AdminJoinDashboard()
        {
            if (Context.User?.IsInRole("Admin") != true) return;
            await Groups.AddToGroupAsync(Context.ConnectionId, "AdminDashboard");
        }

        public async Task AdminJoinConversation(int conversationId)
        {
            if (Context.User?.IsInRole("Admin") != true) return;
            await Groups.AddToGroupAsync(Context.ConnectionId, $"Conversation_{conversationId}");

            // Ghi nhận admin đang xem conversation này
            lock (_lock)
            {
                if (!_adminInConversation.ContainsKey(conversationId))
                    _adminInConversation[conversationId] = new HashSet<string>();
                _adminInConversation[conversationId].Add(Context.ConnectionId);
            }
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            // Xóa admin khỏi danh sách đang xem khi ngắt kết nối
            lock (_lock)
            {
                foreach (var key in _adminInConversation.Keys)
                {
                    _adminInConversation[key].Remove(Context.ConnectionId);
                }
            }
            await base.OnDisconnectedAsync(exception);
        }

        public async Task AdminSendMessage(int conversationId, string message, string adminName)
        {
            if (Context.User?.IsInRole("Admin") != true) return;
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

        public async Task UserSendMessage(int conversationId, string message, string customerName)
        {
            if (string.IsNullOrWhiteSpace(message)) return;

            var conversation = await _context.ChatConversations.FindAsync(conversationId);
            if (conversation == null) return;

            var userId = Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (!string.IsNullOrEmpty(userId) && conversation.UserId != userId) return;

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

            // Kiểm tra có admin đang xem conversation này không
            bool adminOnline = false;
            lock (_lock)
            {
                adminOnline = _adminInConversation.TryGetValue(conversationId, out var connections)
                              && connections.Count > 0;
            }

            // Nếu không có admin online → AI tự trả lời
            if (!adminOnline)
            {
                await Task.Delay(1200); // Dừng 1.2 giây cho tự nhiên hơn

                // Lấy 6 tin nhắn gần nhất làm ngữ cảnh cho AI
                var recentMessages = await _context.ChatMessages
                    .Where(m => m.ConversationId == conversationId)
                    .OrderByDescending(m => m.CreatedAt)
                    .Take(6)
                    .OrderBy(m => m.CreatedAt)
                    .Select(m => $"{m.SenderName}: {m.Message}")
                    .ToListAsync();

                var history = string.Join("\n", recentMessages);
                var aiReply = await _aiChatService.GetReplyAsync(message.Trim(), history);

                var aiMessage = new ChatMessage
                {
                    ConversationId = conversationId,
                    Message = aiReply,
                    SenderType = "Admin",
                    SenderName = "MotoShop AI",
                    CreatedAt = DateTime.Now,
                    IsRead = true
                };

                conversation.LastMessage = aiReply;
                conversation.LastMessageAt = aiMessage.CreatedAt;
                conversation.UnreadByCustomerCount++;
                conversation.UpdatedAt = DateTime.Now;

                _context.ChatMessages.Add(aiMessage);
                await _context.SaveChangesAsync();

                await Clients.Group($"Conversation_{conversationId}").SendAsync("ReceiveMessage", new {
                    aiMessage.Id,
                    aiMessage.ConversationId,
                    aiMessage.Message,
                    aiMessage.SenderType,
                    SenderName = "🤖 MotoShop AI",
                    aiMessage.CreatedAt
                });
            }
        }

        public async Task MarkAsRead(int conversationId, string senderType)
        {
            if (senderType == "Admin" && Context.User?.IsInRole("Admin") != true) return;

            var conversation = await _context.ChatConversations.FindAsync(conversationId);
            if (conversation != null)
            {
                if (senderType == "Admin")
                {
                    conversation.UnreadByAdminCount = 0;
                    var unread = await _context.ChatMessages
                        .Where(m => m.ConversationId == conversationId && m.SenderType == "Customer" && !m.IsRead)
                        .ToListAsync();
                    foreach (var m in unread) m.IsRead = true;
                }
                else
                {
                    conversation.UnreadByCustomerCount = 0;
                    var unread = await _context.ChatMessages
                        .Where(m => m.ConversationId == conversationId && m.SenderType == "Admin" && !m.IsRead)
                        .ToListAsync();
                    foreach (var m in unread) m.IsRead = true;
                }
                await _context.SaveChangesAsync();
                await Clients.Group("AdminDashboard").SendAsync("ConversationRead", conversationId);
            }
        }
    }
}
