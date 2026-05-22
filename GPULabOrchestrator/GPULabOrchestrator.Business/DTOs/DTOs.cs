using GPULabOrchestrator.Data.Models;

namespace GPULabOrchestrator.Business.DTOs;

// ─── GPU ─────────────────────────────────────────────────────────────────────

public class GpuDto
{
    public Guid Id { get; set; }
    public string Model { get; set; } = string.Empty;
    public int VramGb { get; set; }
    public GpuStatus Status { get; set; }
    public string NodeHostname { get; set; } = string.Empty;
    public Guid NodeId { get; set; }
    public int DeviceIndex { get; set; }
}

// ─── Node ─────────────────────────────────────────────────────────────────────

public class NodeDto
{
    public Guid Id { get; set; }
    public string Hostname { get; set; } = string.Empty;
    public string IpAddress { get; set; } = string.Empty;
    public NodeStatus Status { get; set; }
    public DateTime? LastHeartbeat { get; set; }
    public List<GpuDto> GPUs { get; set; } = [];
    public int TotalGpus => GPUs.Count;
    public int AvailableGpus => GPUs.Count(g => g.Status == GpuStatus.Available);
}

// ─── Instance ─────────────────────────────────────────────────────────────────

public class InstanceDto
{
    public Guid Id { get; set; }
    public string? Name { get; set; }
    public InstanceStatus Status { get; set; }
    public string GpuModel { get; set; } = string.Empty;
    public string ImageName { get; set; } = string.Empty;
    public DateTime? StartTime { get; set; }
    public DateTime? ExpiresAt { get; set; }
    public int MaxHours { get; set; }
    public string? ConnectionUri { get; set; }
    public TimeSpan? Uptime => StartTime.HasValue ? DateTime.UtcNow - StartTime.Value : null;
}

public class InstanceDetailDto : InstanceDto
{
    public string OwnerEmail { get; set; } = string.Empty;
    public string OwnerName { get; set; } = string.Empty;
    public Guid? GpuId { get; set; }
    public string NodeHostname { get; set; } = string.Empty;
    public string? JupyterToken { get; set; }
    public List<SnapshotDto> Snapshots { get; set; } = [];
}

public class InstanceCreateDto
{
    public string GpuModel { get; set; } = string.Empty;
    public Guid ImageId { get; set; }
    public int MaxHours { get; set; } = 8;
    public string? Name { get; set; }
}

// ─── Snapshot ─────────────────────────────────────────────────────────────────

public class SnapshotDto
{
    public Guid Id { get; set; }
    public Guid InstanceId { get; set; }
    public int? SizeGb { get; set; }
    public string? Label { get; set; }
    public DateTime CreatedAt { get; set; }
}

// ─── Quota ────────────────────────────────────────────────────────────────────

public class QuotaDto
{
    public int TotalHours { get; set; }
    public int UsedHours { get; set; }
    public int LockedHours { get; set; }
    public int AvailableHours => TotalHours - UsedHours - LockedHours;
    public DateTime? ExpiresAt { get; set; }
    public double UsagePercent => TotalHours > 0 ? (double)UsedHours / TotalHours * 100 : 0;
}

public class QuotaRequestDto
{
    public Guid Id { get; set; }
    public string RequesterEmail { get; set; } = string.Empty;
    public string RequesterName { get; set; } = string.Empty;
    public int RequestedHours { get; set; }
    public string? Reason { get; set; }
    public QuotaRequestStatus Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? ResolvedAt { get; set; }
}

public class QuotaRequestCreateDto
{
    public int RequestedHours { get; set; }
    public string? Reason { get; set; }
}

// ─── User / Dashboard ─────────────────────────────────────────────────────────

public class UserDto
{
    public string Id { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public UserRole Role { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class DashboardDto
{
    public int ActiveInstances { get; set; }
    public int QueuedInstances { get; set; }
    public QuotaDto? Quota { get; set; }
    public int AvailableGpus { get; set; }
    public int TotalGpus { get; set; }
    public List<InstanceDto> RecentInstances { get; set; } = [];
    public List<AuditLogDto> RecentActivity { get; set; } = [];
}

public class AuditLogDto
{
    public long Id { get; set; }
    public string? ActorName { get; set; }
    public string Action { get; set; } = string.Empty;
    public string? EntityType { get; set; }
    public DateTime OccurredAt { get; set; }
}

// ─── ContainerImage ───────────────────────────────────────────────────────────

public class ContainerImageDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Tag { get; set; } = string.Empty;
    public string? Framework { get; set; }
    public bool Approved { get; set; }
    public string FullName => $"{Name}:{Tag}";
}
