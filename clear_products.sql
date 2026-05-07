-- SCRIPT XÓA TOÀN BỘ SẢN PHẨM NHƯNG GIỮ THƯƠNG HIỆU VÀ DANH MỤC
-- Dự án: MotoShop DACS (Đã sửa lỗi tên bảng)

BEGIN TRANSACTION;
BEGIN TRY
    -- 1. Xóa các bảng liên quan đến giao dịch và giỏ hàng (phụ thuộc vào ProductVariant)
    DELETE FROM CartItems;
    DELETE FROM InventoryTransactions;
    DELETE FROM OrderItems;
    DELETE FROM ProductReviews;
    
    -- 2. Xóa các bảng liên quan đến khuyến mãi và wishlist (phụ thuộc vào Product/Variant)
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSaleProducts') DELETE FROM FlashSaleProducts;
    DELETE FROM PromotionProducts;
    
    -- Xóa các bảng Wishlist (thử nhiều tên khác nhau dựa trên schema)
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Custom_Wishlists') DELETE FROM Custom_Wishlists;
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistItems') DELETE FROM WishlistItems;
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Wishlists') DELETE FROM Wishlists;
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'WishlistsNew') DELETE FROM WishlistsNew;
    
    -- 3. Xóa các bảng thuộc tính và hình ảnh
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductVariantAttributeValue') DELETE FROM ProductVariantAttributeValue;
    DELETE FROM ProductImages;
    
    -- 4. Xóa Biến thể và Sản phẩm
    DELETE FROM ProductVariants;
    DELETE FROM Products;

    -- 5. Reset IDENTITY (để ID bắt đầu lại từ 1)
    DBCC CHECKIDENT ('Products', RESEED, 0);
    DBCC CHECKIDENT ('ProductVariants', RESEED, 0);
    DBCC CHECKIDENT ('ProductImages', RESEED, 0);
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FlashSaleProducts') DBCC CHECKIDENT ('FlashSaleProducts', RESEED, 0);
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductVariantAttributeValue') DBCC CHECKIDENT ('ProductVariantAttributeValue', RESEED, 0);

    PRINT 'Da xoa toan bo san pham va du lieu lien quan thanh cong.';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Loi trong qua trinh xoa du lieu: ' + ERROR_MESSAGE();
END CATCH;
