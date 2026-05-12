/* =========================================================================
   MOTOSHOP - SEED DATA (SQL Server)
   - 6 Categories x 3 Products = 18 products
   - 6 Brands x 3 Products    = mỗi thương hiệu đúng 3 SP
   - 29 ProductVariants
   - ProductImages + VariantImages (đường dẫn local /uploads/...)

   IDs dùng range an toàn để tránh conflict với DbSeeder:
     - Categories : 10-15  (DbSeeder đã dùng 1-9)
     - Brands     : 10-15  (DbSeeder đã dùng 1-9)
     - Products   : 101-118
     - Variants   : 101-129
     - Images     : 101-136
     - VarImages  : 101-158
     - Specs      : 101-123
     - Tags       : 101-113
     - Units      : 1-5    (DbSeeder không seed Units)

   THỨ TỰ CHẠY:
     1) Chạy python download_images.py để tải ảnh
     2) Copy thư mục uploads/ vào wwwroot/uploads/
     3) Chạy file SQL này trong SSMS
   ========================================================================= */

USE [MotorcycleShopDB];
GO

SET NOCOUNT ON;
GO

/* -------------------------------------------------------------------------
   1) UNITS - đơn vị tính (DbSeeder không seed, an toàn dùng ID 1-5)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM Units WHERE UnitId = 1)
BEGIN
    SET IDENTITY_INSERT Units ON;
    INSERT INTO Units (UnitId, UnitName, Symbol) VALUES
    (1, N'Lít',  N'L'),
    (2, N'Cái',  N'cái'),
    (3, N'Bộ',   N'bộ'),
    (4, N'Hộp',  N'hộp'),
    (5, N'Chai', N'chai');
    SET IDENTITY_INSERT Units OFF;
    PRINT N'[OK] Đã seed 5 Units';
END
ELSE PRINT N'[SKIP] Units đã tồn tại';
GO

/* -------------------------------------------------------------------------
   2) CATEGORIES - dùng ID 10-15 (DbSeeder đã chiếm 1-9)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryId = 10)
BEGIN
    SET IDENTITY_INSERT Categories ON;
    INSERT INTO Categories (CategoryId, CategoryName, Slug, ParentId, Description, ImageUrl, Icon, IsActive) VALUES
    (10, N'Nhớt & Dầu nhờn', N'nhot-dau-nhon-2', NULL, N'Các loại nhớt động cơ, dầu nhờn cao cấp cho xe máy',
        N'/uploads/categories/nhot-dau-nhon.jpg', N'fa-oil-can', 1),
    (11, N'Lốp xe (Michelin)', N'lop-xe-michelin', NULL, N'Lốp xe máy chính hãng Michelin, đa dạng kích cỡ',
        N'/uploads/categories/lop-xe.jpg', N'fa-circle-notch', 1),
    (12, N'Mũ bảo hiểm',     N'mu-bao-hiem',    NULL, N'Mũ bảo hiểm an toàn đạt chuẩn quốc tế',
        N'/uploads/categories/mu-bao-hiem.jpg', N'fa-hard-hat', 1),
    (13, N'Ắc quy',          N'ac-quy',         NULL, N'Ắc quy xe máy bền bỉ, khởi động khỏe',
        N'/uploads/categories/ac-quy.jpg', N'fa-car-battery', 1),
    (14, N'Phụ tùng máy',    N'phu-tung-may-2', NULL, N'Phụ tùng máy chính hãng cho xe máy',
        N'/uploads/categories/phu-tung-may.jpg', N'fa-cogs', 1),
    (15, N'Phụ kiện xe',     N'phu-kien-xe',    NULL, N'Phụ kiện trang trí và nâng cấp xe máy',
        N'/uploads/categories/phu-kien-xe.jpg', N'fa-motorcycle', 1);
    SET IDENTITY_INSERT Categories OFF;
    PRINT N'[OK] Đã seed 6 Categories (ID 10-15)';
END
ELSE PRINT N'[SKIP] Categories 10-15 đã tồn tại';
GO

/* -------------------------------------------------------------------------
   3) BRANDS - dùng ID 10-15 (DbSeeder đã chiếm 1-9)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM Brands WHERE BrandId = 10)
BEGIN
    SET IDENTITY_INSERT Brands ON;
    INSERT INTO Brands (BrandId, BrandName, LogoUrl, Description) VALUES
    (10, N'Honda',    N'/uploads/brands/honda.png',    N'Tập đoàn Honda - Nhật Bản, dẫn đầu công nghệ xe máy'),
    (11, N'Yamaha',   N'/uploads/brands/yamaha.png',   N'Yamaha Motor - Nhật Bản, thiết kế thể thao đẳng cấp'),
    (12, N'Castrol',  N'/uploads/brands/castrol.png',  N'Castrol - Anh Quốc, hãng dầu nhớt hàng đầu thế giới'),
    (13, N'Michelin', N'/uploads/brands/michelin.png', N'Michelin - Pháp, lốp xe chất lượng cao toàn cầu'),
    (14, N'Yuasa',    N'/uploads/brands/yuasa.png',    N'GS Yuasa - Nhật Bản, ắc quy bền bỉ số 1'),
    (15, N'AGV',      N'/uploads/brands/agv.png',      N'AGV - Ý, mũ bảo hiểm an toàn cho tay đua MotoGP');
    SET IDENTITY_INSERT Brands OFF;
    PRINT N'[OK] Đã seed 6 Brands (ID 10-15)';
END
ELSE PRINT N'[SKIP] Brands 10-15 đã tồn tại';
GO

/* -------------------------------------------------------------------------
   4) PRODUCTS - 18 sản phẩm (ID 101-118)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductId = 101)
BEGIN
    SET IDENTITY_INSERT Products ON;
    INSERT INTO Products (ProductId, CategoryId, BrandId, ProductName, Slug, Description, IsFeatured, IsActive, CreatedDate, IsDeleted, SoldCount) VALUES
    -- ===== NHỚT (Cat 10) - Castrol (Brand 12) =====
    (101, 10, 12, N'Nhớt Castrol POWER 1 4T 10W-40',
        N'nhot-castrol-power-1-4t-10w40',
        N'Nhớt tổng hợp cao cấp Castrol POWER 1 4T 10W-40 dành cho xe máy thể thao. Công nghệ Trizone giúp tăng tốc nhanh, bền bỉ động cơ.',
        1, 1, GETDATE(), 0, 156),
    (102, 10, 12, N'Nhớt Castrol ACTIV 4T 20W-40',
        N'nhot-castrol-activ-4t-20w40',
        N'Nhớt khoáng Castrol ACTIV 4T 20W-40 cho xe số phổ thông. Bảo vệ động cơ khỏi ăn mòn, kéo dài tuổi thọ máy.',
        0, 1, GETDATE(), 0, 89),
    (103, 10, 12, N'Nhớt Castrol MAGNATEC 4T 10W-40',
        N'nhot-castrol-magnatec-4t-10w40',
        N'Nhớt bán tổng hợp Castrol MAGNATEC với phân tử thông minh bám dính trên bề mặt máy, bảo vệ ngay từ lúc khởi động.',
        1, 1, GETDATE(), 0, 124),

    -- ===== LỐP XE (Cat 11) - Michelin (Brand 13) =====
    (104, 11, 13, N'Lốp Michelin City Grip 2 90/90-14',
        N'lop-michelin-city-grip-2-90-90-14',
        N'Lốp xe tay ga Michelin City Grip 2 kích thước 90/90-14, độ bám đường tốt trên cả mặt đường ướt và khô.',
        1, 1, GETDATE(), 0, 67),
    (105, 11, 13, N'Lốp Michelin Pilot Street 2 100/80-17',
        N'lop-michelin-pilot-street-2-100-80-17',
        N'Lốp Michelin Pilot Street 2 cho xe côn tay 100/80-17, hiệu suất cao trong điều kiện đường phố Việt Nam.',
        1, 1, GETDATE(), 0, 45),
    (106, 11, 13, N'Lốp Michelin Power Pure SC 120/70-12',
        N'lop-michelin-power-pure-sc-120-70-12',
        N'Lốp thể thao Michelin Power Pure SC dành cho xe tay ga thể thao 120/70-12.',
        0, 1, GETDATE(), 0, 23),

    -- ===== MŨ BẢO HIỂM (Cat 12) - AGV (Brand 15) =====
    (107, 12, 15, N'Mũ bảo hiểm AGV K1 S Solid',
        N'mu-bao-hiem-agv-k1-s-solid',
        N'Mũ bảo hiểm fullface AGV K1 S, vỏ composite siêu nhẹ, đệm thoáng khí, chuẩn ECE 22.06.',
        1, 1, GETDATE(), 0, 78),
    (108, 12, 15, N'Mũ bảo hiểm AGV K3 SV Rossi',
        N'mu-bao-hiem-agv-k3-sv-rossi',
        N'Mũ AGV K3 SV phiên bản đặc biệt, kính chống tia UV, hệ thống thông gió 5 vị trí.',
        1, 1, GETDATE(), 0, 92),
    (109, 12, 15, N'Mũ bảo hiểm AGV Pista GP RR',
        N'mu-bao-hiem-agv-pista-gp-rr',
        N'Mũ bảo hiểm cao cấp AGV Pista GP RR, vỏ sợi carbon 100%, dùng trong giải MotoGP chuyên nghiệp.',
        1, 1, GETDATE(), 0, 12),

    -- ===== ẮC QUY (Cat 13) - Yuasa (Brand 14) =====
    (110, 13, 14, N'Ắc quy Yuasa YTX7A-BS 12V-7Ah',
        N'ac-quy-yuasa-ytx7a-bs-12v-7ah',
        N'Ắc quy khô Yuasa YTX7A-BS, dung lượng 12V-7Ah, dùng cho Air Blade, Vario, Lead, SH Mode.',
        1, 1, GETDATE(), 0, 234),
    (111, 13, 14, N'Ắc quy Yuasa YB9-B 12V-9Ah',
        N'ac-quy-yuasa-yb9-b-12v-9ah',
        N'Ắc quy nước Yuasa YB9-B 12V-9Ah cho xe côn tay, độ bền cao, khởi động khỏe.',
        0, 1, GETDATE(), 0, 167),
    (112, 13, 14, N'Ắc quy Yuasa YTZ10S 12V-8.6Ah',
        N'ac-quy-yuasa-ytz10s-12v-8-6ah',
        N'Ắc quy Yuasa YTZ10S công nghệ AGM, dung lượng 8.6Ah, không cần bảo dưỡng.',
        1, 1, GETDATE(), 0, 89),

    -- ===== PHỤ TÙNG MÁY (Cat 14) - Honda x2 + Yamaha x1 =====
    (113, 14, 10, N'Bộ nhông xích Honda Wave Alpha',
        N'bo-nhong-xich-honda-wave-alpha',
        N'Bộ nhông xích chính hãng Honda Wave Alpha, gồm nhông trước, nhông sau và xích DID.',
        0, 1, GETDATE(), 0, 134),
    (114, 14, 10, N'Bố thắng đĩa Honda CBR150R',
        N'bo-thang-dia-honda-cbr150r',
        N'Bộ má phanh đĩa chính hãng Honda CBR150R, ma sát cao, êm và bền.',
        1, 1, GETDATE(), 0, 78),
    (115, 14, 11, N'Lọc gió Yamaha Exciter 150',
        N'loc-gio-yamaha-exciter-150',
        N'Lọc gió chính hãng Yamaha cho Exciter 150, lọc bụi mịn, tăng hiệu suất máy.',
        0, 1, GETDATE(), 0, 201),

    -- ===== PHỤ KIỆN XE (Cat 15) - Honda x1 + Yamaha x2 =====
    (116, 15, 10, N'Gương chiếu hậu Honda Vario 150',
        N'guong-chieu-hau-honda-vario-150',
        N'Cặp gương chiếu hậu chính hãng Honda Vario 150, kiểu dáng thể thao, chống chói.',
        1, 1, GETDATE(), 0, 56),
    (117, 15, 11, N'Bao tay Yamaha Exciter 155 VVA',
        N'bao-tay-yamaha-exciter-155-vva',
        N'Bao tay cao su chống trượt cho Yamaha Exciter 155 VVA, ôm sát, êm tay.',
        0, 1, GETDATE(), 0, 145),
    (118, 15, 11, N'Đèn LED trợ sáng Yamaha 30W',
        N'den-led-tro-sang-yamaha-30w',
        N'Đèn LED trợ sáng cho Yamaha công suất 30W, ánh sáng trắng/vàng, chống nước IP67.',
        1, 1, GETDATE(), 0, 98);
    SET IDENTITY_INSERT Products OFF;
    PRINT N'[OK] Đã seed 18 Products (ID 101-118)';
END
ELSE PRINT N'[SKIP] Products 101-118 đã tồn tại';
GO

/* -------------------------------------------------------------------------
   5) PRODUCT VARIANTS - 29 biến thể (ID 101-129)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM ProductVariants WHERE ProductVariantId = 101)
BEGIN
    SET IDENTITY_INSERT ProductVariants ON;
    INSERT INTO ProductVariants (ProductVariantId, ProductId, BaseUnitId, SKU, VariantName, Price, OriginalPrice, CostPrice, StockQuantity, ImageUrl, CreatedDate, MinStockLevel) VALUES
    -- P101 Castrol POWER 1 (2 variants)
    (101, 101, 5, N'NHOT-CASTROL-POWER1-1L',  N'1 Lít',   180000, 200000, 130000, 50,  N'/uploads/variants/nhot-castrol-power1-1l-1.jpg',  GETDATE(), 10),
    (102, 101, 5, N'NHOT-CASTROL-POWER1-08L', N'0.8 Lít', 150000, 170000, 110000, 60,  N'/uploads/variants/nhot-castrol-power1-08l-1.jpg', GETDATE(), 10),

    -- P102 Castrol ACTIV (2 variants)
    (103, 102, 5, N'NHOT-CASTROL-ACTIV-1L',   N'1 Lít',   95000,  110000, 70000,  80,  N'/uploads/variants/nhot-castrol-activ-1l-1.jpg',   GETDATE(), 15),
    (104, 102, 5, N'NHOT-CASTROL-ACTIV-08L',  N'0.8 Lít', 80000,  90000,  60000,  90,  N'/uploads/variants/nhot-castrol-activ-08l-1.jpg',  GETDATE(), 15),

    -- P103 Castrol MAGNATEC (2 variants)
    (105, 103, 5, N'NHOT-CASTROL-MAG-1L',     N'1 Lít',   220000, 240000, 165000, 40,  N'/uploads/variants/nhot-castrol-mag-1l-1.jpg',     GETDATE(), 10),
    (106, 103, 5, N'NHOT-CASTROL-MAG-08L',    N'0.8 Lít', 185000, 200000, 140000, 45,  N'/uploads/variants/nhot-castrol-mag-08l-1.jpg',    GETDATE(), 10),

    -- P104 Michelin City Grip 2 (1 variant)
    (107, 104, 2, N'LOP-MICH-CG2-90-90-14',   N'90/90-14',  750000,  850000,  580000, 25, N'/uploads/variants/lop-mich-cg2-90-90-14-1.jpg',  GETDATE(), 5),

    -- P105 Michelin Pilot Street 2 (1 variant)
    (108, 105, 2, N'LOP-MICH-PS2-100-80-17',  N'100/80-17', 980000,  1100000, 750000, 18, N'/uploads/variants/lop-mich-ps2-100-80-17-1.jpg', GETDATE(), 5),

    -- P106 Michelin Power Pure SC (1 variant)
    (109, 106, 2, N'LOP-MICH-PP-120-70-12',   N'120/70-12', 1250000, 1400000, 950000, 12, N'/uploads/variants/lop-mich-pp-120-70-12-1.jpg',  GETDATE(), 3),

    -- P107 AGV K1 S (3 variants)
    (110, 107, 2, N'MU-AGV-K1S-M',  N'Size M',  4500000, 5000000, 3200000, 8,  N'/uploads/variants/mu-agv-k1s-m-1.jpg',  GETDATE(), 2),
    (111, 107, 2, N'MU-AGV-K1S-L',  N'Size L',  4500000, 5000000, 3200000, 12, N'/uploads/variants/mu-agv-k1s-l-1.jpg',  GETDATE(), 2),
    (112, 107, 2, N'MU-AGV-K1S-XL', N'Size XL', 4500000, 5000000, 3200000, 6,  N'/uploads/variants/mu-agv-k1s-xl-1.jpg', GETDATE(), 2),

    -- P108 AGV K3 SV (3 variants)
    (113, 108, 2, N'MU-AGV-K3SV-M',  N'Size M',  6800000, 7500000, 5000000, 5,  N'/uploads/variants/mu-agv-k3sv-m-1.jpg',  GETDATE(), 2),
    (114, 108, 2, N'MU-AGV-K3SV-L',  N'Size L',  6800000, 7500000, 5000000, 9,  N'/uploads/variants/mu-agv-k3sv-l-1.jpg',  GETDATE(), 2),
    (115, 108, 2, N'MU-AGV-K3SV-XL', N'Size XL', 6800000, 7500000, 5000000, 4,  N'/uploads/variants/mu-agv-k3sv-xl-1.jpg', GETDATE(), 2),

    -- P109 AGV Pista GP RR (2 variants)
    (116, 109, 2, N'MU-AGV-PISTA-L',  N'Size L',  35000000, 38000000, 26000000, 3, N'/uploads/variants/mu-agv-pista-l-1.jpg',  GETDATE(), 1),
    (117, 109, 2, N'MU-AGV-PISTA-XL', N'Size XL', 35000000, 38000000, 26000000, 2, N'/uploads/variants/mu-agv-pista-xl-1.jpg', GETDATE(), 1),

    -- P110 Yuasa YTX7A-BS (1 variant)
    (118, 110, 2, N'ACQUY-YUASA-YTX7A',  N'12V-7Ah',      480000, 550000, 350000, 35, N'/uploads/variants/acquy-yuasa-ytx7a-1.jpg',  GETDATE(), 8),

    -- P111 Yuasa YB9-B (1 variant)
    (119, 111, 2, N'ACQUY-YUASA-YB9B',   N'12V-9Ah',      520000, 580000, 380000, 28, N'/uploads/variants/acquy-yuasa-yb9b-1.jpg',   GETDATE(), 6),

    -- P112 Yuasa YTZ10S (1 variant)
    (120, 112, 2, N'ACQUY-YUASA-YTZ10S', N'12V-8.6Ah AGM',850000, 950000, 620000, 18, N'/uploads/variants/acquy-yuasa-ytz10s-1.jpg', GETDATE(), 5),

    -- P113 Bộ nhông xích Honda Wave (1 variant)
    (121, 113, 3, N'PT-HONDA-NHONG-WAVE',    N'Bộ tiêu chuẩn', 380000, 450000, 280000, 25, N'/uploads/variants/pt-honda-nhong-wave-1.jpg',    GETDATE(), 5),

    -- P114 Bố thắng đĩa Honda CBR (1 variant)
    (122, 114, 2, N'PT-HONDA-BO-CBR150',     N'Trước/Sau',     220000, 260000, 160000, 40, N'/uploads/variants/pt-honda-bo-cbr150-1.jpg',     GETDATE(), 8),

    -- P115 Lọc gió Yamaha Exciter (1 variant)
    (123, 115, 2, N'PT-YAMAHA-LOCGIO-EX150', N'Tiêu chuẩn',    85000,  100000, 60000,  60, N'/uploads/variants/pt-yamaha-locgio-ex150-1.jpg', GETDATE(), 12),

    -- P116 Gương Honda Vario (2 variants)
    (124, 116, 3, N'PK-HONDA-GUONG-VARIO-DEN', N'Màu Đen', 280000, 320000, 200000, 30, N'/uploads/variants/pk-honda-guong-vario-den-1.jpg', GETDATE(), 6),
    (125, 116, 3, N'PK-HONDA-GUONG-VARIO-BAC', N'Màu Bạc', 280000, 320000, 200000, 22, N'/uploads/variants/pk-honda-guong-vario-bac-1.jpg', GETDATE(), 6),

    -- P117 Bao tay Yamaha Exciter (2 variants)
    (126, 117, 2, N'PK-YAMAHA-BAOTAY-EX-DEN', N'Màu Đen', 120000, 140000, 85000, 55, N'/uploads/variants/pk-yamaha-baotay-ex-den-1.jpg', GETDATE(), 10),
    (127, 117, 2, N'PK-YAMAHA-BAOTAY-EX-DO',  N'Màu Đỏ',  120000, 140000, 85000, 48, N'/uploads/variants/pk-yamaha-baotay-ex-do-1.jpg',  GETDATE(), 10),

    -- P118 Đèn LED Yamaha (2 variants)
    (128, 118, 2, N'PK-YAMAHA-LED-30W-TRANG', N'Ánh sáng Trắng', 350000, 420000, 250000, 35, N'/uploads/variants/pk-yamaha-led-30w-trang-1.jpg', GETDATE(), 8),
    (129, 118, 2, N'PK-YAMAHA-LED-30W-VANG',  N'Ánh sáng Vàng',  350000, 420000, 250000, 28, N'/uploads/variants/pk-yamaha-led-30w-vang-1.jpg',  GETDATE(), 8);
    SET IDENTITY_INSERT ProductVariants OFF;
    PRINT N'[OK] Đã seed 29 ProductVariants (ID 101-129)';
END
ELSE PRINT N'[SKIP] ProductVariants 101-129 đã tồn tại';
GO

/* -------------------------------------------------------------------------
   6) PRODUCT IMAGES - 2 ảnh / sản phẩm (ID 101-136)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM ProductImages WHERE ImageId = 101)
BEGIN
    SET IDENTITY_INSERT ProductImages ON;
    INSERT INTO ProductImages (ImageId, ProductId, ImageUrl, IsPrimary, DisplayOrder, MediaType, VideoUrl) VALUES
    (101, 101, N'/uploads/products/nhot-castrol-power-1-4t-10w40-1.jpg', 1, 1, N'image', NULL),
    (102, 101, N'/uploads/products/nhot-castrol-power-1-4t-10w40-2.jpg', 0, 2, N'image', NULL),
    (103, 102, N'/uploads/products/nhot-castrol-activ-4t-20w40-1.jpg',   1, 1, N'image', NULL),
    (104, 102, N'/uploads/products/nhot-castrol-activ-4t-20w40-2.jpg',   0, 2, N'image', NULL),
    (105, 103, N'/uploads/products/nhot-castrol-magnatec-4t-10w40-1.jpg', 1, 1, N'image', NULL),
    (106, 103, N'/uploads/products/nhot-castrol-magnatec-4t-10w40-2.jpg', 0, 2, N'image', NULL),
    (107, 104, N'/uploads/products/lop-michelin-city-grip-2-90-90-14-1.jpg', 1, 1, N'image', NULL),
    (108, 104, N'/uploads/products/lop-michelin-city-grip-2-90-90-14-2.jpg', 0, 2, N'image', NULL),
    (109, 105, N'/uploads/products/lop-michelin-pilot-street-2-100-80-17-1.jpg', 1, 1, N'image', NULL),
    (110, 105, N'/uploads/products/lop-michelin-pilot-street-2-100-80-17-2.jpg', 0, 2, N'image', NULL),
    (111, 106, N'/uploads/products/lop-michelin-power-pure-sc-120-70-12-1.jpg', 1, 1, N'image', NULL),
    (112, 106, N'/uploads/products/lop-michelin-power-pure-sc-120-70-12-2.jpg', 0, 2, N'image', NULL),
    (113, 107, N'/uploads/products/mu-bao-hiem-agv-k1-s-solid-1.jpg', 1, 1, N'image', NULL),
    (114, 107, N'/uploads/products/mu-bao-hiem-agv-k1-s-solid-2.jpg', 0, 2, N'image', NULL),
    (115, 108, N'/uploads/products/mu-bao-hiem-agv-k3-sv-rossi-1.jpg', 1, 1, N'image', NULL),
    (116, 108, N'/uploads/products/mu-bao-hiem-agv-k3-sv-rossi-2.jpg', 0, 2, N'image', NULL),
    (117, 109, N'/uploads/products/mu-bao-hiem-agv-pista-gp-rr-1.jpg', 1, 1, N'image', NULL),
    (118, 109, N'/uploads/products/mu-bao-hiem-agv-pista-gp-rr-2.jpg', 0, 2, N'image', NULL),
    (119, 110, N'/uploads/products/ac-quy-yuasa-ytx7a-bs-12v-7ah-1.jpg', 1, 1, N'image', NULL),
    (120, 110, N'/uploads/products/ac-quy-yuasa-ytx7a-bs-12v-7ah-2.jpg', 0, 2, N'image', NULL),
    (121, 111, N'/uploads/products/ac-quy-yuasa-yb9-b-12v-9ah-1.jpg', 1, 1, N'image', NULL),
    (122, 111, N'/uploads/products/ac-quy-yuasa-yb9-b-12v-9ah-2.jpg', 0, 2, N'image', NULL),
    (123, 112, N'/uploads/products/ac-quy-yuasa-ytz10s-12v-8-6ah-1.jpg', 1, 1, N'image', NULL),
    (124, 112, N'/uploads/products/ac-quy-yuasa-ytz10s-12v-8-6ah-2.jpg', 0, 2, N'image', NULL),
    (125, 113, N'/uploads/products/bo-nhong-xich-honda-wave-alpha-1.jpg', 1, 1, N'image', NULL),
    (126, 113, N'/uploads/products/bo-nhong-xich-honda-wave-alpha-2.jpg', 0, 2, N'image', NULL),
    (127, 114, N'/uploads/products/bo-thang-dia-honda-cbr150r-1.jpg', 1, 1, N'image', NULL),
    (128, 114, N'/uploads/products/bo-thang-dia-honda-cbr150r-2.jpg', 0, 2, N'image', NULL),
    (129, 115, N'/uploads/products/loc-gio-yamaha-exciter-150-1.jpg', 1, 1, N'image', NULL),
    (130, 115, N'/uploads/products/loc-gio-yamaha-exciter-150-2.jpg', 0, 2, N'image', NULL),
    (131, 116, N'/uploads/products/guong-chieu-hau-honda-vario-150-1.jpg', 1, 1, N'image', NULL),
    (132, 116, N'/uploads/products/guong-chieu-hau-honda-vario-150-2.jpg', 0, 2, N'image', NULL),
    (133, 117, N'/uploads/products/bao-tay-yamaha-exciter-155-vva-1.jpg', 1, 1, N'image', NULL),
    (134, 117, N'/uploads/products/bao-tay-yamaha-exciter-155-vva-2.jpg', 0, 2, N'image', NULL),
    (135, 118, N'/uploads/products/den-led-tro-sang-yamaha-30w-1.jpg', 1, 1, N'image', NULL),
    (136, 118, N'/uploads/products/den-led-tro-sang-yamaha-30w-2.jpg', 0, 2, N'image', NULL);
    SET IDENTITY_INSERT ProductImages OFF;
    PRINT N'[OK] Đã seed 36 ProductImages (ID 101-136)';
END
ELSE PRINT N'[SKIP] ProductImages 101-136 đã tồn tại';
GO

/* -------------------------------------------------------------------------
   7) VARIANT IMAGES - 2 ảnh / biến thể (ID 101-158)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM VariantImages WHERE VariantImageId = 101)
BEGIN
    SET IDENTITY_INSERT VariantImages ON;
    INSERT INTO VariantImages (VariantImageId, ProductVariantId, ImageUrl, IsPrimary, DisplayOrder) VALUES
    (101, 101, N'/uploads/variants/nhot-castrol-power1-1l-1.jpg',  1, 1),
    (102, 101, N'/uploads/variants/nhot-castrol-power1-1l-2.jpg',  0, 2),
    (103, 102, N'/uploads/variants/nhot-castrol-power1-08l-1.jpg', 1, 1),
    (104, 102, N'/uploads/variants/nhot-castrol-power1-08l-2.jpg', 0, 2),
    (105, 103, N'/uploads/variants/nhot-castrol-activ-1l-1.jpg',   1, 1),
    (106, 103, N'/uploads/variants/nhot-castrol-activ-1l-2.jpg',   0, 2),
    (107, 104, N'/uploads/variants/nhot-castrol-activ-08l-1.jpg',  1, 1),
    (108, 104, N'/uploads/variants/nhot-castrol-activ-08l-2.jpg',  0, 2),
    (109, 105, N'/uploads/variants/nhot-castrol-mag-1l-1.jpg',     1, 1),
    (110, 105, N'/uploads/variants/nhot-castrol-mag-1l-2.jpg',     0, 2),
    (111, 106, N'/uploads/variants/nhot-castrol-mag-08l-1.jpg',    1, 1),
    (112, 106, N'/uploads/variants/nhot-castrol-mag-08l-2.jpg',    0, 2),
    (113, 107, N'/uploads/variants/lop-mich-cg2-90-90-14-1.jpg',   1, 1),
    (114, 107, N'/uploads/variants/lop-mich-cg2-90-90-14-2.jpg',   0, 2),
    (115, 108, N'/uploads/variants/lop-mich-ps2-100-80-17-1.jpg',  1, 1),
    (116, 108, N'/uploads/variants/lop-mich-ps2-100-80-17-2.jpg',  0, 2),
    (117, 109, N'/uploads/variants/lop-mich-pp-120-70-12-1.jpg',   1, 1),
    (118, 109, N'/uploads/variants/lop-mich-pp-120-70-12-2.jpg',   0, 2),
    (119, 110, N'/uploads/variants/mu-agv-k1s-m-1.jpg',  1, 1),
    (120, 110, N'/uploads/variants/mu-agv-k1s-m-2.jpg',  0, 2),
    (121, 111, N'/uploads/variants/mu-agv-k1s-l-1.jpg',  1, 1),
    (122, 111, N'/uploads/variants/mu-agv-k1s-l-2.jpg',  0, 2),
    (123, 112, N'/uploads/variants/mu-agv-k1s-xl-1.jpg', 1, 1),
    (124, 112, N'/uploads/variants/mu-agv-k1s-xl-2.jpg', 0, 2),
    (125, 113, N'/uploads/variants/mu-agv-k3sv-m-1.jpg',  1, 1),
    (126, 113, N'/uploads/variants/mu-agv-k3sv-m-2.jpg',  0, 2),
    (127, 114, N'/uploads/variants/mu-agv-k3sv-l-1.jpg',  1, 1),
    (128, 114, N'/uploads/variants/mu-agv-k3sv-l-2.jpg',  0, 2),
    (129, 115, N'/uploads/variants/mu-agv-k3sv-xl-1.jpg', 1, 1),
    (130, 115, N'/uploads/variants/mu-agv-k3sv-xl-2.jpg', 0, 2),
    (131, 116, N'/uploads/variants/mu-agv-pista-l-1.jpg',  1, 1),
    (132, 116, N'/uploads/variants/mu-agv-pista-l-2.jpg',  0, 2),
    (133, 117, N'/uploads/variants/mu-agv-pista-xl-1.jpg', 1, 1),
    (134, 117, N'/uploads/variants/mu-agv-pista-xl-2.jpg', 0, 2),
    (135, 118, N'/uploads/variants/acquy-yuasa-ytx7a-1.jpg',  1, 1),
    (136, 118, N'/uploads/variants/acquy-yuasa-ytx7a-2.jpg',  0, 2),
    (137, 119, N'/uploads/variants/acquy-yuasa-yb9b-1.jpg',   1, 1),
    (138, 119, N'/uploads/variants/acquy-yuasa-yb9b-2.jpg',   0, 2),
    (139, 120, N'/uploads/variants/acquy-yuasa-ytz10s-1.jpg', 1, 1),
    (140, 120, N'/uploads/variants/acquy-yuasa-ytz10s-2.jpg', 0, 2),
    (141, 121, N'/uploads/variants/pt-honda-nhong-wave-1.jpg',    1, 1),
    (142, 121, N'/uploads/variants/pt-honda-nhong-wave-2.jpg',    0, 2),
    (143, 122, N'/uploads/variants/pt-honda-bo-cbr150-1.jpg',     1, 1),
    (144, 122, N'/uploads/variants/pt-honda-bo-cbr150-2.jpg',     0, 2),
    (145, 123, N'/uploads/variants/pt-yamaha-locgio-ex150-1.jpg', 1, 1),
    (146, 123, N'/uploads/variants/pt-yamaha-locgio-ex150-2.jpg', 0, 2),
    (147, 124, N'/uploads/variants/pk-honda-guong-vario-den-1.jpg', 1, 1),
    (148, 124, N'/uploads/variants/pk-honda-guong-vario-den-2.jpg', 0, 2),
    (149, 125, N'/uploads/variants/pk-honda-guong-vario-bac-1.jpg', 1, 1),
    (150, 125, N'/uploads/variants/pk-honda-guong-vario-bac-2.jpg', 0, 2),
    (151, 126, N'/uploads/variants/pk-yamaha-baotay-ex-den-1.jpg',  1, 1),
    (152, 126, N'/uploads/variants/pk-yamaha-baotay-ex-den-2.jpg',  0, 2),
    (153, 127, N'/uploads/variants/pk-yamaha-baotay-ex-do-1.jpg',   1, 1),
    (154, 127, N'/uploads/variants/pk-yamaha-baotay-ex-do-2.jpg',   0, 2),
    (155, 128, N'/uploads/variants/pk-yamaha-led-30w-trang-1.jpg',  1, 1),
    (156, 128, N'/uploads/variants/pk-yamaha-led-30w-trang-2.jpg',  0, 2),
    (157, 129, N'/uploads/variants/pk-yamaha-led-30w-vang-1.jpg',   1, 1),
    (158, 129, N'/uploads/variants/pk-yamaha-led-30w-vang-2.jpg',   0, 2);
    SET IDENTITY_INSERT VariantImages OFF;
    PRINT N'[OK] Đã seed 58 VariantImages (ID 101-158)';
END
ELSE PRINT N'[SKIP] VariantImages 101-158 đã tồn tại';
GO

/* -------------------------------------------------------------------------
   8) PRODUCT SPECIFICATIONS (ID 101-123)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM ProductSpecifications WHERE SpecId = 101)
BEGIN
    SET IDENTITY_INSERT ProductSpecifications ON;
    INSERT INTO ProductSpecifications (SpecId, ProductId, SpecName, SpecValue, DisplayOrder) VALUES
    (101, 101, N'Loại nhớt',  N'Tổng hợp toàn phần', 1),
    (102, 101, N'Độ nhớt',    N'10W-40',             2),
    (103, 101, N'Tiêu chuẩn', N'API SN, JASO MA2',   3),
    (104, 102, N'Loại nhớt',  N'Khoáng',             1),
    (105, 102, N'Độ nhớt',    N'20W-40',             2),
    (106, 103, N'Loại nhớt',  N'Bán tổng hợp',       1),
    (107, 103, N'Độ nhớt',    N'10W-40',             2),
    (108, 104, N'Kích cỡ',    N'90/90-14',           1),
    (109, 104, N'Loại',       N'Không ruột',         2),
    (110, 105, N'Kích cỡ',    N'100/80-17',          1),
    (111, 106, N'Kích cỡ',    N'120/70-12',          1),
    (112, 107, N'Chuẩn an toàn', N'ECE 22.06',  1),
    (113, 107, N'Vật liệu vỏ',   N'Composite',  2),
    (114, 108, N'Chuẩn an toàn', N'ECE 22.06',  1),
    (115, 109, N'Vật liệu vỏ',   N'Sợi Carbon', 1),
    (116, 110, N'Điện áp',    N'12V',      1),
    (117, 110, N'Dung lượng', N'7Ah',      2),
    (118, 110, N'Loại',       N'Khô (MF)', 3),
    (119, 111, N'Điện áp',    N'12V',      1),
    (120, 111, N'Dung lượng', N'9Ah',      2),
    (121, 112, N'Điện áp',    N'12V',      1),
    (122, 112, N'Dung lượng', N'8.6Ah',    2),
    (123, 112, N'Công nghệ',  N'AGM',      3);
    SET IDENTITY_INSERT ProductSpecifications OFF;
    PRINT N'[OK] Đã seed 23 ProductSpecifications (ID 101-123)';
END
ELSE PRINT N'[SKIP] ProductSpecifications 101-123 đã tồn tại';
GO

/* -------------------------------------------------------------------------
   9) PRODUCT TAGS (ID 101-113)
   ------------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM ProductTags WHERE TagId = 101)
BEGIN
    SET IDENTITY_INSERT ProductTags ON;
    INSERT INTO ProductTags (TagId, ProductId, TagName) VALUES
    (101, 101, N'nhớt cao cấp'),
    (102, 101, N'tổng hợp'),
    (103, 102, N'nhớt phổ thông'),
    (104, 103, N'magnatec'),
    (105, 104, N'lốp tay ga'),
    (106, 105, N'lốp côn tay'),
    (107, 107, N'mũ fullface'),
    (108, 109, N'mũ carbon'),
    (109, 110, N'ắc quy khô'),
    (110, 112, N'ắc quy AGM'),
    (111, 113, N'phụ tùng Wave'),
    (112, 116, N'gương Vario'),
    (113, 118, N'đèn LED');
    SET IDENTITY_INSERT ProductTags OFF;
    PRINT N'[OK] Đã seed 13 ProductTags (ID 101-113)';
END
ELSE PRINT N'[SKIP] ProductTags 101-113 đã tồn tại';
GO

PRINT N'';
PRINT N'====================================================';
PRINT N'  SEED DATA HOÀN TẤT';
PRINT N'  - 5 đơn vị tính (ID 1-5)';
PRINT N'  - 6 danh mục    (ID 10-15)';
PRINT N'  - 6 thương hiệu (ID 10-15)';
PRINT N'  - 18 sản phẩm   (ID 101-118)';
PRINT N'  - 29 biến thể   (ID 101-129)';
PRINT N'  - 36 ảnh SP + 58 ảnh biến thể';
PRINT N'  Script có thể chạy lại nhiều lần (idempotent).';
PRINT N'====================================================';
GO
