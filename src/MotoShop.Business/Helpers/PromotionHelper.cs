using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Helpers
{
    public static class PromotionHelper
    {
        public static async Task<decimal> GetDiscountedPriceAsync(MotoShopDbContext context, ProductVariant variant)
        {
            decimal finalPrice = variant.Price;
            var now = DateTime.Now;

            // 1. Kiểm tra Flash Sale
            var flashSaleProduct = await context.FlashSaleProducts.AsNoTracking()
                .Include(fsp => fsp.FlashSale)
                .FirstOrDefaultAsync(fsp => fsp.ProductId == variant.ProductId && fsp.FlashSale != null && fsp.FlashSale.IsActive && fsp.FlashSale.StartDate <= now && fsp.FlashSale.EndDate >= now && fsp.Quantity > fsp.SoldQuantity);

            if (flashSaleProduct != null)
            {
                finalPrice = flashSaleProduct.FlashSalePrice;
            }
            else
            {
                // 2. Kiểm tra Khuyến mãi thường
                var activePromotion = await context.PromotionProducts.AsNoTracking()
                    .Include(pp => pp.Promotion)
                    .Where(pp => pp.ProductId == variant.ProductId && pp.Promotion != null && pp.Promotion.IsActive && pp.Promotion.StartDate <= now && pp.Promotion.EndDate >= now)
                    .Select(pp => pp.Promotion)
                    .FirstOrDefaultAsync();

                if (activePromotion != null)
                {
                    if (activePromotion.DiscountType == "Percentage")
                        finalPrice = variant.Price * (1 - (activePromotion.DiscountPercentage / 100));
                    else if (activePromotion.DiscountType == "FixedAmount")
                        finalPrice = variant.Price - activePromotion.DiscountAmount;
                }
            }

            if (finalPrice < 0) finalPrice = 0;
            if (finalPrice > variant.Price) finalPrice = variant.Price;

            return finalPrice;
        }
    }
}