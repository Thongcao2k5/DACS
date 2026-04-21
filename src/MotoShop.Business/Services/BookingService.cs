using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;

namespace MotoShop.Business.Services
{
    public class BookingService : IBookingService
    {
        private readonly IUnitOfWork _uow;
        private readonly IConfiguration _config;

        public BookingService(IUnitOfWork uow, IConfiguration config)
        {
            _uow = uow;
            _config = config;
        }

        public async Task<(bool Success, string Message, int BookingId)> CreateBookingAsync(BookingViewModel model, int? customerId)
        {
            // 1. Kiểm tra slot có bị trùng không
            // TimeSlot thường có dạng "HH:mm"
            if (!TimeSpan.TryParse(model.TimeSlot, out var timeSpan))
            {
                return (false, "Khung giờ không hợp lệ.", 0);
            }

            var serviceDatetime = model.ServiceDate.Date.Add(timeSpan);

            // Lấy số lượng phục vụ tối đa (Dựa trên config hoặc số nhân viên)
            int maxConcurrent = _config.GetValue<int>("Booking:MaxConcurrentBookings", 3);
            var staffCount = await _uow.Repository<Staff>().Find(s => true).CountAsync();
            if (staffCount > 0 && maxConcurrent < staffCount) maxConcurrent = staffCount;

            var currentBookings = await _uow.Repository<ServiceBooking>()
                .Find(b => b.ServiceDate == serviceDatetime && b.Status != "Cancelled")
                .CountAsync();

            if (currentBookings >= maxConcurrent)
                return (false, $"Khung giờ {model.TimeSlot} đã đầy chỗ phục vụ. Vui lòng chọn giờ khác hoặc ngày khác.", 0);

            // 2. Lấy thông tin dịch vụ
            var service = await _uow.Repository<Service>().GetByIdAsync(model.ServiceId);
            if (service == null)
                return (false, "Dịch vụ không tồn tại.", 0);

            // 3. Tính tiền cọc 30%
            decimal depositRate = _config.GetValue<decimal>("Payment:DepositRate", 0.3m);
            decimal depositAmount = Math.Ceiling(service.Price * depositRate / 1000) * 1000; // Làm tròn lên 1000đ

            // 4. Tạo booking
            var booking = new ServiceBooking
            {
                CustomerId = customerId,
                ServiceId = model.ServiceId,
                BookingDate = DateTime.Now,
                ServiceDate = serviceDatetime,
                Status = "Pending",
                
                // Lưu thông tin chi tiết vào các cột mới
                CustomerFullName = model.FullName,
                CustomerPhone = model.Phone,
                CustomerEmail = model.Email,
                VehicleBrand = model.VehicleBrand,
                VehicleModel = model.VehicleModel,
                VehicleYear = model.VehicleYear,
                LicensePlate = model.LicensePlate,
                
                Notes = model.Note,
                DepositAmount = depositAmount,
                DepositStatus = "Unpaid",
                ExpireAt = DateTime.Now.AddHours(_config.GetValue<int>("Booking:ExpireAfterHours", 2))
            };

            await _uow.Repository<ServiceBooking>().AddAsync(booking);
            await _uow.CompleteAsync();

            return (true, "Đặt lịch thành công!", booking.BookingId);
        }

        public async Task<BookingSuccessViewModel> GetBookingSuccessAsync(int bookingId)
        {
            var booking = await _uow.Repository<ServiceBooking>()
                .Find(b => b.BookingId == bookingId)
                .Include(b => b.Service)
                .FirstOrDefaultAsync();

            if (booking == null) return null;

            // Lấy thông tin ngân hàng từ config
            var bankName = _config["Payment:BankName"];
            var accountNumber = _config["Payment:AccountNumber"];
            var accountHolder = _config["Payment:AccountHolder"];

            // Nội dung chuyển khoản
            var transferContent = $"COC {booking.BookingId} {booking.Service?.ServiceName}";

            return new BookingSuccessViewModel
            {
                BookingId = booking.BookingId,
                BookingCode = $"BK{booking.BookingId:000000}",
                ServiceName = booking.Service?.ServiceName ?? "Dịch vụ",
                ServicePrice = booking.Service?.Price ?? 0,
                DepositAmount = booking.DepositAmount,
                RemainingAmount = (booking.Service?.Price ?? 0) - booking.DepositAmount,
                ServiceDate = booking.ServiceDate ?? DateTime.Now,
                TimeSlot = booking.ServiceDate?.ToString("HH:mm") ?? "00:00",
                Status = booking.Status ?? "Pending",
                ExpireAt = booking.ExpireAt ?? DateTime.Now,
                BankName = bankName ?? "Vietcombank",
                AccountNumber = accountNumber ?? "0123456789",
                AccountHolder = accountHolder ?? "CTY TNHH MOTOSHOP",
                TransferContent = transferContent
            };
        }

        public async Task<List<string>> GetBookedSlotsAsync(DateTime date)
        {
            int maxConcurrent = _config.GetValue<int>("Booking:MaxConcurrentBookings", 3);
            var staffCount = await _uow.Repository<Staff>().Find(s => true).CountAsync();
            if (staffCount > 0 && maxConcurrent < staffCount) maxConcurrent = staffCount;

            // Lấy danh sách khung giờ đã đạt tối đa số lượng phục vụ
            var bookedSlots = await _uow.Repository<ServiceBooking>()
                .Find(b => b.ServiceDate.HasValue && b.ServiceDate.Value.Date == date.Date && b.Status != "Cancelled")
                .GroupBy(b => b.ServiceDate.Value)
                .Where(g => g.Count() >= maxConcurrent)
                .Select(g => g.Key.ToString("HH:mm"))
                .ToListAsync();

            return bookedSlots;
        }

        public async Task<bool> ConfirmDepositAsync(int bookingId, string transferProof)
        {
            var booking = await _uow.Repository<ServiceBooking>().GetByIdAsync(bookingId);

            if (booking == null || booking.Status != "Pending")
                return false;

            // Kiểm tra chưa hết hạn
            if (DateTime.Now > booking.ExpireAt)
            {
                booking.Status = "Cancelled";
                booking.CancelReason = "Hết hạn chuyển khoản cọc";
                await _uow.CompleteAsync();
                return false;
            }

            booking.Status = "Confirmed";
            booking.DepositStatus = "Paid";
            booking.TransferProof = transferProof;
            booking.ConfirmedAt = DateTime.Now;

            await _uow.CompleteAsync();
            return true;
        }

        public async Task CancelExpiredBookingsAsync()
        {
            var expired = await _uow.Repository<ServiceBooking>()
                .Find(b => b.Status == "Pending" && b.ExpireAt.HasValue && b.ExpireAt.Value < DateTime.Now)
                .ToListAsync();

            if (expired.Any())
            {
                foreach (var b in expired)
                {
                    b.Status = "Cancelled";
                    b.CancelReason = "Tự động hủy do hết hạn chuyển khoản cọc";
                }
                await _uow.CompleteAsync();
            }
        }
    }
}
