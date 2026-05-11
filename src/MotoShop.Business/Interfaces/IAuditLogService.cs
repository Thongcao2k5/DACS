using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IAuditLogService
    {
        Task LogActionAsync(string? userId, string action, string entityName, string? entityId, string? oldValues, string? newValues, string? ipAddress);
    }
}
