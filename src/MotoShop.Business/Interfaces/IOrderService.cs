using System.Collections.Generic;
using System.Threading.Tasks;
using MotoShop.Business.DTOs;

namespace MotoShop.Business.Interfaces
{
    public interface IOrderService
    {
        // Tạo đơn hàng từ thông tin Checkout và Giỏ hàng
        Task<(bool Success, string Message, int OrderId)> CreateOrderAsync(string userId, CheckoutDto checkoutData);
        
        // Xem danh sách đơn hàng của một người dùng
        Task<List<OrderDto>> GetUserOrdersAsync(string userId);
        
        // Xem chi tiết một đơn hàng
        Task<OrderDto> GetOrderDetailsAsync(int orderId, string userId);
        
        // Hủy đơn hàng (nếu còn ở trạng thái Chờ xử lý)
        Task<bool> CancelOrderAsync(int orderId, string userId);
    }
}
