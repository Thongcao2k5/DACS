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
        private static readonly HashSet<string> _allowedPaymentMethods =
            new(StringComparer.OrdinalIgnoreCase) { "COD", "VNPay", "BankTransfer" };

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
                    decimal originalSubTotal = 0;

                    if (checkoutData.DirectVariantId.HasValue)
                    {
                        if (checkoutData.DirectQuantity < 1)
                            return (false, "Số lượng sản phẩm không hợp lệ.", 0);

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
                        originalSubTotal = variant.Price * checkoutData.DirectQuantity;
                        subTotal = directPrice * checkoutData.DirectQuantity;
                    }
                    else
                    {
                        var cart = await _context.Carts.Include(c => c.CartItems).ThenInclude(i => i.ProductVariant).FirstOrDefaultAsync(c => c.UserId == userId);
                        if (cart == null || !cart.CartItems.Any()) return (false, "Giỏ hàng trống.", 0);

                        foreach (var item in cart.CartItems)
                        {
                            var productVariant = item.ProductVariant;
                            if (item.Quantity < 1)
                                return (false, "Giỏ hàng có sản phẩm với số lượng không hợp lệ.", 0);

                            if (productVariant == null || productVariant.StockQuantity < item.Quantity)
                                return (false, $"Sản phẩm '{productVariant?.VariantName}' không đủ tồn kho.", 0);

                            var discountedPrice = productVariant.ProductId.HasValue
                                ? await _promotionService.CalculateDiscountAsync(productVariant.ProductId.Value, productVariant.Price)
                                : productVariant.Price;
                            orderItemsToCreate.Add(new OrderItem {
                                ProductVariantId = item.ProductVariantId,
                                Quantity = item.Quantity,
                                Price = discountedPrice
                            });
                            originalSubTotal += productVariant.Price * item.Quantity;
                            subTotal += discountedPrice * item.Quantity;
                        }
                    }

                    // 2. XỬ LÝ ĐỊA CHỈ
                    string finalFullName = checkoutData.FullName ?? "";
                    string finalPhone = checkoutData.Phone ?? "";
                    string finalAddressStr = "";

                    if (checkoutData.AddressId.HasValue)
                    {
                        // IDOR: chỉ lấy địa chỉ thuộc về customer hiện tại
                        var savedAddr = await _context.AddressesNew
                            .FirstOrDefaultAsync(a => a.Id == checkoutData.AddressId.Value && a.CustomerId == customer.CustomerId);
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
                    discountAmount += Math.Max(0, originalSubTotal - subTotal); // Flash Sale per-item discount
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
                    int? shippingMethodId = null;

                    if (checkoutData.ShippingDistrictId.HasValue)
                    {
                        // GHN flow — ShippingFee = 0 nếu freeship, > 0 nếu có phí
                        // GHN serviceId ≠ ShippingMethods.Id → không lưu ShippingMethodId
                        shippingCost = checkoutData.ShippingFee;
                    }
                    else if (checkoutData.ShippingMethodId.HasValue)
                    {
                        // Phương thức nội bộ
                        var ship = await _context.ShippingMethods.FindAsync(checkoutData.ShippingMethodId.Value);
                        if (ship != null)
                        {
                            shippingCost  = ship.Cost;
                            shippingMethodId = ship.Id;
                        }
                    }

                    // 4. TẠO ĐƠN HÀNG
                    var order = new Order {
                        CustomerId = customer.CustomerId, OrderDate = DateTime.Now, TotalAmount = discountedSubTotal + shippingCost,
                        Status = MotoShop.Data.Constants.OrderStatusConst.Pending, PaymentStatus = "Unpaid", DiscountAmount = discountAmount,
                        ShippingAddress = $"{finalFullName} | {finalPhone} | {finalAddressStr}",
                        Note = checkoutData.Note, ShippingMethodId = shippingMethodId, CouponId = checkoutData.CouponId,
                        ShippingFee = shippingCost,
                        ShippingDistrictId = checkoutData.ShippingDistrictId,
                        ShippingWardCode = checkoutData.ShippingWardCode,
                        PaymentMethod = _allowedPaymentMethods.Contains(checkoutData.PaymentMethod ?? "")
                            ? checkoutData.PaymentMethod!
                            : "COD"
                    };

                    _context.Orders.Add(order);
                    await _context.SaveChangesAsync();

                    // 5. LƯU CHI TIẾT VÀ TRỪ KHO (atomic — tránh oversell)
                    foreach (var item in orderItemsToCreate)
                    {
                        // Atomic check-and-decrement: chỉ trừ khi còn đủ hàng
                        var stockRows = await _context.ProductVariants
                            .Where(v => v.ProductVariantId == item.ProductVariantId && v.StockQuantity >= item.Quantity)
                            .ExecuteUpdateAsync(v => v.SetProperty(p => p.StockQuantity, p => p.StockQuantity - item.Quantity));

                        if (stockRows == 0)
                            throw new Exception("Sản phẩm vừa hết hàng, vui lòng thử lại.");

                        var productId = await _context.ProductVariants
                            .Where(v => v.ProductVariantId == item.ProductVariantId)
                            .Select(v => v.ProductId)
                            .FirstOrDefaultAsync();

                        if (productId.HasValue)
                            await ReservePromotionQuantityAsync(productId.Value, item.Quantity);

                        item.OrderId = order.OrderId;
                        _context.OrderItems.Add(item);

                        _context.InventoryTransactions.Add(new InventoryTransaction {
                            ProductVariantId = item.ProductVariantId, Quantity = -item.Quantity,
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
                    _logger.LogError(ex,
                        "Checkout lỗi: {Msg} | Inner: {Inner} | StackTrace: {Stack}",
                        ex.Message,
                        ex.InnerException?.Message,
                        ex.InnerException?.StackTrace);
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
                    var order = await _context.Orders
                        .Include(o => o.OrderItems).ThenInclude(oi => oi.ProductVariant)
                        .Include(o => o.Customer)
                        .FirstOrDefaultAsync(o => o.OrderId == orderId && o.Customer != null && o.Customer.UserId == userId);
                    var cancellable = new[] { MotoShop.Data.Constants.OrderStatusConst.Pending, MotoShop.Data.Constants.OrderStatusConst.Processing, MotoShop.Data.Constants.OrderStatusConst.DangXuLy };
                    if (order == null || !cancellable.Contains(order.Status)) return false;

                    order.Status = MotoShop.Data.Constants.OrderStatusConst.Cancelled;
                    foreach (var item in order.OrderItems)
                    {
                        if (item.ProductVariant != null)
                        {
                            // Atomic stock restoration — tránh race condition khi nhiều cancel đồng thời
                            await _context.ProductVariants
                                .Where(v => v.ProductVariantId == item.ProductVariantId)
                                .ExecuteUpdateAsync(v => v.SetProperty(p => p.StockQuantity, p => p.StockQuantity + item.Quantity));

                            if (item.ProductVariant.ProductId.HasValue)
                                await ReleasePromotionQuantityAsync(item.ProductVariant.ProductId.Value, item.Quantity);

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
                catch (Exception ex)
                {
                    await transaction.RollbackAsync();
                    _logger.LogError(ex, "CancelOrderAsync failed for order {OrderId}", orderId);
                    return false;
                }
            });
        }

        public async Task<bool> UpdatePaymentStatusAsync(int orderId, string status)
        {
            // Atomic: chỉ update nếu chưa ở trạng thái Paid — tránh race condition VNPay callback 2 lần
            var rows = await _context.Orders
                .Where(o => o.OrderId == orderId && o.PaymentStatus != MotoShop.Data.Constants.PaymentStatusConst.Paid)
                .ExecuteUpdateAsync(setters => setters
                    .SetProperty(o => o.PaymentStatus, status)
                    .SetProperty(o => o.Status, o => status == MotoShop.Data.Constants.PaymentStatusConst.Paid
                        ? MotoShop.Data.Constants.OrderStatusConst.Processing
                        : o.Status));
            return rows > 0;
        }

        public async Task CompleteOrderAsync(int orderId)
        {
            // Join OrderItems → ProductVariants để lấy ProductId trong 1 query, tránh N+1
            var soldCounts = await _context.OrderItems
                .Where(oi => oi.OrderId == orderId)
                .Join(_context.ProductVariants,
                    oi => oi.ProductVariantId,
                    pv => pv.ProductVariantId,
                    (oi, pv) => new { pv.ProductId, oi.Quantity })
                .Where(x => x.ProductId.HasValue)
                .GroupBy(x => x.ProductId!.Value)
                .Select(g => new { ProductId = g.Key, TotalQty = g.Sum(x => x.Quantity) })
                .ToListAsync();

            foreach (var item in soldCounts)
            {
                await _context.Products
                    .Where(p => p.ProductId == item.ProductId)
                    .ExecuteUpdateAsync(p => p.SetProperty(pp => pp.SoldCount, pp => pp.SoldCount + item.TotalQty));
            }
        }

        private async Task ReservePromotionQuantityAsync(int productId, int quantity)
        {
            var now = DateTime.Now;
            var promotionProductId = await _context.PromotionProducts
                .Where(pp => pp.ProductId == productId
                    && pp.Promotion != null
                    && pp.Promotion.PromotionType == MotoShop.Data.Enums.PromotionType.FlashSale
                    && pp.Promotion.IsActive
                    && pp.Promotion.StartDate <= now
                    && pp.Promotion.EndDate >= now
                    && pp.Quantity.HasValue)
                .OrderByDescending(pp => pp.Promotion!.Priority)
                .Select(pp => (int?)pp.Id)
                .FirstOrDefaultAsync();

            if (!promotionProductId.HasValue) return;

            var rows = await _context.PromotionProducts
                .Where(pp => pp.Id == promotionProductId.Value
                    && pp.Quantity.HasValue
                    && pp.SoldQuantity + quantity <= pp.Quantity.Value)
                .ExecuteUpdateAsync(pp => pp.SetProperty(p => p.SoldQuantity, p => p.SoldQuantity + quantity));

            if (rows == 0)
                throw new Exception("Sản phẩm đã hết số lượng trong Flash Sale.");
        }

        private async Task ReleasePromotionQuantityAsync(int productId, int quantity)
        {
            var now = DateTime.Now;
            var promotionProductId = await _context.PromotionProducts
                .Where(pp => pp.ProductId == productId
                    && pp.Promotion != null
                    && pp.Promotion.PromotionType == MotoShop.Data.Enums.PromotionType.FlashSale
                    && pp.Promotion.IsActive
                    && pp.Promotion.StartDate <= now
                    && pp.Promotion.EndDate >= now
                    && pp.SoldQuantity > 0)
                .OrderByDescending(pp => pp.Promotion!.Priority)
                .Select(pp => (int?)pp.Id)
                .FirstOrDefaultAsync();

            if (!promotionProductId.HasValue) return;

            await _context.PromotionProducts
                .Where(pp => pp.Id == promotionProductId.Value)
                .ExecuteUpdateAsync(pp => pp.SetProperty(p => p.SoldQuantity,
                    p => p.SoldQuantity >= quantity ? p.SoldQuantity - quantity : 0));
        }

    }
}
