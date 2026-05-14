using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MotoShop.Data.Data;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class PromotionBackgroundService : BackgroundService
    {
        private readonly IServiceScopeFactory _scopeFactory;
        private readonly ILogger<PromotionBackgroundService> _logger;

        public PromotionBackgroundService(IServiceScopeFactory scopeFactory, ILogger<PromotionBackgroundService> logger)
        {
            _scopeFactory = scopeFactory;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    await RefreshPromotionStatesAsync(stoppingToken);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Promotion background refresh failed.");
                }

                await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
            }
        }

        private async Task RefreshPromotionStatesAsync(CancellationToken stoppingToken)
        {
            using var scope = _scopeFactory.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<MotoShopDbContext>();
            var now = DateTime.Now;

            var promotions = await context.Promotions.ToListAsync(stoppingToken);
            var hasChanges = false;

            foreach (var promotion in promotions)
            {
                var shouldBeActive = promotion.StartDate <= now && promotion.EndDate >= now;
                if (promotion.IsActive != shouldBeActive)
                {
                    promotion.IsActive = shouldBeActive;
                    promotion.UpdatedAt = now;
                    hasChanges = true;
                }
            }

            if (hasChanges)
            {
                await context.SaveChangesAsync(stoppingToken);
            }
        }
    }
}
