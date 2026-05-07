using MotoShop.Business.DTOs;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IFlashSaleService
    {
        Task<List<FlashSaleDto>> GetActiveFlashSalesAsync();
        Task<FlashSaleDto?> GetFlashSaleDetailsAsync(int id);
    }
}
