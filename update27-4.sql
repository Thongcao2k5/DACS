-- Cập nhật Database MotoShop - Ngày 27/04/2026

-- 1. Bảng Categories (Danh mục sản phẩm)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Categories') AND name = 'Icon')
    ALTER TABLE Categories ADD Icon NVARCHAR(MAX) NULL;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Categories') AND name = 'IsActive')
    ALTER TABLE Categories ADD IsActive BIT DEFAULT 1;

-- Cập nhật dữ liệu mặc định cho các bản ghi cũ
UPDATE Categories SET IsActive = 1 WHERE IsActive IS NULL;


-- 2. Bảng Orders (Đơn hàng)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'PaymentMethod')
    ALTER TABLE Orders ADD PaymentMethod NVARCHAR(100) NULL;


-- 3. Bảng Services (Dịch vụ) - Bổ sung các trường thiếu
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


-- 4. Bảng Blogs
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'IsPublished')
    ALTER TABLE Blogs ADD IsPublished BIT DEFAULT 0;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'MetaTitle')
    ALTER TABLE Blogs ADD MetaTitle NVARCHAR(255) NULL;

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Blogs') AND name = 'MetaDescription')
    ALTER TABLE Blogs ADD MetaDescription NVARCHAR(500) NULL;

UPDATE Blogs SET IsPublished = 0 WHERE IsPublished IS NULL;


-- 5. Bảng Banners
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Banners') AND name = 'DisplayOrder')
    ALTER TABLE Banners ADD DisplayOrder INT DEFAULT 0;

UPDATE Banners SET DisplayOrder = 0 WHERE DisplayOrder IS NULL;


-- 6. Bảng ServiceBookings (Đặt lịch dịch vụ)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ServiceBookings') AND name = 'DepositAmount')
    ALTER TABLE ServiceBookings ADD 
        DepositAmount DECIMAL(18,2) DEFAULT 0, 
        DepositStatus NVARCHAR(50) DEFAULT 'Unpaid', 
        TransferProof NVARCHAR(500) NULL, 
        ConfirmedAt DATETIME NULL, 
        ExpireAt DATETIME NULL, 
        CancelReason NVARCHAR(500) NULL;


-- 7. Các bảng mới (Nếu chưa tồn tại)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceCategories')
    CREATE TABLE ServiceCategories (
        CategoryId INT IDENTITY PRIMARY KEY,
        CategoryName NVARCHAR(100) NOT NULL,
        Slug NVARCHAR(255),
        Icon NVARCHAR(50),
        IsActive BIT DEFAULT 1
    );

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderStatusHistory')
    CREATE TABLE OrderStatusHistory (
        HistoryId INT IDENTITY PRIMARY KEY, 
        OrderId INT NOT NULL, 
        Status NVARCHAR(100) NOT NULL, 
        ChangedDate DATETIME DEFAULT GETDATE(), 
        Note NVARCHAR(MAX) NULL
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

-- 8. Seed dữ liệu cho ServiceCategories
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ServiceCategories') AND NOT EXISTS (SELECT * FROM ServiceCategories)
BEGIN
    INSERT INTO ServiceCategories (CategoryName, Slug, Icon) VALUES 
    (N'Bảo dưỡng', 'bao-duong', 'bx-wrench'),
    (N'Phụ tùng', 'phu-tung', 'bx-cog'),
    (N'Độ xe', 'do-xe', 'bx-tachometer'),
    (N'Cứu hộ', 'cuu-ho', 'bx-unite'),
    (N'Rửa xe', 'rua-xe', 'bx-water');
END
