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
            var customer = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == userId)
                .FirstOrDefaultAsync();

            if (customer == null)
            {
                return (false, "Khong tim thay thong tin khach hang.", 0);
            }

            var cart = await _unitOfWork.Repository<Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.ProductVariant)
                .FirstOrDefaultAsync();

            if (cart == null || !cart.CartItems.Any())
            {
                return (false, "Gio hang rong.", 0);
            }

            foreach (var item in cart.CartItems)
            {
                if (item.ProductVariant == null || item.ProductVariant.StockQuantity < item.Quantity)
                {
                    var variantName = item.ProductVariant?.VariantName ?? "San pham";
                    var stockQuantity = item.ProductVariant?.StockQuantity ?? 0;
                    return (false, $"San pham '{variantName}' hien chi con {stockQuantity} san pham trong kho.", 0);
                }
            }

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
                if (shipping != null)
                {
                    totalAmount += shipping.Cost;
                }
            }

            var order = new Order
            {
                CustomerId = customer.CustomerId,
                OrderDate = DateTime.Now,
                TotalAmount = totalAmount,
                Status = "Pending",
                PaymentStatus = "Unpaid",
                DiscountAmount = discountAmount,
                ShippingAddress = $"{checkoutData.FullName} | {checkoutData.Phone} | {checkoutData.Address}, {checkoutData.Ward}, {checkoutData.District}, {checkoutData.Province}",
                Note = checkoutData.Note,
                ShippingMethodId = checkoutData.ShippingMethodId,
                CouponId = checkoutData.CouponId
            };

            await _unitOfWork.Repository<Order>().AddAsync(order);
            await _unitOfWork.CompleteAsync();

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

                item.ProductVariant!.StockQuantity -= item.Quantity;
                _unitOfWork.Repository<ProductVariant>().Update(item.ProductVariant);

                var transaction = new InventoryTransaction
                {
                    ProductVariantId = item.ProductVariantId,
                    Quantity = -item.Quantity,
                    TransactionType = "Order",
                    TransactionDate = DateTime.Now,
                    Note = $"Don hang #{order.OrderId}"
                };
                await _unitOfWork.Repository<InventoryTransaction>().AddAsync(transaction);
            }

            _unitOfWork.Repository<Cart>().Delete(cart);

            var result = await _unitOfWork.CompleteAsync();
            if (result > 0)
            {
                return (true, "Dat hang thanh cong!", order.OrderId);
            }

            return (false, "Loi khi luu don hang.", 0);
        }

        public async Task<List<OrderDto>> GetUserOrdersAsync(string userId)
        {
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

        public async Task<bool> CancelOrderAsync(int orderId, string userId)
        {
            var order = await _unitOfWork.Repository<Order>().GetByIdAsync(orderId);
            if (order == null || order.Status != "Pending") return false;

            order.Status = "Cancelled";
            _unitOfWork.Repository<Order>().Update(order);

            
            // Hoàn lại tồn kho cho các sản phẩm trong đơn hàng
            var items = await _unitOfWork.Repository<OrderItem>().Find(i => i.OrderId == orderId).ToListAsync();
            foreach (var item in items)
            {
                var variant = await _unitOfWork.Repository<ProductVariant>().GetByIdAsync(item.ProductVariantId);
                if (variant != null)
                {
                    variant.StockQuantity += item.Quantity;
                    _unitOfWork.Repository<ProductVariant>().Update(variant);

                    // Ghi nháº­n giao dá»‹ch hoÃ n kho
                    var transaction = new InventoryTransaction
                    {
                        ProductVariantId = item.ProductVariantId,
                        Quantity = item.Quantity,
                        TransactionType = "Return",
                        TransactionDate = DateTime.Now,
                        Note = $"HoÃ n kho tá»« ÄÆ¡n hÃ ng Ä‘Ã£ há»§y #{order.OrderId}"
                    };
                    await _unitOfWork.Repository<InventoryTransaction>().AddAsync(transaction);
                }
            }

            return await _unitOfWork.CompleteAsync() > 0;
        }

        public async Task<bool> UpdatePaymentStatusAsync(int orderId, string status)
        {
            var order = await _unitOfWork.Repository<Order>().GetByIdAsync(orderId);
            if (order == null) return false;

            order.PaymentStatus = status;
            if (status == "Paid")
            {
                order.Status = "Processing";
            }

            _unitOfWork.Repository<Order>().Update(order);
            return await _unitOfWork.CompleteAsync() > 0;
        }
    }
}
