using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
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
        private readonly MotoShopDbContext _context;

        public OrderService(IUnitOfWork unitOfWork, MotoShopDbContext context)
        {
            _unitOfWork = unitOfWork;
            _context = context;
        }

        public async Task<(bool Success, string Message, int OrderId)> CreateOrderAsync(string userId, CheckoutDto checkoutData)
        {
            var customer = await _unitOfWork.Repository<Customer>()
                .Find(c => c.UserId == userId)
                .FirstOrDefaultAsync();

            if (customer == null) return (false, "Không tìm thấy thông tin khách hàng.", 0);

            // 1. XỬ LÝ DANH SÁCH SẢN PHẨM (MUA NGAY HOẶC GIỎ HÀNG)
            List<OrderItem> orderItemsToCreate = new List<OrderItem>();
            decimal subTotal = 0;

            if (checkoutData.DirectVariantId.HasValue)
            {
                // TRƯỜNG HỢP: MUA NGAY
                var variant = await _context.ProductVariants.FindAsync(checkoutData.DirectVariantId.Value);
                if (variant == null || variant.StockQuantity < checkoutData.DirectQuantity)
                    return (false, "Sản phẩm không hợp lệ hoặc không đủ tồn kho.", 0);

                orderItemsToCreate.Add(new OrderItem {
                    ProductVariantId = variant.ProductVariantId,
                    Quantity = checkoutData.DirectQuantity,
                    Price = variant.Price
                });
                subTotal = variant.Price * checkoutData.DirectQuantity;
            }
            else
            {
                // TRƯỜNG HỢP: GIỎ HÀNG
                var cart = await _context.Carts.Include(c => c.CartItems).ThenInclude(i => i.ProductVariant).FirstOrDefaultAsync(c => c.UserId == userId);
                if (cart == null || !cart.CartItems.Any()) return (false, "Giỏ hàng trống.", 0);

                foreach (var item in cart.CartItems)
                {
                    if (item.ProductVariant == null || item.ProductVariant.StockQuantity < item.Quantity)
                        return (false, $"Sản phẩm '{item.ProductVariant?.VariantName}' không đủ tồn kho.", 0);

                    orderItemsToCreate.Add(new OrderItem {
                        ProductVariantId = item.ProductVariantId,
                        Quantity = item.Quantity,
                        Price = item.Price
                    });
                }
                subTotal = cart.CartItems.Sum(i => i.Price * i.Quantity);
            }

            // 2. XỬ LÝ ĐỊA CHỈ
            if (!checkoutData.AddressId.HasValue)
            {
                var newAddr = new AddressNew {
                    CustomerId = customer.CustomerId, FullName = checkoutData.FullName, Phone = checkoutData.Phone,
                    Province = checkoutData.Province, District = checkoutData.District, Ward = checkoutData.Ward,
                    Street = checkoutData.Address, IsDefault = !await _context.AddressesNew.AnyAsync(a => a.CustomerId == customer.CustomerId)
                };
                _context.AddressesNew.Add(newAddr);
                await _context.SaveChangesAsync();
                checkoutData.AddressId = newAddr.Id;
            }

            // 3. TÍNH TOÁN GIẢM GIÁ & SHIP
            decimal totalAmount = subTotal;
            decimal discountAmount = 0;
            if (!string.IsNullOrEmpty(checkoutData.CouponCode))
            {
                var coupon = await _context.Coupons.FirstOrDefaultAsync(c => c.Code == checkoutData.CouponCode && c.IsActive && c.ExpiryDate >= DateTime.Now);
                if (coupon != null && (coupon.UsageLimit == 0 || coupon.UsedCount < coupon.UsageLimit))
                {
                    discountAmount = coupon.DiscountType == "Percentage" ? subTotal * (coupon.DiscountValue / 100) : coupon.DiscountValue;
                    totalAmount -= discountAmount;
                    checkoutData.CouponId = coupon.Id;
                    coupon.UsedCount++;
                }
            }

            if (checkoutData.ShippingMethodId.HasValue)
            {
                var ship = await _context.ShippingMethods.FindAsync(checkoutData.ShippingMethodId.Value);
                if (ship != null) totalAmount += ship.Cost;
            }

            // 4. TẠO ĐƠN HÀNG
            var order = new Order {
                CustomerId = customer.CustomerId, OrderDate = DateTime.Now, TotalAmount = totalAmount,
                Status = "Pending", PaymentStatus = "Unpaid", DiscountAmount = discountAmount,
                ShippingAddress = $"{checkoutData.FullName} | {checkoutData.Phone} | {checkoutData.Address}, {checkoutData.Ward}, {checkoutData.District}, {checkoutData.Province}",
                Note = checkoutData.Note, ShippingMethodId = checkoutData.ShippingMethodId, CouponId = checkoutData.CouponId
            };

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            // 5. LƯU CHI TIẾT VÀ TRỪ KHO
            foreach (var item in orderItemsToCreate)
            {
                item.OrderId = order.OrderId;
                _context.OrderItems.Add(item);

                var dbVar = await _context.ProductVariants.FindAsync(item.ProductVariantId);
                if (dbVar != null)
                {
                    dbVar.StockQuantity -= item.Quantity;
                    _context.InventoryTransactions.Add(new InventoryTransaction {
                        ProductVariantId = dbVar.ProductVariantId, Quantity = -item.Quantity,
                        TransactionType = "Order", TransactionDate = DateTime.Now, Note = $"Đơn hàng #{order.OrderId}"
                    });
                }
            }

            // 6. DỌN DẸP GIỎ HÀNG (Nếu không phải mua ngay)
            if (!checkoutData.DirectVariantId.HasValue)
            {
                var cart = await _context.Carts.Include(c => c.CartItems).FirstOrDefaultAsync(c => c.UserId == userId);
                if (cart != null) _context.Carts.Remove(cart);
            }

            await _context.SaveChangesAsync();
            return (true, "Đặt hàng thành công!", order.OrderId);
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
