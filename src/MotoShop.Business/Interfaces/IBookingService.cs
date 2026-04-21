using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using MotoShop.Business.DTOs;

namespace MotoShop.Business.Interfaces
{
    public interface IBookingService
    {
        Task<(bool Success, string Message, int BookingId)> CreateBookingAsync(BookingViewModel model, int? customerId);
        Task<BookingSuccessViewModel> GetBookingSuccessAsync(int bookingId);
        Task<List<string>> GetBookedSlotsAsync(DateTime date);
        Task<bool> ConfirmDepositAsync(int bookingId, string transferProof);
        Task CancelExpiredBookingsAsync();
    }
}
