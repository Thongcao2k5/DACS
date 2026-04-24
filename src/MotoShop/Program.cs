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
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.AddMemoryCache();

builder.Services.AddIdentity<IdentityUser, IdentityRole>(options => {
    options.Password.RequireDigit = false;
    options.Password.RequiredLength = 6;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.Password.RequireLowercase = false;
})
.AddEntityFrameworkStores<MotoShopDbContext>()
.AddDefaultTokenProviders();

builder.Services.ConfigureApplicationCookie(options => {
    options.LoginPath = "/Account/Login";
    options.AccessDeniedPath = "/Account/Login";
    options.ReturnUrlParameter = "returnUrl";
    options.Cookie.Name = "MotoShop.Auth";
    options.ExpireTimeSpan = TimeSpan.FromDays(30);
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
        
        // GIAI ĐOẠN 1: TẠO BẢNG VÀ CỘT
        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceCategories')
            CREATE TABLE ServiceCategories (
                CategoryId INT IDENTITY PRIMARY KEY,
                CategoryName NVARCHAR(100) NOT NULL,
                Slug NVARCHAR(255),
                Icon NVARCHAR(50),
                IsActive BIT DEFAULT 1
            );

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
            
            -- Đảm bảo không có giá trị NULL cho cột IsPublished (Sửa lỗi SqlNullValueException)
            UPDATE Blogs SET IsPublished = 0 WHERE IsPublished IS NULL;

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'MetaTitle')
                ALTER TABLE Blogs ADD MetaTitle NVARCHAR(255) NULL;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'MetaDescription')
                ALTER TABLE Blogs ADD MetaDescription NVARCHAR(500) NULL;

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Banners') AND name = 'DisplayOrder')
                ALTER TABLE Banners ADD DisplayOrder INT DEFAULT 0;
            
            -- Đảm bảo không có giá trị NULL cho cột DisplayOrder (Sửa lỗi SqlNullValueException)
            UPDATE Banners SET DisplayOrder = 0 WHERE DisplayOrder IS NULL;

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'DepositAmount')
                ALTER TABLE ServiceBookings ADD DepositAmount DECIMAL(18,2) DEFAULT 0, DepositStatus NVARCHAR(50) DEFAULT 'Unpaid', TransferProof NVARCHAR(500) NULL, ConfirmedAt DATETIME NULL, ExpireAt DATETIME NULL, CancelReason NVARCHAR(500) NULL;

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderStatusHistory')
                CREATE TABLE OrderStatusHistory (HistoryId INT IDENTITY PRIMARY KEY, OrderId INT NOT NULL, Status NVARCHAR(100) NOT NULL, ChangedDate DATETIME DEFAULT GETDATE(), Note NVARCHAR(MAX) NULL);
        ");

        // GIAI ĐOẠN 2: SEED DATA
        Log.Information("Seeding Data...");
        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT * FROM ServiceCategories)
            BEGIN
                INSERT INTO ServiceCategories (CategoryName, Slug, Icon) VALUES 
                (N'Bảo dưỡng', 'bao-duong', 'bx-wrench'),
                (N'Phụ tùng', 'phu-tung', 'bx-cog'),
                (N'Độ xe', 'do-xe', 'bx-tachometer'),
                (N'Cứu hộ', 'cuu-ho', 'bx-unite'),
                (N'Rửa xe', 'rua-xe', 'bx-water');

                DECLARE @catBaoDuong INT = (SELECT CategoryId FROM ServiceCategories WHERE Slug = 'bao-duong');
                DECLARE @catPhuTung INT = (SELECT CategoryId FROM ServiceCategories WHERE Slug = 'phu-tung');
                DECLARE @catDoXe INT = (SELECT CategoryId FROM ServiceCategories WHERE Slug = 'do-xe');
                DECLARE @catCuuHo INT = (SELECT CategoryId FROM ServiceCategories WHERE Slug = 'cuu-ho');
                DECLARE @catRuaXe INT = (SELECT CategoryId FROM ServiceCategories WHERE Slug = 'rua-xe');

                DELETE FROM Services;
                INSERT INTO Services (ServiceName, Price, Duration, Slug, CategoryId, Description, WarrantyDays, TotalBookings, IsActive) VALUES
                (N'Thay nhớt động cơ', 120000, 30, 'thay-nhot-dong-co', @catBaoDuong, N'Thay nhớt động cơ giúp xe vận hành mượt mà hơn.', 30, 120, 1),
                (N'Bảo dưỡng định kỳ', 350000, 90, 'bao-duong-dinh-ky', @catBaoDuong, N'Bao gồm kiểm tra phanh, nhớt, lọc gió, bugi và hệ thống điện.', 45, 85, 1),
                (N'Kiểm tra phanh', 180000, 45, 'kiem-tra-phanh', @catBaoDuong, N'Kiểm tra bố thắng, dầu phanh và hiệu suất phanh.', 30, 50, 1),
                (N'Thay lốp xe', 450000, 60, 'thay-lop-xe', @catPhuTung, N'Thay lốp mới và cân chỉnh áp suất tiêu chuẩn.', 60, 65, 1),
                (N'Thay bugi', 200000, 30, 'thay-bugi', @catPhuTung, N'Giúp xe đề nổ tốt hơn và tiết kiệm nhiên liệu.', 30, 40, 1),
                (N'Lắp đèn LED', 500000, 60, 'lap-den-led', @catPhuTung, N'Tăng độ sáng và tính thẩm mỹ cho xe.', 90, 32, 1),
                (N'Độ pô xe', 1200000, 180, 'do-po-xe', @catDoXe, N'Tăng hiệu suất động cơ và âm thanh mạnh mẽ.', 90, 22, 1),
                (N'Sơn tem xe', 900000, 240, 'son-tem-xe', @catDoXe, N'Tùy chỉnh phong cách xe theo sở thích.', 60, 18, 1),
                (N'Cứu hộ xe chết máy', 250000, 60, 'cuu-ho-xe-chet-may', @catCuuHo, N'Hỗ trợ xe chết máy tại chỗ trong nội thành.', 7, 55, 1),
                (N'Cứu hộ thủng lốp', 200000, 45, 'cuu-ho-thung-lop', @catCuuHo, N'Hỗ trợ khẩn cấp khi xe bị thủng lốp.', 7, 38, 1),
                (N'Rửa xe cơ bản', 50000, 20, 'rua-xe-co-ban', @catRuaXe, N'Làm sạch thân xe và bánh xe.', 0, 150, 1),
                (N'Rửa xe cao cấp', 150000, 45, 'rua-xe-cao-cap', @catRuaXe, N'Bao gồm đánh bóng và vệ sinh chuyên sâu.', 0, 95, 1);
            END

            UPDATE Services SET Duration = 30 WHERE Duration IS NULL;
            UPDATE Services SET IsActive = 1 WHERE IsActive IS NULL;
            UPDATE Services SET TotalBookings = 0 WHERE TotalBookings IS NULL;
            UPDATE Services SET WarrantyDays = 30 WHERE WarrantyDays IS NULL;
            UPDATE ServiceCategories SET IsActive = 1 WHERE IsActive IS NULL;
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

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(name: "areas", pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");
app.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
