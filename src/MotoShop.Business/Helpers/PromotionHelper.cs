using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Enums;
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

            // 1. Kiểm tra Flash Sale (theo schema mới)
            var flashSaleProduct = await context.PromotionProducts.AsNoTracking()
                .Include(pp => pp.Promotion)
                .FirstOrDefaultAsync(pp => pp.ProductId == variant.ProductId 
                    && pp.Promotion != null 
                    && pp.Promotion.PromotionType == PromotionType.FlashSale
                    && pp.Promotion.DiscountValue > 0
                    && pp.Promotion.IsActive 
                    && pp.Promotion.StartDate <= now 
                    && pp.Promotion.EndDate >= now);

            if (flashSaleProduct != null)
            {
                var promo = flashSaleProduct.Promotion!;
                if (promo.DiscountType == DiscountType.Percent)
                    finalPrice = variant.Price * (1 - (promo.DiscountValue / 100));
                else
                    finalPrice = variant.Price - promo.DiscountValue;
            }
            else
            {
                // 2. Kiểm tra Khuyến mãi thường (ProductDiscount)
                var activePromotion = await context.PromotionProducts.AsNoTracking()
                    .Include(pp => pp.Promotion)
                    .Where(pp => pp.ProductId == variant.ProductId 
                        && pp.Promotion != null 
                        && pp.Promotion.PromotionType == PromotionType.ProductDiscount
                        && pp.Promotion.IsActive 
                        && pp.Promotion.StartDate <= now 
                        && pp.Promotion.EndDate >= now)
                    .Select(pp => pp.Promotion)
                    .FirstOrDefaultAsync();

                if (activePromotion != null)
                {
                    if (activePromotion.DiscountType == DiscountType.Percent)
                        finalPrice = variant.Price * (1 - (activePromotion.DiscountValue / 100));
                    else if (activePromotion.DiscountType == DiscountType.Fixed)
                        finalPrice = variant.Price - activePromotion.DiscountValue;
                }
            }

            if (finalPrice < 0) finalPrice = 0;
            if (finalPrice > variant.Price) finalPrice = variant.Price;

            return finalPrice;
        }
    }
}
