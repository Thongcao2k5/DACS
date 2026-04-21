USE [MotorcycleShopDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
    INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u2', 'thang_staff', 'thang.staff@motoshop.vn', 1, 0, 0, 1, 0);
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUsers] WHERE [Id] = 'u3')
    INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES ('u3', 'an_customer', 'an.customer@gmail.com', 1, 0, 0, 1, 0);

-- 3. AspNetUserRoles
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUserRoles] WHERE [UserId] = 'u1' AND [RoleId] = 'r1')
    INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u1', 'r1');
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUserRoles] WHERE [UserId] = 'u2' AND [RoleId] = 'r2')
    INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u2', 'r2');
IF NOT EXISTS (SELECT * FROM [dbo].[AspNetUserRoles] WHERE [UserId] = 'u3' AND [RoleId] = 'r3')
    INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES ('u3', 'r3');

-- 4. Stores
SET IDENTITY_INSERT [dbo].[Stores] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Stores] WHERE [StoreId] IN (1, 2))
BEGIN
    INSERT INTO [dbo].[Stores] ([StoreId], [StoreName], [Address], [Phone]) VALUES 
    (1, N'MotoShop Quận 1', N'123 Lý Tự Trọng, Q1, TP.HCM', '028 1111 2222'),
    (2, N'MotoShop Quận 7', N'456 Nguyễn Thị Thập, Q7, TP.HCM', '028 3333 4444');
END
SET IDENTITY_INSERT [dbo].[Stores] OFF;

-- 5. Staffs (Đã sửa từ Staff thành Staffs)
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
IF NOT EXISTS (SELECT * FROM [dbo].[Brands] WHERE [BrandId] IN (1, 2, 3, 4))
BEGIN
    INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES 
    (1, 'Honda', 'honda.svg'),
    (2, 'Yamaha', 'yamaha.svg'),
    (3, 'Motul', 'motul.svg'),
    (4, 'NGK', 'ngk.svg');
END
SET IDENTITY_INSERT [dbo].[Brands] OFF;

-- 8. Categories
SET IDENTITY_INSERT [dbo].[Categories] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Categories] WHERE [CategoryId] IN (1, 2, 3))
BEGIN
    INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug], [ParentId]) VALUES 
    (1, N'Dầu nhớt', 'dau-nhot', NULL),
    (2, N'Hệ thống truyền động', 'truyen-dong', NULL),
    (3, N'Bộ nồi xe ga', 'bo-noi-xe-ga', 2);
END
SET IDENTITY_INSERT [dbo].[Categories] OFF;

-- 9. Units
SET IDENTITY_INSERT [dbo].[Units] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Units] WHERE [UnitId] IN (1, 2, 3))
BEGIN
    INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES 
    (1, N'Lon', 'L'),
    (2, N'Cái', 'C'),
    (3, N'Bộ', 'B');
END
SET IDENTITY_INSERT [dbo].[Units] OFF;

-- 10. ProductAttributes
SET IDENTITY_INSERT [dbo].[ProductAttributes] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ProductAttributes] WHERE [AttributeId] IN (1, 2))
BEGIN
    INSERT INTO [dbo].[ProductAttributes] ([AttributeId], [AttributeName]) VALUES 
    (1, N'Dung tích'),
    (2, N'Màu sắc');
END
SET IDENTITY_INSERT [dbo].[ProductAttributes] OFF;

-- 11. AttributeValues
SET IDENTITY_INSERT [dbo].[AttributeValues] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[AttributeValues] WHERE [ValueId] IN (1, 2))
BEGIN
    INSERT INTO [dbo].[AttributeValues] ([ValueId], [AttributeId], [Value]) VALUES 
    (1, 1, N'1 Lít'),
    (2, 2, N'Đen CNC');
END
SET IDENTITY_INSERT [dbo].[AttributeValues] OFF;

-- 12. Products
SET IDENTITY_INSERT [dbo].[Products] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Products] WHERE [ProductId] = 1)
    INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured]) VALUES (1, 1, 3, N'Dầu nhớt Motul 300V', 'motul-300v', N'Dầu nhớt cao cấp cho xe phân khối lớn.', 1);
SET IDENTITY_INSERT [dbo].[Products] OFF;

-- 13. ProductVariants
SET IDENTITY_INSERT [dbo].[ProductVariants] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ProductVariants] WHERE [ProductVariantId] = 101)
    INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price]) VALUES (101, 1, 1, 'MOT300V10W40', N'Motul 300V 10W40 1L', 450000);
SET IDENTITY_INSERT [dbo].[ProductVariants] OFF;

-- 14. ProductImages
SET IDENTITY_INSERT [dbo].[ProductImages] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ProductImages] WHERE [ImageId] = 1)
    INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES (1, 1, 'motul-300v.jpg', 1);
SET IDENTITY_INSERT [dbo].[ProductImages] OFF;

-- 15. Promotions (Đã sửa Name thành PromotionName)
SET IDENTITY_INSERT [dbo].[Promotions] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Promotions] WHERE [PromotionId] = 1)
    INSERT INTO [dbo].[Promotions] ([PromotionId], [PromotionName], [DiscountPercentage], [StartDate], [EndDate]) VALUES (1, N'Flash Sale Tháng 3', 10, '2026-03-01', '2026-03-31');
SET IDENTITY_INSERT [dbo].[Promotions] OFF;

-- 16. PromotionProducts (Đã sửa từ ProductPromotions thành PromotionProducts)
IF NOT EXISTS (SELECT * FROM [dbo].[PromotionProducts] WHERE [ProductId] = 1 AND [PromotionId] = 1)
    INSERT INTO [dbo].[PromotionProducts] ([ProductId], [PromotionId]) VALUES (1, 1);

-- 17. Orders
SET IDENTITY_INSERT [dbo].[Orders] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Orders] WHERE [OrderId] = 1)
    INSERT INTO [dbo].[Orders] ([OrderId], [CustomerId], [StoreId], [OrderDate], [TotalAmount], [Status]) VALUES (1, 1, 1, '2026-03-12 10:00:00', 405000, N'Đã hoàn thành');
SET IDENTITY_INSERT [dbo].[Orders] OFF;

-- 18. OrderItems
SET IDENTITY_INSERT [dbo].[OrderItems] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[OrderItems] WHERE [OrderItemId] = 1)
    INSERT INTO [dbo].[OrderItems] ([OrderItemId], [OrderId], [ProductVariantId], [Quantity], [Price]) VALUES (1, 1, 101, 1, 405000);
SET IDENTITY_INSERT [dbo].[OrderItems] OFF;

-- 19. OrderStatusHistories (Đã sửa từ OrderStatusHistory thành OrderStatusHistories)
SET IDENTITY_INSERT [dbo].[OrderStatusHistories] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[OrderStatusHistories] WHERE [HistoryId] IN (1, 2))
BEGIN
    INSERT INTO [dbo].[OrderStatusHistories] ([HistoryId], [OrderId], [Status], [ChangedDate]) VALUES 
    (1, 1, N'Chờ xác nhận', '2026-03-12 10:00:00'),
    (2, 1, N'Đã giao hàng', '2026-03-12 15:00:00');
END
SET IDENTITY_INSERT [dbo].[OrderStatusHistories] OFF;

-- 20. Payments
SET IDENTITY_INSERT [dbo].[Payments] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Payments] WHERE [PaymentId] = 1)
    INSERT INTO [dbo].[Payments] ([PaymentId], [OrderId], [PaymentMethod], [PaymentStatus], [PaidDate]) VALUES (1, 1, N'Chuyển khoản', N'Đã thanh toán', '2026-03-12 10:05:00');
SET IDENTITY_INSERT [dbo].[Payments] OFF;

-- 21. Services
SET IDENTITY_INSERT [dbo].[Services] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Services] WHERE [ServiceId] = 1)
    INSERT INTO [dbo].[Services] ([ServiceId], [ServiceName], [Price], [Description]) VALUES (1, N'Vệ sinh kim phun Fi', 150000, N'Làm sạch kim phun bằng sóng siêu âm.');
SET IDENTITY_INSERT [dbo].[Services] OFF;

-- 22. ServiceBookings
SET IDENTITY_INSERT [dbo].[ServiceBookings] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ServiceBookings] WHERE [BookingId] = 1)
    INSERT INTO [dbo].[ServiceBookings] ([BookingId], [CustomerId], [ServiceId], [AssignedStaffId], [BookingDate], [ServiceDate], [Status]) VALUES (1, 1, 1, 1, '2026-03-14 08:00:00', '2026-03-16 09:00:00', N'Đã xác nhận');
SET IDENTITY_INSERT [dbo].[ServiceBookings] OFF;

-- 23. ProductReviews
SET IDENTITY_INSERT [dbo].[ProductReviews] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[ProductReviews] WHERE [ReviewId] = 1)
    INSERT INTO [dbo].[ProductReviews] ([ReviewId], [ProductId], [CustomerId], [Rating], [Comment]) VALUES (1, 1, 1, 5, N'Nhớt chạy rất êm máy!');
SET IDENTITY_INSERT [dbo].[ProductReviews] OFF;

-- 24. InventoryTransactions (Đã sửa từ StockMovements thành InventoryTransactions)
SET IDENTITY_INSERT [dbo].[InventoryTransactions] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[InventoryTransactions] WHERE [TransactionId] = 1)
    -- Giả sử bảng này có cấu trúc tương tự (TransactionId, ProductVariantId, Quantity, Reason, CreatedDate)
    INSERT INTO [dbo].[InventoryTransactions] ([TransactionId], [ProductVariantId], [Quantity], [TransactionType], [Note], [CreatedDate]) 
    VALUES (1, 101, -1, N'Xuất kho', N'Bán hàng đơn #1', '2026-03-12 10:00:00');
SET IDENTITY_INSERT [dbo].[InventoryTransactions] OFF;

-- 25. Sliders
SET IDENTITY_INSERT [dbo].[Sliders] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Sliders] WHERE [SliderId] = 1)
    INSERT INTO [dbo].[Sliders] ([SliderId], [Title], [ImageUrl], [LinkUrl]) VALUES (1, N'Bảo dưỡng chuyên nghiệp', 'slider1.jpg', 'service.html');
SET IDENTITY_INSERT [dbo].[Sliders] OFF;

-- 26. Banners
SET IDENTITY_INSERT [dbo].[Banners] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Banners] WHERE [BannerId] = 1)
    INSERT INTO [dbo].[Banners] ([BannerId], [Title], [ImageUrl], [Position]) VALUES (1, N'Giảm giá 50%', 'banner1.jpg', 'Top');
SET IDENTITY_INSERT [dbo].[Banners] OFF;

-- 27. Wishlists
SET IDENTITY_INSERT [dbo].[Wishlists] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[Wishlists] WHERE [WishlistId] = 1)
    INSERT INTO [dbo].[Wishlists] ([WishlistId], [CustomerId]) VALUES (1, 1);
SET IDENTITY_INSERT [dbo].[Wishlists] OFF;

-- 28. WishlistItems (Đã sửa ProductVariantId thành ProductId)
SET IDENTITY_INSERT [dbo].[WishlistItems] ON;
IF NOT EXISTS (SELECT * FROM [dbo].[WishlistItems] WHERE [WishlistItemId] = 1)
    INSERT INTO [dbo].[WishlistItems] ([WishlistItemId], [WishlistId], [ProductId]) VALUES (1, 1, 1);
SET IDENTITY_INSERT [dbo].[WishlistItems] OFF;
GO
