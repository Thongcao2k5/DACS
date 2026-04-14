using Microsoft.AspNetCore.Mvc;
using MotoShop.Business.Interfaces;
using MotoShop.Business.DTOs;
using MotoShop.Models.ViewModels;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class ServiceController : Controller
    {
        private readonly IServiceService _serviceService;
        private readonly IServiceBookingService _bookingService;

        public ServiceController(IServiceService serviceService, IServiceBookingService bookingService)
        {
            _serviceService = serviceService;
            _bookingService = bookingService;
        }

        // Action to list services with paging
        public async Task<IActionResult> Index(string searchTerm, int page = 1, int pageSize = 6)
        {
            var pagedServices = await _serviceService.GetPagedAsync(searchTerm, page, pageSize);
            return View(pagedServices);
        }

        public async Task<IActionResult> Details(int id)
        {
            var service = await _serviceService.GetByIdAsync(id);
            if (service == null) return NotFound();
            return View(service);
        }

        [HttpGet]
        public async Task<IActionResult> Booking(int? serviceId)
        {
            var model = new ServiceBookingViewModel();
            if (serviceId.HasValue)
            {
                var service = await _serviceService.GetByIdAsync(serviceId.Value);
                if (service != null)
                {
                    model.ServiceId = service.ServiceId;
                    model.SelectedService = service;
                }
            }
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Booking(ServiceBookingViewModel model)
        {
            if (ModelState.IsValid)
            {
                var bookingDto = new ServiceBookingDto
                {
                    ServiceId = model.ServiceId,
                    CustomerName = model.CustomerName,
                    CustomerPhone = model.CustomerPhone,
                    VehicleBrand = model.VehicleBrand,
                    VehicleModel = model.VehicleModel,
                    LicensePlate = model.LicensePlate,
                    Notes = model.Notes,
                    ServiceDate = model.ServiceDate,
                    // Optionally combining ServiceDate and ServiceTime into ServiceDate
                    Status = "Pending"
                };

                var success = await _bookingService.CreateBookingAsync(bookingDto);
                if (success)
                {
                    TempData["SuccessMessage"] = "Đặt lịch thành công! Chúng tôi sẽ liên hệ lại sớm nhất.";
                    return RedirectToAction(nameof(BookingSuccess));
                }
                ModelState.AddModelError("", "Đã có lỗi xảy ra. Vui lòng thử lại sau.");
            }

            // Repopulate selected service if form submission fails
            if (model.ServiceId.HasValue)
            {
                model.SelectedService = await _serviceService.GetByIdAsync(model.ServiceId.Value);
            }
            
            return View(model);
        }

        public IActionResult BookingSuccess()
        {
            return View();
        }
    }
}
