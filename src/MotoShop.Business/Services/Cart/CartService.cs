using AutoMapper;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
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

        public CartService(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<bool> AddToCartAsync(string userId, int variantId, int quantity)
        {
            var variant = await _unitOfWork.Repository<ProductVariant>().GetByIdAsync(variantId);
            if (variant == null || variant.StockQuantity < quantity) return false;

            var cart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (cart == null)
            {
                cart = new MotoShop.Data.Models.Cart { UserId = userId, CreatedDate = DateTime.Now };
                await _unitOfWork.Repository<MotoShop.Data.Models.Cart>().AddAsync(cart);
                await _unitOfWork.CompleteAsync();
            }

            var cartItem = cart.CartItems.FirstOrDefault(ci => ci.ProductVariantId == variantId);

            if (cartItem != null)
            {
                int newQty = cartItem.Quantity + quantity;
                if (variant.StockQuantity < newQty) return false;
                cartItem.Quantity = newQty;
                _unitOfWork.Repository<CartItem>().Update(cartItem);
            }
            else
            {
                cartItem = new CartItem
                {
                    CartId = cart.CartId,
                    ProductVariantId = variantId,
                    Quantity = quantity,
                    Price = variant.Price
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
                        .ThenInclude(pv => pv.Product)
                .FirstOrDefaultAsync();

            if (cart == null) return new List<CartItemDto>();

            return cart.CartItems.Select(ci => new CartItemDto
            {
                ProductVariantId = ci.ProductVariantId,
                ProductName = ci.ProductVariant.Product.ProductName,
                VariantName = ci.ProductVariant.VariantName,
                ImageUrl = ci.ProductVariant.ImageUrl ?? "",
                Price = ci.Price,
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

        public async Task SyncCartAsync(string guestId, string userId)
        {
            var guestCart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == guestId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (guestCart == null || !guestCart.CartItems.Any()) return;

            var userCart = await _unitOfWork.Repository<MotoShop.Data.Models.Cart>()
                .Find(c => c.UserId == userId)
                .Include(c => c.CartItems)
                .FirstOrDefaultAsync();

            if (userCart == null)
            {
                userCart = new MotoShop.Data.Models.Cart { UserId = userId, CreatedDate = DateTime.Now };
                await _unitOfWork.Repository<MotoShop.Data.Models.Cart>().AddAsync(userCart);
                await _unitOfWork.CompleteAsync();
            }

            foreach (var guestItem in guestCart.CartItems.ToList())
            {
                var userItem = userCart.CartItems.FirstOrDefault(i => i.ProductVariantId == guestItem.ProductVariantId);
                if (userItem != null)
                {
                    userItem.Quantity += guestItem.Quantity;
                    _unitOfWork.Repository<CartItem>().Update(userItem);
                }
                else
                {
                    guestItem.CartId = userCart.CartId;
                    await _unitOfWork.Repository<CartItem>().AddAsync(guestItem);
                }
            }

            _unitOfWork.Repository<MotoShop.Data.Models.Cart>().Delete(guestCart);
            await _unitOfWork.CompleteAsync();
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
