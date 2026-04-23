USE [MotorcycleShopDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 1. Tắt tất cả Foreign Keys
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- 2. Xóa toàn bộ dữ liệu
DELETE FROM [dbo].[ServiceComboItems];
DELETE FROM [dbo].[ServiceCombos];
DELETE FROM [dbo].[OrderItems];
DELETE FROM [dbo].[Orders];
DELETE FROM [dbo].[Payments];
DELETE FROM [dbo].[OrderStatusHistories];
DELETE FROM [dbo].[ServiceBookings];
DELETE FROM [dbo].[Services];
DELETE FROM [dbo].[InventoryTransactions];
DELETE FROM [dbo].[ProductReviews];
DELETE FROM [dbo].[PromotionProducts];
DELETE FROM [dbo].[Promotions];
DELETE FROM [dbo].[ProductImages];
DELETE FROM [dbo].[ProductVariantAttributeValue];
DELETE FROM [dbo].[ProductVariants];
DELETE FROM [dbo].[Products];
DELETE FROM [dbo].[Categories];
DELETE FROM [dbo].[Brands];
DELETE FROM [dbo].[AttributeValues];
DELETE FROM [dbo].[ProductAttributes];
DELETE FROM [dbo].[Units];
DELETE FROM [dbo].[Staffs];
DELETE FROM [dbo].[CustomerAddresses];
DELETE FROM [dbo].[Customers];
DELETE FROM [dbo].[Stores];
DELETE FROM [dbo].[WishlistItems];
DELETE FROM [dbo].[Wishlists];
DELETE FROM [dbo].[CartItems];
DELETE FROM [dbo].[Carts];
DELETE FROM [dbo].[Blogs];
DELETE FROM [dbo].[BlogCategories];
DELETE FROM [dbo].[Banners];
DELETE FROM [dbo].[Sliders];
DELETE FROM [dbo].[Coupons];
DELETE FROM [dbo].[ShippingMethods];

DELETE FROM [dbo].[AspNetUserRoles];
DELETE FROM [dbo].[AspNetUsers];
DELETE FROM [dbo].[AspNetRoles];

-- 3. Reset IDENTITY về 1
EXEC sp_MSforeachtable "IF OBJECTPROPERTY(OBJECT_ID('?'), 'TableHasIdentity') = 1 DBCC CHECKIDENT ('?', RESEED, 0)"

-- 4. Bật lại Foreign Keys
EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

-- 5. Nạp dữ liệu
-- AspNetRoles
INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName]) VALUES ('r1', 'Admin', 'ADMIN');
INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName]) VALUES ('r2', 'Staff', 'STAFF');
INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName]) VALUES ('r3', 'Customer', 'CUSTOMER');

-- AspNetUsers
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u1', 'admin', 'admin@motoshop.vn', 1, 0, 0, 1, 0);
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u2', 'staff', 'staff@motoshop.vn', 1, 0, 0, 1, 0);
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u3', 'customer', 'customer@gmail.com', 1, 0, 0, 1, 0);

-- AspNetUserRoles
INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u1', 'r1');
INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u2', 'r2');
INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u3', 'r3');

-- Stores
SET IDENTITY_INSERT [dbo].[Stores] ON;
INSERT INTO [dbo].[Stores] ([StoreId], [StoreName], [Address], [Phone]) VALUES (1, N'MotoShop Quận 1', N'123 Lý Tự Trọng, Q1, TP.HCM', '028 1111 2222');
INSERT INTO [dbo].[Stores] ([StoreId], [StoreName], [Address], [Phone]) VALUES (2, N'MotoShop Quận 7', N'456 Nguyễn Thị Thập, Q7, TP.HCM', '028 3333 4444');
SET IDENTITY_INSERT [dbo].[Stores] OFF;

-- Staffs
SET IDENTITY_INSERT [dbo].[Staffs] ON;
INSERT INTO [dbo].[Staffs] ([StaffId], [UserId], [StoreId], [StaffCode], [Position], [CreatedDate]) VALUES (1, 'u2', 1, 'STF001', N'Kỹ thuật viên trưởng', GETDATE());
SET IDENTITY_INSERT [dbo].[Staffs] OFF;

-- Customers
SET IDENTITY_INSERT [dbo].[Customers] ON;
INSERT INTO [dbo].[Customers] ([CustomerId], [UserId], [FullName], [Phone], [Address], [CreatedDate], [IsLocked], [AvatarUrl]) VALUES (1, 'u3', N'Nguyễn Văn An', '0901234567', N'789 Phan Xích Long, Phú Nhuận', GETDATE(), 0, 'https://demos.themeselection.com/sneat-bootstrap-html-admin-template/assets/img/avatars/1.png');
SET IDENTITY_INSERT [dbo].[Customers] OFF;

-- Brands
SET IDENTITY_INSERT [dbo].[Brands] ON;
INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (1, 'Honda', 'honda.svg');
INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (2, 'Yamaha', 'yamaha.svg');
INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (3, 'Motul', 'motul.svg');
INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (4, 'Michelin', 'michelin.svg');
INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (5, 'GS', 'gs.svg');
SET IDENTITY_INSERT [dbo].[Brands] OFF;

-- Categories
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (1, N'Dầu nhớt', 'dau-nhot');
INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (2, N'Lốp xe máy', 'lop-xe-may');
INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (3, N'Ắc quy', 'ac-quy');
INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (4, N'Hệ thống phanh', 'phanh');
INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (5, N'Nhông sên dĩa', 'nhong-sen-dia');
SET IDENTITY_INSERT [dbo].[Categories] OFF;

-- Units
SET IDENTITY_INSERT [dbo].[Units] ON;
INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES (1, N'Lon', 'L');
INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES (2, N'Cái', 'C');
INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES (3, N'Bộ', 'B');
SET IDENTITY_INSERT [dbo].[Units] OFF;

-- Products
SET IDENTITY_INSERT [dbo].[Products] ON;
INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive], [IsDeleted], [CreatedDate]) VALUES (1, 1, 3, N'Motul 300V 10W40', 'motul-300v-10w40', N'Nhớt tổng hợp cao cấp.', 1, 1, 0, GETDATE());
INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive], [IsDeleted], [CreatedDate]) VALUES (2, 2, 4, N'Michelin Pilot Street 2', 'michelin-pilot-street-2', N'Lốp bám đường cực tốt.', 1, 1, 0, GETDATE());
INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive], [IsDeleted], [CreatedDate]) VALUES (3, 3, 5, N'Ắc quy GS GTZ6V', 'gs-gtz6v', N'Bình khô cho xe ga.', 0, 1, 0, GETDATE());
INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive], [IsDeleted], [CreatedDate]) VALUES (4, 4, 1, N'Má phanh Honda Winner', 'ma-phanh-honda', N'Hàng chính hãng Honda.', 0, 1, 0, GETDATE());
INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive], [IsDeleted], [CreatedDate]) VALUES (5, 5, 2, N'Nhông sên dĩa Yamaha Exciter', 'nsd-exciter', N'Bộ truyền động chính hãng.', 0, 1, 0, GETDATE());
INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive], [IsDeleted], [CreatedDate]) VALUES (6, 1, 3, N'Motul 7100 10W50', 'motul-7100-10w50', N'Nhớt đỏ 100% tổng hợp.', 1, 1, 0, GETDATE());
SET IDENTITY_INSERT [dbo].[Products] OFF;

-- ProductVariants
SET IDENTITY_INSERT [dbo].[ProductVariants] ON;
INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity], [CostPrice], [CreatedDate]) VALUES (1, 1, 1, 'MOT300V-1L', N'1 Lít', 450000, 100, 350000, GETDATE());
INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity], [CostPrice], [CreatedDate]) VALUES (2, 2, 2, 'MIC-70-90-17', N'70/90-17', 550000, 50, 450000, GETDATE());
INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity], [CostPrice], [CreatedDate]) VALUES (3, 2, 2, 'MIC-80-90-17', N'80/90-17', 650000, 40, 500000, GETDATE());
INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity], [CostPrice], [CreatedDate]) VALUES (4, 3, 2, 'GS-GTZ6V', N'Tiêu chuẩn', 380000, 30, 280000, GETDATE());
INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity], [CostPrice], [CreatedDate]) VALUES (5, 6, 1, 'MOT7100-1L', N'1 Lít', 320000, 150, 250000, GETDATE());
SET IDENTITY_INSERT [dbo].[ProductVariants] OFF;

-- ProductImages
SET IDENTITY_INSERT [dbo].[ProductImages] ON;
INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary], [DisplayOrder]) VALUES (1, 1, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1, 1);
INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary], [DisplayOrder]) VALUES (2, 2, 'https://cf.shopee.vn/file/vn-11134207-7ra0g-ma4aqo52ong852', 1, 1);
INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary], [DisplayOrder]) VALUES (3, 3, 'https://cf.shopee.vn/file/sg-11134201-7rdvv-lzzy638h94kic7', 1, 1);
INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary], [DisplayOrder]) VALUES (4, 4, 'https://cf.shopee.vn/file/vn-11134207-7r98o-lzlek80h6rf1d1', 1, 1);
INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary], [DisplayOrder]) VALUES (5, 5, 'https://cf.shopee.vn/file/sg-11134201-22110-nv34i5b53cjvb4', 1, 1);
INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary], [DisplayOrder]) VALUES (6, 6, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1, 1);
SET IDENTITY_INSERT [dbo].[ProductImages] OFF;

-- Sliders
SET IDENTITY_INSERT [dbo].[Sliders] ON;
INSERT INTO [dbo].[Sliders] ([SliderId], [Title], [ImageUrl], [LinkUrl], [IsActive]) VALUES (1, N'Bảo dưỡng chuyên nghiệp', 'https://static.shop2banh.vn/images/banner/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 'service.html', 1);
INSERT INTO [dbo].[Sliders] ([SliderId], [Title], [ImageUrl], [LinkUrl], [IsActive]) VALUES (2, N'Ưu đãi tháng 4', 'https://static.shop2banh.vn/images/banner/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 'promotion.html', 1);
SET IDENTITY_INSERT [dbo].[Sliders] OFF;

-- Banners
SET IDENTITY_INSERT [dbo].[Banners] ON;
INSERT INTO [dbo].[Banners] ([BannerId], [Title], [ImageUrl], [Position], [IsActive]) VALUES (1, N'Sale 50%', 'https://static.shop2banh.vn/images/banner/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 'Top', 1);
SET IDENTITY_INSERT [dbo].[Banners] OFF;

-- BlogCategories
SET IDENTITY_INSERT [dbo].[BlogCategories] ON;
INSERT INTO [dbo].[BlogCategories] ([Id], [Name], [Slug]) VALUES (1, N'Kinh nghiệm bảo dưỡng', 'kinh-nghiem-bao-duong');
INSERT INTO [dbo].[BlogCategories] ([Id], [Name], [Slug]) VALUES (2, N'Tin tức xe máy', 'tin-tuc-xe-may');
SET IDENTITY_INSERT [dbo].[BlogCategories] OFF;

-- Blogs
SET IDENTITY_INSERT [dbo].[Blogs] ON;
INSERT INTO [dbo].[Blogs] ([Id], [Title], [Slug], [Content], [Thumbnail], [CategoryId], [Status], [CreatedDate]) VALUES (1, N'Khi nào cần thay nhớt xe máy?', 'khi-nao-thay-nhot', N'Nên thay nhớt định kỳ mỗi 1500km - 2000km...', 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1, 1, GETDATE());
INSERT INTO [dbo].[Blogs] ([Id], [Title], [Slug], [Content], [Thumbnail], [CategoryId], [Status], [CreatedDate]) VALUES (2, N'Honda ra mắt dòng xe mới', 'honda-moi', N'Mẫu xe mới tiết kiệm nhiên liệu vượt trội...', 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 2, 1, GETDATE());
SET IDENTITY_INSERT [dbo].[Blogs] OFF;

-- Services
SET IDENTITY_INSERT [dbo].[Services] ON;
INSERT INTO [dbo].[Services] ([ServiceId], [ServiceName], [Price], [Description], [IsActive]) VALUES (1, N'Vệ sinh kim phun Fi', 150000, N'Làm sạch kim phun bằng sóng siêu âm.', 1);
INSERT INTO [dbo].[Services] ([ServiceId], [ServiceName], [Price], [Description], [IsActive]) VALUES (2, N'Bảo dưỡng toàn diện', 350000, N'Kiểm tra và vệ sinh 15 hạng mục.', 1);
SET IDENTITY_INSERT [dbo].[Services] OFF;

-- 17.1 ServiceCombos
SET IDENTITY_INSERT [dbo].[ServiceCombos] ON;
INSERT INTO [dbo].[ServiceCombos] ([ComboId], [ComboName], [TotalPrice], [DiscountPrice], [Description], [ImageUrl], [IsActive]) VALUES 
(1, N'Combo Tiết Kiệm Hè', 500000, 450000, N'Bao gồm vệ sinh kim phun và bảo dưỡng toàn diện.', 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1);
SET IDENTITY_INSERT [dbo].[ServiceCombos] OFF;

-- 17.2 ServiceComboItems
SET IDENTITY_INSERT [dbo].[ServiceComboItems] ON;
INSERT INTO [dbo].[ServiceComboItems] ([Id], [ComboId], [ServiceId]) VALUES 
(1, 1, 1),
(2, 1, 2);
SET IDENTITY_INSERT [dbo].[ServiceComboItems] OFF;

-- 18. ProductReviews
SET IDENTITY_INSERT [dbo].[ProductReviews] ON;
INSERT INTO [dbo].[ProductReviews] ([ReviewId], [ProductId], [ProductVariantId], [CustomerId], [Rating], [Comment], [Status], [CreatedDate]) VALUES (1, 1, 1, 1, 5, N'Nhớt rất tốt!', 1, GETDATE());
INSERT INTO [dbo].[ProductReviews] ([ReviewId], [ProductId], [ProductVariantId], [CustomerId], [Rating], [Comment], [Status], [CreatedDate]) VALUES (2, 2, 2, 1, 4, N'Lốp bám đường tốt nhưng hơi cứng.', 1, GETDATE());
SET IDENTITY_INSERT [dbo].[ProductReviews] OFF;

-- Promotions
SET IDENTITY_INSERT [dbo].[Promotions] ON;
INSERT INTO [dbo].[Promotions] ([PromotionId], [PromotionName], [DiscountPercentage], [DiscountType], [StartDate], [EndDate], [IsActive]) VALUES (1, N'Hè rực rỡ', 10, 'Percentage', '2026-04-01', '2026-08-31', 1);
SET IDENTITY_INSERT [dbo].[Promotions] OFF;

-- Coupons
SET IDENTITY_INSERT [dbo].[Coupons] ON;
INSERT INTO [dbo].[Coupons] ([Id], [Code], [DiscountValue], [DiscountType], [ExpiryDate], [IsActive], [UsageLimit], [UsedCount]) VALUES (1, 'HELLO2026', 50000, 'Amount', '2026-12-31', 1, 100, 0);
SET IDENTITY_INSERT [dbo].[Coupons] OFF;

-- ShippingMethods
SET IDENTITY_INSERT [dbo].[ShippingMethods] ON;
INSERT INTO [dbo].[ShippingMethods] ([Id], [Name], [Cost], [EstimatedDays], [IsActive]) VALUES (1, N'Giao hàng nhanh', 30000, 2, 1);
INSERT INTO [dbo].[ShippingMethods] ([Id], [Name], [Cost], [EstimatedDays], [IsActive]) VALUES (2, N'Hỏa tốc (2h)', 60000, 1, 1);
SET IDENTITY_INSERT [dbo].[ShippingMethods] OFF;
GO