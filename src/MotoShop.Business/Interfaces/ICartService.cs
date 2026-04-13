using MotoShop.Business.DTOs;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface ICartService
    {
        Task<bool> AddToCartAsync(string userId, int variantId, int quantity);
        Task<bool> RemoveFromCartAsync(string userId, int variantId);
        Task<bool> UpdateQuantityAsync(string userId, int variantId, int quantity);
        Task<List<CartItemDto>> GetCartAsync(string userId);
        Task<bool> ClearCartAsync(string userId);
        Task SyncCartAsync(string guestId, string userId);
        Task<int> GetCartCountAsync(string userId);
    }
}
