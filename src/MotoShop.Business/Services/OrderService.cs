using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class OrderService : IOrderService
    {
        private readonly IUnitOfWork _unitOfWork;

        public OrderService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<(bool Success, string Message, int OrderId)> CreateOrderAsync(string userId, CheckoutDto checkoutData)
        {
            // 1. Lấy giỏ hàng
            var cart = await _unitOfWork.Repository<Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.ProductVariant)
                .FirstOrDefaultAsync();

            if (cart == null || !cart.CartItems.Any())
            {
                return (false, "Giỏ hàng rỗng.", 0);
            }

            // 2. Kiểm tra tồn kho cho tất cả sản phẩm
            foreach (var item in cart.CartItems)
            {
                if (item.ProductVariant.StockQuantity < item.Quantity)
                {
                    return (false, $"Sản phẩm '{item.ProductVariant.VariantName}' hiện chỉ còn {item.ProductVariant.StockQuantity} sản phẩm trong kho.", 0);
                }
            }

            // 3. Tính tổng tiền
            decimal totalAmount = cart.CartItems.Sum(ci => ci.Price * ci.Quantity);
            decimal discountAmount = 0;

            // Handle Coupon
            if (!string.IsNullOrEmpty(checkoutData.CouponCode))
            {
                var coupon = await _unitOfWork.Repository<Coupon>().Find(c => c.Code == checkoutData.CouponCode && c.IsActive && c.ExpiryDate >= DateTime.Now).FirstOrDefaultAsync();
                if (coupon != null && (coupon.UsageLimit == 0 || coupon.UsedCount < coupon.UsageLimit))
                {
                    if (coupon.MinOrderValue == null || totalAmount >= coupon.MinOrderValue)
                    {
                        if (coupon.DiscountType == "Percentage")
                        {
                            discountAmount = totalAmount * (coupon.DiscountValue / 100);
                        }
                        else
                        {
                            discountAmount = coupon.DiscountValue;
                        }
                        totalAmount -= discountAmount;
                        checkoutData.CouponId = coupon.Id;
                        
                        // Increment used count
                        coupon.UsedCount++;
                        _unitOfWork.Repository<Coupon>().Update(coupon);
                    }
                }
            }

            // Handle Shipping Method
            if (checkoutData.ShippingMethodId.HasValue)
            {
                var shipping = await _unitOfWork.Repository<ShippingMethod>().GetByIdAsync(checkoutData.ShippingMethodId.Value);
                if (shipping != null) totalAmount += shipping.Cost;
            }

            // 4. Tạo Đơn hàng chính
            var order = new Order
            {
                CustomerId = null, // Có thể gán từ bảng Customer dựa trên userId sau này
                OrderDate = DateTime.Now,
                TotalAmount = totalAmount,
                DiscountAmount = discountAmount,
                Status = "Pending", // Chờ xử lý
                PaymentStatus = "Unpaid", // Chưa thanh toán
                ShippingAddress = $"{checkoutData.FullName} | {checkoutData.Phone} | {checkoutData.Address}, {checkoutData.Ward}, {checkoutData.District}, {checkoutData.Province}",
                Note = checkoutData.Note,
                ShippingMethodId = checkoutData.ShippingMethodId,
                CouponId = checkoutData.CouponId
            };

            await _unitOfWork.Repository<Order>().AddAsync(order);
            await _unitOfWork.CompleteAsync(); // Lưu để lấy OrderId (PK)

            // 5. Tạo Chi tiết đơn hàng và Trừ tồn kho
            foreach (var item in cart.CartItems)
            {
                var orderItem = new OrderItem
                {
                    OrderId = order.OrderId,
                    ProductVariantId = item.ProductVariantId,
                    Quantity = item.Quantity,
                    Price = item.Price
                };
                await _unitOfWork.Repository<OrderItem>().AddAsync(orderItem);

                // Trừ tồn kho
                item.ProductVariant.StockQuantity -= item.Quantity;
                _unitOfWork.Repository<ProductVariant>().Update(item.ProductVariant);

                // Ghi nhận giao dịch kho (Lịch sử)
                var transaction = new InventoryTransaction
                {
                    ProductVariantId = item.ProductVariantId,
                    Quantity = -item.Quantity, // Số âm là xuất kho
                    TransactionType = "Order",
                    TransactionDate = DateTime.Now,
                    Note = $"Đơn hàng #{order.OrderId}"
                };
                await _unitOfWork.Repository<InventoryTransaction>().AddAsync(transaction);
            }

            // 6. Xóa giỏ hàng
            _unitOfWork.Repository<Cart>().Delete(cart);

            // Hoàn tất Transaction
            var result = await _unitOfWork.CompleteAsync();
            if (result > 0)
            {
                return (true, "Đặt hàng thành công!", order.OrderId);
            }

            return (false, "Lỗi khi lưu đơn hàng.", 0);
        }

        public async Task<List<OrderDto>> GetUserOrdersAsync(string userId)
        {
            // Tạm thời lấy tất cả đơn hàng, cần liên kết userId -> CustomerId sau này
            var orders = await _unitOfWork.Repository<Order>().GetAllAsync();
            return orders.Select(o => new OrderDto
            {
                OrderId = o.OrderId,
                OrderCode = o.OrderCode,
                OrderDate = o.OrderDate,
                TotalAmount = o.TotalAmount,
                Status = o.Status,
                PaymentStatus = o.PaymentStatus,
                ShippingAddress = o.ShippingAddress
            }).OrderByDescending(o => o.OrderDate).ToList();
        }

        public async Task<OrderDto> GetOrderDetailsAsync(int orderId, string userId)
        {
            var o = await _unitOfWork.Repository<Order>().GetByIdAsync(orderId);
            if (o == null) return null!;

            return new OrderDto
            {
                OrderId = o.OrderId,
                OrderCode = o.OrderCode,
                OrderDate = o.OrderDate,
                TotalAmount = o.TotalAmount,
                Status = o.Status,
                PaymentStatus = o.PaymentStatus,
                ShippingAddress = o.ShippingAddress
            };
        }

        public async Task<bool> CancelOrderAsync(int orderId, string reason)
        {
            var order = await _unitOfWork.Repository<Order>().GetByIdAsync(orderId);
            if (order == null || order.Status != "Pending") return false;

            order.Status = "Cancelled";
            order.Note = $"[Lý do hủy: {reason}] " + (order.Note ?? "");
            _unitOfWork.Repository<Order>().Update(order);
            
            // Hoàn lại tồn kho cho các sản phẩm trong đơn hàng
            var items = await _unitOfWork.Repository<OrderItem>().Find(i => i.OrderId == orderId).ToListAsync();
            foreach(var item in items)
            {
                var variant = await _unitOfWork.Repository<ProductVariant>().GetByIdAsync(item.ProductVariantId);
                if (variant != null)
                {
                    variant.StockQuantity += item.Quantity;
                    _unitOfWork.Repository<ProductVariant>().Update(variant);

                    // Ghi nhận giao dịch hoàn kho
                    var transaction = new InventoryTransaction
                    {
                        ProductVariantId = item.ProductVariantId,
                        Quantity = item.Quantity,
                        TransactionType = "Return",
                        TransactionDate = DateTime.Now,
                        Note = $"Hoàn kho từ Đơn hàng đã hủy #{order.OrderId}"
                    };
                    await _unitOfWork.Repository<InventoryTransaction>().AddAsync(transaction);
                }
            }

            return await _unitOfWork.CompleteAsync() > 0;
        }
    }
}
