using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Repositories;
using MotoShop.Business.Mappings;
using MotoShop.Business.Interfaces;
using MotoShop.Business.Services;
using MotoShop.Services;
using Serilog;
using Microsoft.AspNetCore.Identity.UI.Services;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .WriteTo.File("Logs/motoshop-.txt", rollingInterval: RollingInterval.Day)
    .CreateLogger();

builder.Host.UseSerilog();

// Add services to the container.
builder.Services.AddControllersWithViews()
    .AddJsonOptions(options => {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
        options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
    });

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        builder =>
        {
            builder.SetIsOriginAllowed(origin => true) // Cho phép tất cả origin
                   .AllowAnyMethod()
                   .AllowAnyHeader()
                   .AllowCredentials(); // RẤT QUAN TRỌNG: Cho phép gửi Cookies/Auth
        });
});

// Register AutoMapper
builder.Services.AddAutoMapper(typeof(MappingProfile));

// Register DbContext
builder.Services.AddDbContext<MotoShopDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Register Email Sender
builder.Services.AddTransient<IEmailSender, EmailSender>();

// Đăng ký MemoryCache (cần thiết cho việc lưu OTP)
builder.Services.AddMemoryCache();

// Configure Identity
builder.Services.AddIdentity<IdentityUser, IdentityRole>(options => {
    options.Password.RequireDigit = false;
    options.Password.RequiredLength = 6;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.Password.RequireLowercase = false;
})
.AddEntityFrameworkStores<MotoShopDbContext>()
.AddDefaultTokenProviders();

// Register Repositories
builder.Services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();

// Register Services
builder.Services.AddScoped<IProductService, ProductService>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<IBrandService, BrandService>();
builder.Services.AddScoped<IMotorbikeModelService, MotorbikeModelService>();
builder.Services.AddScoped<ICartService, CartService>();
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<IFileService, FileService>();
builder.Services.AddScoped<IBookingService, BookingService>();
builder.Services.AddHostedService<BookingExpiryService>();

var app = builder.Build();

// Seed Data
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<MotoShopDbContext>();
    var userManager = services.GetRequiredService<UserManager<IdentityUser>>();
    var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();

    // THỰC HIỆN HARD RESET: Xóa và tạo mới hoàn toàn Database
    Log.Information("Performing Hard Reset: Deleting existing database...");
    await context.Database.EnsureDeletedAsync();
    Log.Information("Creating fresh database with correct schema...");
    await context.Database.EnsureCreatedAsync();
    Log.Information("Database synchronized and created successfully.");
    
    try 
    {
        Log.Information("Seeding fresh data...");
        await DbSeeder.SeedAsync(context, userManager, roleManager);
        Log.Information("Seeding completed successfully.");
    }
    catch (Exception ex)
    {
        Log.Error("Seeding Error: {Message}", ex.Message);
    }
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseRouting();

app.UseCors("AllowAll");

app.UseAuthentication();
app.UseAuthorization();

app.MapStaticAssets();

app.MapControllerRoute(
    name: "blog_detail",
    pattern: "Blog/Detail/{slug}",
    defaults: new { controller = "Blog", action = "Detail" });

app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();

app.Run();
