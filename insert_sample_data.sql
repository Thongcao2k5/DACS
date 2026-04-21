USE [MotorcycleShopDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Xóa dữ liệu cũ (tùy chọn, hãy cẩn thận)
-- DELETE FROM OrderItems; DELETE FROM Orders; ...

-- 1. AspNetRoles
INSERT INTO [dbo].[AspNetRoles] ([Id], [Name], [NormalizedName]) VALUES 
('r1', 'Admin', 'ADMIN'),
('r2', 'Staff', 'STAFF'),
('r3', 'Customer', 'CUSTOMER');

-- 2. AspNetUsers
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]) VALUES 
('u1', 'admin', 'admin@motoshop.vn', 1, 0, 0, 1, 0),
('u2', 'thang_staff', 'thang.staff@motoshop.vn', 1, 0, 0, 1, 0),
('u3', 'an_customer', 'an.customer@gmail.com', 1, 0, 0, 1, 0);

-- 3. AspNetUserRoles
INSERT INTO [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES 
('u1', 'r1'),
('u2', 'r2'),
('u3', 'r3');

-- 4. Stores
SET IDENTITY_INSERT [dbo].[Stores] ON;
INSERT INTO [dbo].[Stores] ([StoreId], [StoreName], [Address], [Phone]) VALUES 
(1, N'MotoShop Quận 1', N'123 Lý Tự Trọng, Q1, TP.HCM', '028 1111 2222'),
(2, N'MotoShop Quận 7', N'456 Nguyễn Thị Thập, Q7, TP.HCM', '028 3333 4444');
SET IDENTITY_INSERT [dbo].[Stores] OFF;

-- 5. Staff
SET IDENTITY_INSERT [dbo].[Staff] ON;
INSERT INTO [dbo].[Staff] ([StaffId], [UserId], [StoreId], [StaffCode], [Position]) VALUES 
(1, 'u2', 1, 'STF001', N'Kỹ thuật viên trưởng');
SET IDENTITY_INSERT [dbo].[Staff] OFF;

-- 6. Customers
SET IDENTITY_INSERT [dbo].[Customers] ON;
INSERT INTO [dbo].[Customers] ([CustomerId], [UserId], [FullName], [Phone], [Address]) VALUES 
(1, 'u3', N'Nguyễn Văn An', '0901234567', N'789 Phan Xích Long, Phú Nhuận');
SET IDENTITY_INSERT [dbo].[Customers] OFF;

-- 7. Brands
SET IDENTITY_INSERT [dbo].[Brands] ON;
INSERT INTO [dbo].[Brands] ([BrandId], [BrandName], [LogoUrl]) VALUES 
(1, 'Honda', 'honda.svg'),
(2, 'Yamaha', 'yamaha.svg'),
(3, 'Motul', 'motul.svg'),
(4, 'NGK', 'ngk.svg');
SET IDENTITY_INSERT [dbo].[Brands] OFF;

-- 8. Categories
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT INTO [dbo].[Categories] ([CategoryId], [CategoryName], [Slug], [ParentId]) VALUES 
(1, N'Dầu nhớt', 'dau-nhot', NULL),
(2, N'Hệ thống truyền động', 'truyen-dong', NULL),
(3, N'Bộ nồi xe ga', 'bo-noi-xe-ga', 2);
SET IDENTITY_INSERT [dbo].[Categories] OFF;

-- 9. Units
SET IDENTITY_INSERT [dbo].[Units] ON;
INSERT INTO [dbo].[Units] ([UnitId], [UnitName], [Symbol]) VALUES 
(1, N'Lon', 'L'),
(2, N'Cái', 'C'),
(3, N'Bộ', 'B');
SET IDENTITY_INSERT [dbo].[Units] OFF;

-- 10. ProductAttributes
SET IDENTITY_INSERT [dbo].[ProductAttributes] ON;
INSERT INTO [dbo].[ProductAttributes] ([AttributeId], [AttributeName]) VALUES 
(1, N'Dung tích'),
(2, N'Màu sắc');
SET IDENTITY_INSERT [dbo].[ProductAttributes] OFF;

-- 11. AttributeValues
SET IDENTITY_INSERT [dbo].[AttributeValues] ON;
INSERT INTO [dbo].[AttributeValues] ([ValueId], [AttributeId], [Value]) VALUES 
(1, 1, N'1 Lít'),
(2, 2, N'Đen CNC');
SET IDENTITY_INSERT [dbo].[AttributeValues] OFF;

-- 12. Products
SET IDENTITY_INSERT [dbo].[Products] ON;
INSERT INTO [dbo].[Products] ([ProductId], [CategoryId], [BrandId], [ProductName], [Slug], [Description], [IsFeatured]) VALUES 
(1, 1, 3, N'Dầu nhớt Motul 300V', 'motul-300v', N'Dầu nhớt cao cấp cho xe phân khối lớn.', 1);
SET IDENTITY_INSERT [dbo].[Products] OFF;

-- 13. ProductVariants
SET IDENTITY_INSERT [dbo].[ProductVariants] ON;
INSERT INTO [dbo].[ProductVariants] ([ProductVariantId], [ProductId], [BaseUnitId], [SKU], [VariantName], [Price]) VALUES 
(101, 1, 1, 'MOT300V10W40', N'Motul 300V 10W40 1L', 450000);
SET IDENTITY_INSERT [dbo].[ProductVariants] OFF;

-- 14. VariantAttributeValues
INSERT INTO [dbo].[VariantAttributeValues] ([ProductVariantId], [AttributeValueId]) VALUES 
(101, 1);

-- 15. ProductImages
SET IDENTITY_INSERT [dbo].[ProductImages] ON;
INSERT INTO [dbo].[ProductImages] ([ImageId], [ProductId], [ImageUrl], [IsPrimary]) VALUES 
(1, 1, 'motul-300v.jpg', 1);
SET IDENTITY_INSERT [dbo].[ProductImages] OFF;

-- 16. Promotions
SET IDENTITY_INSERT [dbo].[Promotions] ON;
INSERT INTO [dbo].[Promotions] ([PromotionId], [PromotionName], [DiscountPercentage], [StartDate], [EndDate]) VALUES 
(1, N'Flash Sale Tháng 3', 10, '2026-03-01', '2026-03-31');
SET IDENTITY_INSERT [dbo].[Promotions] OFF;

-- 17. ProductPromotions
SET IDENTITY_INSERT [dbo].[ProductPromotions] ON;
INSERT INTO [dbo].[ProductPromotions] ([Id], [ProductId], [PromotionId]) VALUES 
(1, 1, 1);
SET IDENTITY_INSERT [dbo].[ProductPromotions] OFF;

-- 18. Orders
SET IDENTITY_INSERT [dbo].[Orders] ON;
INSERT INTO [dbo].[Orders] ([OrderId], [CustomerId], [StoreId], [OrderDate], [TotalAmount], [Status]) VALUES 
(1, 1, 1, '2026-03-12 10:00:00', 405000, N'Đã hoàn thành');
SET IDENTITY_INSERT [dbo].[Orders] OFF;

-- 19. OrderItems
SET IDENTITY_INSERT [dbo].[OrderItems] ON;
INSERT INTO [dbo].[OrderItems] ([OrderItemId], [OrderId], [ProductVariantId], [Quantity], [Price]) VALUES 
(1, 1, 101, 1, 405000);
SET IDENTITY_INSERT [dbo].[OrderItems] OFF;

-- 20. OrderStatusHistory
SET IDENTITY_INSERT [dbo].[OrderStatusHistory] ON;
INSERT INTO [dbo].[OrderStatusHistory] ([HistoryId], [OrderId], [Status], [ChangedDate]) VALUES 
(1, 1, N'Chờ xác nhận', '2026-03-12 10:00:00'),
(2, 1, N'Đã giao hàng', '2026-03-12 15:00:00');
SET IDENTITY_INSERT [dbo].[OrderStatusHistory] OFF;

-- 21. Payments
SET IDENTITY_INSERT [dbo].[Payments] ON;
INSERT INTO [dbo].[Payments] ([PaymentId], [OrderId], [PaymentMethod], [PaymentStatus], [PaidDate]) VALUES 
(1, 1, N'Chuyển khoản', N'Đã thanh toán', '2026-03-12 10:05:00');
SET IDENTITY_INSERT [dbo].[Payments] OFF;

-- 22. Services
SET IDENTITY_INSERT [dbo].[Services] ON;
INSERT INTO [dbo].[Services] ([ServiceId], [ServiceName], [Price], [Description]) VALUES 
(1, N'Vệ sinh kim phun Fi', 150000, N'Làm sạch kim phun bằng sóng siêu âm.');
SET IDENTITY_INSERT [dbo].[Services] OFF;

-- 23. ServiceBookings
SET IDENTITY_INSERT [dbo].[ServiceBookings] ON;
INSERT INTO [dbo].[ServiceBookings] ([BookingId], [CustomerId], [ServiceId], [AssignedStaffId], [BookingDate], [ServiceDate], [Status]) VALUES 
(1, 1, 1, 1, '2026-03-14 08:00:00', '2026-03-16 09:00:00', N'Đã xác nhận');
SET IDENTITY_INSERT [dbo].[ServiceBookings] OFF;

-- 24. ProductReviews
SET IDENTITY_INSERT [dbo].[ProductReviews] ON;
INSERT INTO [dbo].[ProductReviews] ([ReviewId], [ProductId], [CustomerId], [Rating], [Comment]) VALUES 
(1, 1, 1, 5, N'Nhớt chạy rất êm máy!');
SET IDENTITY_INSERT [dbo].[ProductReviews] OFF;

-- 25. StockMovements
SET IDENTITY_INSERT [dbo].[StockMovements] ON;
INSERT INTO [dbo].[StockMovements] ([MovementId], [ProductVariantId], [ChangeQty], [Reason], [CreatedDate]) VALUES 
(1, 101, -1, N'Bán hàng đơn #1', '2026-03-12 10:00:00');
SET IDENTITY_INSERT [dbo].[StockMovements] OFF;

-- 26. Sliders
SET IDENTITY_INSERT [dbo].[Sliders] ON;
INSERT INTO [dbo].[Sliders] ([SliderId], [Title], [ImageUrl], [LinkUrl]) VALUES 
(1, N'Bảo dưỡng chuyên nghiệp', 'slider1.jpg', 'service.html');
SET IDENTITY_INSERT [dbo].[Sliders] OFF;

-- 27. Banners
SET IDENTITY_INSERT [dbo].[Banners] ON;
INSERT INTO [dbo].[Banners] ([BannerId], [Title], [ImageUrl], [Position]) VALUES 
(1, N'Giảm giá 50%', 'banner1.jpg', 'Top');
SET IDENTITY_INSERT [dbo].[Banners] OFF;

-- 28. Wishlists
SET IDENTITY_INSERT [dbo].[Wishlists] ON;
INSERT INTO [dbo].[Wishlists] ([WishlistId], [CustomerId]) VALUES 
(1, 1);
SET IDENTITY_INSERT [dbo].[Wishlists] OFF;

-- 29. WishlistItems
SET IDENTITY_INSERT [dbo].[WishlistItems] ON;
INSERT INTO [dbo].[WishlistItems] ([WishlistItemId], [WishlistId], [ProductId]) VALUES 
(1, 1, 1);
SET IDENTITY_INSERT [dbo].[WishlistItems] OFF;
GO
