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
            var strategy = _context.Database.CreateExecutionStrategy();

            return await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    var customer = await _unitOfWork.Repository<Customer>()
                        .Find(c => c.UserId == userId)
                        .FirstOrDefaultAsync();

                    if (customer == null) return (false, "Không tìm thấy thông tin khách hàng.", 0);

                    // 1. XỬ LÝ DANH SÁCH SẢN PHẨM
                    List<OrderItem> orderItemsToCreate = new List<OrderItem>();
                    decimal subTotal = 0;

                    if (checkoutData.DirectVariantId.HasValue)
                    {
                        var variant = await _context.ProductVariants.FindAsync(checkoutData.DirectVariantId.Value);
                        if (variant == null || variant.StockQuantity < checkoutData.DirectQuantity)
                            return (false, "Sản phẩm không đủ tồn kho.", 0);
                        
                        orderItemsToCreate.Add(new OrderItem {
                            ProductVariantId = variant.ProductVariantId,
                            Quantity = checkoutData.DirectQuantity,
                            Price = variant.Price
                        });
                        subTotal = variant.Price * checkoutData.DirectQuantity;
                    }
                    else
                    {
                        var cart = await _context.Carts.Include(c => c.CartItems).ThenInclude(i => i.ProductVariant).FirstOrDefaultAsync(c => c.UserId == userId);
                        if (cart == null || !cart.CartItems.Any()) return (false, "Giỏ hàng trống.", 0);

                        foreach (var item in cart.CartItems)
                        {
                            var variant = await _context.ProductVariants.FirstOrDefaultAsync(v => v.ProductVariantId == item.ProductVariantId);
                            if (variant == null || variant.StockQuantity < item.Quantity)
                                return (false, $"Sản phẩm '{item.ProductVariant?.VariantName}' không đủ tồn kho.", 0);

                            orderItemsToCreate.Add(new OrderItem {
                                ProductVariantId = item.ProductVariantId,
                                Quantity = item.Quantity,
                                Price = variant.Price
                            });
                            subTotal += variant.Price * item.Quantity;
                        }
                    }

                    // 2. XỬ LÝ ĐỊA CHỈ
                    string finalFullName = checkoutData.FullName ?? "";
                    string finalPhone = checkoutData.Phone ?? "";
                    string finalAddressStr = "";

                    if (checkoutData.AddressId.HasValue)
                    {
                        var savedAddr = await _context.AddressesNew.FindAsync(checkoutData.AddressId.Value);
                        if (savedAddr != null)
                        {
                            finalFullName = savedAddr.FullName ?? finalFullName;
                            finalPhone = savedAddr.Phone ?? finalPhone;
                            finalAddressStr = $"{savedAddr.Street}, {savedAddr.Ward}, {savedAddr.District}, {savedAddr.Province}";
                        }
                    }
                    else
                    {
                        var newAddr = new AddressNew {
                            CustomerId = customer.CustomerId, FullName = checkoutData.FullName, Phone = checkoutData.Phone,
                            Province = checkoutData.Province, District = checkoutData.District, Ward = checkoutData.Ward,
                            Street = checkoutData.Address, IsDefault = !await _context.AddressesNew.AnyAsync(a => a.CustomerId == customer.CustomerId)
                        };
                        _context.AddressesNew.Add(newAddr);
                        await _context.SaveChangesAsync();
                        checkoutData.AddressId = newAddr.Id;
                        finalAddressStr = $"{checkoutData.Address}, {checkoutData.Ward}, {checkoutData.District}, {checkoutData.Province}";
                    }

                    // 3. TÍNH TOÁN GIẢM GIÁ & SHIP
                    decimal discountAmount = 0;
                    if (!string.IsNullOrEmpty(checkoutData.CouponCode))
                    {
                        var coupon = await _context.Coupons.FirstOrDefaultAsync(c => c.Code == checkoutData.CouponCode && c.IsActive && c.ExpiryDate >= DateTime.Now);
                        if (coupon != null && (coupon.UsageLimit == 0 || coupon.UsedCount < coupon.UsageLimit))
                        {
                            if (subTotal >= coupon.MinOrderValue)
                            {
                                discountAmount = coupon.DiscountType == "Percentage" ? subTotal * (coupon.DiscountValue / 100) : coupon.DiscountValue;
                                checkoutData.CouponId = coupon.Id;
                                coupon.UsedCount++;
                            }
                        }
                    }

                    decimal shippingCost = 0;
                    if (checkoutData.ShippingMethodId.HasValue)
                    {
                        var ship = await _context.ShippingMethods.FindAsync(checkoutData.ShippingMethodId.Value);
                        if (ship != null) shippingCost = ship.Cost;
                    }

                    // 4. TẠO ĐƠN HÀNG
                    var order = new Order {
                        CustomerId = customer.CustomerId, OrderDate = DateTime.Now, TotalAmount = subTotal + shippingCost - discountAmount,
                        Status = "Pending", PaymentStatus = "Unpaid", DiscountAmount = discountAmount,
                        ShippingAddress = $"{finalFullName} | {finalPhone} | {finalAddressStr}",
                        Note = checkoutData.Note, ShippingMethodId = checkoutData.ShippingMethodId, CouponId = checkoutData.CouponId,
                        PaymentMethod = checkoutData.PaymentMethod
                    };

                    _context.Orders.Add(order);
                    await _context.SaveChangesAsync();

                    // 5. LƯU CHI TIẾT VÀ TRỪ KHO
                    foreach (var item in orderItemsToCreate)
                    {
                        var dbVar = await _context.ProductVariants.FindAsync(item.ProductVariantId);
                        if (dbVar == null || dbVar.StockQuantity < item.Quantity) throw new Exception("Sản phẩm hết hàng.");
                        item.OrderId = order.OrderId;
                        _context.OrderItems.Add(item);
                        dbVar.StockQuantity -= item.Quantity;
                        _context.InventoryTransactions.Add(new InventoryTransaction {
                            ProductVariantId = dbVar.ProductVariantId, Quantity = -item.Quantity,
                            TransactionType = "OUT", TransactionDate = DateTime.Now, Note = $"Đơn hàng #{order.OrderId}"
                        });
                    }

                    if (!checkoutData.DirectVariantId.HasValue)
                    {
                        var cart = await _context.Carts.Include(c => c.CartItems).FirstOrDefaultAsync(c => c.UserId == userId);
                        if (cart != null) _context.Carts.Remove(cart);
                    }

                    await _context.SaveChangesAsync();
                    await transaction.CommitAsync();
                    return (true, "Đặt hàng thành công!", order.OrderId);
                }
                catch (Exception ex)
                {
                    await transaction.RollbackAsync();
                    return (false, "Lỗi hệ thống: " + ex.Message, 0);
                }
            });
        }

        public async Task<List<OrderDto>> GetUserOrdersAsync(string userId)
        {
            var orders = await _unitOfWork.Repository<Order>().GetAllAsync();
            return orders.Select(o => new OrderDto
            {
                OrderId = o.OrderId, OrderCode = o.OrderCode, OrderDate = o.OrderDate,
                TotalAmount = o.TotalAmount, Status = o.Status, PaymentStatus = o.PaymentStatus, ShippingAddress = o.ShippingAddress
            }).OrderByDescending(o => o.OrderDate).ToList();
        }

        public async Task<OrderDto> GetOrderDetailsAsync(int orderId, string userId)
        {
            var o = await _unitOfWork.Repository<Order>().GetByIdAsync(orderId);
            return o == null ? null! : new OrderDto { OrderId = o.OrderId, OrderCode = o.OrderCode, TotalAmount = o.TotalAmount, Status = o.Status };
        }

        public async Task<bool> CancelOrderAsync(int orderId, string userId)
        {
            var strategy = _context.Database.CreateExecutionStrategy();
            return await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    var order = await _context.Orders.Include(o => o.OrderItems).ThenInclude(oi => oi.ProductVariant).FirstOrDefaultAsync(o => o.OrderId == orderId);
                    var cancellable = new[] { "Pending", "Processing", "DangXuLy" };
                    if (order == null || !cancellable.Contains(order.Status)) return false;

                    order.Status = "Cancelled";
                    if (order.CouponId.HasValue)
                    {
                        var coupon = await _context.Coupons.FindAsync(order.CouponId.Value);
                        if (coupon != null && coupon.UsedCount > 0) coupon.UsedCount--;
                    }

                    foreach (var item in order.OrderItems)
                    {
                        if (item.ProductVariant != null)
                        {
                            item.ProductVariant.StockQuantity += item.Quantity;
                            _context.InventoryTransactions.Add(new InventoryTransaction {
                                ProductVariantId = item.ProductVariantId, Quantity = item.Quantity,
                                TransactionType = "IN", TransactionDate = DateTime.Now, Note = $"Hoàn kho #{order.OrderId}"
                            });
                        }
                    }
                    await _context.SaveChangesAsync();
                    await transaction.CommitAsync();
                    return true;
                }
                catch
                {
                    await transaction.RollbackAsync();
                    return false;
                }
            });
        }

        public async Task<bool> UpdatePaymentStatusAsync(int orderId, string status)
        {
            var order = await _unitOfWork.Repository<Order>().GetByIdAsync(orderId);
            if (order == null) return false;
            order.PaymentStatus = status;
            if (status == "Paid") order.Status = "Processing";
            _unitOfWork.Repository<Order>().Update(order);
            return await _unitOfWork.CompleteAsync() > 0;
        }
    }
}
