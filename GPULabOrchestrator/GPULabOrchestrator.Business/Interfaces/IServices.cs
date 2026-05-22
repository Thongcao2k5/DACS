using GPULabOrchestrator.Business.DTOs;
using GPULabOrchestrator.Data.Models;

namespace GPULabOrchestrator.Business.Interfaces;

public interface IInstanceService
{
    Task<(Guid instanceId, InstanceStatus status, int? queuePosition)> CreateInstanceAsync(
        string userId, InstanceCreateDto dto);
    Task StopInstanceAsync(Guid instanceId, string userId);
    Task StartInstanceAsync(Guid instanceId, string userId);
    Task DestroyInstanceAsync(Guid instanceId, string userId);
    Task<InstanceDetailDto?> GetDetailAsync(Guid instanceId);
    Task<IEnumerable<InstanceDto>> GetByOwnerAsync(string userId);
    Task<IEnumerable<InstanceDto>> GetAllAsync();
    Task TransitionStatusAsync(Guid instanceId, InstanceStatus newStatus, string actorId);
}

public interface IQuotaService
{
    Task<QuotaDto?> GetBalanceAsync(string userId);
    Task<QuotaRequestDto> SubmitRequestAsync(string userId, QuotaRequestCreateDto dto);
    Task<IEnumerable<QuotaRequestDto>> GetPendingRequestsAsync();
    Task<IEnumerable<QuotaRequestDto>> GetMyRequestsAsync(string userId);
    Task ApproveRequestAsync(Guid requestId, string approverId);
    Task RejectRequestAsync(Guid requestId, string approverId, string reason);
}

public interface IGpuService
{
    Task<IEnumerable<GpuDto>> GetAllAsync(string? model = null, GpuStatus? status = null);
    Task<IEnumerable<GpuDto>> GetAvailableAsync(string? model = null);
    Task<GpuDto?> GetByIdAsync(Guid id);
    Task UpdateStatusAsync(Guid gpuId, GpuStatus status, string actorId);
}

public interface INodeService
{
    Task<IEnumerable<NodeDto>> GetAllAsync();
    Task<NodeDto?> GetByIdAsync(Guid id);
    Task<NodeDto> AddNodeAsync(string hostname, string ipAddress, string adminId);
    Task RemoveNodeAsync(Guid nodeId, string adminId, bool drain = true);
}

public interface ISnapshotService
{
    Task<SnapshotDto> CreateSnapshotAsync(Guid instanceId, string userId, string? label = null);
    Task<IEnumerable<SnapshotDto>> GetByInstanceAsync(Guid instanceId);
    Task DeleteSnapshotAsync(Guid snapshotId, string userId);
    Task RestoreFromSnapshotAsync(Guid snapshotId, string userId);
}

public interface IAuditService
{
    Task LogAsync(string? actorId, string action, string? entityType = null,
        Guid? entityId = null, object? before = null, object? after = null);
    Task<IEnumerable<AuditLogDto>> GetRecentAsync(int count = 50);
    Task<IEnumerable<AuditLogDto>> FilterAsync(string? actorId, string? entityType,
        DateTime? from, DateTime? to);
}

public interface IDashboardService
{
    Task<DashboardDto> GetResearcherDashboardAsync(string userId);
}

public interface IContainerImageService
{
    Task<IEnumerable<ContainerImageDto>> GetAllAsync(bool? approvedOnly = null);
    Task ApproveImageAsync(Guid imageId, string adminId);
    Task RejectImageAsync(Guid imageId, string adminId);
}
