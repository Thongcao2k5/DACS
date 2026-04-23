using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using Microsoft.AspNetCore.Authorization;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Security.Claims;

namespace MotoShop.Controllers
{
    public class ServiceController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IBookingService _bookingService;
        private readonly IUnitOfWork _uow;

        public ServiceController(MotoShopDbContext context, IBookingService bookingService, IUnitOfWork uow)
        {
            _context = context;
            _bookingService = bookingService;
            _uow = uow;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> Details(int id)
        {
            var service = await _uow.Repository<Service>().GetByIdAsync(id);
            if (service == null) return NotFound();
            return View(service);
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
            ViewBag.Services = await _uow.Repository<Service>().Find(s => s.IsActive).ToListAsync();

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var customer = await _uow.Repository<Customer>().Find(c => c.UserId == userId).FirstOrDefaultAsync();
            
            if (customer == null)
            {
                ViewBag.Customer = new Customer { FullName = User.Identity.Name, Email = User.Identity.Name };
            }
            else
            {
                ViewBag.Customer = customer;
            }

            ViewBag.Brands = await _uow.Repository<MotorbikeModel>()
                .Find(m => m.Manufacturer != null)
                .Select(m => m.Manufacturer)
                .Distinct()
                .ToListAsync();

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
                return Json(new
                {
                    success = false,
                    message = "Vui lòng điền đầy đủ thông tin bắt buộc.",
                    errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage)
                });
            }

            var customerId = GetCurrentCustomerId();
            var (success, message, bookingId) = await _bookingService.CreateBookingAsync(model, customerId);

            if (!success)
            {
                return Json(new { success = false, message });
            }

            return Json(new
            {
                success = true,
                redirectUrl = Url.Action("BookingSuccess", new { id = bookingId })
            });
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
            var models = await _uow.Repository<MotorbikeModel>()
                .Find(m => m.Manufacturer == brand)
                .Select(m => new { modelId = m.ModelId, modelName = m.ModelName })
                .ToListAsync();
            return Json(models);
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

        private int? GetCurrentCustomerId()
        {
            var customerIdClaim = User.FindFirst("CustomerId")?.Value;
            if (int.TryParse(customerIdClaim, out int customerId))
            {
                return customerId;
            }
            return null;
        }
    }
}
