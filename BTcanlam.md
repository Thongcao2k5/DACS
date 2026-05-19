# Danh sách việc cần làm - MotoShop DACS

## ✅ Đã sửa (Critical — hoàn tất)

### 1. ~~Product.SoldCount không được cập nhật~~ ✅ ĐÃ SỬA
- `CompleteOrderAsync` (OrderService.cs:332) cập nhật `SoldCount` bằng `ExecuteUpdateAsync`
- Được gọi từ AdminOrderController khi status chuyển sang "Completed"

### 2. ~~FlashSale.SoldQuantity không được cập nhật~~ ✅ ĐÃ SỬA
- `ReservePromotionQuantityAsync` (OrderService.cs:354) cập nhật `PromotionProduct.SoldQuantity` trong `CreateOrderAsync`
- Hệ thống đã migrate sang `Promotion`/`PromotionProduct` (thay thế `FlashSale`/`FlashSaleProduct` cũ)

### 3. ~~Credentials lộ trong appsettings.json~~ ✅ ĐÃ SỬA
- `appsettings.json` chỉ còn placeholder values (`YOUR_GMAIL_USER`, `YOUR_VNPAY_HASH_SECRET`...)
- Credentials thật được cấu hình local, không commit lên git

### 4. ~~Startup exception bị nuốt~~ ✅ ĐÃ SỬA
- `Program.cs` catch block đã có `throw;` — app sẽ crash đúng cách nếu seed lỗi

---

## ✅ Đã sửa (High Priority — hoàn tất)

### 5. ~~Hai bảng trùng lặp chưa migrate xong~~ ✅ ĐÃ SỬA
- `Customer.Addresses` → `ICollection<AddressNew>` (bảng `AddressesNew`)
- DbContext chỉ có `WishlistsNew` + `AddressesNew`, không có DbSet cũ
- Bảng `Wishlists`/`CustomerAddresses` cũ còn trong DB nhưng code không dùng — không ảnh hưởng

### 6. ~~FileService không validate file upload~~ ✅ ĐÃ SỬA
- `FileService.cs` có đủ: whitelist extension (jpg/png/webp), MIME type check, giới hạn 5MB, magic bytes validation (byte header thực tế của file)

### 7. ~~Không validate pageNumber/pageSize trong controllers~~ ✅ ĐÃ SỬA
- Tất cả action có pagination đều có `Math.Max(1, page)` + `Math.Clamp(pageSize, 1, 100)`

---

## 🟠 Khi rảnh (Medium Priority)

### 8. CORS AllowAll
- **Vị trí:** `src/MotoShop/Program.cs`
- **Vấn đề:** `.SetIsOriginAllowed(origin => true)` cho phép mọi origin
- **Fix:** Khi deploy production, đổi thành domain cụ thể

### 9. FlashSale logic nhân bản ở 4 nơi
- **Vị trí:** CartService + OrderService + ProductService + MappingProfile
- **Vấn đề:** Cùng logic tính giá flash sale, dễ sinh bug nếu sửa 1 nơi quên nơi khác
- **Fix:** Tách thành 1 private method hoặc helper class dùng chung

### 10. Cache key hardcoded, không có cache invalidation
- **Vị trí:** `src/MotoShop/Controllers/HomeController.cs`
- **Vấn đề:** `"home_featured_8"`, `"all_categories"` hardcode, cache không bị xóa khi admin cập nhật dữ liệu
- **Fix:** Dùng constants, thêm cache invalidation khi lưu/xóa product/category

### 11. BookingExpiryService không có lock (race condition)
- **Vị trí:** `src/MotoShop/Services/` (background hosted service)
- **Vấn đề:** Nếu chạy nhiều instance hoặc timer chồng nhau có thể xử lý 2 lần
- **Fix:** Thêm `SemaphoreSlim` hoặc check trước khi update

---

## 🟢 Sau bảo vệ (Low Priority / Code Quality)

### 12. Hardcoded strings rải rác
- **Vấn đề:** `"Approved"`, `"Pending"`, `"Đã kết thúc"` nằm ở nhiều file
- **Fix:** Tạo static class `OrderStatus`, `BookingStatus` với constants

### 13. Email HTML hardcode 450+ dòng
- **Vị trí:** `src/MotoShop.Business/Services/EmailService.cs`
- **Fix:** Chuyển sang Razor template (.cshtml) hoặc file HTML riêng

### 14. Models không dùng đến
- `ProductTag` — định nghĩa nhưng không có UI
- `ProductAttribute`, `AttributeValue` — chưa có trang quản lý
- Có thể bỏ qua nếu không có thời gian implement

### 15. Không có unit tests
- Toàn bộ dự án chưa có test coverage
- Ưu tiên test: OrderService, CartService, FlashSaleService

---

## Ghi chú thêm

- **Admin credentials mặc định:** `admin@motoshop.vn / Admin@123`
- **Database:** `MotorcycleShopDB` trên `MSI\SQLEXPRESS`
- **Port dev:** `https://localhost:7106`
- **VnPay:** Đang dùng sandbox endpoint
- **Migrations:** 5 versions, migration mới nhất `20260512011755_FixCustomerUserIdColumnType`
