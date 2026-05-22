using GPULabOrchestrator.Data.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace GPULabOrchestrator.Data.Data;

public static class DbSeeder
{
    public static async Task SeedAsync(IServiceProvider services)
    {
        var context = services.GetRequiredService<GPULabDbContext>();
        var userManager = services.GetRequiredService<UserManager<ApplicationUser>>();
        var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();

        await context.Database.MigrateAsync();

        // Seed roles
        foreach (var role in new[] { "SystemAdmin", "LabManager", "Researcher" })
        {
            if (!await roleManager.RoleExistsAsync(role))
                await roleManager.CreateAsync(new IdentityRole(role));
        }

        // Seed users
        await SeedUserAsync(userManager, "admin@gpulab.edu", "Admin@123", "System Administrator", UserRole.SystemAdmin, "SystemAdmin");
        await SeedUserAsync(userManager, "manager@gpulab.edu", "Manager@123", "Lab Manager", UserRole.LabManager, "LabManager");
        await SeedUserAsync(userManager, "researcher1@gpulab.edu", "Research@123", "Alice Nguyen", UserRole.Researcher, "Researcher");
        await SeedUserAsync(userManager, "researcher2@gpulab.edu", "Research@123", "Bob Tran", UserRole.Researcher, "Researcher");

        // Seed quotas for researchers
        var researchers = await context.Users
            .Where(u => u.Role == UserRole.Researcher)
            .ToListAsync();

        foreach (var r in researchers)
        {
            if (!await context.Quotas.AnyAsync(q => q.UserId == r.Id))
            {
                context.Quotas.Add(new Quota
                {
                    UserId = r.Id,
                    TotalHours = 200,
                    UsedHours = 0,
                    LockedHours = 0,
                    ExpiresAt = DateTime.UtcNow.AddMonths(6)
                });
            }
        }

        // Seed nodes and GPUs
        if (!await context.Nodes.AnyAsync())
        {
            var node1 = new Node
            {
                Id = Guid.NewGuid(),
                Hostname = "worker-01",
                IpAddress = "192.168.1.101",
                Status = NodeStatus.Online,
                LastHeartbeat = DateTime.UtcNow,
                GPUs =
                [
                    new GPU { DeviceIndex = 0, Model = "RTX 4090", VramGb = 24, Status = GpuStatus.Available },
                    new GPU { DeviceIndex = 1, Model = "RTX 4090", VramGb = 24, Status = GpuStatus.Available },
                    new GPU { DeviceIndex = 2, Model = "A100", VramGb = 80, Status = GpuStatus.Available },
                    new GPU { DeviceIndex = 3, Model = "A100", VramGb = 80, Status = GpuStatus.Available },
                ]
            };

            var node2 = new Node
            {
                Id = Guid.NewGuid(),
                Hostname = "worker-02",
                IpAddress = "192.168.1.102",
                Status = NodeStatus.Online,
                LastHeartbeat = DateTime.UtcNow,
                GPUs =
                [
                    new GPU { DeviceIndex = 0, Model = "RTX 3090", VramGb = 24, Status = GpuStatus.Available },
                    new GPU { DeviceIndex = 1, Model = "RTX 3090", VramGb = 24, Status = GpuStatus.Available },
                    new GPU { DeviceIndex = 2, Model = "A100", VramGb = 40, Status = GpuStatus.Maintenance },
                    new GPU { DeviceIndex = 3, Model = "A100", VramGb = 40, Status = GpuStatus.Available },
                ]
            };

            context.Nodes.AddRange(node1, node2);
        }

        // Seed container images
        if (!await context.ContainerImages.AnyAsync())
        {
            context.ContainerImages.AddRange(
                new ContainerImage { Name = "pytorch", Tag = "2.3-cuda12", Framework = "PyTorch", Approved = true },
                new ContainerImage { Name = "tensorflow", Tag = "2.15-cuda12", Framework = "TensorFlow", Approved = true },
                new ContainerImage { Name = "jax", Tag = "0.4-cuda12", Framework = "JAX", Approved = true },
                new ContainerImage { Name = "pytorch", Tag = "2.2-cuda11", Framework = "PyTorch", Approved = true },
                new ContainerImage { Name = "ubuntu", Tag = "22.04-cuda12", Framework = "Base", Approved = true }
            );
        }

        await context.SaveChangesAsync();
    }

    private static async Task SeedUserAsync(
        UserManager<ApplicationUser> userManager,
        string email, string password, string fullName,
        UserRole role, string roleName)
    {
        if (await userManager.FindByEmailAsync(email) is not null) return;

        var user = new ApplicationUser
        {
            UserName = email,
            Email = email,
            FullName = fullName,
            Role = role,
            EmailConfirmed = true
        };

        var result = await userManager.CreateAsync(user, password);
        if (result.Succeeded)
            await userManager.AddToRoleAsync(user, roleName);
    }
}
