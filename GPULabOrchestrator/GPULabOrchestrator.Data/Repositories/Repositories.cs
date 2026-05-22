using GPULabOrchestrator.Data.Data;
using GPULabOrchestrator.Data.Models;
using GPULabOrchestrator.Data.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace GPULabOrchestrator.Data.Repositories;

// ─── Generic Repository ───────────────────────────────────────────────────────

public class Repository<T>(GPULabDbContext context) : IRepository<T> where T : class
{
    protected readonly GPULabDbContext _db = context;
    protected readonly DbSet<T> _set = context.Set<T>();

    public async Task<T?> GetByIdAsync(Guid id) => await _set.FindAsync(id);
    public async Task<IEnumerable<T>> GetAllAsync() => await _set.ToListAsync();
    public async Task<IEnumerable<T>> FindAsync(Expression<Func<T, bool>> predicate)
        => await _set.Where(predicate).ToListAsync();
    public async Task AddAsync(T entity) => await _set.AddAsync(entity);
    public void Update(T entity) => _set.Update(entity);
    public void Remove(T entity) => _set.Remove(entity);
    public async Task SaveChangesAsync() => await _db.SaveChangesAsync();
}

// ─── Instance Repository ──────────────────────────────────────────────────────

public class InstanceRepository(GPULabDbContext context)
    : Repository<Instance>(context), IInstanceRepository
{
    public async Task<IEnumerable<Instance>> GetByOwnerAsync(string ownerId)
        => await _db.Instances
            .Include(i => i.GPU).ThenInclude(g => g!.Node)
            .Include(i => i.Image)
            .Where(i => i.OwnerId == ownerId && i.Status != InstanceStatus.Destroyed)
            .OrderByDescending(i => i.CreatedAt)
            .ToListAsync();

    public async Task<IEnumerable<Instance>> GetByStatusAsync(InstanceStatus status)
        => await _db.Instances.Where(i => i.Status == status).ToListAsync();

    public async Task<IEnumerable<Instance>> GetRunningExpiredAsync()
        => await _db.Instances
            .Where(i => i.Status == InstanceStatus.Running && i.ExpiresAt < DateTime.UtcNow)
            .ToListAsync();

    public async Task<Instance?> GetWithDetailsAsync(Guid id)
        => await _db.Instances
            .Include(i => i.Owner)
            .Include(i => i.GPU).ThenInclude(g => g!.Node)
            .Include(i => i.Image)
            .Include(i => i.Snapshots)
            .FirstOrDefaultAsync(i => i.Id == id);
}

// ─── GPU Repository ───────────────────────────────────────────────────────────

public class GpuRepository(GPULabDbContext context)
    : Repository<GPU>(context), IGpuRepository
{
    public async Task<IEnumerable<GPU>> GetAvailableAsync(string? model = null)
    {
        var query = _db.GPUs
            .Include(g => g.Node)
            .Where(g => g.Status == GpuStatus.Available && g.Node.Status == NodeStatus.Online);

        if (!string.IsNullOrEmpty(model))
            query = query.Where(g => g.Model == model);

        return await query.ToListAsync();
    }

    public async Task<GPU?> GetAvailableByModelAsync(string model)
        => await _db.GPUs
            .Include(g => g.Node)
            .Where(g => g.Model == model
                && g.Status == GpuStatus.Available
                && g.Node.Status == NodeStatus.Online)
            .FirstOrDefaultAsync();

    public async Task<IEnumerable<GPU>> GetByNodeAsync(Guid nodeId)
        => await _db.GPUs.Where(g => g.NodeId == nodeId).ToListAsync();
}

// ─── Quota Repository ─────────────────────────────────────────────────────────

public class QuotaRepository(GPULabDbContext context)
    : Repository<Quota>(context), IQuotaRepository
{
    public async Task<Quota?> GetByUserAsync(string userId)
        => await _db.Quotas.FirstOrDefaultAsync(q => q.UserId == userId);

    public async Task<bool> PreLockAsync(string userId, int hours)
    {
        var quota = await GetByUserAsync(userId)
            ?? throw new InvalidOperationException("Quota not found");

        if (quota.UsedHours + quota.LockedHours + hours > quota.TotalHours)
            return false;

        quota.LockedHours += hours;
        await _db.SaveChangesAsync();
        return true;
    }

    public async Task ConsumeAsync(string userId, int hours)
    {
        var quota = await GetByUserAsync(userId)
            ?? throw new InvalidOperationException("Quota not found");

        quota.UsedHours += hours;
        quota.LockedHours = Math.Max(0, quota.LockedHours - hours);
        await _db.SaveChangesAsync();
    }

    public async Task ReleaseLockedAsync(string userId, int hours)
    {
        var quota = await GetByUserAsync(userId)
            ?? throw new InvalidOperationException("Quota not found");

        quota.LockedHours = Math.Max(0, quota.LockedHours - hours);
        await _db.SaveChangesAsync();
    }
}

// ─── Node Repository ──────────────────────────────────────────────────────────

public class NodeRepository(GPULabDbContext context)
    : Repository<Node>(context), INodeRepository
{
    public async Task<IEnumerable<Node>> GetOnlineNodesAsync()
        => await _db.Nodes
            .Include(n => n.GPUs)
            .Where(n => n.Status == NodeStatus.Online)
            .ToListAsync();

    public async Task<Node?> GetWithGpusAsync(Guid id)
        => await _db.Nodes
            .Include(n => n.GPUs)
            .FirstOrDefaultAsync(n => n.Id == id);
}

// ─── QuotaRequest Repository ──────────────────────────────────────────────────

public class QuotaRequestRepository(GPULabDbContext context)
    : Repository<QuotaRequest>(context), IQuotaRequestRepository
{
    public async Task<IEnumerable<QuotaRequest>> GetPendingAsync()
        => await _db.QuotaRequests
            .Include(r => r.Requester)
            .Where(r => r.Status == QuotaRequestStatus.Pending)
            .OrderBy(r => r.CreatedAt)
            .ToListAsync();

    public async Task<IEnumerable<QuotaRequest>> GetByRequesterAsync(string userId)
        => await _db.QuotaRequests
            .Where(r => r.RequesterId == userId)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
}

// ─── AuditLog Repository ──────────────────────────────────────────────────────

public class AuditLogRepository(GPULabDbContext context) : IAuditLogRepository
{
    public async Task LogAsync(string? actorId, string action, string? entityType = null,
        Guid? entityId = null, string? before = null, string? after = null)
    {
        context.AuditLogs.Add(new AuditLog
        {
            ActorId = actorId,
            Action = action,
            EntityType = entityType,
            EntityId = entityId,
            BeforeState = before,
            AfterState = after,
            OccurredAt = DateTime.UtcNow
        });
        await context.SaveChangesAsync();
    }

    public async Task<IEnumerable<AuditLog>> GetRecentAsync(int count = 50)
        => await context.AuditLogs
            .Include(a => a.Actor)
            .OrderByDescending(a => a.OccurredAt)
            .Take(count)
            .ToListAsync();

    public async Task<IEnumerable<AuditLog>> FilterAsync(string? actorId, string? entityType,
        DateTime? from, DateTime? to)
    {
        var query = context.AuditLogs.Include(a => a.Actor).AsQueryable();

        if (!string.IsNullOrEmpty(actorId)) query = query.Where(a => a.ActorId == actorId);
        if (!string.IsNullOrEmpty(entityType)) query = query.Where(a => a.EntityType == entityType);
        if (from.HasValue) query = query.Where(a => a.OccurredAt >= from.Value);
        if (to.HasValue) query = query.Where(a => a.OccurredAt <= to.Value);

        return await query.OrderByDescending(a => a.OccurredAt).ToListAsync();
    }
}
