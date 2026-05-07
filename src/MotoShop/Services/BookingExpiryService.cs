using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using MotoShop.Business.Interfaces;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace MotoShop.Services
{
    public class BookingExpiryService : BackgroundService
    {
        private readonly IServiceProvider _provider;

        public BookingExpiryService(IServiceProvider provider)
        {
            _provider = provider;
        }

        protected override async Task ExecuteAsync(CancellationToken ct)
        {
            while (!ct.IsCancellationRequested)
            {
                using (var scope = _provider.CreateScope())
                {
                    var bookingService = scope.ServiceProvider.GetRequiredService<IBookingService>();
                    try
                    {
                        await bookingService.CancelExpiredBookingsAsync();
                    }
                    catch (Exception)
                    {
                        // Log error if needed
                    }
                }

                // Chạy mỗi 5 phút
                await Task.Delay(TimeSpan.FromMinutes(5), ct);
            }
        }
    }
}
