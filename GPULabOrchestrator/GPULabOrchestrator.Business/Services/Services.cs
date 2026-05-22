using GPULabOrchestrator.Business.DTOs;
using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Data.Data;
using GPULabOrchestrator.Data.Models;
using GPULabOrchestrator.Data.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;

namespace GPULabOrchestrator.Business.Services;

// ─── Instance Service ─────────────────────────────────────────────────────────

public class InstanceService(
    IInstanceRepository instanceRepo,
    IGpuRepository gpuRepo,
    IQuotaRepository quotaRepo,
    IAuditService auditService) : IInstanceService
{
    private const int AutoApproveThreshold = 10;

    public async Task<(Guid, InstanceStatus, int?)> CreateInstanceAsync(string userId, InstanceCreateDto dto)
    {
        // Pre-lock quota
        var locked = await quotaRepo.PreLockAsync(userId, dto.MaxHours);
        if (!locked) throw new InvalidOperationException("Insufficient quota balance.");

        var instance = new Instance
        {
            OwnerId = userId,
            ImageId = dto.ImageId,
            MaxHours = dto.MaxHours,
            Name = dto.Name,
            ExpiresAt = DateTime.UtcNow.AddHours(dto.MaxHours)
        };

        // Try to find a free GPU
        var gpu = await gpuRepo.GetAvailableByModelAsync(dto.GpuModel);

        if (gpu is not null)
        {
            instance.GpuId = gpu.Id;
            instance.Status = InstanceStatus.Allocating;
            instance.StartTime = DateTime.UtcNow;
            gpu.Status = GpuStatus.Allocated;
            gpuRepo.Update(gpu);
        }
        else
        {
            instance.Status = InstanceStatus.Queued;
        }

        await instanceRepo.AddAsync(instance);
        await instanceRepo.SaveChangesAsync();

        await auditService.LogAsync(userId, "CREATE_INSTANCE", "Instance", instance.Id,
            null, new { instance.Status, dto.GpuModel });

        int? queuePos = instance.Status == InstanceStatus.Queued ? 1 : null;
        return (instance.Id, instance.Status, queuePos);
    }

    public async Task StopInstanceAsync(Guid instanceId, string userId)
    {
        var instance = await GetAndValidateOwnerAsync(instanceId, userId);
        var before = instance.Status;

        if (instance.GpuId.HasValue)
        {
            var gpu = await gpuRepo.GetByIdAsync(instance.GpuId.Value);
            if (gpu is not null) { gpu.Status = GpuStatus.Available; gpuRepo.Update(gpu); }
            instance.GpuId = null;
        }

        instance.Status = InstanceStatus.Stopped;
        instanceRepo.Update(instance);
        await instanceRepo.SaveChangesAsync();

        await auditService.LogAsync(userId, "STOP_INSTANCE", "Instance", instanceId,
            new { Status = before }, new { Status = InstanceStatus.Stopped });
    }

    public async Task StartInstanceAsync(Guid instanceId, string userId)
    {
        var instance = await GetAndValidateOwnerAsync(instanceId, userId);
        if (instance.Status != InstanceStatus.Stopped)
            throw new InvalidOperationException("Instance is not in Stopped state.");

        var gpu = await gpuRepo.GetAvailableByModelAsync(
            instance.GPU?.Model ?? throw new InvalidOperationException("No GPU model recorded."));

        if (gpu is null) throw new InvalidOperationException("No GPU available. Please queue.");

        instance.GpuId = gpu.Id;
        instance.Status = InstanceStatus.Allocating;
        instance.StartTime = DateTime.UtcNow;
        instance.ExpiresAt = DateTime.UtcNow.AddHours(instance.MaxHours);
        gpu.Status = GpuStatus.Allocated;

        gpuRepo.Update(gpu);
        instanceRepo.Update(instance);
        await instanceRepo.SaveChangesAsync();
    }

    public async Task DestroyInstanceAsync(Guid instanceId, string userId)
    {
        var instance = await GetAndValidateOwnerAsync(instanceId, userId);
        var before = instance.Status;

        if (instance.GpuId.HasValue)
        {
            var gpu = await gpuRepo.GetByIdAsync(instance.GpuId.Value);
            if (gpu is not null) { gpu.Status = GpuStatus.Available; gpuRepo.Update(gpu); }
        }

        await quotaRepo.ReleaseLockedAsync(userId, instance.MaxHours);
        instance.Status = InstanceStatus.Destroyed;
        instanceRepo.Update(instance);
        await instanceRepo.SaveChangesAsync();

        await auditService.LogAsync(userId, "DESTROY_INSTANCE", "Instance", instanceId,
            new { Status = before }, new { Status = InstanceStatus.Destroyed });
    }

    public async Task<InstanceDetailDto?> GetDetailAsync(Guid instanceId)
    {
        var i = await instanceRepo.GetWithDetailsAsync(instanceId);
        if (i is null) return null;

        return new InstanceDetailDto
        {
            Id = i.Id,
            Name = i.Name,
            Status = i.Status,
            GpuModel = i.GPU?.Model ?? "N/A",
            GpuId = i.GpuId,
            NodeHostname = i.GPU?.Node?.Hostname ?? "N/A",
            ImageName = $"{i.Image.Name}:{i.Image.Tag}",
            StartTime = i.StartTime,
            ExpiresAt = i.ExpiresAt,
            MaxHours = i.MaxHours,
            ConnectionUri = i.ConnectionUri,
            JupyterToken = i.JupyterToken,
            OwnerEmail = i.Owner.Email ?? "",
            OwnerName = i.Owner.FullName,
            Snapshots = i.Snapshots.Select(s => new SnapshotDto
            {
                Id = s.Id,
                InstanceId = s.InstanceId,
                SizeGb = s.SizeGb,
                Label = s.Label,
                CreatedAt = s.CreatedAt
            }).ToList()
        };
    }

    public async Task<IEnumerable<InstanceDto>> GetByOwnerAsync(string userId)
    {
        var instances = await instanceRepo.GetByOwnerAsync(userId);
        return instances.Select(MapToDto);
    }

    public async Task<IEnumerable<InstanceDto>> GetAllAsync()
    {
        var instances = await instanceRepo.GetAllAsync();
        return instances.Select(MapToDto);
    }

    public async Task TransitionStatusAsync(Guid instanceId, InstanceStatus newStatus, string actorId)
    {
        var instance = await instanceRepo.GetByIdAsync(instanceId)
            ?? throw new KeyNotFoundException("Instance not found.");
        var before = instance.Status;
        instance.Status = newStatus;
        instanceRepo.Update(instance);
        await instanceRepo.SaveChangesAsync();
        await auditService.LogAsync(actorId, "TRANSITION_STATUS", "Instance", instanceId,
            new { Status = before }, new { Status = newStatus });
    }

    private async Task<Instance> GetAndValidateOwnerAsync(Guid instanceId, string userId)
    {
        var instance = await instanceRepo.GetWithDetailsAsync(instanceId)
            ?? throw new KeyNotFoundException("Instance not found.");
        if (instance.OwnerId != userId)
            throw new UnauthorizedAccessException("You do not own this instance.");
        return instance;
    }

    private static InstanceDto MapToDto(Instance i) => new()
    {
        Id = i.Id,
        Name = i.Name,
        Status = i.Status,
        GpuModel = i.GPU?.Model ?? "N/A",
        ImageName = $"{i.Image?.Name}:{i.Image?.Tag}",
        StartTime = i.StartTime,
        ExpiresAt = i.ExpiresAt,
        MaxHours = i.MaxHours,
        ConnectionUri = i.ConnectionUri
    };
}

// ─── Quota Service ────────────────────────────────────────────────────────────

public class QuotaService(
    IQuotaRepository quotaRepo,
    IQuotaRequestRepository requestRepo,
    IAuditService auditService) : IQuotaService
{
    private const int AutoApproveThreshold = 10;

    public async Task<QuotaDto?> GetBalanceAsync(string userId)
    {
        var quota = await quotaRepo.GetByUserAsync(userId);
        if (quota is null) return null;
        return new QuotaDto
        {
            TotalHours = quota.TotalHours,
            UsedHours = quota.UsedHours,
            LockedHours = quota.LockedHours,
            ExpiresAt = quota.ExpiresAt
        };
    }

    public async Task<QuotaRequestDto> SubmitRequestAsync(string userId, QuotaRequestCreateDto dto)
    {
        var request = new QuotaRequest
        {
            RequesterId = userId,
            RequestedHours = dto.RequestedHours,
            Reason = dto.Reason
        };

        if (dto.RequestedHours <= AutoApproveThreshold)
        {
            request.Status = QuotaRequestStatus.AutoApproved;
            request.ResolvedAt = DateTime.UtcNow;
            await ApplyQuotaTopUpAsync(userId, dto.RequestedHours);
        }

        await requestRepo.AddAsync(request);
        await requestRepo.SaveChangesAsync();
        await auditService.LogAsync(userId, "SUBMIT_QUOTA_REQUEST", "QuotaRequest", request.Id);

        return MapToDto(request);
    }

    public async Task<IEnumerable<QuotaRequestDto>> GetPendingRequestsAsync()
    {
        var requests = await requestRepo.GetPendingAsync();
        return requests.Select(MapToDto);
    }

    public async Task<IEnumerable<QuotaRequestDto>> GetMyRequestsAsync(string userId)
    {
        var requests = await requestRepo.GetByRequesterAsync(userId);
        return requests.Select(MapToDto);
    }

    public async Task ApproveRequestAsync(Guid requestId, string approverId)
    {
        var request = await requestRepo.GetByIdAsync(requestId)
            ?? throw new KeyNotFoundException("Request not found.");

        request.Status = QuotaRequestStatus.Approved;
        request.ApproverId = approverId;
        request.ResolvedAt = DateTime.UtcNow;

        await ApplyQuotaTopUpAsync(request.RequesterId, request.RequestedHours);
        requestRepo.Update(request);
        await requestRepo.SaveChangesAsync();

        await auditService.LogAsync(approverId, "APPROVE_QUOTA_REQUEST", "QuotaRequest", requestId);
    }

    public async Task RejectRequestAsync(Guid requestId, string approverId, string reason)
    {
        var request = await requestRepo.GetByIdAsync(requestId)
            ?? throw new KeyNotFoundException("Request not found.");

        request.Status = QuotaRequestStatus.Rejected;
        request.ApproverId = approverId;
        request.ResolvedAt = DateTime.UtcNow;
        request.RejectionReason = reason;

        requestRepo.Update(request);
        await requestRepo.SaveChangesAsync();
        await auditService.LogAsync(approverId, "REJECT_QUOTA_REQUEST", "QuotaRequest", requestId);
    }

    private async Task ApplyQuotaTopUpAsync(string userId, int hours)
    {
        var quota = await quotaRepo.GetByUserAsync(userId)
            ?? throw new InvalidOperationException("Quota not found.");
        quota.TotalHours += hours;
        quotaRepo.Update(quota);
        await quotaRepo.SaveChangesAsync();
    }

    private static QuotaRequestDto MapToDto(QuotaRequest r) => new()
    {
        Id = r.Id,
        RequesterEmail = r.Requester?.Email ?? "",
        RequesterName = r.Requester?.FullName ?? "",
        RequestedHours = r.RequestedHours,
        Reason = r.Reason,
        Status = r.Status,
        CreatedAt = r.CreatedAt,
        ResolvedAt = r.ResolvedAt
    };
}

// ─── GPU Service ──────────────────────────────────────────────────────────────

public class GpuService(IGpuRepository gpuRepo, IAuditService auditService) : IGpuService
{
    public async Task<IEnumerable<GpuDto>> GetAllAsync(string? model = null, GpuStatus? status = null)
    {
        var gpus = await gpuRepo.GetAllAsync();
        if (!string.IsNullOrEmpty(model)) gpus = gpus.Where(g => g.Model == model);
        if (status.HasValue) gpus = gpus.Where(g => g.Status == status.Value);
        return gpus.Select(MapToDto);
    }

    public async Task<IEnumerable<GpuDto>> GetAvailableAsync(string? model = null)
    {
        var gpus = await gpuRepo.GetAvailableAsync(model);
        return gpus.Select(MapToDto);
    }

    public async Task<GpuDto?> GetByIdAsync(Guid id)
    {
        var gpu = await gpuRepo.GetByIdAsync(id);
        return gpu is null ? null : MapToDto(gpu);
    }

    public async Task UpdateStatusAsync(Guid gpuId, GpuStatus status, string actorId)
    {
        var gpu = await gpuRepo.GetByIdAsync(gpuId)
            ?? throw new KeyNotFoundException("GPU not found.");
        var before = gpu.Status;
        gpu.Status = status;
        gpuRepo.Update(gpu);
        await gpuRepo.SaveChangesAsync();
        await auditService.LogAsync(actorId, "UPDATE_GPU_STATUS", "GPU", gpuId,
            new { Status = before }, new { Status = status });
    }

    private static GpuDto MapToDto(GPU g) => new()
    {
        Id = g.Id,
        Model = g.Model,
        VramGb = g.VramGb,
        Status = g.Status,
        NodeHostname = g.Node?.Hostname ?? "N/A",
        NodeId = g.NodeId,
        DeviceIndex = g.DeviceIndex
    };
}

// ─── Node Service ─────────────────────────────────────────────────────────────

public class NodeService(INodeRepository nodeRepo, IAuditService auditService) : INodeService
{
    public async Task<IEnumerable<NodeDto>> GetAllAsync()
    {
        var nodes = await nodeRepo.GetAllAsync();
        return nodes.Select(MapToDto);
    }

    public async Task<NodeDto?> GetByIdAsync(Guid id)
    {
        var node = await nodeRepo.GetWithGpusAsync(id);
        return node is null ? null : MapToDto(node);
    }

    public async Task<NodeDto> AddNodeAsync(string hostname, string ipAddress, string adminId)
    {
        var node = new Node { Hostname = hostname, IpAddress = ipAddress, ManagedById = adminId };
        await nodeRepo.AddAsync(node);
        await nodeRepo.SaveChangesAsync();
        await auditService.LogAsync(adminId, "ADD_NODE", "Node", node.Id);
        return MapToDto(node);
    }

    public async Task RemoveNodeAsync(Guid nodeId, string adminId, bool drain = true)
    {
        var node = await nodeRepo.GetByIdAsync(nodeId)
            ?? throw new KeyNotFoundException("Node not found.");
        node.Status = NodeStatus.Offline;
        nodeRepo.Update(node);
        await nodeRepo.SaveChangesAsync();
        await auditService.LogAsync(adminId, "REMOVE_NODE", "Node", nodeId);
    }

    private static NodeDto MapToDto(Node n) => new()
    {
        Id = n.Id,
        Hostname = n.Hostname,
        IpAddress = n.IpAddress,
        Status = n.Status,
        LastHeartbeat = n.LastHeartbeat,
        GPUs = n.GPUs.Select(g => new GpuDto
        {
            Id = g.Id,
            Model = g.Model,
            VramGb = g.VramGb,
            Status = g.Status,
            DeviceIndex = g.DeviceIndex,
            NodeId = g.NodeId,
            NodeHostname = n.Hostname
        }).ToList()
    };
}

// ─── Audit Service ────────────────────────────────────────────────────────────

public class AuditService(IAuditLogRepository auditRepo) : IAuditService
{
    public async Task LogAsync(string? actorId, string action, string? entityType = null,
        Guid? entityId = null, object? before = null, object? after = null)
    {
        await auditRepo.LogAsync(
            actorId, action, entityType, entityId,
            before is null ? null : JsonSerializer.Serialize(before),
            after is null ? null : JsonSerializer.Serialize(after));
    }

    public async Task<IEnumerable<AuditLogDto>> GetRecentAsync(int count = 50)
    {
        var logs = await auditRepo.GetRecentAsync(count);
        return logs.Select(MapToDto);
    }

    public async Task<IEnumerable<AuditLogDto>> FilterAsync(string? actorId, string? entityType,
        DateTime? from, DateTime? to)
    {
        var logs = await auditRepo.FilterAsync(actorId, entityType, from, to);
        return logs.Select(MapToDto);
    }

    private static AuditLogDto MapToDto(AuditLog a) => new()
    {
        Id = a.Id,
        ActorName = a.Actor?.FullName ?? "System",
        Action = a.Action,
        EntityType = a.EntityType,
        OccurredAt = a.OccurredAt
    };
}

// ─── Dashboard Service ────────────────────────────────────────────────────────

public class DashboardService(
    IInstanceService instanceService,
    IQuotaService quotaService,
    IGpuService gpuService,
    IAuditService auditService) : IDashboardService
{
    public async Task<DashboardDto> GetResearcherDashboardAsync(string userId)
    {
        var instances = (await instanceService.GetByOwnerAsync(userId)).ToList();
        var quota = await quotaService.GetBalanceAsync(userId);
        var availableGpus = (await gpuService.GetAvailableAsync()).ToList();
        var allGpus = (await gpuService.GetAllAsync()).ToList();
        var activity = (await auditService.GetRecentAsync(10)).ToList();

        return new DashboardDto
        {
            ActiveInstances = instances.Count(i => i.Status == InstanceStatus.Running),
            QueuedInstances = instances.Count(i => i.Status == InstanceStatus.Queued),
            Quota = quota,
            AvailableGpus = availableGpus.Count,
            TotalGpus = allGpus.Count,
            RecentInstances = instances.Take(5).ToList(),
            RecentActivity = activity
        };
    }
}

// ─── Container Image Service ──────────────────────────────────────────────────

public class ContainerImageService(GPULabDbContext context, IAuditService auditService)
    : IContainerImageService
{
    public async Task<IEnumerable<ContainerImageDto>> GetAllAsync(bool? approvedOnly = null)
    {
        var query = context.ContainerImages.AsQueryable();
        if (approvedOnly.HasValue) query = query.Where(i => i.Approved == approvedOnly.Value);
        var images = await query.ToListAsync();
        return images.Select(i => new ContainerImageDto
        {
            Id = i.Id,
            Name = i.Name,
            Tag = i.Tag,
            Framework = i.Framework,
            Approved = i.Approved
        });
    }

    public async Task ApproveImageAsync(Guid imageId, string adminId)
    {
        var image = await context.ContainerImages.FindAsync(imageId)
            ?? throw new KeyNotFoundException("Image not found.");
        image.Approved = true;
        await context.SaveChangesAsync();
        await auditService.LogAsync(adminId, "APPROVE_IMAGE", "ContainerImage", imageId);
    }

    public async Task RejectImageAsync(Guid imageId, string adminId)
    {
        var image = await context.ContainerImages.FindAsync(imageId)
            ?? throw new KeyNotFoundException("Image not found.");
        image.Approved = false;
        await context.SaveChangesAsync();
        await auditService.LogAsync(adminId, "REJECT_IMAGE", "ContainerImage", imageId);
    }
}

// ─── Snapshot Service ─────────────────────────────────────────────────────────

public class SnapshotService(GPULabDbContext context, IAuditService auditService) : ISnapshotService
{
    public async Task<SnapshotDto> CreateSnapshotAsync(Guid instanceId, string userId, string? label = null)
    {
        var snapshot = new Snapshot
        {
            InstanceId = instanceId,
            StoragePath = $"snapshots/{instanceId}/{Guid.NewGuid()}",
            Label = label ?? $"snapshot-{DateTime.UtcNow:yyyyMMdd-HHmm}"
        };
        context.Snapshots.Add(snapshot);
        await context.SaveChangesAsync();
        await auditService.LogAsync(userId, "CREATE_SNAPSHOT", "Snapshot", snapshot.Id);

        return new SnapshotDto
        {
            Id = snapshot.Id,
            InstanceId = instanceId,
            Label = snapshot.Label,
            CreatedAt = snapshot.CreatedAt
        };
    }

    public async Task<IEnumerable<SnapshotDto>> GetByInstanceAsync(Guid instanceId)
    {
        var snapshots = await context.Snapshots
            .Where(s => s.InstanceId == instanceId)
            .OrderByDescending(s => s.CreatedAt)
            .ToListAsync();

        return snapshots.Select(s => new SnapshotDto
        {
            Id = s.Id,
            InstanceId = s.InstanceId,
            SizeGb = s.SizeGb,
            Label = s.Label,
            CreatedAt = s.CreatedAt
        });
    }

    public async Task DeleteSnapshotAsync(Guid snapshotId, string userId)
    {
        var snapshot = await context.Snapshots.FindAsync(snapshotId)
            ?? throw new KeyNotFoundException("Snapshot not found.");
        context.Snapshots.Remove(snapshot);
        await context.SaveChangesAsync();
        await auditService.LogAsync(userId, "DELETE_SNAPSHOT", "Snapshot", snapshotId);
    }

    public async Task RestoreFromSnapshotAsync(Guid snapshotId, string userId)
    {
        var snapshot = await context.Snapshots.Include(s => s.Instance)
            .FirstOrDefaultAsync(s => s.Id == snapshotId)
            ?? throw new KeyNotFoundException("Snapshot not found.");

        await auditService.LogAsync(userId, "RESTORE_SNAPSHOT", "Snapshot", snapshotId);
    }
}
