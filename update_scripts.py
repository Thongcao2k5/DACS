
-- SQL Update Script for MotoShop - Branch sql-23
-- Date: 2026-04-24

-- 1. Bảng Coupons (Mã giảm giá) - Thêm tính năng áp dụng theo sản phẩm/danh mục
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Coupons') AND name = 'IsAllProducts')
    ALTER TABLE Coupons ADD IsAllProducts BIT DEFAULT 1;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Coupons') AND name = 'AppliedCategoryIds')
    ALTER TABLE Coupons ADD AppliedCategoryIds NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Coupons') AND name = 'AppliedProductIds')
    ALTER TABLE Coupons ADD AppliedProductIds NVARCHAR(MAX) NULL;

-- 2. Bảng OrderStatusHistory (Lịch sử đơn hàng) - Theo dõi tiến trình
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderStatusHistory')
BEGIN
    CREATE TABLE OrderStatusHistory (
        HistoryId INT IDENTITY(1,1) PRIMARY KEY,
        OrderId INT NOT NULL,
        Status NVARCHAR(100) NOT NULL,
        ChangedDate DATETIME DEFAULT GETDATE(),
        Note NVARCHAR(MAX) NULL,
        CONSTRAINT FK_OrderStatusHistory_Orders FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON DELETE CASCADE
    );
END
ELSE
BEGIN
    -- Đảm bảo tên cột là HistoryId nếu trước đó lỡ tạo là Id
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('OrderStatusHistory') AND name = 'Id')
        EXEC sp_rename 'OrderStatusHistory.Id', 'HistoryId', 'COLUMN';
    
    -- Thêm cột Note nếu chưa có
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('OrderStatusHistory') AND name = 'Note')
        ALTER TABLE OrderStatusHistory ADD Note NVARCHAR(MAX) NULL;
END

-- 3. Phân quyền (Roles) - Đảm bảo có Role Customer cho đăng ký mới
IF NOT EXISTS (SELECT * FROM AspNetRoles WHERE Name = 'Customer')
BEGIN
    INSERT INTO AspNetRoles (Id, Name, NormalizedName, ConcurrencyStamp) 
    VALUES (NEWID(), 'Customer', 'CUSTOMER', NEWID());
END

-- 4. Blog & Tin tức - Đảm bảo cấu trúc hỗ trợ hiển thị ổn định
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BlogCategories')
BEGIN
    CREATE TABLE BlogCategories (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(200) NOT NULL,
        Slug NVARCHAR(255) NULL
    );
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Blogs')
BEGIN
    CREATE TABLE Blogs (
        Id INT IDENTITY(1,1) PRIMARY KEY,
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
END
ELSE
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'IsPublished')
        ALTER TABLE Blogs ADD IsPublished BIT DEFAULT 0;
END

-- 5. Bảng Services - Cập nhật để hỗ trợ hiển thị giao diện mới
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'ImageUrl')
    ALTER TABLE Services ADD ImageUrl NVARCHAR(500);

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Services') AND name = 'IsActive')
    ALTER TABLE Services ADD IsActive BIT DEFAULT 1;

-- 6. Đồng bộ các bảng mới hỗ trợ Address và Wishlist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistsNew')
CREATE TABLE WishlistsNew (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId NVARCHAR(450) NOT NULL,
    ProductId INT NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AddressesNew')
CREATE TABLE AddressesNew (
    Id INT IDENTITY(1,1) PRIMARY KEY, 
    CustomerId INT NOT NULL, 
    FullName NVARCHAR(200), 
    Phone NVARCHAR(50), 
    Province NVARCHAR(100), 
    District NVARCHAR(100), 
    Ward NVARCHAR(100), 
    Street NVARCHAR(200), 
    IsDefault BIT DEFAULT 0
);
