using MotoShop.Business.DTOs;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IServiceBookingService
    {
        Task<bool> CreateBookingAsync(ServiceBookingDto bookingDto);
    }
}
