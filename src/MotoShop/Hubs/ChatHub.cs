using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;

namespace MotoShop.Hubs
{
    public class ChatHub : Hub
    {
        private readonly MotoShopDbContext _context;

        public ChatHub(MotoShopDbContext context)
        {
            _context = context;
        }

        // Khách join vào room riêng của phiên mình
        public async Task JoinSession(string sessionId)
        {
            if (!string.IsNullOrWhiteSpace(sessionId))
                await Groups.AddToGroupAsync(Context.ConnectionId, $"chat_{sessionId}");
        }

        // Admin join room giám sát tất cả phiên
        public async Task JoinAdminRoom()
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, "admins");
        }

        // Khách gửi tin nhắn
        public async Task SendMessage(string message, string sessionId)
        {
            if (string.IsNullOrWhiteSpace(message) || string.IsNullOrWhiteSpace(sessionId))
                return;

            var now = DateTime.Now;
            var text = message.Trim();

            // Lưu DB
            await _context.Database.ExecuteSqlRawAsync(
                "INSERT INTO ChatMessages (SessionId, Message, CreatedAt, IsFromAdmin, IsRead) VALUES ({0}, {1}, {2}, 0, 0)",
                sessionId, text, now);

            // Echo lại cho khách (xác nhận đã gửi)
            await Clients.Group($"chat_{sessionId}").SendAsync("ReceiveMessage", text, false, now);

            // Thông báo tất cả admin
            await Clients.Group("admins").SendAsync("NewMessage", sessionId, text, now);
        }

        // Admin phản hồi một phiên cụ thể
        public async Task AdminReply(string message, string sessionId)
        {
            if (string.IsNullOrWhiteSpace(message) || string.IsNullOrWhiteSpace(sessionId))
                return;

            var now = DateTime.Now;
            var text = message.Trim();

            // Lưu DB
            await _context.Database.ExecuteSqlRawAsync(
                "INSERT INTO ChatMessages (SessionId, Message, CreatedAt, IsFromAdmin, IsRead) VALUES ({0}, {1}, {2}, 1, 1)",
                sessionId, text, now);

            // Đẩy tin đến khách
            await Clients.Group($"chat_{sessionId}").SendAsync("ReceiveMessage", text, true, now);

            // Phát cho tất cả admin để đồng bộ nhiều tab
            await Clients.Group("admins").SendAsync("AdminMessageSent", sessionId, text, now);
        }

        public override async Task OnDisconnectedAsync(Exception? exception)
        {
            await base.OnDisconnectedAsync(exception);
        }
    }
}
