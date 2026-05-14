using MotoShop.Business.DTOs;
using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IPromotionService
    {
        Task<List<PromotionDto>> GetAllAsync();
        Task<List<PromotionDto>> GetActivePromotionsAsync();
        Task<List<PromotionDto>> GetFlashSalesAsync();
        Task<List<PromotionDto>> GetFeaturedAsync();
        Task<List<ProductDto>> GetFlashSaleProductsAsync(int count = 12);

        Task<decimal> CalculateDiscountAsync(int productId, decimal originalPrice);
        Task<decimal> CalculateOrderDiscountAsync(decimal orderTotal, List<CartItem> items);
        Task<decimal> ApplyVoucherAsync(string code, decimal orderTotal);
        Task<(bool IsValid, decimal DiscountAmount, string Message)> ValidateVoucherAsync(string code, decimal orderTotal);

        Task<PromotionDto> CreateAsync(PromotionDto dto);
        Task<bool> UpdateAsync(int id, PromotionDto dto);
        Task<bool> DeleteAsync(int id);
        Task<bool> ToggleActiveAsync(int id);
    }
}
