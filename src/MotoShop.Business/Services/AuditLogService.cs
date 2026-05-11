using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Threading.Tasks;
using System;

namespace MotoShop.Business.Services
{
    public class AuditLogService : IAuditLogService
    {
        private readonly MotoShopDbContext _context;

        public AuditLogService(MotoShopDbContext context)
        {
            _context = context;
        }

        public async Task LogActionAsync(string? userId, string action, string entityName, string? entityId, string? oldValues, string? newValues, string? ipAddress)
        {
            var auditLog = new AuditLog
            {
                UserId = userId,
                Action = action,
                EntityName = entityName,
                EntityId = entityId,
                OldValues = oldValues,
                NewValues = newValues,
                IpAddress = ipAddress,
                CreatedAt = DateTime.Now
            };

            _context.AuditLogs.Add(auditLog);
            await _context.SaveChangesAsync();
        }
    }
}
