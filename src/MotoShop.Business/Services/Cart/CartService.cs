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
    public class CartService : ICartService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IPromotionService _promotionService;

        public CartService(IUnitOfWork unitOfWork, IPromotionService promotionService)
        {
            _unitOfWork = unitOfWork;
            _promotionService = promotionService;
        }

        public async Task<bool> AddToCartAsync(string userId, int variantId, int quantity)
        {
            if (quantity < 1) return false;

            var variant = await _unitOfWork.Repository<ProductVariant>()
                .Find(v => v.ProductVariantId == variantId)
                .Include(v => v.Product)
                .FirstOrDefaultAsync();

            if (variant == null || variant.StockQuantity < quantity) return false;

            decimal finalPrice = variant.ProductId.HasValue
                ? await _promotionService.CalculateDiscountAsync(variant.ProductId.Value, variant.Price)
                : variant.Price;

            var cart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (cart == null)
            {
                cart = new MotoShop.Data.Models.Cart { UserId = userId, CreatedDate = DateTime.Now, CartItems = new List<CartItem>() };
                await _unitOfWork.Repository<MotoShop.Data.Models.Cart>().AddAsync(cart);
                await _unitOfWork.CompleteAsync(); // Save to generate CartId
            }

            var cartItem = cart.CartItems.FirstOrDefault(ci => ci.ProductVariantId == variantId);

            if (cartItem != null)
            {
                int newQty = cartItem.Quantity + quantity;
                if (variant.StockQuantity < newQty) return false;
                cartItem.Quantity = newQty;
                cartItem.Price = finalPrice; // Cập nhật lại giá nếu có khuyến mãi mới
                _unitOfWork.Repository<CartItem>().Update(cartItem);
            }
            else
            {
                cartItem = new CartItem
                {
                    CartId = cart.CartId,
                    ProductVariantId = variantId,
                    Quantity = quantity,
                    Price = finalPrice // Lưu giá khuyến mãi vào giỏ hàng
                };
                await _unitOfWork.Repository<CartItem>().AddAsync(cartItem);
            }

            return await _unitOfWork.CompleteAsync() > 0;
        }

        public async Task<List<CartItemDto>> GetCartAsync(string userId)
        {
            var cart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                    .ThenInclude(ci => ci.ProductVariant)
                        .ThenInclude(pv => pv != null ? pv.Product : null)
                .FirstOrDefaultAsync();

            if (cart == null) return new List<CartItemDto>();

            return cart.CartItems
                .Where(ci => ci.ProductVariant != null && ci.ProductVariant.Product != null)
                .Select(ci => new CartItemDto
            {
                ProductVariantId = ci.ProductVariantId,
                ProductName = ci.ProductVariant!.Product!.ProductName,
                VariantName = ci.ProductVariant.VariantName,
                ImageUrl = ci.ProductVariant.ImageUrl ?? "",
                Price = ci.Price, // Giá đã lưu trong giỏ hàng (có thể là giá khuyến mãi)
                OriginalPrice = ci.ProductVariant.Price, // Giá niêm yết hiện tại của hệ thống
                Quantity = ci.Quantity,
                StockQuantity = ci.ProductVariant.StockQuantity
            }).ToList();
        }

        public async Task<bool> UpdateQuantityAsync(string userId, int variantId, int quantity)
        {
            var cart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (cart == null) return false;

            var cartItem = cart.CartItems.FirstOrDefault(ci => ci.ProductVariantId == variantId);
            if (cartItem == null) return false;

            if (quantity <= 0)
            {
                _unitOfWork.Repository<CartItem>().Delete(cartItem);
            }
            else
            {
                var variant = await _unitOfWork.Repository<ProductVariant>().GetByIdAsync(variantId);
                if (variant == null || variant.StockQuantity < quantity) return false;
                cartItem.Quantity = quantity;
                _unitOfWork.Repository<CartItem>().Update(cartItem);
            }

            return await _unitOfWork.CompleteAsync() > 0;
        }

        public async Task<bool> RemoveFromCartAsync(string userId, int variantId)
        {
            var cart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (cart == null) return false;

            var cartItem = cart.CartItems.FirstOrDefault(ci => ci.ProductVariantId == variantId);
            if (cartItem != null)
            {
                _unitOfWork.Repository<CartItem>().Delete(cartItem);
                return await _unitOfWork.CompleteAsync() > 0;
            }
            return false;
        }

        public async Task<bool> ClearCartAsync(string userId)
        {
            var cart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (cart == null) return true;

            foreach (var item in cart.CartItems.ToList())
            {
                _unitOfWork.Repository<CartItem>().Delete(item);
            }
            return await _unitOfWork.CompleteAsync() > 0;
        }

        public async Task<bool> SyncCartAsync(string guestId, string userId)
        {
            if (string.IsNullOrEmpty(guestId) || guestId == userId) return true;

            // 1. Lấy giỏ hàng khách
            var guestCart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == guestId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (guestCart == null || !guestCart.CartItems.Any()) return true;

            // 2. Lấy hoặc tạo giỏ hàng User
            var userCart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (userCart == null)
            {
                userCart = new MotoShop.Data.Models.Cart { UserId = userId, CreatedDate = DateTime.Now, CartItems = new List<CartItem>() };
                await _unitOfWork.Repository<MotoShop.Data.Models.Cart>().AddAsync(userCart);
                await _unitOfWork.CompleteAsync(); 
            }

            // 3. Sao chép items — giới hạn số lượng không vượt tồn kho hiện tại
            var guestItems = guestCart.CartItems.ToList();
            foreach (var guestItem in guestItems)
            {
                var stock = await _unitOfWork.Repository<ProductVariant>()
                    .Find(v => v.ProductVariantId == guestItem.ProductVariantId)
                    .Select(v => v.StockQuantity)
                    .FirstOrDefaultAsync();

                var userItem = userCart.CartItems.FirstOrDefault(i => i.ProductVariantId == guestItem.ProductVariantId);
                if (userItem != null)
                {
                    if (guestItem.Quantity < 1) continue;
                    userItem.Quantity = Math.Min(userItem.Quantity + guestItem.Quantity, stock);
                    _unitOfWork.Repository<CartItem>().Update(userItem);
                }
                else
                {
                    if (guestItem.Quantity < 1 || stock < 1) continue;
                    var newItem = new CartItem
                    {
                        CartId = userCart.CartId,
                        ProductVariantId = guestItem.ProductVariantId,
                        Quantity = Math.Min(guestItem.Quantity, stock),
                        Price = guestItem.Price
                    };
                    await _unitOfWork.Repository<CartItem>().AddAsync(newItem);
                }
            }

            // 4. Xóa giỏ hàng khách
            _unitOfWork.Repository<MotoShop.Data.Models.Cart>().Delete(guestCart);
            
            try
            {
                return await _unitOfWork.CompleteAsync() > 0;
            }
            catch (DbUpdateConcurrencyException)
            {
                return false;
            }
        }

        public async Task<int> GetCartCountAsync(string userId)
        {
            var cart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            return cart?.CartItems.Sum(i => i.Quantity) ?? 0;
        }
    }
}
