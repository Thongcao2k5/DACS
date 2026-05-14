using MotoShop.Data.Enums;
using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Data.Interfaces
{
    public interface IPromotionRepository : IGenericRepository<Promotion>
    {
        Task<List<Promotion>> GetActivePromotions();
        Task<List<Promotion>> GetByType(PromotionType type);
        Task<Promotion?> GetByCode(string code);
        Task<List<Promotion>> GetFlashSales();
        Task<List<PromotionProduct>> GetPromotionProducts(int promotionId);
    }
}
