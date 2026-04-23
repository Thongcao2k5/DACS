USE [MotorcycleShopDB]
GO

-- 1. AspNetRoles
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetRoles] WHERE [Id] = 'r1')
    INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName]) VALUES ('r1', 'Admin', 'ADMIN');
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetRoles] WHERE [Id] = 'r2')
    INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName]) VALUES ('r2', 'Staff', 'STAFF');
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetRoles] WHERE [Id] = 'r3')
    INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName]) VALUES ('r3', 'Customer', 'CUSTOMER');

-- 2. AspNetUsers
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUsers] WHERE [Id] = 'u1')
    INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u1', 'admin', 'admin@motoshop.vn', 1, 0, 0, 1, 0);
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUsers] WHERE [Id] = 'u2')
    INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u2', 'staff', 'staff@motoshop.vn', 1, 0, 0, 1, 0);
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUsers] WHERE [Id] = 'u3')
    INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u3', 'customer', 'customer@gmail.com', 1, 0, 0, 1, 0);

-- 3. AspNetUserRoles
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUserRoles] WHERE [UserId] = 'u1' AND [RoleId] = 'r1') INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u1', 'r1');
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUserRoles] WHERE [UserId] = 'u2' AND [RoleId] = 'r2') INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u2', 'r2');
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUserRoles] WHERE [UserId] = 'u3' AND [RoleId] = 'r3') INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u3', 'r3');

-- 4. Stores
SET IDENTITY_INSERT [dbo].[Stores] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Stores] WHERE [StoreId] = 1)
    INSERT INTO [dbo].[Stores] ([StoreId], [StoreName], [Address], [Phone]) VALUES (1, N'MotoShop Quận 1', N'123 Lý Tự Trọng, Q1, TP.HCM', '028 1111 2222');
IF NOT EXISTS (SELECT * FROM [dbo].[Stores] WHERE [StoreId] = 2)
    INSERT INTO [dbo].[Stores] ([StoreId], [StoreName], [Address], [Phone]) VALUES (2, N'MotoShop Quận 7', N'456 Nguyễn Thị Thập, Q7, TP.HCM', '028 3333 4444');
SET IDENTITY_INSERT [dbo].[Stores] OFF;

-- 5. Staffs
SET IDENTITY_INSERT [dbo].[Staffs] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Staffs] WHERE [StaffId] = 1)
    INSERT INTO [dbo].[Staffs] ([StaffId], [UserId], [StoreId], [StaffCode], [Position]) VALUES (1, 'u2', 1, 'STF001', N'Kỹ thuật viên trưởng');
SET IDENTITY_INSERT [dbo].[Staffs] OFF;

-- 6. Customers
SET IDENTITY_INSERT [dbo].[Customers] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Customers] WHERE [CustomerId] = 1)
    INSERT INTO [dbo].[Customers] ([CustomerId], [UserId], [FullName], [Phone], [Address]) VALUES (1, 'u3', N'Nguyễn Văn An', '0901234567', N'789 Phan Xích Long, Phú Nhuận');
SET IDENTITY_INSERT [dbo].[Customers] OFF;

-- 7. Brands
SET IDENTITY_INSERT [dbo].[Brands] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Brands] WHERE [BrandId] = 1) INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (1, 'Honda', 'honda.svg');
IF NOT EXISTS (SELECT * FROM [dbo].[Brands] WHERE [BrandId] = 2) INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (2, 'Yamaha', 'yamaha.svg');
IF NOT EXISTS (SELECT * FROM [dbo].[Brands] WHERE [BrandId] = 3) INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (3, 'Motul', 'motul.svg');
IF NOT EXISTS (SELECT * FROM [dbo].[Brands] WHERE [BrandId] = 4) INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (4, 'Michelin', 'michelin.svg');
IF NOT EXISTS (SELECT * FROM [dbo].[Brands] WHERE [BrandId] = 5) INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES (5, 'GS', 'gs.svg');
SET IDENTITY_INSERT [dbo].[Brands] OFF;

-- 8. Categories
SET IDENTITY_INSERT [dbo].[Categories] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Categories] WHERE [CategoryId] = 1) INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (1, N'Dầu nhớt', 'dau-nhot');
IF NOT EXISTS (SELECT * FROM [dbo].[Categories] WHERE [CategoryId] = 2) INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (2, N'Lốp xe máy', 'lop-xe-may');
IF NOT EXISTS (SELECT * FROM [dbo].[Categories] WHERE [CategoryId] = 3) INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (3, N'Ắc quy', 'ac-quy');
IF NOT EXISTS (SELECT * FROM [dbo].[Categories] WHERE [CategoryId] = 4) INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (4, N'Hệ thống phanh', 'phanh');
IF NOT EXISTS (SELECT * FROM [dbo].[Categories] WHERE [CategoryId] = 5) INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug]) VALUES (5, N'Nhông sên dĩa', 'nhong-sen-dia');
SET IDENTITY_INSERT [dbo].[Categories] OFF;

-- 9. Units
SET IDENTITY_INSERT [dbo].[Units] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Units] WHERE [UnitId] = 1) INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES (1, N'Lon', 'L');
IF NOT EXISTS (SELECT * FROM [dbo].[Units] WHERE [UnitId] = 2) INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES (2, N'Cái', 'C');
IF NOT EXISTS (SELECT * FROM [dbo].[Units] WHERE [UnitId] = 3) INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES (3, N'Bộ', 'B');
SET IDENTITY_INSERT [dbo].[Units] OFF;

-- 10. Products
SET IDENTITY_INSERT [dbo].[Products] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Products] WHERE [ProductId] = 1) INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive]) VALUES (1, 1, 3, N'Motul 300V 10W40', 'motul-300v-10w40', N'Nhớt tổng hợp cao cấp.', 1, 1);
IF NOT EXISTS (SELECT * FROM [dbo].[Products] WHERE [ProductId] = 2) INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive]) VALUES (2, 2, 4, N'Michelin Pilot Street 2', 'michelin-pilot-street-2', N'Lốp bám đường cực tốt.', 1, 1);
IF NOT EXISTS (SELECT * FROM [dbo].[Products] WHERE [ProductId] = 3) INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive]) VALUES (3, 3, 5, N'Ắc quy GS GTZ6V', 'gs-gtz6v', N'Bình khô cho xe ga.', 0, 1);
IF NOT EXISTS (SELECT * FROM [dbo].[Products] WHERE [ProductId] = 4) INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive]) VALUES (4, 4, 1, N'Má phanh Honda Winner', 'ma-phanh-honda', N'Hàng chính hãng Honda.', 0, 1);
IF NOT EXISTS (SELECT * FROM [dbo].[Products] WHERE [ProductId] = 5) INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive]) VALUES (5, 5, 2, N'Nhông sên dĩa Yamaha Exciter', 'nsd-exciter', N'Bộ truyền động chính hãng.', 0, 1);
IF NOT EXISTS (SELECT * FROM [dbo].[Products] WHERE [ProductId] = 6) INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured], [IsActive]) VALUES (6, 1, 3, N'Motul 7100 10W50', 'motul-7100-10w50', N'Nhớt đỏ 100% tổng hợp.', 1, 1);
SET IDENTITY_INSERT [dbo].[Products] OFF;

-- 11. ProductVariants
SET IDENTITY_INSERT [dbo].[ProductVariants] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ProductVariants] WHERE [ProductVariantId] = 1) INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity]) VALUES (1, 1, 1, 'MOT300V-1L', N'1 Lít', 450000, 100);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductVariants] WHERE [ProductVariantId] = 2) INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity]) VALUES (2, 2, 2, 'MIC-70-90-17', N'70/90-17', 550000, 50);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductVariants] WHERE [ProductVariantId] = 3) INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity]) VALUES (3, 2, 2, 'MIC-80-90-17', N'80/90-17', 650000, 40);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductVariants] WHERE [ProductVariantId] = 4) INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity]) VALUES (4, 3, 2, 'GS-GTZ6V', N'Tiêu chuẩn', 380000, 30);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductVariants] WHERE [ProductVariantId] = 5) INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price], [StockQuantity]) VALUES (5, 6, 1, 'MOT7100-1L', N'1 Lít', 320000, 150);
SET IDENTITY_INSERT [dbo].[ProductVariants] OFF;

-- 12. ProductImages
SET IDENTITY_INSERT [dbo].[ProductImages] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ProductImages] WHERE [ImageId] = 1) INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES (1, 1, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductImages] WHERE [ImageId] = 2) INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES (2, 2, 'https://cf.shopee.vn/file/vn-11134207-7ra0g-ma4aqo52ong852', 1);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductImages] WHERE [ImageId] = 3) INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES (3, 3, 'https://cf.shopee.vn/file/sg-11134201-7rdvv-lzzy638h94kic7', 1);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductImages] WHERE [ImageId] = 4) INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES (4, 4, 'https://cf.shopee.vn/file/vn-11134207-7r98o-lzlek80h6rf1d1', 1);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductImages] WHERE [ImageId] = 5) INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES (5, 5, 'https://cf.shopee.vn/file/sg-11134201-22110-nv34i5b53cjvb4', 1);
IF NOT EXISTS (SELECT * FROM [dbo].[ProductImages] WHERE [ImageId] = 6) INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES (6, 6, 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1);
SET IDENTITY_INSERT [dbo].[ProductImages] OFF;

-- 13. Sliders
SET IDENTITY_INSERT [dbo].[Sliders] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Sliders] WHERE [SliderId] = 1) INSERT INTO [dbo].[Sliders] ([SliderId], [Title], [ImageUrl], [LinkUrl], [IsActive]) VALUES (1, N'Bảo dưỡng chuyên nghiệp', 'https://static.shop2banh.vn/images/banner/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 'service.html', 1);
IF NOT EXISTS (SELECT * FROM [dbo].[Sliders] WHERE [SliderId] = 2) INSERT INTO [dbo].[Sliders] ([SliderId], [Title], [ImageUrl], [LinkUrl], [IsActive]) VALUES (2, N'Ưu đãi tháng 4', 'https://static.shop2banh.vn/images/banner/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 'promotion.html', 1);
SET IDENTITY_INSERT [dbo].[Sliders] OFF;

-- 14. Banners
SET IDENTITY_INSERT [dbo].[Banners] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Banners] WHERE [BannerId] = 1) INSERT INTO [dbo].[Banners] ([BannerId], [Title], [ImageUrl], [Position], [IsActive]) VALUES (1, N'Sale 50%', 'https://static.shop2banh.vn/images/banner/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 'Top', 1);
SET IDENTITY_INSERT [dbo].[Banners] OFF;

-- 15. BlogCategories
SET IDENTITY_INSERT [dbo].[BlogCategories] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[BlogCategories] WHERE [Id] = 1) INSERT INTO [dbo].[BlogCategories] ([Id], [Name], [Slug]) VALUES (1, N'Kinh nghiệm bảo dưỡng', 'kinh-nghiem-bao-duong');
IF NOT EXISTS (SELECT * FROM [dbo].[BlogCategories] WHERE [Id] = 2) INSERT INTO [dbo].[BlogCategories] ([Id], [Name], [Slug]) VALUES (2, N'Tin tức xe máy', 'tin-tuc-xe-may');
SET IDENTITY_INSERT [dbo].[BlogCategories] OFF;

-- 16. Blogs
SET IDENTITY_INSERT [dbo].[Blogs] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Blogs] WHERE [Id] = 1) INSERT INTO [dbo].[Blogs] ([Id], [Title], [Slug], [Content], [Thumbnail], [CategoryId], [Status]) VALUES (1, N'Khi nào cần thay nhớt xe máy?', 'khi-nao-thay-nhot', N'Nên thay nhớt định kỳ mỗi 1500km - 2000km...', 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 1, 'Published');
IF NOT EXISTS (SELECT * FROM [dbo].[Blogs] WHERE [Id] = 2) INSERT INTO [dbo].[Blogs] ([Id], [Title], [Slug], [Content], [Thumbnail], [CategoryId], [Status]) VALUES (2, N'Honda ra mắt dòng xe mới', 'honda-moi', N'Mẫu xe mới tiết kiệm nhiên liệu vượt trội...', 'https://nhotchinhhang.vn/images/2024/08/20240814_8189527a7b4a2799f6661cb2a7c137c8_1723619923.jpg', 2, 'Published');
SET IDENTITY_INSERT [dbo].[Blogs] OFF;

-- 17. Services
SET IDENTITY_INSERT [dbo].[Services] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Services] WHERE [ServiceId] = 1) INSERT INTO [dbo].[Services] ([ServiceId], [ServiceName], [Price], [Description]) VALUES (1, N'Vệ sinh kim phun Fi', 150000, N'Làm sạch kim phun bằng sóng siêu âm.');
IF NOT EXISTS (SELECT * FROM [dbo].[Services] WHERE [ServiceId] = 2) INSERT INTO [dbo].[Services] ([ServiceId], [ServiceName], [Price], [Description]) VALUES (2, N'Bảo dưỡng toàn diện', 350000, N'Kiểm tra và vệ sinh 15 hạng mục.');
SET IDENTITY_INSERT [dbo].[Services] OFF;

-- 18. ProductReviews
SET IDENTITY_INSERT [dbo].[ProductReviews] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ProductReviews] WHERE [ReviewId] = 1) INSERT INTO [dbo].[ProductReviews] ([ReviewId], [ProductId], [ProductVariantId], [CustomerId], [Rating], [Comment], [Status]) VALUES (1, 1, 1, 1, 5, N'Nhớt rất tốt!', 'Approved');
IF NOT EXISTS (SELECT * FROM [dbo].[ProductReviews] WHERE [ReviewId] = 2) INSERT INTO [dbo].[ProductReviews] ([ReviewId], [ProductId], [ProductVariantId], [CustomerId], [Rating], [Comment], [Status]) VALUES (2, 2, 2, 1, 4, N'Lốp bám đường tốt nhưng hơi cứng.', 'Approved');
SET IDENTITY_INSERT [dbo].[ProductReviews] OFF;

-- 19. Promotions
SET IDENTITY_INSERT [dbo].[Promotions] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Promotions] WHERE [PromotionId] = 1) INSERT INTO [dbo].[Promotions] ([PromotionId], [PromotionName], [DiscountPercentage], [DiscountType], [StartDate], [EndDate], [IsActive]) VALUES (1, N'Hè rực rỡ', 10, 'Percentage', '2026-04-01', '2026-08-31', 1);
SET IDENTITY_INSERT [dbo].[Promotions] OFF;

-- 20. Coupons
SET IDENTITY_INSERT [dbo].[Coupons] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Coupons] WHERE [Id] = 1) INSERT INTO [dbo].[Coupons] ([Id], [Code], [DiscountValue], [DiscountType], [ExpiryDate], [IsActive]) VALUES (1, 'HELLO2026', 50000, 'Amount', '2026-12-31', 1);
SET IDENTITY_INSERT [dbo].[Coupons] OFF;

-- 21. ShippingMethods
SET IDENTITY_INSERT [dbo].[ShippingMethods] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ShippingMethods] WHERE [Id] = 1) INSERT INTO [dbo].[ShippingMethods] ([Id], [Name], [Cost], [EstimatedDays]) VALUES (1, N'Giao hàng nhanh', 30000, 2);
IF NOT EXISTS (SELECT * FROM [dbo].[ShippingMethods] WHERE [Id] = 2) INSERT INTO [dbo].[ShippingMethods] ([Id], [Name], [Cost], [EstimatedDays]) VALUES (2, N'Hỏa tốc (2h)', 60000, 1);
SET IDENTITY_INSERT [dbo].[ShippingMethods] OFF;

GO
