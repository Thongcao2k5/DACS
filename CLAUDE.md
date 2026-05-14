# MotoShop DACS — Claude Code Instructions

## Tổng quan dự án

**MotoShop** là website thương mại điện tử bán phụ tùng và dịch vụ xe máy (UI kiểu Shopee), được xây dựng bằng ASP.NET Core 9 MVC + SQL Server. Đây là đồ án đại học (DACS).

- **Dev URL:** `https://localhost:7106`
- **Database:** `MotorcycleShopDB` trên `MSI\SQLEXPRESS` (Windows Auth, TrustServerCertificate)
- **Admin mặc định:** `admin@motoshop.vn / Admin@123`
- **VNPay:** Đang dùng sandbox endpoint

---

## Kiến trúc dự án (3-tier)

```
src/
├── MotoShop/               # Presentation Layer
│   ├── Controllers/        # Public controllers
│   ├── Areas/Admin/        # Admin area (21 controllers)
│   ├── Views/              # Razor views
│   ├── ViewComponents/     # View components
│   ├── Services/           # Background services (e.g., BookingExpiryService)
│   ├── wwwroot/            # Static files (uploads/, lib/)
│   └── Program.cs          # Entry point: DI, middleware, raw SQL schema updates
│
├── MotoShop.Business/      # Business Logic Layer
│   ├── Services/           # Business services
│   ├── Interfaces/         # Service interfaces
│   ├── DTOs/               # Data transfer objects
│   ├── Mappings/           # AutoMapper profiles (MappingProfile.cs)
│   └── Helpers/            # Utility helpers
│
└── MotoShop.Data/          # Data Layer
    ├── Data/               # MotoShopDbContext.cs, DbSeeder.cs
    ├── Models/             # MotoShopModels.cs (TẤT CẢ entities trong 1 file)
    ├── Repositories/       # Repository implementations
    ├── Interfaces/         # Repository interfaces
    └── Migrations/         # EF Core migrations
```

---

## Tech Stack

| Thành phần | Chi tiết |
|---|---|
| Framework | ASP.NET Core 9.0 MVC |
| ORM | EF Core 9.0 + Repository + UnitOfWork |
| Database | SQL Server (MSI\SQLEXPRESS) |
| Auth | ASP.NET Core Identity (cookie 7 ngày, lockout 5 lần) |
| Mapping | AutoMapper 14 |
| Logging | Serilog (rolling file `Logs/log-.txt`, giữ 7 ngày) |
| Image | SixLabors.ImageSharp |
| Export | ClosedXML (Excel) |
| Payment | VNPay + Bank transfer |
| Email | Gmail SMTP (cấu hình trong appsettings.json) |
| OAuth | Google + Facebook |

---

## Controllers

### Public Controllers (`src/MotoShop/Controllers/`)
`HomeController`, `ProductController`, `CartController`, `OrderController`, `AccountController`, `ServiceController`, `BookingController`, `PaymentController`, `BlogController`, `WishlistController`, `ReviewController`, `ChatController`, `AddressController`, `InfoController`, `NewsletterController`, `ConsultationController`, `ProductReviewAddonController`

API: `Api/AccountApiController`, `Api/HomeApiController`

### Admin Controllers (`src/MotoShop/Areas/Admin/Controllers/`)
`HomeController`, `ProductController`, `CategoryController`, `BrandController`, `OrderController`, `CustomerController`, `BookingController`, `ServiceController`, `InventoryController`, `CouponController`, `PromotionController`, `FlashSaleController`, `BlogController`, `ReviewController`, `SliderBannerController`, `ShippingMethodController`, `UnitController`, `ChatController`, `ReportController`, `AccountController`, `AuditLogController`

---

## Quy tắc bắt buộc (từ GEMINI.md)

### Product & Variant
1. **1 Product = Nhiều Variants** — luôn gom các phiên bản khác nhau vào cùng `ProductId`
   - Ví dụ: "Bi nồi Malossi" là 1 Product; "9g", "10g", "11g" là Variants
2. **KHÔNG tách Product** — không tạo Product riêng cho từng variant, sẽ vỡ UI chọn nhóm
3. **Attribute nhất quán** — dùng "Trọng lượng" với values "9g", "10g"; không mix "9g", "9 gram", "0.01kg"
4. **SKU duy nhất** — mỗi `ProductVariant` phải có SKU riêng, format gợi ý: `[BRAND]-[MODEL]-[VARIANT]`

### Frontend
- Variant selection dùng: `selectAttr`, `checkVariants`, `updateUrl` trong `Details.cshtml`
- `variantId` được track trong URL query string để share link variant cụ thể
- `handleAddToCart` và `handleBuyNow` phải luôn nhận `variantId` và `quantity`

---

## Quy tắc làm việc với code

### Thêm tính năng mới
1. Định nghĩa entity trong `MotoShopModels.cs`
2. Tạo interface trong `MotoShop.Business/Interfaces/`
3. Implement service trong `MotoShop.Business/Services/`
4. Đăng ký DI trong `Program.cs`
5. Nếu cần schema DB mới: **ưu tiên raw SQL trong `Program.cs`** thay vì tạo migration mới

### Migration
- Hiện có 5 migrations, mới nhất: `20260512011755_FixCustomerUserIdColumnType`
- **Không tạo migration mới** khi có thể dùng raw SQL trong `Program.cs` startup

### File upload
- Static files lưu trong `wwwroot/uploads/` (avatars, products, blogs, services, deposits)
- Whitelist extension: jpg, png, webp; giới hạn max 5MB

### Pagination
- Luôn validate: `pageNumber = Math.Max(1, pageNumber)`, `pageSize = Math.Clamp(pageSize, 1, 100)`

---

## Các vấn đề đã biết (BTcanlam.md)

### Critical
- `Product.SoldCount` không tăng khi order hoàn thành → mục "bán chạy" sai
- `FlashSale.SoldQuantity` không giảm sau order → nguy cơ oversell
- Credentials lộ trong `appsettings.json` (Gmail, Google/Facebook secret, VnPay hash)
- Startup exception bị nuốt ở `Program.cs` ~351 (thiếu `throw;`)

### High Priority (trước demo)
- Hai bảng trùng: `Wishlists`/`WishlistsNew`, `Addresses`/`AddressesNew`
- `FileService.UploadAsync()` chưa validate extension/size/mime
- Thiếu validate pageNumber/pageSize trong controllers

### Medium Priority
- CORS `AllowAll` — chỉ dev, cần đổi khi deploy production
- FlashSale logic nhân bản ở 4 nơi (CartService, OrderService, ProductService, MappingProfile)
- Cache key hardcoded, không có cache invalidation

---

## Key Files nhanh

| File | Mục đích |
|---|---|
| `src/MotoShop/Program.cs` | DI registration, middleware, raw SQL schema |
| `src/MotoShop.Data/Models/MotoShopModels.cs` | Tất cả entity models |
| `src/MotoShop.Data/Data/MotoShopDbContext.cs` | EF DbContext (kế thừa IdentityDbContext) |
| `src/MotoShop.Data/Data/DbSeeder.cs` | Seed dữ liệu ban đầu |
| `src/MotoShop.Business/Mappings/MappingProfile.cs` | AutoMapper profiles |
| `src/MotoShop/appsettings.json` | Config (DB, Email, VNPay, OAuth) |
| `GEMINI.md` | Quy tắc Product/Variant (đọc trước khi sửa product) |
| `BTcanlam.md` | Danh sách bug và việc cần làm |
