using AutoMapper;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class ServiceBookingService : IServiceBookingService
    {
        private readonly IGenericRepository<ServiceBooking> _bookingRepository;
        private readonly IMapper _mapper;

        public ServiceBookingService(IGenericRepository<ServiceBooking> bookingRepository, IMapper mapper)
        {
            _bookingRepository = bookingRepository;
            _mapper = mapper;
        }

        public async Task<bool> CreateBookingAsync(ServiceBookingDto bookingDto)
        {
            try
            {
                var booking = _mapper.Map<ServiceBooking>(bookingDto);
                booking.BookingDate = DateTime.Now;
                booking.Status = "Pending";

                await _bookingRepository.AddAsync(booking);
                await _bookingRepository.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}
