using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IEmailService
    {
        Task SendEmailAsync(string toEmail, string subject, string message);
        Task SendPromotionEmailAsync(string toEmail, string promotionName, string description, string startDate, string endDate);
    }
}
