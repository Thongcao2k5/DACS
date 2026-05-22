using Microsoft.AspNetCore.Identity;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace GPULabOrchestrator.Data.Models;

// ─── Enums ───────────────────────────────────────────────────────────────────

public enum UserRole { Researcher, LabManager, SystemAdmin }

public enum InstanceStatus
{
    Draft, Queued, Allocating, Running,
    Paused, Stopped, Checkpointing, Suspended,
    Failed, Destroyed
}

public enum GpuStatus { Available, Allocated, Maintenance, Failed }

public enum NodeStatus { Online, Offline, Maintenance }

public enum QuotaRequestStatus { Pending, Approved, Rejected, AutoApproved }

// ─── Identity User ───────────────────────────────────────────────────────────

public class ApplicationUser : IdentityUser
{
    [Required, MaxLength(100)]
    public string FullName { get; set; } = string.Empty;

    public UserRole Role { get; set; } = UserRole.Researcher;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public Quota? Quota { get; set; }
    public ICollection<Instance> Instances { get; set; } = [];
    public ICollection<QuotaRequest> QuotaRequests { get; set; } = [];
    public ICollection<Reservation> Reservations { get; set; } = [];
    public ICollection<Node> ManagedNodes { get; set; } = [];
}

// ─── Quota ───────────────────────────────────────────────────────────────────

public class Quota
{
    [Key, ForeignKey(nameof(User))]
    public string UserId { get; set; } = string.Empty;

    public int TotalHours { get; set; }
    public int UsedHours { get; set; }
    public int LockedHours { get; set; }
    public DateTime? ExpiresAt { get; set; }

    public ApplicationUser User { get; set; } = null!;
}

// ─── QuotaRequest ─────────────────────────────────────────────────────────────

public class QuotaRequest
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    public string RequesterId { get; set; } = string.Empty;
    public string? ApproverId { get; set; }

    public int RequestedHours { get; set; }

    [MaxLength(500)]
    public string? Reason { get; set; }

    public QuotaRequestStatus Status { get; set; } = QuotaRequestStatus.Pending;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? ResolvedAt { get; set; }

    [MaxLength(500)]
    public string? RejectionReason { get; set; }

    // Navigation
    public ApplicationUser Requester { get; set; } = null!;
    public ApplicationUser? Approver { get; set; }
}

// ─── Node ─────────────────────────────────────────────────────────────────────

public class Node
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required, MaxLength(100)]
    public string Hostname { get; set; } = string.Empty;

    [Required, MaxLength(45)]
    public string IpAddress { get; set; } = string.Empty;

    public NodeStatus Status { get; set; } = NodeStatus.Online;

    public DateTime? LastHeartbeat { get; set; }

    public string? ManagedById { get; set; }

    // Navigation
    public ApplicationUser? ManagedBy { get; set; }
    public ICollection<GPU> GPUs { get; set; } = [];
}

// ─── GPU ──────────────────────────────────────────────────────────────────────

public class GPU
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid NodeId { get; set; }

    public int DeviceIndex { get; set; }

    [Required, MaxLength(50)]
    public string Model { get; set; } = string.Empty;

    public int VramGb { get; set; }

    public GpuStatus Status { get; set; } = GpuStatus.Available;

    public int Version { get; set; } = 0; // optimistic concurrency

    // Navigation
    public Node Node { get; set; } = null!;
    public Instance? CurrentInstance { get; set; }
}

// ─── ContainerImage ───────────────────────────────────────────────────────────

public class ContainerImage
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;

    [Required, MaxLength(50)]
    public string Tag { get; set; } = string.Empty;

    [MaxLength(50)]
    public string? Framework { get; set; }

    public bool Approved { get; set; } = false;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public ICollection<Instance> Instances { get; set; } = [];
}

// ─── Instance ─────────────────────────────────────────────────────────────────

public class Instance
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    public string OwnerId { get; set; } = string.Empty;
    public Guid? GpuId { get; set; }
    public Guid ImageId { get; set; }

    public InstanceStatus Status { get; set; } = InstanceStatus.Draft;

    [MaxLength(100)]
    public string? Name { get; set; }

    public DateTime? StartTime { get; set; }
    public DateTime? ExpiresAt { get; set; }
    public int MaxHours { get; set; }

    [MaxLength(200)]
    public string? ConnectionUri { get; set; }

    [MaxLength(200)]
    public string? JupyterToken { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public ApplicationUser Owner { get; set; } = null!;
    public GPU? GPU { get; set; }
    public ContainerImage Image { get; set; } = null!;
    public ICollection<Snapshot> Snapshots { get; set; } = [];
}

// ─── Snapshot ─────────────────────────────────────────────────────────────────

public class Snapshot
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    public Guid InstanceId { get; set; }

    public int? SizeGb { get; set; }

    [Required, MaxLength(300)]
    public string StoragePath { get; set; } = string.Empty;

    [MaxLength(100)]
    public string? Label { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public Instance Instance { get; set; } = null!;
}

// ─── Reservation ──────────────────────────────────────────────────────────────

public class Reservation
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    public string UserId { get; set; } = string.Empty;

    [Required, MaxLength(50)]
    public string GpuModel { get; set; } = string.Empty;

    public DateTime StartTime { get; set; }
    public DateTime EndTime { get; set; }
    public int Priority { get; set; } = 0;

    // Navigation
    public ApplicationUser User { get; set; } = null!;
}

// ─── AuditLog ─────────────────────────────────────────────────────────────────

public class AuditLog
{
    [Key, DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public long Id { get; set; }

    public string? ActorId { get; set; }

    [Required, MaxLength(100)]
    public string Action { get; set; } = string.Empty;

    [MaxLength(100)]
    public string? EntityType { get; set; }

    public Guid? EntityId { get; set; }

    public string? BeforeState { get; set; } // JSON
    public string? AfterState { get; set; }  // JSON

    public DateTime OccurredAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public ApplicationUser? Actor { get; set; }
}
