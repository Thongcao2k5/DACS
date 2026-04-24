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

var app = builder.Build();

// TỐI ƯU HÓA KHỞI ĐỘNG (CHỈ TẠO BẢNG NẾU CẦN)
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<MotoShopDbContext>();
    var userManager = services.GetRequiredService<UserManager<IdentityUser>>();
    var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();

    try 
    {
        Log.Information("Checking and Seeding data...");
        
        // ĐẢM BẢO BẢNG SMART FEATURES TỒN TẠI VÀ ĐÚNG CẤU TRÚC
        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistsNew')
            CREATE TABLE WishlistsNew (
                Id INT IDENTITY PRIMARY KEY,
                UserId INT NOT NULL,
                ProductId INT NOT NULL,
                CreatedAt DATETIME DEFAULT GETDATE()
            );

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AddressesNew')
            CREATE TABLE AddressesNew (
                Id INT IDENTITY PRIMARY KEY, 
                CustomerId INT NOT NULL, 
                FullName NVARCHAR(200), 
                Phone NVARCHAR(50), 
                Province NVARCHAR(100), 
                District NVARCHAR(100), 
                Ward NVARCHAR(100), 
                Street NVARCHAR(200), 
                IsDefault BIT DEFAULT 0
            );

            -- Sửa lỗi thiếu cột UserId trong bảng Carts (để hỗ trợ Guest Cart)
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Carts') AND name = 'UserId')
                ALTER TABLE Carts ADD UserId NVARCHAR(450);

            -- Sửa lỗi thiếu cột ImageUrl và IsActive trong Services
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'ImageUrl')
                ALTER TABLE Services ADD ImageUrl NVARCHAR(500);
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'IsActive')
                ALTER TABLE Services ADD IsActive BIT DEFAULT 1;

            -- Cập nhật ServiceBookings để hỗ trợ ComboId
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'ComboId')
                ALTER TABLE ServiceBookings ADD ComboId INT NULL;

            -- Tạo bảng ServiceCombos nếu chưa có (Tránh lỗi SQL khi truy vấn)
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceCombos')
            CREATE TABLE ServiceCombos (
                ComboId INT IDENTITY PRIMARY KEY,
                ComboName NVARCHAR(200) NOT NULL,
                TotalPrice DECIMAL(18,2) NOT NULL,
                DiscountPrice DECIMAL(18,2) NOT NULL,
                Description NVARCHAR(MAX),
                ImageUrl NVARCHAR(500),
                IsActive BIT DEFAULT 1
            );

            -- Tạo bảng ServiceComboItems nếu chưa có
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceComboItems')
            CREATE TABLE ServiceComboItems (
                Id INT IDENTITY PRIMARY KEY,
                ComboId INT NOT NULL,
                ServiceId INT NOT NULL,
                CONSTRAINT FK_ServiceComboItems_Combos FOREIGN KEY (ComboId) REFERENCES ServiceCombos(ComboId) ON DELETE CASCADE,
                CONSTRAINT FK_ServiceComboItems_Services FOREIGN KEY (ServiceId) REFERENCES Services(ServiceId) ON DELETE CASCADE
            );

            -- Tạo bảng OrderStatusHistory nếu chưa có
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderStatusHistory')
            CREATE TABLE OrderStatusHistory (
                HistoryId INT IDENTITY PRIMARY KEY,
                OrderId INT NOT NULL,
                Status NVARCHAR(100) NOT NULL,
                ChangedDate DATETIME DEFAULT GETDATE(),
                Note NVARCHAR(MAX) NULL,
                CONSTRAINT FK_OrderStatusHistory_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE
            );
            ELSE
            BEGIN
                -- Nếu lỡ tạo với tên cột 'Id', đổi tên thành 'HistoryId'
                IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('OrderStatusHistory') AND name = 'Id')
                    EXEC sp_rename 'OrderStatusHistory.Id', 'HistoryId', 'COLUMN';
            END




            -- Sửa lỗi tên bảng Staff (cũ) thành Staffs (mới)
            IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Staff') AND NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Staffs')
                EXEC sp_rename 'Staff', 'Staffs';
            
            -- Tạo bảng InventoryTransactions nếu chưa có (thay thế StockMovements)
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InventoryTransactions')
            BEGIN
                IF EXISTS (SELECT * FROM sys.tables WHERE name = 'StockMovements')
                    EXEC sp_rename 'StockMovements', 'InventoryTransactions';
                ELSE
                CREATE TABLE InventoryTransactions (
                    TransactionId INT IDENTITY PRIMARY KEY,
                    ProductVariantId INT NULL,
                    Quantity INT NOT NULL,
                    TransactionType NVARCHAR(50) NOT NULL,
                    TransactionDate DATETIME DEFAULT GETDATE(),
                    Note NVARCHAR(MAX)
                );
            END

            -- Tạo bảng BlogCategories nếu chưa có
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BlogCategories')
            CREATE TABLE BlogCategories (
                Id INT IDENTITY PRIMARY KEY,
                Name NVARCHAR(200) NOT NULL,
                Slug NVARCHAR(255) NULL
            );

            -- Tạo bảng Blogs nếu chưa có và thêm cột IsPublished nếu thiếu
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Blogs')
            CREATE TABLE Blogs (
                Id INT IDENTITY PRIMARY KEY,
                Title NVARCHAR(300) NOT NULL,
                Slug NVARCHAR(300) NOT NULL,
                Content NVARCHAR(MAX) NOT NULL,
                Thumbnail NVARCHAR(500) NULL,
                CategoryId INT NOT NULL,
                Status INT DEFAULT 0,
                CreatedDate DATETIME DEFAULT GETDATE(),
                UpdatedDate DATETIME NULL,
                IsPublished BIT DEFAULT 0,
                CONSTRAINT FK_Blogs_Categories FOREIGN KEY (CategoryId) REFERENCES BlogCategories(Id) ON DELETE CASCADE
            );
            ELSE
            BEGIN
                IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'IsPublished')
                    ALTER TABLE Blogs ADD IsPublished BIT DEFAULT 0;
            END

            -- Thêm các cột cho Coupons nếu thiếu
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Coupons') AND name = 'IsAllProducts')
                ALTER TABLE Coupons ADD IsAllProducts BIT DEFAULT 1;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Coupons') AND name = 'AppliedCategoryIds')
                ALTER TABLE Coupons ADD AppliedCategoryIds NVARCHAR(MAX) NULL;
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Coupons') AND name = 'AppliedProductIds')
                ALTER TABLE Coupons ADD AppliedProductIds NVARCHAR(MAX) NULL;

            -- Đảm bảo Role 'Customer' tồn tại
            IF NOT EXISTS (SELECT * FROM AspNetRoles WHERE Name = 'Customer')
            BEGIN
                INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) 
                VALUES (NEWID(), 'Customer', 'CUSTOMER', NEWID());
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

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(name: "areas", pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");
app.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
