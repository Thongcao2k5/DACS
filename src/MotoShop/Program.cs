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
    .CreateLogger();

builder.Host.UseSerilog();

builder.Services.AddControllersWithViews()
    .AddJsonOptions(options => {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
        options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
    });

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        builder =>
        {
            builder.SetIsOriginAllowed(origin => true)
                   .AllowAnyMethod()
                   .AllowAnyHeader()
                   .AllowCredentials();
        });
});

builder.Services.AddAutoMapper(typeof(MappingProfile));

builder.Services.AddDbContext<MotoShopDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"),
    sqlOptions => sqlOptions.EnableRetryOnFailure(
        maxRetryCount: 3,
        maxRetryDelay: TimeSpan.FromSeconds(5),
        errorNumbersToAdd: null)));

builder.Services.AddAntiforgery(options => options.HeaderName = "X-XSRF-TOKEN");
builder.Services.AddHealthChecks();

builder.Services.AddIdentity<IdentityUser, IdentityRole>(options => {
    options.Password.RequireDigit = true;
    options.Password.RequiredLength = 8;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.Password.RequireLowercase = true;
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(5);
    options.Lockout.MaxFailedAccessAttempts = 5;
    options.Lockout.AllowedForNewUsers = true;
    options.User.RequireUniqueEmail = true;
})
.AddEntityFrameworkStores<MotoShopDbContext>()
.AddDefaultTokenProviders();

builder.Services.ConfigureApplicationCookie(options => {
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.Cookie.SameSite = SameSiteMode.Strict;
    options.ExpireTimeSpan = TimeSpan.FromDays(7);
    options.SlidingExpiration = true;
    options.LoginPath = "/Account/Login";
    options.AccessDeniedPath = "/Account/Login";
    options.ReturnUrlParameter = "returnUrl";
    options.Cookie.Name = "MotoShop.Auth";
});

builder.Services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<IProductService, ProductService>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<IBrandService, BrandService>();
builder.Services.AddScoped<IMotorbikeModelService, MotorbikeModelService>();
builder.Services.AddScoped<ICartService, CartService>();
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<IFileService, FileService>();
builder.Services.AddScoped<IBookingService, BookingService>();
builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.AddHostedService<BookingExpiryService>();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<MotoShopDbContext>();
    var userManager = services.GetRequiredService<UserManager<IdentityUser>>();
    var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();

    try 
    {
        Log.Information("Updating Database Schema...");
        
        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceCategories')
            BEGIN
                CREATE TABLE ServiceCategories (
                    CategoryId INT IDENTITY PRIMARY KEY,
                    CategoryName NVARCHAR(100) NOT NULL,
                    Slug NVARCHAR(255),
                    Icon NVARCHAR(50),
                    IsActive BIT DEFAULT 1
                );
            END
        ");

        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Categories') AND name = 'Icon')
                ALTER TABLE Categories ADD Icon NVARCHAR(MAX) NULL;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Categories') AND name = 'IsActive')
                ALTER TABLE Categories ADD IsActive BIT DEFAULT 1;
        ");

        // Đảm bảo không có giá trị NULL cho các cột bool mới
        await context.Database.ExecuteSqlRawAsync("UPDATE Categories SET IsActive = 1 WHERE IsActive IS NULL");

        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'CategoryId')
                ALTER TABLE Services ADD CategoryId INT NULL;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'Slug')
                ALTER TABLE Services ADD Slug NVARCHAR(255);
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'Duration')
                ALTER TABLE Services ADD Duration INT DEFAULT 30;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'ShortDescription')
                ALTER TABLE Services ADD ShortDescription NVARCHAR(MAX);
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'WarrantyDays')
                ALTER TABLE Services ADD WarrantyDays INT DEFAULT 30;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'TotalBookings')
                ALTER TABLE Services ADD TotalBookings INT DEFAULT 0;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'ImageUrl')
                ALTER TABLE Services ADD ImageUrl NVARCHAR(500);
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'IsActive')
                ALTER TABLE Services ADD IsActive BIT DEFAULT 1;

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Custom_Wishlists')
                CREATE TABLE Custom_Wishlists (Id INT IDENTITY PRIMARY KEY, UserId INT NOT NULL, ProductId INT NOT NULL, CreatedAt DATETIME DEFAULT GETDATE());
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistsNew')
                CREATE TABLE WishlistsNew (Id INT IDENTITY PRIMARY KEY, UserId INT NOT NULL, ProductId INT NOT NULL, CreatedAt DATETIME DEFAULT GETDATE());
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AddressesNew')
                CREATE TABLE AddressesNew (Id INT IDENTITY PRIMARY KEY, CustomerId INT NOT NULL, FullName NVARCHAR(200), Phone NVARCHAR(50), Province NVARCHAR(100), District NVARCHAR(100), Ward NVARCHAR(100), Street NVARCHAR(200), IsDefault BIT DEFAULT 0);
            
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Carts') AND name = 'UserId')
                ALTER TABLE Carts ADD UserId NVARCHAR(450);
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Customers') AND name = 'AvatarUrl')
                ALTER TABLE Customers ADD AvatarUrl NVARCHAR(MAX) NULL;

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceReviews')
                CREATE TABLE ServiceReviews (ReviewId INT IDENTITY PRIMARY KEY, ServiceId INT NOT NULL, CustomerId INT NULL, Rating INT NOT NULL, Comment NVARCHAR(MAX), IsApproved BIT DEFAULT 0, CreatedDate DATETIME DEFAULT GETDATE());

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'IsPublished')
                ALTER TABLE Blogs ADD IsPublished BIT DEFAULT 0;
            
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'MetaTitle')
                ALTER TABLE Blogs ADD MetaTitle NVARCHAR(255) NULL;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'MetaDescription')
                ALTER TABLE Blogs ADD MetaDescription NVARCHAR(500) NULL;

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Banners') AND name = 'DisplayOrder')
                ALTER TABLE Banners ADD DisplayOrder INT DEFAULT 0;

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'DepositAmount')
                ALTER TABLE ServiceBookings ADD DepositAmount DECIMAL(18,2) DEFAULT 0, DepositStatus NVARCHAR(50) DEFAULT 'Unpaid', TransferProof NVARCHAR(500) NULL, ConfirmedAt DATETIME NULL, ExpireAt DATETIME NULL, CancelReason NVARCHAR(500) NULL;

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderStatusHistory')
                CREATE TABLE OrderStatusHistory (HistoryId INT IDENTITY PRIMARY KEY, OrderId INT NOT NULL, Status NVARCHAR(100) NOT NULL, ChangedDate DATETIME DEFAULT GETDATE(), Note NVARCHAR(MAX) NULL);
            
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'PaymentMethod')
                ALTER TABLE Orders ADD PaymentMethod NVARCHAR(100) NULL;
        ");

        await context.Database.ExecuteSqlRawAsync(@"
            UPDATE Blogs SET IsPublished = 0 WHERE IsPublished IS NULL;
            UPDATE Banners SET DisplayOrder = 0 WHERE DisplayOrder IS NULL;
        ");

        Log.Information("Seeding Data...");
        await context.Database.ExecuteSqlRawAsync(@"
            IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceCategories') AND NOT EXISTS (SELECT * FROM ServiceCategories)
            BEGIN
                INSERT INTO ServiceCategories (CategoryName, Slug, Icon) VALUES 
                (N'Bảo dưỡng', 'bao-duong', 'bx-wrench'),
                (N'Phụ tùng', 'phu-tung', 'bx-cog'),
                (N'Độ xe', 'do-xe', 'bx-tachometer'),
                (N'Cứu hộ', 'cuu-ho', 'bx-unite'),
                (N'Rửa xe', 'rua-xe', 'bx-water');
            END
        ");

        if (!context.Categories.Any()) {
            await DbSeeder.SeedAsync(context, userManager, roleManager);
        }
    }
    catch (Exception ex) { Log.Error("Startup Error: {Message}", ex.Message); }
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/Home/Error/{0}");

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();
app.UseAntiforgery(); // Cần thiết để nhận diện X-XSRF-TOKEN header

app.MapControllerRoute(name: "areas", pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");
app.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
