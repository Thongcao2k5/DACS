using GPULabOrchestrator.Business.Interfaces;
using GPULabOrchestrator.Business.Services;
using GPULabOrchestrator.Data.Data;
using GPULabOrchestrator.Data.Models;
using GPULabOrchestrator.Data.Repositories;
using GPULabOrchestrator.Data.Repositories.Interfaces;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .CreateLogger();
builder.Host.UseSerilog();

// Database
builder.Services.AddDbContext<GPULabDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("GPULabDb")));

// Identity
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options =>
{
    options.Password.RequireDigit = true;
    options.Password.RequiredLength = 8;
    options.Password.RequireUppercase = true;
    options.Lockout.MaxFailedAccessAttempts = 5;
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(15);
    options.User.RequireUniqueEmail = true;
})
.AddEntityFrameworkStores<GPULabDbContext>()
.AddDefaultTokenProviders();

// Cookie
builder.Services.ConfigureApplicationCookie(options =>
{
    options.LoginPath = "/Account/Login";
    options.AccessDeniedPath = "/Account/AccessDenied";
    options.ExpireTimeSpan = TimeSpan.FromDays(7);
    options.SlidingExpiration = true;
});

// Authorization policies
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("RequireResearcher", p => p.RequireRole("Researcher", "LabManager", "SystemAdmin"));
    options.AddPolicy("RequireLabManager", p => p.RequireRole("LabManager", "SystemAdmin"));
    options.AddPolicy("RequireSystemAdmin", p => p.RequireRole("SystemAdmin"));
});

// Repositories
builder.Services.AddScoped<IInstanceRepository, InstanceRepository>();
builder.Services.AddScoped<IGpuRepository, GpuRepository>();
builder.Services.AddScoped<IQuotaRepository, QuotaRepository>();
builder.Services.AddScoped<INodeRepository, NodeRepository>();
builder.Services.AddScoped<IQuotaRequestRepository, QuotaRequestRepository>();
builder.Services.AddScoped<IAuditLogRepository, AuditLogRepository>();

// Services
builder.Services.AddScoped<IAuditService, AuditService>();
builder.Services.AddScoped<IInstanceService, InstanceService>();
builder.Services.AddScoped<IQuotaService, QuotaService>();
builder.Services.AddScoped<IGpuService, GpuService>();
builder.Services.AddScoped<INodeService, NodeService>();
builder.Services.AddScoped<ISnapshotService, SnapshotService>();
builder.Services.AddScoped<IDashboardService, DashboardService>();
builder.Services.AddScoped<IContainerImageService, ContainerImageService>();

// MVC
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Seed database
using (var scope = app.Services.CreateScope())
{
    try
    {
        await DbSeeder.SeedAsync(scope.ServiceProvider);
    }
    catch (Exception ex)
    {
        Log.Error(ex, "Error seeding database");
        throw;
    }
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

// Area routing
app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
