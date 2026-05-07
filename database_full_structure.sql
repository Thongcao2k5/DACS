IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
CREATE TABLE [AspNetRoles] (
    [Id] nvarchar(450) NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);

CREATE TABLE [AspNetUsers] (
    [Id] nvarchar(450) NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(max) NULL,
    [SecurityStamp] nvarchar(max) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
);

CREATE TABLE [Banners] (
    [BannerId] int NOT NULL IDENTITY,
    [Title] nvarchar(255) NULL,
    [ImageUrl] nvarchar(500) NULL,
    [LinkUrl] nvarchar(500) NULL,
    [Position] nvarchar(100) NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_Banners] PRIMARY KEY ([BannerId])
);

CREATE TABLE [BlogCategories] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(200) NOT NULL,
    [Slug] nvarchar(255) NULL,
    CONSTRAINT [PK_BlogCategories] PRIMARY KEY ([Id])
);

CREATE TABLE [Brands] (
    [BrandId] int NOT NULL IDENTITY,
    [BrandName] nvarchar(255) NOT NULL,
    [LogoUrl] nvarchar(500) NULL,
    [Description] nvarchar(max) NULL,
    CONSTRAINT [PK_Brands] PRIMARY KEY ([BrandId])
);

CREATE TABLE [Categories] (
    [CategoryId] int NOT NULL IDENTITY,
    [CategoryName] nvarchar(200) NOT NULL,
    [Slug] nvarchar(255) NULL,
    [ParentId] int NULL,
    [Description] nvarchar(max) NULL,
    [ImageUrl] nvarchar(500) NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY ([CategoryId]),
    CONSTRAINT [FK_Categories_Categories_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [Categories] ([CategoryId])
);

CREATE TABLE [Coupons] (
    [Id] int NOT NULL IDENTITY,
    [Code] nvarchar(50) NOT NULL,
    [DiscountValue] decimal(18,2) NOT NULL,
    [DiscountType] nvarchar(20) NOT NULL,
    [MinOrderValue] decimal(18,2) NULL,
    [UsageLimit] int NOT NULL,
    [UsedCount] int NOT NULL,
    [ExpiryDate] datetime2 NOT NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_Coupons] PRIMARY KEY ([Id])
);

CREATE TABLE [Customers] (
    [CustomerId] int NOT NULL IDENTITY,
    [UserId] nvarchar(max) NULL,
    [FullName] nvarchar(200) NOT NULL,
    [Email] nvarchar(255) NULL,
    [Phone] nvarchar(50) NULL,
    [Address] nvarchar(500) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [IsLocked] bit NOT NULL,
    CONSTRAINT [PK_Customers] PRIMARY KEY ([CustomerId])
);

CREATE TABLE [MotorbikeModels] (
    [ModelId] int NOT NULL IDENTITY,
    [ModelName] nvarchar(200) NOT NULL,
    [Manufacturer] nvarchar(200) NULL,
    [ParentId] int NULL,
    CONSTRAINT [PK_MotorbikeModels] PRIMARY KEY ([ModelId]),
    CONSTRAINT [FK_MotorbikeModels_MotorbikeModels_ParentId] FOREIGN KEY ([ParentId]) REFERENCES [MotorbikeModels] ([ModelId])
);

CREATE TABLE [Notifications] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(max) NOT NULL,
    [Title] nvarchar(255) NOT NULL,
    [Message] nvarchar(max) NOT NULL,
    [IsRead] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_Notifications] PRIMARY KEY ([Id])
);

CREATE TABLE [ProductAttributes] (
    [AttributeId] int NOT NULL IDENTITY,
    [AttributeName] nvarchar(200) NOT NULL,
    CONSTRAINT [PK_ProductAttributes] PRIMARY KEY ([AttributeId])
);

CREATE TABLE [Promotions] (
    [PromotionId] int NOT NULL IDENTITY,
    [PromotionName] nvarchar(255) NOT NULL,
    [Description] nvarchar(max) NULL,
    [DiscountType] nvarchar(20) NOT NULL,
    [DiscountPercentage] decimal(5,2) NOT NULL,
    [DiscountAmount] decimal(18,2) NOT NULL,
    [MinOrderValue] decimal(18,2) NULL,
    [MinQuantity] int NULL,
    [StartDate] datetime2 NOT NULL,
    [EndDate] datetime2 NOT NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_Promotions] PRIMARY KEY ([PromotionId])
);

CREATE TABLE [ServiceCombos] (
    [ComboId] int NOT NULL IDENTITY,
    [ComboName] nvarchar(200) NOT NULL,
    [TotalPrice] decimal(18,2) NOT NULL,
    [DiscountPrice] decimal(18,2) NOT NULL,
    [Description] nvarchar(max) NULL,
    [ImageUrl] nvarchar(500) NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_ServiceCombos] PRIMARY KEY ([ComboId])
);

CREATE TABLE [Services] (
    [ServiceId] int NOT NULL IDENTITY,
    [ServiceName] nvarchar(200) NOT NULL,
    [Price] decimal(18,2) NOT NULL,
    [Description] nvarchar(max) NULL,
    [ImageUrl] nvarchar(500) NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_Services] PRIMARY KEY ([ServiceId])
);

CREATE TABLE [ShippingMethods] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(100) NOT NULL,
    [Description] nvarchar(max) NULL,
    [Cost] decimal(18,2) NOT NULL,
    [EstimatedDays] nvarchar(100) NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_ShippingMethods] PRIMARY KEY ([Id])
);

CREATE TABLE [Sliders] (
    [SliderId] int NOT NULL IDENTITY,
    [Title] nvarchar(255) NULL,
    [ImageUrl] nvarchar(500) NULL,
    [LinkUrl] nvarchar(500) NULL,
    [Position] int NOT NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_Sliders] PRIMARY KEY ([SliderId])
);

CREATE TABLE [Stores] (
    [StoreId] int NOT NULL IDENTITY,
    [StoreName] nvarchar(200) NOT NULL,
    [Address] nvarchar(500) NULL,
    [Phone] nvarchar(50) NULL,
    CONSTRAINT [PK_Stores] PRIMARY KEY ([StoreId])
);

CREATE TABLE [StoreSettings] (
    [SettingID] int NOT NULL IDENTITY,
    [StoreName] nvarchar(255) NOT NULL,
    [LogoUrl] nvarchar(500) NULL,
    [Phone] nvarchar(50) NULL,
    [Email] nvarchar(100) NULL,
    [Address] nvarchar(max) NULL,
    [Facebook] nvarchar(255) NULL,
    [Zalo] nvarchar(255) NULL,
    CONSTRAINT [PK_StoreSettings] PRIMARY KEY ([SettingID])
);

CREATE TABLE [Units] (
    [UnitId] int NOT NULL IDENTITY,
    [UnitName] nvarchar(50) NOT NULL,
    [Symbol] nvarchar(20) NULL,
    CONSTRAINT [PK_Units] PRIMARY KEY ([UnitId])
);

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] nvarchar(450) NOT NULL,
    [ProviderKey] nvarchar(450) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserRoles] (
    [UserId] nvarchar(450) NOT NULL,
    [RoleId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [AspNetUserTokens] (
    [UserId] nvarchar(450) NOT NULL,
    [LoginProvider] nvarchar(450) NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [Blogs] (
    [Id] int NOT NULL IDENTITY,
    [Title] nvarchar(300) NOT NULL,
    [Slug] nvarchar(300) NOT NULL,
    [Content] nvarchar(max) NOT NULL,
    [Thumbnail] nvarchar(500) NULL,
    [CategoryId] int NOT NULL,
    [Status] int NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [UpdatedDate] datetime2 NULL,
    [IsPublished] bit NOT NULL,
    CONSTRAINT [PK_Blogs] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Blogs_BlogCategories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [BlogCategories] ([Id]) ON DELETE CASCADE
);

CREATE TABLE [Products] (
    [ProductId] int NOT NULL IDENTITY,
    [CategoryId] int NULL,
    [BrandId] int NULL,
    [ProductName] nvarchar(300) NOT NULL,
    [Slug] nvarchar(255) NULL,
    [Description] nvarchar(max) NULL,
    [IsFeatured] bit NOT NULL,
    [IsActive] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    [IsDeleted] bit NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY ([ProductId]),
    CONSTRAINT [FK_Products_Brands_BrandId] FOREIGN KEY ([BrandId]) REFERENCES [Brands] ([BrandId]),
    CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([CategoryId])
);

CREATE TABLE [Carts] (
    [CartId] int NOT NULL IDENTITY,
    [CustomerId] int NULL,
    [CreatedDate] datetime2 NOT NULL,
    [UserId] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Carts] PRIMARY KEY ([CartId]),
    CONSTRAINT [FK_Carts_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId])
);

CREATE TABLE [CustomerAddresses] (
    [Id] int NOT NULL IDENTITY,
    [CustomerId] int NOT NULL,
    [FullName] nvarchar(200) NOT NULL,
    [Phone] nvarchar(50) NOT NULL,
    [Address] nvarchar(500) NOT NULL,
    [IsDefault] bit NOT NULL,
    CONSTRAINT [PK_CustomerAddresses] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CustomerAddresses_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId]) ON DELETE CASCADE
);

CREATE TABLE [Wishlists] (
    [WishlistId] int NOT NULL IDENTITY,
    [CustomerId] int NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_Wishlists] PRIMARY KEY ([WishlistId]),
    CONSTRAINT [FK_Wishlists_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId])
);

CREATE TABLE [AttributeValues] (
    [ValueId] int NOT NULL IDENTITY,
    [AttributeId] int NULL,
    [Value] nvarchar(200) NULL,
    CONSTRAINT [PK_AttributeValues] PRIMARY KEY ([ValueId]),
    CONSTRAINT [FK_AttributeValues_ProductAttributes_AttributeId] FOREIGN KEY ([AttributeId]) REFERENCES [ProductAttributes] ([AttributeId])
);

CREATE TABLE [ServiceComboItems] (
    [Id] int NOT NULL IDENTITY,
    [ComboId] int NOT NULL,
    [ServiceId] int NOT NULL,
    CONSTRAINT [PK_ServiceComboItems] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ServiceComboItems_ServiceCombos_ComboId] FOREIGN KEY ([ComboId]) REFERENCES [ServiceCombos] ([ComboId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ServiceComboItems_Services_ServiceId] FOREIGN KEY ([ServiceId]) REFERENCES [Services] ([ServiceId]) ON DELETE CASCADE
);

CREATE TABLE [Staffs] (
    [StaffId] int NOT NULL IDENTITY,
    [UserId] nvarchar(max) NULL,
    [StoreId] int NULL,
    [StaffCode] nvarchar(50) NOT NULL,
    [Position] nvarchar(100) NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_Staffs] PRIMARY KEY ([StaffId]),
    CONSTRAINT [FK_Staffs_Stores_StoreId] FOREIGN KEY ([StoreId]) REFERENCES [Stores] ([StoreId])
);

CREATE TABLE [ProductImages] (
    [ImageId] int NOT NULL IDENTITY,
    [ProductId] int NULL,
    [ImageUrl] nvarchar(500) NOT NULL,
    [IsPrimary] bit NOT NULL,
    [DisplayOrder] int NOT NULL,
    CONSTRAINT [PK_ProductImages] PRIMARY KEY ([ImageId]),
    CONSTRAINT [FK_ProductImages_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId])
);

CREATE TABLE [ProductVariants] (
    [ProductVariantId] int NOT NULL IDENTITY,
    [ProductId] int NULL,
    [BaseUnitId] int NULL,
    [ModelId] int NULL,
    [SKU] nvarchar(100) NULL,
    [VariantName] nvarchar(255) NOT NULL,
    [Price] decimal(18,2) NOT NULL,
    [OriginalPrice] decimal(18,2) NULL,
    [CostPrice] decimal(18,2) NOT NULL,
    [StockQuantity] int NOT NULL,
    [ImageUrl] nvarchar(500) NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_ProductVariants] PRIMARY KEY ([ProductVariantId]),
    CONSTRAINT [FK_ProductVariants_MotorbikeModels_ModelId] FOREIGN KEY ([ModelId]) REFERENCES [MotorbikeModels] ([ModelId]),
    CONSTRAINT [FK_ProductVariants_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]),
    CONSTRAINT [FK_ProductVariants_Units_BaseUnitId] FOREIGN KEY ([BaseUnitId]) REFERENCES [Units] ([UnitId])
);

CREATE TABLE [PromotionProducts] (
    [Id] int NOT NULL IDENTITY,
    [PromotionId] int NOT NULL,
    [ProductId] int NOT NULL,
    CONSTRAINT [PK_PromotionProducts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PromotionProducts_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE,
    CONSTRAINT [FK_PromotionProducts_Promotions_PromotionId] FOREIGN KEY ([PromotionId]) REFERENCES [Promotions] ([PromotionId]) ON DELETE CASCADE
);

CREATE TABLE [WishlistItems] (
    [WishlistItemId] int NOT NULL IDENTITY,
    [WishlistId] int NULL,
    [ProductId] int NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_WishlistItems] PRIMARY KEY ([WishlistItemId]),
    CONSTRAINT [FK_WishlistItems_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]),
    CONSTRAINT [FK_WishlistItems_Wishlists_WishlistId] FOREIGN KEY ([WishlistId]) REFERENCES [Wishlists] ([WishlistId])
);

CREATE TABLE [Orders] (
    [OrderId] int NOT NULL IDENTITY,
    [OrderCode] AS 'DH'+right('000000'+CONVERT([nvarchar],[OrderId]),(6)) PERSISTED,
    [CustomerId] int NULL,
    [StoreId] int NULL,
    [CreatedByStaffId] int NULL,
    [CouponId] int NULL,
    [ShippingMethodId] int NULL,
    [OrderDate] datetime2 NOT NULL,
    [TotalAmount] decimal(18,2) NOT NULL,
    [DiscountAmount] decimal(18,2) NOT NULL,
    [Status] nvarchar(50) NULL,
    [ShippingAddress] nvarchar(500) NULL,
    [PaymentStatus] nvarchar(100) NULL,
    [Note] nvarchar(max) NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([OrderId]),
    CONSTRAINT [FK_Orders_Coupons_CouponId] FOREIGN KEY ([CouponId]) REFERENCES [Coupons] ([Id]),
    CONSTRAINT [FK_Orders_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId]),
    CONSTRAINT [FK_Orders_ShippingMethods_ShippingMethodId] FOREIGN KEY ([ShippingMethodId]) REFERENCES [ShippingMethods] ([Id]),
    CONSTRAINT [FK_Orders_Staffs_CreatedByStaffId] FOREIGN KEY ([CreatedByStaffId]) REFERENCES [Staffs] ([StaffId]),
    CONSTRAINT [FK_Orders_Stores_StoreId] FOREIGN KEY ([StoreId]) REFERENCES [Stores] ([StoreId])
);

CREATE TABLE [ServiceBookings] (
    [BookingId] int NOT NULL IDENTITY,
    [BookingCode] AS 'DV'+right('000000'+CONVERT([nvarchar],[BookingId]),(6)) PERSISTED,
    [CustomerId] int NULL,
    [ServiceId] int NULL,
    [ComboId] int NULL,
    [CreatedByStaffId] int NULL,
    [AssignedStaffId] int NULL,
    [BookingDate] datetime2 NOT NULL,
    [ServiceDate] datetime2 NULL,
    [Status] nvarchar(50) NULL,
    [CustomerFullName] nvarchar(200) NULL,
    [CustomerPhone] nvarchar(50) NULL,
    [CustomerEmail] nvarchar(255) NULL,
    [VehicleBrand] nvarchar(200) NULL,
    [VehicleModel] nvarchar(200) NULL,
    [VehicleYear] int NULL,
    [LicensePlate] nvarchar(50) NULL,
    [Notes] nvarchar(max) NULL,
    [DepositAmount] decimal(18,2) NOT NULL,
    [DepositStatus] nvarchar(50) NULL,
    [TransferProof] nvarchar(500) NULL,
    [ConfirmedAt] datetime2 NULL,
    [ExpireAt] datetime2 NULL,
    [CancelReason] nvarchar(max) NULL,
    CONSTRAINT [PK_ServiceBookings] PRIMARY KEY ([BookingId]),
    CONSTRAINT [FK_ServiceBookings_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId]),
    CONSTRAINT [FK_ServiceBookings_ServiceCombos_ComboId] FOREIGN KEY ([ComboId]) REFERENCES [ServiceCombos] ([ComboId]),
    CONSTRAINT [FK_ServiceBookings_Services_ServiceId] FOREIGN KEY ([ServiceId]) REFERENCES [Services] ([ServiceId]),
    CONSTRAINT [FK_ServiceBookings_Staffs_AssignedStaffId] FOREIGN KEY ([AssignedStaffId]) REFERENCES [Staffs] ([StaffId]),
    CONSTRAINT [FK_ServiceBookings_Staffs_CreatedByStaffId] FOREIGN KEY ([CreatedByStaffId]) REFERENCES [Staffs] ([StaffId])
);

CREATE TABLE [CartItems] (
    [CartItemId] int NOT NULL IDENTITY,
    [CartId] int NOT NULL,
    [ProductVariantId] int NOT NULL,
    [Quantity] int NOT NULL,
    [Price] decimal(18,2) NOT NULL,
    CONSTRAINT [PK_CartItems] PRIMARY KEY ([CartItemId]),
    CONSTRAINT [FK_CartItems_Carts_CartId] FOREIGN KEY ([CartId]) REFERENCES [Carts] ([CartId]) ON DELETE CASCADE,
    CONSTRAINT [FK_CartItems_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([ProductVariantId]) ON DELETE CASCADE
);

CREATE TABLE [InventoryTransactions] (
    [TransactionId] int NOT NULL IDENTITY,
    [ProductVariantId] int NULL,
    [Quantity] int NOT NULL,
    [TransactionType] nvarchar(50) NOT NULL,
    [TransactionDate] datetime2 NOT NULL,
    [Note] nvarchar(max) NULL,
    CONSTRAINT [PK_InventoryTransactions] PRIMARY KEY ([TransactionId]),
    CONSTRAINT [FK_InventoryTransactions_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([ProductVariantId])
);

CREATE TABLE [ProductReviews] (
    [ReviewId] int NOT NULL IDENTITY,
    [ProductId] int NULL,
    [ProductVariantId] int NULL,
    [CustomerId] int NULL,
    [Rating] int NOT NULL,
    [Comment] nvarchar(max) NULL,
    [CreatedDate] datetime2 NOT NULL,
    [Status] nvarchar(20) NOT NULL,
    CONSTRAINT [PK_ProductReviews] PRIMARY KEY ([ReviewId]),
    CONSTRAINT [FK_ProductReviews_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId]),
    CONSTRAINT [FK_ProductReviews_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([ProductVariantId]),
    CONSTRAINT [FK_ProductReviews_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId])
);

CREATE TABLE [ProductVariantAttributeValue] (
    [Id] int NOT NULL IDENTITY,
    [ProductVariantId] int NOT NULL,
    [ValueId] int NOT NULL,
    CONSTRAINT [PK_ProductVariantAttributeValue] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ProductVariantAttributeValue_AttributeValues_ValueId] FOREIGN KEY ([ValueId]) REFERENCES [AttributeValues] ([ValueId]) ON DELETE CASCADE,
    CONSTRAINT [FK_ProductVariantAttributeValue_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([ProductVariantId]) ON DELETE CASCADE
);

CREATE TABLE [OrderItems] (
    [OrderItemId] int NOT NULL IDENTITY,
    [OrderId] int NULL,
    [ProductVariantId] int NULL,
    [Quantity] int NOT NULL,
    [Price] decimal(18,2) NOT NULL,
    CONSTRAINT [PK_OrderItems] PRIMARY KEY ([OrderItemId]),
    CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([OrderId]),
    CONSTRAINT [FK_OrderItems_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([ProductVariantId])
);

CREATE TABLE [OrderStatusHistories] (
    [HistoryId] int NOT NULL IDENTITY,
    [OrderId] int NULL,
    [Status] nvarchar(100) NULL,
    [ChangedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_OrderStatusHistories] PRIMARY KEY ([HistoryId]),
    CONSTRAINT [FK_OrderStatusHistories_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([OrderId])
);

CREATE TABLE [Payments] (
    [PaymentId] int NOT NULL IDENTITY,
    [OrderId] int NULL,
    [PaymentMethod] nvarchar(100) NULL,
    [PaymentStatus] nvarchar(100) NULL,
    [PaidDate] datetime2 NULL,
    CONSTRAINT [PK_Payments] PRIMARY KEY ([PaymentId]),
    CONSTRAINT [FK_Payments_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([OrderId])
);

CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);

CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;

CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);

CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);

CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);

CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);

CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;

CREATE INDEX [IX_AttributeValues_AttributeId] ON [AttributeValues] ([AttributeId]);

CREATE INDEX [IX_Blogs_CategoryId] ON [Blogs] ([CategoryId]);

CREATE INDEX [IX_CartItems_CartId] ON [CartItems] ([CartId]);

CREATE INDEX [IX_CartItems_ProductVariantId] ON [CartItems] ([ProductVariantId]);

CREATE INDEX [IX_Carts_CustomerId] ON [Carts] ([CustomerId]);

CREATE INDEX [IX_Categories_ParentId] ON [Categories] ([ParentId]);

CREATE INDEX [IX_CustomerAddresses_CustomerId] ON [CustomerAddresses] ([CustomerId]);

CREATE INDEX [IX_InventoryTransactions_ProductVariantId] ON [InventoryTransactions] ([ProductVariantId]);

CREATE INDEX [IX_MotorbikeModels_ParentId] ON [MotorbikeModels] ([ParentId]);

CREATE INDEX [IX_OrderItems_OrderId] ON [OrderItems] ([OrderId]);

CREATE INDEX [IX_OrderItems_ProductVariantId] ON [OrderItems] ([ProductVariantId]);

CREATE INDEX [IX_Orders_CouponId] ON [Orders] ([CouponId]);

CREATE INDEX [IX_Orders_CreatedByStaffId] ON [Orders] ([CreatedByStaffId]);

CREATE INDEX [IX_Orders_CustomerId] ON [Orders] ([CustomerId]);

CREATE INDEX [IX_Orders_ShippingMethodId] ON [Orders] ([ShippingMethodId]);

CREATE INDEX [IX_Orders_StoreId] ON [Orders] ([StoreId]);

CREATE INDEX [IX_OrderStatusHistories_OrderId] ON [OrderStatusHistories] ([OrderId]);

CREATE INDEX [IX_Payments_OrderId] ON [Payments] ([OrderId]);

CREATE INDEX [IX_ProductImages_ProductId] ON [ProductImages] ([ProductId]);

CREATE INDEX [IX_ProductReviews_CustomerId] ON [ProductReviews] ([CustomerId]);

CREATE INDEX [IX_ProductReviews_ProductId] ON [ProductReviews] ([ProductId]);

CREATE INDEX [IX_ProductReviews_ProductVariantId] ON [ProductReviews] ([ProductVariantId]);

CREATE INDEX [IX_Products_BrandId] ON [Products] ([BrandId]);

CREATE INDEX [IX_Products_CategoryId] ON [Products] ([CategoryId]);

CREATE INDEX [IX_ProductVariantAttributeValue_ProductVariantId] ON [ProductVariantAttributeValue] ([ProductVariantId]);

CREATE INDEX [IX_ProductVariantAttributeValue_ValueId] ON [ProductVariantAttributeValue] ([ValueId]);

CREATE INDEX [IX_ProductVariants_BaseUnitId] ON [ProductVariants] ([BaseUnitId]);

CREATE INDEX [IX_ProductVariants_ModelId] ON [ProductVariants] ([ModelId]);

CREATE INDEX [IX_ProductVariants_ProductId] ON [ProductVariants] ([ProductId]);

CREATE INDEX [IX_PromotionProducts_ProductId] ON [PromotionProducts] ([ProductId]);

CREATE INDEX [IX_PromotionProducts_PromotionId] ON [PromotionProducts] ([PromotionId]);

CREATE INDEX [IX_ServiceBookings_AssignedStaffId] ON [ServiceBookings] ([AssignedStaffId]);

CREATE INDEX [IX_ServiceBookings_ComboId] ON [ServiceBookings] ([ComboId]);

CREATE INDEX [IX_ServiceBookings_CreatedByStaffId] ON [ServiceBookings] ([CreatedByStaffId]);

CREATE INDEX [IX_ServiceBookings_CustomerId] ON [ServiceBookings] ([CustomerId]);

CREATE INDEX [IX_ServiceBookings_ServiceId] ON [ServiceBookings] ([ServiceId]);

CREATE INDEX [IX_ServiceComboItems_ComboId] ON [ServiceComboItems] ([ComboId]);

CREATE INDEX [IX_ServiceComboItems_ServiceId] ON [ServiceComboItems] ([ServiceId]);

CREATE INDEX [IX_Staffs_StoreId] ON [Staffs] ([StoreId]);

CREATE INDEX [IX_WishlistItems_ProductId] ON [WishlistItems] ([ProductId]);

CREATE INDEX [IX_WishlistItems_WishlistId] ON [WishlistItems] ([WishlistId]);

CREATE INDEX [IX_Wishlists_CustomerId] ON [Wishlists] ([CustomerId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260421144152_InitialCreate', N'9.0.0');

ALTER TABLE [OrderStatusHistories] DROP CONSTRAINT [FK_OrderStatusHistories_Orders_OrderId];

ALTER TABLE [OrderStatusHistories] DROP CONSTRAINT [PK_OrderStatusHistories];

EXEC sp_rename N'[OrderStatusHistories]', N'OrderStatusHistory', 'OBJECT';

EXEC sp_rename N'[OrderStatusHistory].[IX_OrderStatusHistories_OrderId]', N'IX_OrderStatusHistory_OrderId', 'INDEX';

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Services]') AND [c].[name] = N'IsActive');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Services] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [Services] ALTER COLUMN [IsActive] bit NULL;

ALTER TABLE [Services] ADD [CategoryId] int NULL;

ALTER TABLE [Services] ADD [Duration] int NULL;

ALTER TABLE [Services] ADD [ShortDescription] nvarchar(max) NULL;

ALTER TABLE [Services] ADD [Slug] nvarchar(max) NULL;

ALTER TABLE [Services] ADD [TotalBookings] int NULL;

ALTER TABLE [Services] ADD [WarrantyDays] int NULL;

ALTER TABLE [Orders] ADD [PaymentMethod] nvarchar(100) NULL;

ALTER TABLE [Customers] ADD [AvatarUrl] nvarchar(max) NULL;

ALTER TABLE [Coupons] ADD [AppliedCategoryIds] nvarchar(max) NULL;

ALTER TABLE [Coupons] ADD [AppliedProductIds] nvarchar(max) NULL;

ALTER TABLE [Coupons] ADD [IsAllProducts] bit NULL;

ALTER TABLE [Categories] ADD [Icon] nvarchar(max) NULL;

ALTER TABLE [Categories] ADD [IsActive] bit NOT NULL DEFAULT CAST(0 AS bit);

ALTER TABLE [Blogs] ADD [MetaDescription] nvarchar(max) NULL;

ALTER TABLE [Blogs] ADD [MetaTitle] nvarchar(max) NULL;

ALTER TABLE [Banners] ADD [DisplayOrder] int NOT NULL DEFAULT 0;

ALTER TABLE [OrderStatusHistory] ADD CONSTRAINT [PK_OrderStatusHistory] PRIMARY KEY ([HistoryId]);

CREATE TABLE [AddressesNew] (
    [Id] int NOT NULL IDENTITY,
    [CustomerId] int NOT NULL,
    [FullName] nvarchar(max) NULL,
    [Phone] nvarchar(max) NULL,
    [Province] nvarchar(max) NULL,
    [District] nvarchar(max) NULL,
    [Ward] nvarchar(max) NULL,
    [Street] nvarchar(max) NULL,
    [IsDefault] bit NOT NULL,
    CONSTRAINT [PK_AddressesNew] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AddressesNew_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId]) ON DELETE CASCADE
);

CREATE TABLE [ChatMessages] (
    [Id] int NOT NULL IDENTITY,
    [SenderId] nvarchar(max) NULL,
    [SessionId] nvarchar(max) NOT NULL,
    [Message] nvarchar(max) NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    [IsFromAdmin] bit NOT NULL,
    [IsRead] bit NOT NULL,
    CONSTRAINT [PK_ChatMessages] PRIMARY KEY ([Id])
);

CREATE TABLE [ServiceCategories] (
    [CategoryId] int NOT NULL IDENTITY,
    [CategoryName] nvarchar(100) NOT NULL,
    [Slug] nvarchar(max) NULL,
    [Icon] nvarchar(max) NULL,
    [IsActive] bit NOT NULL,
    CONSTRAINT [PK_ServiceCategories] PRIMARY KEY ([CategoryId])
);

CREATE TABLE [ServiceReviews] (
    [ReviewId] int NOT NULL IDENTITY,
    [ServiceId] int NOT NULL,
    [CustomerId] int NULL,
    [Rating] int NOT NULL,
    [Comment] nvarchar(max) NULL,
    [IsApproved] bit NOT NULL,
    [CreatedDate] datetime2 NOT NULL,
    CONSTRAINT [PK_ServiceReviews] PRIMARY KEY ([ReviewId]),
    CONSTRAINT [FK_ServiceReviews_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([CustomerId]),
    CONSTRAINT [FK_ServiceReviews_Services_ServiceId] FOREIGN KEY ([ServiceId]) REFERENCES [Services] ([ServiceId]) ON DELETE CASCADE
);

CREATE TABLE [WishlistsNew] (
    [Id] int NOT NULL IDENTITY,
    [UserId] int NOT NULL,
    [ProductId] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    CONSTRAINT [PK_WishlistsNew] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_WishlistsNew_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE
);

CREATE INDEX [IX_Services_CategoryId] ON [Services] ([CategoryId]);

CREATE INDEX [IX_AddressesNew_CustomerId] ON [AddressesNew] ([CustomerId]);

CREATE INDEX [IX_ServiceReviews_CustomerId] ON [ServiceReviews] ([CustomerId]);

CREATE INDEX [IX_ServiceReviews_ServiceId] ON [ServiceReviews] ([ServiceId]);

CREATE INDEX [IX_WishlistsNew_ProductId] ON [WishlistsNew] ([ProductId]);

ALTER TABLE [OrderStatusHistory] ADD CONSTRAINT [FK_OrderStatusHistory_Orders_OrderId] FOREIGN KEY ([OrderId]) REFERENCES [Orders] ([OrderId]);

ALTER TABLE [Services] ADD CONSTRAINT [FK_Services_ServiceCategories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [ServiceCategories] ([CategoryId]);

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260505085545_AddChatMessages', N'9.0.0');

ALTER TABLE [Products] DROP CONSTRAINT [FK_Products_Brands_BrandId];

ALTER TABLE [Products] DROP CONSTRAINT [FK_Products_Categories_CategoryId];

ALTER TABLE [ProductVariants] ADD [MinStockLevel] int NOT NULL DEFAULT 0;

ALTER TABLE [Products] ADD [SoldCount] int NOT NULL DEFAULT 0;

ALTER TABLE [ProductImages] ADD [MediaType] nvarchar(10) NOT NULL DEFAULT N'';

ALTER TABLE [ProductImages] ADD [VideoUrl] nvarchar(500) NULL;

CREATE TABLE [ProductSpecifications] (
    [SpecId] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [SpecName] nvarchar(100) NOT NULL,
    [SpecValue] nvarchar(500) NOT NULL,
    [DisplayOrder] int NOT NULL,
    CONSTRAINT [PK_ProductSpecifications] PRIMARY KEY ([SpecId]),
    CONSTRAINT [FK_ProductSpecifications_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE
);

CREATE TABLE [ProductTags] (
    [TagId] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [TagName] nvarchar(100) NOT NULL,
    CONSTRAINT [PK_ProductTags] PRIMARY KEY ([TagId]),
    CONSTRAINT [FK_ProductTags_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE
);

CREATE TABLE [VariantImages] (
    [VariantImageId] int NOT NULL IDENTITY,
    [ProductVariantId] int NOT NULL,
    [ImageUrl] nvarchar(500) NOT NULL,
    [IsPrimary] bit NOT NULL,
    [DisplayOrder] int NOT NULL,
    CONSTRAINT [PK_VariantImages] PRIMARY KEY ([VariantImageId]),
    CONSTRAINT [FK_VariantImages_ProductVariants_ProductVariantId] FOREIGN KEY ([ProductVariantId]) REFERENCES [ProductVariants] ([ProductVariantId]) ON DELETE CASCADE
);

CREATE INDEX [IX_ProductSpecifications_ProductId] ON [ProductSpecifications] ([ProductId]);

CREATE INDEX [IX_ProductTags_ProductId] ON [ProductTags] ([ProductId]);

CREATE INDEX [IX_VariantImages_ProductVariantId] ON [VariantImages] ([ProductVariantId]);

ALTER TABLE [Products] ADD CONSTRAINT [FK_Products_Brands_BrandId] FOREIGN KEY ([BrandId]) REFERENCES [Brands] ([BrandId]) ON DELETE NO ACTION;

ALTER TABLE [Products] ADD CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([CategoryId]) ON DELETE NO ACTION;

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260507034019_UpdateProductShopeeStyle', N'9.0.0');

COMMIT;
GO

