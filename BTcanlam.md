# Danh sách việc cần làm - MotoShop DACS

## 🔴 Sửa ngay (Critical)

### 1. Product.SoldCount không được cập nhật
- **Vị trí:** `src/MotoShop.Business/Services/OrderService.cs`
- **Vấn đề:** `SoldCount` tồn tại nhưng không tăng khi đơn hàng hoàn thành
- **Hậu quả:** Mục "bán chạy nhất" trên trang chủ luôn hiển thị sai
- **Fix:** Sau khi order Completed, tăng `Product.SoldCount += quantity` cho mỗi OrderItem

### 2. FlashSale.SoldQuantity không được cập nhật
- **Vị trí:** `src/MotoShop.Business/Services/OrderService.cs`
- **Vấn đề:** Số lượng đã bán của flash sale không giảm khi order xong
- **Hậu quả:** Có thể bán quá số lượng cho phép (oversell)
- **Fix:** Sau khi order thành công, giảm `FlashSaleProduct.SoldQuantity += quantity`

### 3. Credentials lộ trong appsettings.json
- **Vị trí:** `src/MotoShop/appsettings.json`
- **Vấn đề:** Gmail password, Google/Facebook secret, VnPay hash secret để plain text trong git
- **Fix:** Chuyển sang User Secrets (`dotnet user-secrets set`) hoặc environment variables

### 4. Startup exception bị nuốt
- **Vị trí:** `src/MotoShop/Program.cs` dòng ~351
- **Vấn đề:** `catch (Exception ex) { Log.Error(...); }` — app vẫn khởi động nếu seed lỗi
- **Fix:** Thêm `throw;` hoặc `Environment.Exit(1)` sau Log.Error để fail fast

---

## 🟡 Trước demo (High Priority)

### 5. Hai bảng trùng lặp chưa migrate xong
- **Vấn đề:** `Wishlists` + `WishlistsNew`, `Addresses` + `AddressesNew` — code dùng cả hai
- **Fix:** Xóa bảng legacy, chuyển toàn bộ code sang dùng bảng mới

### 6. FileService không validate file upload
- **Vị trí:** `src/MotoShop.Business/Services/FileService.cs`
- **Vấn đề:** `UploadAsync()` chấp nhận mọi loại file, không kiểm tra extension/size/mime
- **Fix:** Thêm whitelist extension (jpg, png, webp), giới hạn max size (5MB)

### 7. Không validate pageNumber/pageSize trong controllers
- **Vị trí:** ProductController, OrderController, AdminController
- **Vấn đề:** Tham số có thể âm hoặc cực lớn gây lỗi/chậm
- **Fix:** `pageNumber = Math.Max(1, pageNumber)`, `pageSize = Math.Clamp(pageSize, 1, 100)`

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
