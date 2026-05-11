using System.Threading.Tasks;
using MotoShop.Data.Models;

namespace MotoShop.Business.Interfaces
{
    public interface IEmailService
    {
        Task SendEmailAsync(string toEmail, string subject, string message);
        Task SendPromotionEmailAsync(string toEmail, string promotionName, string description, string startDate, string endDate);
        Task SendOrderConfirmationAsync(Order order);
        Task SendOrderShippingAsync(Order order);
        Task SendOrderCompletedAsync(Order order);
        Task SendBookingConfirmationAsync(ServiceBooking booking);
        Task SendDepositConfirmedAsync(ServiceBooking booking, string vnpayTxnRef);
    }
}
