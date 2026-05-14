using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
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
        private readonly IEmailService _emailService;
        private readonly IPromotionService _promotionService;
        private readonly ILogger<OrderService> _logger;

        public OrderService(IUnitOfWork unitOfWork, MotoShopDbContext context, IEmailService emailService, IPromotionService promotionService, ILogger<OrderService> logger)
        {
            _unitOfWork = unitOfWork;
            _context = context;
            _emailService = emailService;
            _promotionService = promotionService;
            _logger = logger;
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
                        
                        decimal directPrice = variant.ProductId.HasValue
                            ? await _promotionService.CalculateDiscountAsync(variant.ProductId.Value, variant.Price)
                            : variant.Price;

                        orderItemsToCreate.Add(new OrderItem {
                            ProductVariantId = variant.ProductVariantId,
                            Quantity = checkoutData.DirectQuantity,
                            Price = directPrice
                        });
                        subTotal = directPrice * checkoutData.DirectQuantity;
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

                            var productVariant = item.ProductVariant ?? variant;
                            var discountedPrice = productVariant.ProductId.HasValue
                                ? await _promotionService.CalculateDiscountAsync(productVariant.ProductId.Value, productVariant.Price)
                                : productVariant.Price;
                            orderItemsToCreate.Add(new OrderItem {
                                ProductVariantId = item.ProductVariantId,
                                Quantity = item.Quantity,
                                Price = discountedPrice
                            });
                            subTotal += discountedPrice * item.Quantity;
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
                    decimal discountedSubTotal = await _promotionService.CalculateOrderDiscountAsync(subTotal, new List<CartItem>());
                    discountAmount += subTotal - discountedSubTotal;

                    if (!string.IsNullOrEmpty(checkoutData.CouponCode))
                    {
                        checkoutData.CouponId = null;

                        var voucherValidation = await _promotionService.ValidateVoucherAsync(checkoutData.CouponCode, discountedSubTotal);
                        if (voucherValidation.IsValid)
                        {
                            var totalAfterVoucher = await _promotionService.ApplyVoucherAsync(checkoutData.CouponCode, discountedSubTotal);
                            discountAmount += discountedSubTotal - totalAfterVoucher;
                            discountedSubTotal = totalAfterVoucher;
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
                        CustomerId = customer.CustomerId, OrderDate = DateTime.Now, TotalAmount = discountedSubTotal + shippingCost,
                        Status = MotoShop.Data.Constants.OrderStatusConst.Pending, PaymentStatus = "Unpaid", DiscountAmount = discountAmount,
                        ShippingAddress = $"{finalFullName} | {finalPhone} | {finalAddressStr}",
                        Note = checkoutData.Note, ShippingMethodId = checkoutData.ShippingMethodId, CouponId = checkoutData.CouponId,
                        PaymentMethod = checkoutData.PaymentMethod
                    };

                    _context.Orders.Add(order);
                    await _context.SaveChangesAsync();

                    // 5. LƯU CHI TIẾT VÀ TRỪ KHO
                    foreach (var item in orderItemsToCreate)
                    {
                        var dbVar = await _context.ProductVariants
                            .Include(v => v.Product)
                            .FirstOrDefaultAsync(v => v.ProductVariantId == item.ProductVariantId);
                            
                        if (dbVar == null || dbVar.StockQuantity < item.Quantity) throw new Exception("Sản phẩm hết hàng.");
                        item.OrderId = order.OrderId;
                        _context.OrderItems.Add(item);
                        dbVar.StockQuantity -= item.Quantity;
                        
                        if (dbVar.Product != null)
                        {
                            dbVar.Product.SoldCount += item.Quantity;
                        }

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

                    // Gửi email xác nhận — không block nếu lỗi
                    var confirmedOrderId = order.OrderId;
                    try
                    {
                        var orderForEmail = await _context.Orders
                            .AsNoTracking()
                            .Include(o => o.Customer)
                            .Include(o => o.OrderItems)
                                .ThenInclude(oi => oi.ProductVariant)
                                    .ThenInclude(v => v!.Product)
                            .Include(o => o.ShippingMethod)
                            .FirstOrDefaultAsync(o => o.OrderId == confirmedOrderId);

                        if (orderForEmail?.Customer?.Email != null)
                            await _emailService.SendOrderConfirmationAsync(orderForEmail);
                    }
                    catch (Exception emailEx)
                    {
                        _logger.LogError(emailEx, "Order confirmation email failed for order {OrderId}", confirmedOrderId);
                    }

                    return (true, "Đặt hàng thành công!", confirmedOrderId);
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
            var orders = await _context.Orders
                .Include(o => o.Customer)
                .Where(o => o.Customer != null && o.Customer.UserId == userId)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            return orders.Select(o => new OrderDto
            {
                OrderId = o.OrderId, 
                OrderCode = o.OrderCode ?? string.Empty, 
                OrderDate = o.OrderDate,
                TotalAmount = o.TotalAmount, 
                Status = o.Status ?? string.Empty, 
                PaymentStatus = o.PaymentStatus ?? string.Empty, 
                ShippingAddress = o.ShippingAddress ?? string.Empty
            }).ToList();
        }

        public async Task<OrderDto> GetOrderDetailsAsync(int orderId, string userId)
        {
            var o = await _context.Orders
                .Include(o => o.Customer)
                .FirstOrDefaultAsync(o => o.OrderId == orderId && o.Customer != null && o.Customer.UserId == userId);
                
            return o == null ? null! : new OrderDto { 
                OrderId = o.OrderId, 
                OrderCode = o.OrderCode ?? string.Empty, 
                TotalAmount = o.TotalAmount, 
                Status = o.Status ?? string.Empty 
            };
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
                    var cancellable = new[] { MotoShop.Data.Constants.OrderStatusConst.Pending, MotoShop.Data.Constants.OrderStatusConst.Processing, MotoShop.Data.Constants.OrderStatusConst.DangXuLy };
                    if (order == null || !cancellable.Contains(order.Status)) return false;

                    order.Status = MotoShop.Data.Constants.OrderStatusConst.Cancelled;
                    foreach (var item in order.OrderItems)
                    {
                        if (item.ProductVariant != null)
                        {
                            item.ProductVariant.StockQuantity += item.Quantity;
                            
                            var dbProduct = await _context.Products.FindAsync(item.ProductVariant.ProductId);
                            if (dbProduct != null)
                            {
                                dbProduct.SoldCount = Math.Max(0, dbProduct.SoldCount - item.Quantity);
                            }

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
            if (status == "Paid") order.Status = MotoShop.Data.Constants.OrderStatusConst.Processing;
            _unitOfWork.Repository<Order>().Update(order);
            return await _unitOfWork.CompleteAsync() > 0;
        }

    }
}
