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
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console()
    .WriteTo.File("Logs/log-.txt", rollingInterval: RollingInterval.Day, retainedFileCountLimit: 7)
    .CreateLogger();

builder.Host.UseSerilog();

builder.Services.AddControllersWithViews(options => 
    {
        options.Filters.Add(new AutoValidateAntiforgeryTokenAttribute());
    })
    .AddJsonOptions(options => {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
        options.JsonSerializerOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;
    });

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy =>
        {
            var allowedOrigins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>();
            if (builder.Environment.IsDevelopment())
            {
                policy.SetIsOriginAllowed(origin => true)
                      .AllowAnyMethod()
                      .AllowAnyHeader()
                      .AllowCredentials();
            }
            else if (allowedOrigins == null || allowedOrigins.Length == 0)
            {
                policy.WithOrigins(builder.Configuration["AppUrl"] ?? "https://localhost")
                      .AllowAnyMethod()
                      .AllowAnyHeader()
                      .AllowCredentials();
            }
            else
            {
                policy.WithOrigins(allowedOrigins)
                      .AllowAnyMethod()
                      .AllowAnyHeader()
                      .AllowCredentials();
            }
        });
});

builder.Services.AddAutoMapper(cfg => cfg.AddProfile<MappingProfile>());

builder.Services.AddDbContextPool<MotoShopDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"),
    sqlOptions =>
    {
        sqlOptions.EnableRetryOnFailure(
            maxRetryCount: 3,
            maxRetryDelay: TimeSpan.FromSeconds(5),
            errorNumbersToAdd: null);
        sqlOptions.CommandTimeout(120);
        sqlOptions.UseQuerySplittingBehavior(QuerySplittingBehavior.SplitQuery);
    })
    .ConfigureWarnings(w => w
        .Ignore(Microsoft.EntityFrameworkCore.Diagnostics.RelationalEventId.PendingModelChangesWarning)
        .Ignore(Microsoft.EntityFrameworkCore.Diagnostics.RelationalEventId.MultipleCollectionIncludeWarning)),
    poolSize: 50);

builder.Services.AddSignalR();
builder.Services.AddMemoryCache();
if (!builder.Environment.IsDevelopment())
{
    builder.Services.AddResponseCompression(opts =>
    {
        opts.EnableForHttps = true;
        opts.Providers.Add<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProvider>();
        opts.Providers.Add<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProvider>();
    });
    builder.Services.Configure<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions>(o => o.Level = System.IO.Compression.CompressionLevel.Fastest);
    builder.Services.Configure<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions>(o => o.Level = System.IO.Compression.CompressionLevel.Fastest);
}

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

builder.Services.AddAuthentication()
    .AddGoogle(options => {
        options.ClientId = builder.Configuration["Authentication:Google:ClientId"]!;
        options.ClientSecret = builder.Configuration["Authentication:Google:ClientSecret"]!;
    })
    .AddFacebook(options => {
        options.AppId = builder.Configuration["Authentication:Facebook:AppId"]!;
        options.AppSecret = builder.Configuration["Authentication:Facebook:AppSecret"]!;
        options.Scope.Clear();
        options.Scope.Add("public_profile");
        options.Fields.Add("name");
        options.Fields.Add("email");
    });

builder.Services.ConfigureApplicationCookie(options => {
    options.Cookie.HttpOnly = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.Cookie.SameSite = SameSiteMode.Lax;
    options.ExpireTimeSpan = TimeSpan.FromDays(7);
    options.SlidingExpiration = true;
    options.LoginPath = "/Account/Login";
    options.AccessDeniedPath = "/Account/Login";
    options.ReturnUrlParameter = "returnUrl";
    options.Cookie.Name = "MotoShop.Auth";
});

builder.Services.AddScoped(typeof(IGenericRepository<>), typeof(GenericRepository<>));
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IPromotionRepository, PromotionRepository>();
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<IProductService, ProductService>();
builder.Services.AddScoped<ICategoryService, CategoryService>();
builder.Services.AddScoped<IBrandService, BrandService>();
builder.Services.AddScoped<IMotorbikeModelService, MotorbikeModelService>();
builder.Services.AddScoped<ICartService, CartService>();
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<IFileService, FileService>();
builder.Services.AddScoped<IAuditLogService, AuditLogService>();
builder.Services.AddScoped<IBookingService, BookingService>();
builder.Services.AddScoped<IPromotionService, PromotionService>();
builder.Services.AddScoped<IEmailService, EmailService>();
builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.AddHttpClient<IGhnService, GhnService>(client =>
{
    client.Timeout = TimeSpan.FromSeconds(10);
});
builder.Services.AddHostedService<BookingExpiryService>();
builder.Services.AddHostedService<PendingPaymentCleanupService>();
builder.Services.AddHostedService<PromotionBackgroundService>();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var context = services.GetRequiredService<MotoShopDbContext>();
    var userManager = services.GetRequiredService<UserManager<IdentityUser>>();
    var roleManager = services.GetRequiredService<RoleManager<IdentityRole>>();

    try
    {
        // Tăng timeout lên 5 phút cho toàn bộ startup SQL
        context.Database.SetCommandTimeout(300);
        Log.Information("Updating Database Schema...");
        await context.Database.MigrateAsync();

        await context.Database.ExecuteSqlRawAsync(@"
            IF OBJECT_ID('Promotions', 'U') IS NULL
            BEGIN
                CREATE TABLE Promotions
                (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Promotions PRIMARY KEY,
                    Name NVARCHAR(255) NOT NULL,
                    Slug NVARCHAR(255) NULL,
                    Description NVARCHAR(MAX) NULL,
                    PromotionType NVARCHAR(50) NOT NULL CONSTRAINT DF_Promotions_PromotionType DEFAULT('ProductDiscount'),
                    DiscountType NVARCHAR(20) NOT NULL CONSTRAINT DF_Promotions_DiscountType DEFAULT('Percent'),
                    DiscountValue DECIMAL(18,2) NOT NULL CONSTRAINT DF_Promotions_DiscountValue DEFAULT(0),
                    MaxDiscountAmount DECIMAL(18,2) NULL,
                    MinOrderAmount DECIMAL(18,2) NULL,
                    CouponCode NVARCHAR(100) NULL,
                    StartDate DATETIME NOT NULL CONSTRAINT DF_Promotions_StartDate DEFAULT(GETDATE()),
                    EndDate DATETIME NOT NULL CONSTRAINT DF_Promotions_EndDate DEFAULT(DATEADD(day, 7, GETDATE())),
                    UsageLimit INT NULL,
                    UsedCount INT NOT NULL CONSTRAINT DF_Promotions_UsedCount DEFAULT(0),
                    IsActive BIT NOT NULL CONSTRAINT DF_Promotions_IsActive DEFAULT(1),
                    IsFeatured BIT NOT NULL CONSTRAINT DF_Promotions_IsFeatured DEFAULT(0),
                    Priority INT NOT NULL CONSTRAINT DF_Promotions_Priority DEFAULT(0),
                    BannerImage NVARCHAR(500) NULL,
                    BackgroundColor NVARCHAR(50) NULL,
                    CreatedAt DATETIME NOT NULL CONSTRAINT DF_Promotions_CreatedAt DEFAULT(GETDATE()),
                    UpdatedAt DATETIME NULL
                );
            END
            ELSE
            BEGIN
                IF COL_LENGTH('Promotions', 'PromotionId') IS NOT NULL AND COL_LENGTH('Promotions', 'Id') IS NULL
                    EXEC sp_rename 'Promotions.PromotionId', 'Id', 'COLUMN';

                IF COL_LENGTH('Promotions', 'PromotionName') IS NOT NULL AND COL_LENGTH('Promotions', 'Name') IS NULL
                    EXEC sp_rename 'Promotions.PromotionName', 'Name', 'COLUMN';

                IF COL_LENGTH('Promotions', 'Id') IS NULL
                    ALTER TABLE Promotions ADD Id INT IDENTITY(1,1) NOT NULL;
                IF COL_LENGTH('Promotions', 'Name') IS NULL
                    ALTER TABLE Promotions ADD Name NVARCHAR(255) NOT NULL CONSTRAINT DF_Promotions_Name DEFAULT('');
                IF COL_LENGTH('Promotions', 'Slug') IS NULL
                    ALTER TABLE Promotions ADD Slug NVARCHAR(255) NULL;
                IF COL_LENGTH('Promotions', 'Description') IS NULL
                    ALTER TABLE Promotions ADD Description NVARCHAR(MAX) NULL;
                IF COL_LENGTH('Promotions', 'PromotionType') IS NULL
                    ALTER TABLE Promotions ADD PromotionType NVARCHAR(50) NOT NULL CONSTRAINT DF_Promotions_PromotionType DEFAULT('ProductDiscount');
                IF COL_LENGTH('Promotions', 'DiscountType') IS NULL
                    ALTER TABLE Promotions ADD DiscountType NVARCHAR(20) NOT NULL CONSTRAINT DF_Promotions_DiscountType DEFAULT('Percent');
                IF COL_LENGTH('Promotions', 'DiscountValue') IS NULL
                    ALTER TABLE Promotions ADD DiscountValue DECIMAL(18,2) NOT NULL CONSTRAINT DF_Promotions_DiscountValue DEFAULT(0);
                IF COL_LENGTH('Promotions', 'MaxDiscountAmount') IS NULL
                    ALTER TABLE Promotions ADD MaxDiscountAmount DECIMAL(18,2) NULL;
                IF COL_LENGTH('Promotions', 'MinOrderAmount') IS NULL
                    ALTER TABLE Promotions ADD MinOrderAmount DECIMAL(18,2) NULL;
                IF COL_LENGTH('Promotions', 'CouponCode') IS NULL
                    ALTER TABLE Promotions ADD CouponCode NVARCHAR(100) NULL;
                IF COL_LENGTH('Promotions', 'StartDate') IS NULL
                    ALTER TABLE Promotions ADD StartDate DATETIME NOT NULL CONSTRAINT DF_Promotions_StartDate DEFAULT(GETDATE());
                IF COL_LENGTH('Promotions', 'EndDate') IS NULL
                    ALTER TABLE Promotions ADD EndDate DATETIME NOT NULL CONSTRAINT DF_Promotions_EndDate DEFAULT(DATEADD(day, 7, GETDATE()));
                IF COL_LENGTH('Promotions', 'UsageLimit') IS NULL
                    ALTER TABLE Promotions ADD UsageLimit INT NULL;
                IF COL_LENGTH('Promotions', 'UsedCount') IS NULL
                    ALTER TABLE Promotions ADD UsedCount INT NOT NULL CONSTRAINT DF_Promotions_UsedCount DEFAULT(0);
                IF COL_LENGTH('Promotions', 'IsActive') IS NULL
                    ALTER TABLE Promotions ADD IsActive BIT NOT NULL CONSTRAINT DF_Promotions_IsActive DEFAULT(1);
                IF COL_LENGTH('Promotions', 'IsFeatured') IS NULL
                    ALTER TABLE Promotions ADD IsFeatured BIT NOT NULL CONSTRAINT DF_Promotions_IsFeatured DEFAULT(0);
                IF COL_LENGTH('Promotions', 'Priority') IS NULL
                    ALTER TABLE Promotions ADD Priority INT NOT NULL CONSTRAINT DF_Promotions_Priority DEFAULT(0);
                IF COL_LENGTH('Promotions', 'BannerImage') IS NULL
                    ALTER TABLE Promotions ADD BannerImage NVARCHAR(500) NULL;
                IF COL_LENGTH('Promotions', 'BackgroundColor') IS NULL
                    ALTER TABLE Promotions ADD BackgroundColor NVARCHAR(50) NULL;
                IF COL_LENGTH('Promotions', 'CreatedAt') IS NULL
                    ALTER TABLE Promotions ADD CreatedAt DATETIME NOT NULL CONSTRAINT DF_Promotions_CreatedAt DEFAULT(GETDATE());
                IF COL_LENGTH('Promotions', 'UpdatedAt') IS NULL
                    ALTER TABLE Promotions ADD UpdatedAt DATETIME NULL;

                -- Drop legacy columns if they exist to prevent NULL constraint errors
                IF COL_LENGTH('Promotions', 'DiscountPercentage') IS NOT NULL
                    ALTER TABLE Promotions DROP COLUMN DiscountPercentage;
                IF COL_LENGTH('Promotions', 'DiscountAmount') IS NOT NULL
                    ALTER TABLE Promotions DROP COLUMN DiscountAmount;
                IF COL_LENGTH('Promotions', 'MinOrderValue') IS NOT NULL
                    ALTER TABLE Promotions DROP COLUMN MinOrderValue;
                IF COL_LENGTH('Promotions', 'MinQuantity') IS NOT NULL
                    ALTER TABLE Promotions DROP COLUMN MinQuantity;
            END

            IF OBJECT_ID('PromotionProducts', 'U') IS NULL
            BEGIN
                CREATE TABLE PromotionProducts
                (
                    Id INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PromotionProducts PRIMARY KEY,
                    PromotionId INT NOT NULL,
                    ProductId INT NOT NULL
                );
            END
        ");

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

            -- Đảm bảo dữ liệu cũ không bị NULL gây lỗi SqlNullValueException
            EXEC('UPDATE Services SET Duration = 30 WHERE Duration IS NULL');
            EXEC('UPDATE Services SET TotalBookings = 0 WHERE TotalBookings IS NULL');
            EXEC('UPDATE Services SET IsActive = 1 WHERE IsActive IS NULL');
            EXEC('UPDATE Services SET WarrantyDays = 30 WHERE WarrantyDays IS NULL');

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

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'CompletedAt')
                ALTER TABLE ServiceBookings ADD CompletedAt DATETIME NULL;

            IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'CompletedAt')
                UPDATE ServiceBookings
                SET CompletedAt = COALESCE(ServiceDate, BookingDate, GETDATE())
                WHERE Status IN ('Completed', 'DaHoanThanh')
                  AND CompletedAt IS NULL;

            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'RevenueAmount')
                ALTER TABLE ServiceBookings ADD RevenueAmount DECIMAL(18,2) NOT NULL DEFAULT 0;

            IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'RevenueAmount')
            BEGIN
                EXEC(N'
                    UPDATE b
                    SET RevenueAmount = CASE
                        WHEN s.ServiceId IS NOT NULL THEN s.Price
                        WHEN c.ComboId IS NOT NULL THEN CASE WHEN c.DiscountPrice > 0 THEN c.DiscountPrice ELSE c.TotalPrice END
                        ELSE ISNULL(b.DepositAmount, 0)
                    END
                    FROM ServiceBookings b
                    LEFT JOIN Services s ON b.ServiceId = s.ServiceId
                    LEFT JOIN ServiceCombos c ON b.ComboId = c.ComboId
                    WHERE b.Status IN (''Completed'', ''DaHoanThanh'')
                      AND ISNULL(b.RevenueAmount, 0) = 0;
                ');
            END

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderStatusHistory')
                CREATE TABLE OrderStatusHistory (HistoryId INT IDENTITY PRIMARY KEY, OrderId INT NOT NULL, Status NVARCHAR(100) NOT NULL, ChangedDate DATETIME DEFAULT GETDATE(), Note NVARCHAR(MAX) NULL);
            
            IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'PaymentMethod')
                ALTER TABLE Orders ADD PaymentMethod NVARCHAR(100) NULL;

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLogs')
                CREATE TABLE AuditLogs (Id INT IDENTITY PRIMARY KEY, UserId NVARCHAR(450) NULL, Action NVARCHAR(255) NOT NULL, EntityName NVARCHAR(255) NOT NULL, EntityId NVARCHAR(100) NULL, OldValues NVARCHAR(MAX) NULL, NewValues NVARCHAR(MAX) NULL, IpAddress NVARCHAR(50) NULL, CreatedAt DATETIME DEFAULT GETDATE());
            
            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductReviewImages')
                CREATE TABLE ProductReviewImages (Id INT IDENTITY PRIMARY KEY, ReviewId INT NOT NULL, ImageUrl NVARCHAR(500) NOT NULL);

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChatConversations')
                CREATE TABLE ChatConversations (
                    Id INT IDENTITY PRIMARY KEY,
                    UserId NVARCHAR(450) NULL,
                    GuestSessionId NVARCHAR(100) NULL,
                    CustomerName NVARCHAR(200) NULL,
                    CustomerEmail NVARCHAR(255) NULL,
                    LastMessage NVARCHAR(MAX) NULL,
                    LastMessageAt DATETIME NULL,
                    UnreadByAdminCount INT DEFAULT 0,
                    UnreadByCustomerCount INT DEFAULT 0,
                    CreatedAt DATETIME DEFAULT GETDATE(),
                    UpdatedAt DATETIME DEFAULT GETDATE(),
                    IsClosed BIT DEFAULT 0
                );

            IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChatMessages')
            BEGIN
                CREATE TABLE ChatMessages (
                    Id INT IDENTITY PRIMARY KEY,
                    ConversationId INT NOT NULL,
                    SenderType NVARCHAR(20) NOT NULL,
                    SenderId NVARCHAR(450) NULL,
                    SenderName NVARCHAR(200) NULL,
                    Message NVARCHAR(MAX) NOT NULL,
                    IsRead BIT DEFAULT 0,
                    CreatedAt DATETIME DEFAULT GETDATE()
                );
            END
            ELSE
            BEGIN
                -- Nếu bảng đã tồn tại kiểu cũ, xóa và tạo lại để khớp schema mới (vì dữ liệu chat cũ thường không quan trọng)
                IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ChatMessages') AND name = 'ConversationId')
                BEGIN
                    DROP TABLE ChatMessages;
                    CREATE TABLE ChatMessages (
                        Id INT IDENTITY PRIMARY KEY,
                        ConversationId INT NOT NULL,
                        SenderType NVARCHAR(20) NOT NULL,
                        SenderId NVARCHAR(450) NULL,
                        SenderName NVARCHAR(200) NULL,
                        Message NVARCHAR(MAX) NOT NULL,
                        IsRead BIT DEFAULT 0,
                        CreatedAt DATETIME DEFAULT GETDATE()
                    );
                END
            END
        ");

        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Categories_CategoryName' AND object_id = OBJECT_ID('Categories'))
                CREATE UNIQUE INDEX IX_Categories_CategoryName ON Categories (CategoryName);

            -- Products: index chính cho listing/filter
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Active_Deleted' AND object_id = OBJECT_ID('Products'))
                CREATE INDEX IX_Products_Active_Deleted ON Products (IsActive, IsDeleted)
                INCLUDE (ProductId, CategoryId, BrandId, IsFeatured, SoldCount, CreatedDate, ProductName, Slug);

            -- Upgrade non-unique IX_Products_Slug to unique (drop old first if it's not already unique)
            IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Slug' AND object_id = OBJECT_ID('Products') AND is_unique = 0)
                DROP INDEX IX_Products_Slug ON Products;
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Slug' AND object_id = OBJECT_ID('Products'))
            BEGIN
                IF NOT EXISTS (SELECT Slug FROM Products WHERE Slug IS NOT NULL GROUP BY Slug HAVING COUNT(*) > 1)
                    CREATE UNIQUE INDEX IX_Products_Slug ON Products (Slug) WHERE Slug IS NOT NULL;
            END

            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_CategoryId' AND object_id = OBJECT_ID('Products'))
                CREATE INDEX IX_Products_CategoryId ON Products (CategoryId, IsActive, IsDeleted);

            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_BrandId' AND object_id = OBJECT_ID('Products'))
                CREATE INDEX IX_Products_BrandId ON Products (BrandId, IsActive, IsDeleted);

            -- ProductVariants: index cho join với Products
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ProductVariants_ProductId' AND object_id = OBJECT_ID('ProductVariants'))
                CREATE INDEX IX_ProductVariants_ProductId ON ProductVariants (ProductId)
                INCLUDE (Price, OriginalPrice, StockQuantity, SKU, VariantName);

            -- Orders: index cho báo cáo và lịch sử đơn hàng
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_Status_Date' AND object_id = OBJECT_ID('Orders'))
                CREATE INDEX IX_Orders_Status_Date ON Orders (Status, OrderDate DESC)
                INCLUDE (CustomerId, TotalAmount, PaymentMethod);

            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Orders_CustomerId' AND object_id = OBJECT_ID('Orders'))
                CREATE INDEX IX_Orders_CustomerId ON Orders (CustomerId, OrderDate DESC);

            -- OrderItems: index cho join với Orders và ProductVariants
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_OrderItems_OrderId' AND object_id = OBJECT_ID('OrderItems'))
                CREATE INDEX IX_OrderItems_OrderId ON OrderItems (OrderId)
                INCLUDE (ProductVariantId, Quantity, Price);

            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_OrderItems_ProductVariantId' AND object_id = OBJECT_ID('OrderItems'))
                CREATE INDEX IX_OrderItems_ProductVariantId ON OrderItems (ProductVariantId);

            -- CartItems: index cho join với Carts
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_CartItems_CartId' AND object_id = OBJECT_ID('CartItems'))
                CREATE INDEX IX_CartItems_CartId ON CartItems (CartId)
                INCLUDE (ProductVariantId, Quantity, Price);

            -- ServiceBookings: index cho customer và status
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_ServiceBookings_CustomerId' AND object_id = OBJECT_ID('ServiceBookings'))
                CREATE INDEX IX_ServiceBookings_CustomerId ON ServiceBookings (CustomerId, BookingDate DESC);

            -- Customers: index cho UserId (link với IdentityUser)
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Customers_UserId' AND object_id = OBJECT_ID('Customers'))
                CREATE INDEX IX_Customers_UserId ON Customers (UserId);

            -- Blogs: unique slug (only if no duplicates exist)
            IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Blogs_Slug' AND object_id = OBJECT_ID('Blogs'))
            BEGIN
                IF NOT EXISTS (SELECT Slug FROM Blogs WHERE Slug IS NOT NULL GROUP BY Slug HAVING COUNT(*) > 1)
                    CREATE UNIQUE INDEX IX_Blogs_Slug ON Blogs (Slug) WHERE Slug IS NOT NULL;
            END
        ");

        await context.Database.ExecuteSqlRawAsync(@"
            UPDATE Blogs SET IsPublished = 0 WHERE IsPublished IS NULL;
            UPDATE Banners SET DisplayOrder = 0 WHERE DisplayOrder IS NULL;
            UPDATE ServiceBookings SET DepositAmount = 0 WHERE DepositAmount IS NULL;
        ");

        // Cập nhật logo thương hiệu — map chính xác theo nội dung ảnh thực tế
        await context.Database.ExecuteSqlRawAsync(@"
            UPDATE Brands SET LogoUrl = '/uploads/brands/honda.svg'        WHERE BrandName = N'Honda';
            UPDATE Brands SET LogoUrl = '/uploads/brands/yamaha.svg'       WHERE BrandName = N'Yamaha';
            UPDATE Brands SET LogoUrl = '/uploads/brands/michelin.svg'     WHERE BrandName = N'Michelin';
            UPDATE Brands SET LogoUrl = '/uploads/brands/castrol.svg'      WHERE BrandName = N'Castrol';
            UPDATE Brands SET LogoUrl = '/uploads/brands/yuasa.svg'        WHERE BrandName = N'Yuasa';
            UPDATE Brands SET LogoUrl = '/uploads/brands/agv.svg'          WHERE BrandName = N'AGV';
            UPDATE Brands SET LogoUrl = '/uploads/brands/brembo.svg'       WHERE BrandName = N'Brembo';
            UPDATE Brands SET LogoUrl = '/uploads/brands/liquimoly.svg'    WHERE BrandName = N'Liqui Moly';
            UPDATE Brands SET LogoUrl = '/uploads/brands/motul.svg'        WHERE BrandName = N'Motul';
            UPDATE Brands SET LogoUrl = '/uploads/brands/ngk.svg'          WHERE BrandName = N'NGK';
            UPDATE Brands SET LogoUrl = '/uploads/brands/ohlins.svg'       WHERE BrandName = N'Ohlins';
            UPDATE Brands SET LogoUrl = '/uploads/brands/yss.png'          WHERE BrandName = N'YSS';
            UPDATE Brands SET LogoUrl = '/uploads/brands/motobatt.png'     WHERE BrandName = N'Motobatt';
            UPDATE Brands SET LogoUrl = '/uploads/brands/mtx.png'          WHERE BrandName = N'MTX';
            UPDATE Brands SET LogoUrl = '/uploads/brands/crg.png'          WHERE BrandName = N'CRG';
            UPDATE Brands SET LogoUrl = '/uploads/brands/fkr.png'          WHERE BrandName = N'FKR';
            UPDATE Brands SET LogoUrl = '/uploads/brands/fmf.png'          WHERE BrandName = N'FMF';
            UPDATE Brands SET LogoUrl = '/uploads/brands/faito.png'        WHERE BrandName = N'Faito';
            UPDATE Brands SET LogoUrl = '/uploads/brands/kozi.png'         WHERE BrandName = N'Kozi';
            UPDATE Brands SET LogoUrl = '/uploads/brands/orange.png'       WHERE BrandName = N'Orange';
            UPDATE Brands SET LogoUrl = '/uploads/brands/rgv.png'          WHERE BrandName = N'RGV';
            UPDATE Brands SET LogoUrl = '/uploads/brands/apido.png'        WHERE BrandName = N'Apido';
            UPDATE Brands SET LogoUrl = '/uploads/brands/senarc.png'       WHERE BrandName = N'Senarc';
            UPDATE Brands SET LogoUrl = '/uploads/brands/yaguso.png'       WHERE BrandName = N'Yaguso';
            UPDATE Brands SET LogoUrl = '/uploads/brands/malossi.png'      WHERE BrandName = N'Malossi';
            UPDATE Brands SET LogoUrl = '/uploads/brands/tan_lan.png'      WHERE BrandName = N'Tân Lân';
            UPDATE Brands SET LogoUrl = '/uploads/brands/tan_lan.png'      WHERE BrandName = N'Tan Lan';
            UPDATE Brands SET LogoUrl = '/uploads/brands/tr_tiller.png'    WHERE BrandName = N'Tilier';
            UPDATE Brands SET LogoUrl = '/uploads/brands/tr_tiller.png'    WHERE BrandName = N'TR Tilier';
            UPDATE Brands SET LogoUrl = '/uploads/brands/ct_cytracing.png' WHERE BrandName = N'CYT Racing';
            UPDATE Brands SET LogoUrl = '/uploads/brands/ct_cytracing.png' WHERE BrandName = N'CYT RACING';
        ");

        Log.Information("Seeding Data...");
        await context.Database.ExecuteSqlRawAsync(@"
            IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceCategories') AND NOT EXISTS (SELECT * FROM ServiceCategories)
            BEGIN
                INSERT INTO ServiceCategories (CategoryName, Slug, Icon, IsActive) VALUES 
                (N'Bảo dưỡng', 'bao-duong', 'bx-wrench', 1),
                (N'Phụ tùng', 'phu-tung', 'bx-cog', 1),
                (N'Độ xe', 'do-xe', 'bx-tachometer', 1),
                (N'Cứu hộ', 'cuu-ho', 'bx-unite', 1),
                (N'Rửa xe', 'rua-xe', 'bx-water', 1);
            END
        ");

// === SHIPPING UPGRADE — thêm cột mới ===
        await context.Database.ExecuteSqlRawAsync(@"
            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'ShippingMethods') AND name = N'EstimatedDaysInt')
                ALTER TABLE ShippingMethods ADD EstimatedDaysInt INT NOT NULL DEFAULT 3;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'ShippingMethods') AND name = N'FreeShipThreshold')
                ALTER TABLE ShippingMethods ADD FreeShipThreshold DECIMAL(18,2) NULL;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'ShippingMethods') AND name = N'Provider')
                ALTER TABLE ShippingMethods ADD Provider NVARCHAR(100) NULL DEFAULT N'Nội bộ';

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'Orders') AND name = N'ShippingFee')
                ALTER TABLE Orders ADD ShippingFee DECIMAL(18,2) NOT NULL DEFAULT 0;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'Orders') AND name = N'ShippingProvinceCode')
                ALTER TABLE Orders ADD ShippingProvinceCode NVARCHAR(20) NULL;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'Orders') AND name = N'ShippingDistrictId')
                ALTER TABLE Orders ADD ShippingDistrictId INT NULL;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'Orders') AND name = N'ShippingWardCode')
                ALTER TABLE Orders ADD ShippingWardCode NVARCHAR(20) NULL;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'ProductVariants') AND name = N'Weight')
                ALTER TABLE ProductVariants ADD Weight INT NOT NULL DEFAULT 500;

            UPDATE ShippingMethods SET Provider = N'Nội bộ' WHERE Provider IS NULL;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'AddressesNew') AND name = N'DistrictId')
                ALTER TABLE AddressesNew ADD DistrictId INT NULL;

            IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'AddressesNew') AND name = N'WardCode')
                ALTER TABLE AddressesNew ADD WardCode NVARCHAR(20) NULL;

            -- Backfill: map address text names to GHN codes for existing rows missing DistrictId/WardCode
            UPDATE AddressesNew
            SET DistrictId = 1462, WardCode = N'21618'
            WHERE DistrictId IS NULL
              AND District   = N'Quận Bình Thạnh'
              AND Ward       = N'Phường 26';
        ");

        await context.Database.ExecuteSqlRawAsync("""
            IF NOT EXISTS (
                SELECT 1 FROM sys.objects
                WHERE object_id = OBJECT_ID(N'WeightGroups') AND type = 'U'
            )
            BEGIN
                CREATE TABLE WeightGroups (
                    Id            INT IDENTITY(1,1) PRIMARY KEY,
                    Name          NVARCHAR(100) NOT NULL,
                    DefaultWeight INT NOT NULL,
                    MinWeight     INT NOT NULL,
                    MaxWeight     INT NOT NULL,
                    Description   NVARCHAR(200) NULL
                );
                INSERT INTO WeightGroups (Name, DefaultWeight, MinWeight, MaxWeight, Description) VALUES
                (N'Hàng nhẹ',        300,    1,    499,  N'Bugi, xi nhan, bao tay, lọc gió, dây dầu, phụ kiện nhỏ'),
                (N'Hàng trung bình', 1000,  500,  1999,  N'Dầu nhớt 1L, đĩa phanh, heo dầu, nhông sên dĩa, ắc quy nhỏ'),
                (N'Hàng nặng',       3000, 2000,  4999,  N'Lốp xe, giảm xóc bộ đôi, ắc quy lớn, bình nhớt 4L'),
                (N'Hàng rất nặng',   6000, 5000, 50000,  N'Bộ phước + bình dầu, bộ lốp + vành, động cơ');
            END

            IF NOT EXISTS (
                SELECT 1 FROM sys.columns
                WHERE object_id = OBJECT_ID(N'ProductVariants') AND name = N'WeightGroupId'
            )
                ALTER TABLE ProductVariants ADD WeightGroupId INT NULL
                CONSTRAINT FK_ProductVariants_WeightGroup FOREIGN KEY REFERENCES WeightGroups(Id);
            """);
        // Category child groups from backup home UI branch.
        // Resolve parent IDs by slug instead of hardcoded identity values; existing DBs may
        // have different CategoryId values, and hardcoded IDs can violate the self-FK.
        await context.Database.ExecuteSqlRawAsync("""
    IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dau-nhot-boi-tron')
        INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive)
        VALUES (N'Dau nhot & Boi tron', 'dau-nhot-boi-tron', NULL, 1);

    IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'lop-xe-vanh')
        INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive)
        VALUES (N'Lop xe & Vanh', 'lop-xe-vanh', NULL, 1);

    IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'he-thong-phanh')
        INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive)
        VALUES (N'He thong phanh', 'he-thong-phanh', NULL, 1);

    IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'giam-xoc')
        INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive)
        VALUES (N'Giam xoc', 'giam-xoc', NULL, 1);

    IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'ac-quy-dien')
        INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive)
        VALUES (N'Ac quy & Dien', 'ac-quy-dien', NULL, 1);

    IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'phu-tung-phu-kien')
        INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive)
        VALUES (N'Phu tung & Phu kien', 'phu-tung-phu-kien', NULL, 1);

    DECLARE @OilParentId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE Slug = 'dau-nhot-boi-tron');
    DECLARE @TireParentId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE Slug = 'lop-xe-vanh');
    DECLARE @BrakeParentId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE Slug = 'he-thong-phanh');
    DECLARE @ShockParentId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE Slug = 'giam-xoc');
    DECLARE @ElectricParentId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE Slug = 'ac-quy-dien');
    DECLARE @PartsParentId INT = (SELECT TOP 1 CategoryId FROM Categories WHERE Slug = 'phu-tung-phu-kien');

    IF @OilParentId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dau-nhot-dong-co')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dau nhot dong co', 'dau-nhot-dong-co', @OilParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dung-dich-ve-sinh')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dung dich & Ve sinh', 'dung-dich-ve-sinh', @OilParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'duong-xe-bao-ve')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Duong xe & Bao ve', 'duong-xe-bao-ve', @OilParentId, 1);
    END

    IF @TireParentId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'lop-the-thao')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lop the thao', 'lop-the-thao', @TireParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'lop-pho-thong')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Lop pho thong', 'lop-pho-thong', @TireParentId, 1);
    END

    IF @BrakeParentId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dia-phanh-ma-phanh')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dia phanh & Ma phanh', 'dia-phanh-ma-phanh', @BrakeParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'heo-dau-cum-thang')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Heo dau & Cum thang', 'heo-dau-cum-thang', @BrakeParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'phu-kien-phanh')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Phu kien phanh', 'phu-kien-phanh', @BrakeParentId, 1);
    END

    IF @ShockParentId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'phuoc-sau')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Phuoc sau', 'phuoc-sau', @ShockParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'phuoc-truoc-bo-nang')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Phuoc truoc & Bo nang', 'phuoc-truoc-bo-nang', @ShockParentId, 1);
    END

    IF @ElectricParentId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'ac-quy-sac')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Ac quy & Sac', 'ac-quy-sac', @ElectricParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'den-dien-xe')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Den & Dien xe', 'den-dien-xe', @ElectricParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'bugi-an-toan')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Bugi & An toan', 'bugi-an-toan', @ElectricParentId, 1);
    END

    IF @PartsParentId IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'nhong-sen-dia')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Nhong sen dia', 'nhong-sen-dia', @PartsParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'truyen-dong-xe-tay-ga')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Truyen dong xe tay ga', 'truyen-dong-xe-tay-ga', @PartsParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'truyen-dong-dong-co')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Truyen dong & Dong co', 'truyen-dong-dong-co', @PartsParentId, 1);
        IF NOT EXISTS (SELECT 1 FROM Categories WHERE Slug = 'dieu-khien-phu-kien')
            INSERT INTO Categories (CategoryName, Slug, ParentId, IsActive) VALUES (N'Dieu khien & Phu kien', 'dieu-khien-phu-kien', @PartsParentId, 1);
    END
    """);

        await context.Database.ExecuteSqlRawAsync("""
    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'dau-nhot-dong-co')
    WHERE ProductId IN (204,205,206,207,208,209);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'dung-dich-ve-sinh')
    WHERE ProductId IN (210,212,213,214);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'duong-xe-bao-ve')
    WHERE ProductId IN (211,215);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'lop-the-thao')
    WHERE ProductId IN (216,217,218,220,222,224,225);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'lop-pho-thong')
    WHERE ProductId IN (219,221,223);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'dia-phanh-ma-phanh')
    WHERE ProductId IN (226,227,232,233);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'heo-dau-cum-thang')
    WHERE ProductId IN (228,231,234);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'phu-kien-phanh')
    WHERE ProductId IN (229,230,235);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'phuoc-sau')
    WHERE ProductId IN (236,237,238,240,241,242,243,244);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'phuoc-truoc-bo-nang')
    WHERE ProductId IN (239,245);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'ac-quy-sac')
    WHERE ProductId IN (247,249,251);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'den-dien-xe')
    WHERE ProductId IN (246,250,253,254);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'bugi-an-toan')
    WHERE ProductId IN (248,252);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'nhong-sen-dia')
    WHERE ProductId IN (265,267,268);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'truyen-dong-xe-tay-ga')
    WHERE ProductId IN (262,266,269);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'truyen-dong-dong-co')
    WHERE ProductId IN (260,261,263,264);

    UPDATE Products SET CategoryId =
        (SELECT CategoryId FROM Categories WHERE Slug = 'dieu-khien-phu-kien')
    WHERE ProductId IN (255,256,257,258,259);
    """);

        // VIỆC 1: Backfill DistrictId cho địa chỉ Tân Bình thiếu DistrictId
        await context.Database.ExecuteSqlRawAsync(@"
            UPDATE AddressesNew
            SET DistrictId = 1455
            WHERE District LIKE N'%Tân Bình%'
              AND (DistrictId IS NULL OR DistrictId = 0);
        ");

        // VIỆC 2: Tạo bảng EventPopups + seed data
        await context.Database.ExecuteSqlRawAsync("""
            IF NOT EXISTS (SELECT 1 FROM sys.objects
                           WHERE object_id = OBJECT_ID(N'EventPopups') AND type = 'U')
            BEGIN
                CREATE TABLE EventPopups (
                    Id          INT IDENTITY(1,1) PRIMARY KEY,
                    EventType   NVARCHAR(50)  NOT NULL CONSTRAINT DF_EP_EventType  DEFAULT 'FlashSale',
                    Title       NVARCHAR(200) NOT NULL,
                    Subtitle    NVARCHAR(300) NULL,
                    Description NVARCHAR(500) NULL,
                    Conditions  NVARCHAR(500) NULL,
                    CouponCode  NVARCHAR(50)  NULL,
                    CtaText     NVARCHAR(100) NOT NULL CONSTRAINT DF_EP_CtaText    DEFAULT N'Mua ngay',
                    CtaUrl      NVARCHAR(200) NOT NULL CONSTRAINT DF_EP_CtaUrl     DEFAULT '/khuyen-mai',
                    StartDate   DATETIME2     NOT NULL,
                    EndDate     DATETIME2     NOT NULL,
                    TotalQty    INT           NULL,
                    IsEnabled   BIT           NOT NULL CONSTRAINT DF_EP_IsEnabled  DEFAULT 1,
                    CreatedAt   DATETIME2     NOT NULL CONSTRAINT DF_EP_CreatedAt  DEFAULT GETDATE()
                );

                INSERT INTO EventPopups
                    (EventType, Title, Subtitle, Description, Conditions,
                     CouponCode, CtaText, CtaUrl, StartDate, EndDate, TotalQty, IsEnabled)
                VALUES (
                    'FlashSale',
                    N'Flash Sale Cuối Tuần — Giảm đến 40%!',
                    N'Chỉ còn trong thời gian giới hạn',
                    N'Áp dụng cho tất cả sản phẩm Phụ tùng & Phụ kiện',
                    N'Đơn tối thiểu 200k · Mỗi KH 1 lần/ngày',
                    'FLASHSALE40',
                    N'Mua ngay',
                    '/Product/Promotion',
                    DATEADD(DAY, -1, GETDATE()),
                    DATEADD(DAY, 7, GETDATE()),
                    200,
                    1
                );
            END
        """);

        await DbSeeder.SeedAsync(context, userManager, roleManager);
    }
    catch (Exception ex) { 
        Log.Error("Startup Error: {Message}", ex.Message); 
        throw; 
    }
}

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/Home/Error/{0}");

if (!app.Environment.IsDevelopment())
{
    app.UseResponseCompression();
}
app.UseHttpsRedirection();
app.UseStaticFiles(new StaticFileOptions
{
    OnPrepareResponse = ctx =>
    {
        ctx.Context.Response.Headers["Cache-Control"] = "public,max-age=31536000";
    }
});
app.UseRouting();
app.UseCors("AllowAll");
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(name: "areas", pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}");
app.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");
app.MapHub<MotoShop.Hubs.ChatHub>("/chatHub");

app.Run();
    
