using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MotoShop.Business.Interfaces;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace MotoShop.Services
{
    public class BookingExpiryService : BackgroundService
    {
        private readonly IServiceProvider _provider;
        private readonly ILogger<BookingExpiryService> _logger;
        private static readonly SemaphoreSlim _semaphore = new SemaphoreSlim(1, 1);

        public BookingExpiryService(IServiceProvider provider, ILogger<BookingExpiryService> logger)
        {
            _provider = provider;
            _logger = logger;
        }

        protected override async Task ExecuteAsync(CancellationToken ct)
        {
            while (!ct.IsCancellationRequested)
            {
                if (await _semaphore.WaitAsync(0))
                {
                    try
                    {
                        using var scope = _provider.CreateScope();
                        var bookingService = scope.ServiceProvider.GetRequiredService<IBookingService>();
                        await bookingService.CancelExpiredBookingsAsync();
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "BookingExpiryService: lỗi khi hủy booking hết hạn");
                    }
                    finally
                    {
                        _semaphore.Release();
                    }
                }

                try
                {
                    await Task.Delay(TimeSpan.FromMinutes(5), ct);
                }
                catch (OperationCanceledException)
                {
                    break;
                }
            }
        }
    }
}
