using GPULabOrchestrator.Data.Models;
using System.Linq.Expressions;

namespace GPULabOrchestrator.Data.Repositories.Interfaces;

public interface IRepository<T> where T : class
{
    Task<T?> GetByIdAsync(Guid id);
    Task<IEnumerable<T>> GetAllAsync();
    Task<IEnumerable<T>> FindAsync(Expression<Func<T, bool>> predicate);
    Task AddAsync(T entity);
    void Update(T entity);
    void Remove(T entity);
    Task SaveChangesAsync();
}

public interface IInstanceRepository : IRepository<Instance>
{
    Task<IEnumerable<Instance>> GetByOwnerAsync(string ownerId);
    Task<IEnumerable<Instance>> GetByStatusAsync(InstanceStatus status);
    Task<IEnumerable<Instance>> GetRunningExpiredAsync();
    Task<Instance?> GetWithDetailsAsync(Guid id);
}

public interface IGpuRepository : IRepository<GPU>
{
    Task<IEnumerable<GPU>> GetAvailableAsync(string? model = null);
    Task<GPU?> GetAvailableByModelAsync(string model);
    Task<IEnumerable<GPU>> GetByNodeAsync(Guid nodeId);
}

public interface IQuotaRepository : IRepository<Quota>
{
    Task<Quota?> GetByUserAsync(string userId);
    Task<bool> PreLockAsync(string userId, int hours);
    Task ConsumeAsync(string userId, int hours);
    Task ReleaseLockedAsync(string userId, int hours);
}

public interface INodeRepository : IRepository<Node>
{
    Task<IEnumerable<Node>> GetOnlineNodesAsync();
    Task<Node?> GetWithGpusAsync(Guid id);
}

public interface IQuotaRequestRepository : IRepository<QuotaRequest>
{
    Task<IEnumerable<QuotaRequest>> GetPendingAsync();
    Task<IEnumerable<QuotaRequest>> GetByRequesterAsync(string userId);
}

public interface IAuditLogRepository
{
    Task LogAsync(string? actorId, string action, string? entityType = null,
        Guid? entityId = null, string? before = null, string? after = null);
    Task<IEnumerable<AuditLog>> GetRecentAsync(int count = 50);
    Task<IEnumerable<AuditLog>> FilterAsync(string? actorId, string? entityType,
        DateTime? from, DateTime? to);
}
