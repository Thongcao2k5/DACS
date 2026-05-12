using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace MotoShop.Services
{
    public class PendingPaymentCleanupService : BackgroundService
    {
        private readonly IServiceProvider _provider;
        private readonly ILogger<PendingPaymentCleanupService> _logger;

        public PendingPaymentCleanupService(IServiceProvider provider, ILogger<PendingPaymentCleanupService> logger)
        {
            _provider = provider;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                try
                {
                    await Task.Delay(TimeSpan.FromMinutes(15), stoppingToken);
                }
                catch (OperationCanceledException)
                {
                    break;
                }

                try
                {
                    using var scope = _provider.CreateScope();
                    var context = scope.ServiceProvider.GetRequiredService<MotoShop.Data.Data.MotoShopDbContext>();

                    var threshold = DateTime.Now.AddMinutes(-30);
                    var expiredOrders = await context.Orders
                        .Where(o => o.PaymentMethod == "VNPay"
                            && o.PaymentStatus == "Unpaid"
                            && o.Status == "Pending"
                            && o.OrderDate < threshold)
                        .ToListAsync(stoppingToken);

                    if (expiredOrders.Count > 0)
                    {
                        foreach (var order in expiredOrders)
                        {
                            order.Status = "Cancelled";
                            order.PaymentStatus = "Cancelled";
                        }
                        await context.SaveChangesAsync(stoppingToken);
                        _logger.LogInformation("Cancelled {Count} expired VNPay orders (pending > 30 min)", expiredOrders.Count);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error in PendingPaymentCleanupService");
                }
            }
        }
    }
}
