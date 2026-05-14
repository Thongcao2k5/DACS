using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Enums;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Data.Repositories
{
    public class PromotionRepository : GenericRepository<Promotion>, IPromotionRepository
    {
        public PromotionRepository(MotoShopDbContext context) : base(context)
        {
        }

        public async Task<List<Promotion>> GetActivePromotions()
        {
            var now = System.DateTime.Now;
            return await _context.Promotions
                .AsNoTracking()
                .Include(p => p.PromotionProducts)
                    .ThenInclude(pp => pp.Product)
                        .ThenInclude(p => p!.Variants)
                .Include(p => p.PromotionProducts)
                    .ThenInclude(pp => pp.Product)
                        .ThenInclude(p => p!.Images)
                .Where(p => p.IsActive && p.StartDate <= now && p.EndDate >= now)
                .OrderByDescending(p => p.Priority)
                .ThenByDescending(p => p.StartDate)
                .ToListAsync();
        }

        public async Task<List<Promotion>> GetByType(PromotionType type)
        {
            var now = System.DateTime.Now;
            return await _context.Promotions
                .AsNoTracking()
                .Include(p => p.PromotionProducts)
                    .ThenInclude(pp => pp.Product)
                        .ThenInclude(p => p!.Variants)
                .Where(p => p.PromotionType == type && p.IsActive && p.StartDate <= now && p.EndDate >= now)
                .OrderByDescending(p => p.Priority)
                .ThenByDescending(p => p.StartDate)
                .ToListAsync();
        }

        public async Task<Promotion?> GetByCode(string code)
        {
            if (string.IsNullOrWhiteSpace(code))
            {
                return null;
            }

            return await _context.Promotions
                .Include(p => p.PromotionProducts)
                    .ThenInclude(pp => pp.Product)
                        .ThenInclude(p => p!.Variants)
                .FirstOrDefaultAsync(p => p.CouponCode != null && p.CouponCode.ToLower() == code.ToLower());
        }

        public Task<List<Promotion>> GetFlashSales()
        {
            return GetByType(PromotionType.FlashSale);
        }

        public async Task<List<PromotionProduct>> GetPromotionProducts(int promotionId)
        {
            return await _context.PromotionProducts
                .AsNoTracking()
                .Where(pp => pp.PromotionId == promotionId)
                .Include(pp => pp.Product)
                    .ThenInclude(p => p!.Variants)
                .Include(pp => pp.Product)
                    .ThenInclude(p => p!.Images)
                .ToListAsync();
        }
    }
}
