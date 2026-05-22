using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace GPULabOrchestrator.Data.Data;

public class GPULabDbContext : IdentityDbContext<ApplicationUser>
{
    public GPULabDbContext(DbContextOptions<GPULabDbContext> options) : base(options) { }

    public DbSet<Quota> Quotas => Set<Quota>();
    public DbSet<QuotaRequest> QuotaRequests => Set<QuotaRequest>();
    public DbSet<Node> Nodes => Set<Node>();
    public DbSet<GPU> GPUs => Set<GPU>();
    public DbSet<ContainerImage> ContainerImages => Set<ContainerImage>();
    public DbSet<Instance> Instances => Set<Instance>();
    public DbSet<Snapshot> Snapshots => Set<Snapshot>();
    public DbSet<Reservation> Reservations => Set<Reservation>();
    public DbSet<AuditLog> AuditLogs => Set<AuditLog>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        // GPU: unique (NodeId, DeviceIndex) + optimistic concurrency
        builder.Entity<GPU>(e =>
        {
            e.HasIndex(g => new { g.NodeId, g.DeviceIndex }).IsUnique();
            e.Property(g => g.Version).IsConcurrencyToken();
            e.HasOne(g => g.Node)
             .WithMany(n => n.GPUs)
             .HasForeignKey(g => g.NodeId)
             .OnDelete(DeleteBehavior.Cascade);
        });

        // ContainerImage: unique (Name, Tag)
        builder.Entity<ContainerImage>(e =>
        {
            e.HasIndex(ci => new { ci.Name, ci.Tag }).IsUnique();
        });

        // Instance → GPU (at most one running instance per GPU)
        builder.Entity<Instance>(e =>
        {
            e.HasOne(i => i.GPU)
             .WithOne(g => g.CurrentInstance)
             .HasForeignKey<Instance>(i => i.GpuId)
             .OnDelete(DeleteBehavior.SetNull);

            e.HasOne(i => i.Owner)
             .WithMany(u => u.Instances)
             .HasForeignKey(i => i.OwnerId)
             .OnDelete(DeleteBehavior.Restrict);
        });

        // Quota check constraint
        builder.Entity<Quota>(e =>
        {
            e.ToTable(t => t.HasCheckConstraint(
                "CK_Quota_UsedPlusLocked",
                "[UsedHours] + [LockedHours] <= [TotalHours]"
            ));
        });

        // Reservation: EndTime > StartTime
        builder.Entity<Reservation>(e =>
        {
            e.ToTable(t => t.HasCheckConstraint(
                "CK_Reservation_EndAfterStart",
                "[EndTime] > [StartTime]"
            ));
        });

        // QuotaRequest navigation
        builder.Entity<QuotaRequest>(e =>
        {
            e.HasOne(r => r.Requester)
             .WithMany(u => u.QuotaRequests)
             .HasForeignKey(r => r.RequesterId)
             .OnDelete(DeleteBehavior.Restrict);

            e.HasOne(r => r.Approver)
             .WithMany()
             .HasForeignKey(r => r.ApproverId)
             .OnDelete(DeleteBehavior.SetNull);
        });

        // AuditLog
        builder.Entity<AuditLog>(e =>
        {
            e.HasOne(a => a.Actor)
             .WithMany()
             .HasForeignKey(a => a.ActorId)
             .OnDelete(DeleteBehavior.SetNull);
        });
    }
}
