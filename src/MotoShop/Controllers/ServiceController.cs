using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using Microsoft.AspNetCore.Authorization;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Security.Claims;
using Microsoft.AspNetCore.Identity;

namespace MotoShop.Controllers
{
    public class ServiceController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IBookingService _bookingService;
        private readonly IUnitOfWork _uow;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IAuditLogService _auditLogService;

        public ServiceController(MotoShopDbContext context, IBookingService bookingService, IUnitOfWork uow, UserManager<IdentityUser> userManager, IAuditLogService auditLogService)
        {
            _context = context;
            _bookingService = bookingService;
            _uow = uow;
            _userManager = userManager;
            _auditLogService = auditLogService;
        }

        public async Task<IActionResult> Index(int? categoryId)
        {
            // 1. Lấy danh sách danh mục để hiển thị bộ lọc (Sidebar)
            var categories = await _context.ServiceCategories
                .Where(c => c.IsActive)
                .OrderBy(c => c.DisplayOrder)
                .ThenBy(c => c.CategoryName)
                .ToListAsync();
            ViewBag.ServiceCategories = categories;

            // Đếm dịch vụ active theo từng danh mục (tránh dùng nav property chưa Include)
            var serviceCounts = await _context.Services
                .Where(s => s.IsActive == true && s.CategoryId.HasValue)
                .GroupBy(s => s.CategoryId!.Value)
                .Select(g => new { CategoryId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.CategoryId, x => x.Count);
            ViewBag.ServiceCounts = serviceCounts;

            // 2. Lấy danh sách dịch vụ thực tế
            var query = _context.Services
                .Include(s => s.ServiceCategory)
                .Where(s => s.IsActive == true);

            // Lọc theo danh mục nếu có chọn
            if (categoryId.HasValue)
            {
                query = query.Where(s => s.CategoryId == categoryId.Value);
                ViewBag.CurrentCategoryId = categoryId.Value;
            }

            var services = await query
                .OrderByDescending(s => s.TotalBookings)
                .ToListAsync();

            return View(services);
        }

        public async Task<IActionResult> Details(string slug)
        {
            if (string.IsNullOrEmpty(slug)) return RedirectToAction("Index");

            // Thử tìm theo Slug trước, nếu không thấy và slug là số thì tìm theo ID
            var service = await _context.Services
                .Include(s => s.ServiceCategory)
                .Include(s => s.Reviews.Where(r => r.IsApproved))
                    .ThenInclude(r => r.Customer)
                .FirstOrDefaultAsync(s => s.Slug == slug && s.IsActive == true);

            if (service == null && int.TryParse(slug, out int id))
            {
                service = await _context.Services
                    .Include(s => s.ServiceCategory)
                    .Include(s => s.Reviews.Where(r => r.IsApproved))
                        .ThenInclude(r => r.Customer)
                    .FirstOrDefaultAsync(s => s.ServiceId == id && s.IsActive == true);
            }

            if (service == null) return NotFound();

            // Dịch vụ liên quan (cùng danh mục)
            ViewBag.RelatedServices = await _context.Services
                .Where(s => s.IsActive == true && s.ServiceId != service.ServiceId && s.CategoryId == service.CategoryId)
                .Take(3)
                .ToListAsync();

            // Slots còn lại hôm nay (Ví dụ 16 slots mỗi ngày)
            var bookedToday = await _context.ServiceBookings
                .CountAsync(b => b.ServiceId == service.ServiceId && b.ServiceDate.HasValue && b.ServiceDate.Value.Date == DateTime.Today && b.Status != "Cancelled");
            ViewBag.RemainingSlots = Math.Max(0, 16 - bookedToday);

            // Cọc trước 30%
            ViewBag.DepositAmount = Math.Ceiling(service.Price * 0.3m / 1000) * 1000;

            // Thông tin cửa hàng từ settings
            var settings = await _context.StoreSettings.FirstOrDefaultAsync();
            ViewBag.StorePhone = settings?.Phone ?? "0123.456.789";
            ViewBag.StoreAddress = settings?.Address ?? "Địa chỉ MotoShop";

            // Kiểm tra quyền đánh giá (đã hoàn thành dịch vụ này)
            var userId = _userManager.GetUserId(User);
            bool canReview = false;
            bool hasReviewed = false;

            if (!string.IsNullOrEmpty(userId))
            {
                var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
                if (customer != null)
                {
                    canReview = await _context.ServiceBookings.AnyAsync(b => b.CustomerId == customer.CustomerId && b.ServiceId == service.ServiceId && b.Status == "Completed");
                    hasReviewed = await _context.ServiceReviews.AnyAsync(r => r.CustomerId == customer.CustomerId && r.ServiceId == service.ServiceId);
                }
            }

            ViewBag.CanReview = canReview;
            ViewBag.HasReviewed = hasReviewed;

            // Tính toán Rating
            ViewBag.AvgRating = service.Reviews.Any() ? Math.Round(service.Reviews.Average(r => r.Rating), 1) : 0;
            ViewBag.RatingBreakdown = Enumerable.Range(1, 5).Reverse()
                .Select(star => new {
                    Star = star,
                    Count = service.Reviews.Count(r => r.Rating == star),
                    Percent = service.Reviews.Any() ? (int)(service.Reviews.Count(r => r.Rating == star) * 100.0 / service.Reviews.Count) : 0
                }).ToList();

            return View(service);
        }

        [HttpGet]
        public async Task<IActionResult> LoadMoreReviews(int serviceId, int page = 1)
        {
            page = Math.Max(1, page);
            int pageSize = 5;
            var reviews = await _context.ServiceReviews
                .Include(r => r.Customer)
                .Where(r => r.ServiceId == serviceId && r.IsApproved)
                .OrderByDescending(r => r.CreatedDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(r => new {
                    r.ReviewId,
                    customerName = r.Customer != null ? r.Customer.FullName : "Ẩn danh",
                    r.Rating,
                    r.Comment,
                    createdDate = r.CreatedDate.ToString("dd/MM/yyyy")
                })
                .ToListAsync();

            return Json(reviews);
        }

        [HttpPost]
        [Authorize]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateServiceReview(int serviceId, int rating, string comment)
        {
            if (rating < 1 || rating > 5) return Json(new { success = false, message = "Vui lòng chọn số sao." });
            if (string.IsNullOrEmpty(comment) || comment.Length < 10) return Json(new { success = false, message = "Nội dung tối thiểu 10 ký tự." });

            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return Json(new { success = false, message = "Không tìm thấy thông tin khách hàng." });

            var existed = await _context.ServiceReviews.AnyAsync(r => r.CustomerId == customer.CustomerId && r.ServiceId == serviceId);
            if (existed) return Json(new { success = false, message = "Bạn đã đánh giá dịch vụ này rồi." });

            var review = new ServiceReview
            {
                ServiceId = serviceId,
                CustomerId = customer.CustomerId,
                Rating = rating,
                Comment = comment,
                IsApproved = false,
                CreatedDate = DateTime.Now
            };

            _context.ServiceReviews.Add(review);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Cảm ơn bạn! Đánh giá của bạn đang chờ quản trị viên duyệt." });
        }

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> Booking(int? serviceId)
        {
            if (!serviceId.HasValue)
            {
                ViewBag.HasService = false;
                return View(new BookingViewModel());
            }

            var service = await _uow.Repository<Service>().GetByIdAsync(serviceId.Value);
            if (service == null) return NotFound();

            ViewBag.HasService = true;
            ViewBag.Service = service;
            ViewBag.SelectedServiceId = service.ServiceId;
            ViewBag.Services = await _uow.Repository<Service>().Find(s => s.IsActive == true).ToListAsync();

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var customer = await _uow.Repository<Customer>().Find(c => c.UserId == userId).FirstOrDefaultAsync();
            
            if (customer == null)
            {
                ViewBag.Customer = new Customer { FullName = User.Identity?.Name ?? "Guest", Email = User.Identity?.Name ?? "guest@example.com" };
            }
            else
            {
                ViewBag.Customer = customer;
            }

            ViewBag.Brands = await _context.MotorbikeModels
                .Where(m => m.ParentId == null)
                .Select(m => m.ModelName)
                .Distinct()
                .OrderBy(b => b)
                .ToListAsync();

            // Nếu DB chưa có Brand theo ParentId, fallback về Manufacturer
            if (ViewBag.Brands.Count == 0)
            {
                ViewBag.Brands = await _context.MotorbikeModels
                    .Where(m => m.Manufacturer != null)
                    .Select(m => m.Manufacturer)
                    .Distinct()
                    .OrderBy(b => b)
                    .ToListAsync();
            }

            ViewBag.BookedSlots = await _bookingService.GetBookedSlotsAsync(DateTime.Today);
            ViewBag.DepositAmount = Math.Ceiling(service.Price * 0.3m / 1000) * 1000;

            var model = new BookingViewModel
            {
                ServiceId = serviceId.Value,
                ServiceDate = DateTime.Today,
                FullName = customer?.FullName ?? "",
                Phone = customer?.Phone ?? "",
                Email = customer?.Email ?? ""
            };

            return View(model);
        }

        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Booking(BookingViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var errors = string.Join("<br/>", ModelState.Values
                    .SelectMany(v => v.Errors)
                    .Select(e => e.ErrorMessage));

                return Json(new
                {
                    success = false,
                    message = "Vui lòng kiểm tra lại thông tin:<br/>" + errors
                });
            }

            var customerId = GetCurrentCustomerId();
            var (success, message, bookingId) = await _bookingService.CreateBookingAsync(model, customerId);

            if (!success)
            {
                return Json(new { success = false, message });
            }

            await _auditLogService.LogActionAsync(
                _userManager.GetUserId(User), "Create", "Booking", bookingId.ToString(),
                null, $"Đặt lịch dịch vụ #{bookingId}",
                HttpContext.Connection.RemoteIpAddress?.ToString());

            return Json(new
            {
                success = true,
                redirectUrl = Url.Action("DepositPayment", new { id = bookingId })
            });
        }

        [HttpGet]
        public async Task<IActionResult> DepositPayment(int id)
        {
            var booking = await _context.ServiceBookings
                .Include(b => b.Service)
                .FirstOrDefaultAsync(b => b.BookingId == id);

            if (booking == null) return NotFound();
            
            // Nếu đã thanh toán rồi thì về trang thành công luôn
            if (booking.DepositStatus == "Paid" || booking.DepositStatus == "Confirmed")
            {
                return RedirectToAction("BookingSuccess", new { id = booking.BookingId });
            }

            ViewBag.DepositAmount = booking.DepositAmount;
            return View(booking);
        }

        [HttpGet]
        public async Task<IActionResult> BookingSuccess(int id)
        {
            var vm = await _bookingService.GetBookingSuccessAsync(id);
            if (vm == null) return NotFound();

            return View(vm);
        }

        [HttpGet]
        public async Task<IActionResult> GetBookedSlots(DateTime date)
        {
            var slots = await _bookingService.GetBookedSlotsAsync(date);
            return Json(slots);
        }

        [HttpGet]
        public async Task<IActionResult> GetModelsByBrand(string brand)
        {
            if (string.IsNullOrEmpty(brand)) return Json(new List<object>());

            // Tìm theo ParentId (Brand là tên của một Model có ParentId null)
            var brandEntity = await _context.MotorbikeModels
                .FirstOrDefaultAsync(m => m.ModelName == brand && m.ParentId == null);

            if (brandEntity != null)
            {
                var models = await _context.MotorbikeModels
                    .Where(m => m.ParentId == brandEntity.ModelId)
                    .Select(m => new { modelId = m.ModelId, modelName = m.ModelName })
                    .ToListAsync();
                return Json(models);
            }
            else
            {
                // Fallback dùng Manufacturer
                var models = await _context.MotorbikeModels
                    .Where(m => m.Manufacturer == brand && m.ParentId != null)
                    .Select(m => new { modelId = m.ModelId, modelName = m.ModelName })
                    .ToListAsync();
                return Json(models);
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConfirmDeposit(int bookingId, IFormFile transferProof)
        {
            if (transferProof == null || transferProof.Length == 0)
            {
                return Json(new { success = false, message = "Vui lòng tải ảnh chuyển khoản lên." });
            }

            var uploadDir = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads/deposits");
            if (!Directory.Exists(uploadDir)) Directory.CreateDirectory(uploadDir);

            var fileName = $"deposit_{bookingId}_{DateTime.Now:yyyyMMddHHmmss}{Path.GetExtension(transferProof.FileName)}";
            var savePath = Path.Combine(uploadDir, fileName);

            using (var stream = new FileStream(savePath, FileMode.Create))
            {
                await transferProof.CopyToAsync(stream);
            }

            var result = await _bookingService.ConfirmDepositAsync(bookingId, $"/uploads/deposits/{fileName}");

            if (!result)
            {
                return Json(new { success = false, message = "Lịch hẹn đã hết hạn hoặc không tồn tại." });
            }

            return Json(new
            {
                success = true,
                message = "Xác nhận cọc thành công! Admin sẽ duyệt trong 30 phút."
            });
        }

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> MyBookings()
        {
            var userId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == userId);
            if (customer == null) return RedirectToAction("Login", "Account");

            var bookings = await _context.ServiceBookings
                .Include(b => b.Service)
                .Where(b => b.CustomerId == customer.CustomerId)
                .OrderByDescending(b => b.BookingDate)
                .ToListAsync();

            ViewBag.Customer = customer;
            return View(bookings);
        }

        private int? GetCurrentCustomerId()
        {
            var customerIdClaim = User.FindFirst("CustomerId")?.Value;
            if (customerIdClaim != null && int.TryParse(customerIdClaim, out int customerId))
            {
                return customerId;
            }
            return null;
        }
    }
}
