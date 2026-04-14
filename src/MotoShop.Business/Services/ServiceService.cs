using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class ServiceService : IServiceService
    {
        private readonly IGenericRepository<Service> _repository;
        private readonly IMapper _mapper;

        public ServiceService(IGenericRepository<Service> repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ServiceDto>> GetAllAsync()
        {
            var services = await _repository.GetAllAsync();
            return _mapper.Map<IEnumerable<ServiceDto>>(services);
        }

        public async Task<ServiceDto> GetByIdAsync(int id)
        {
            var service = await _repository.Find(s => s.ServiceId == id).FirstOrDefaultAsync();
            return _mapper.Map<ServiceDto>(service);
        }

        public async Task<PagedList<ServiceDto>> GetPagedAsync(string searchTerm, int pageNumber, int pageSize)
        {
            var query = _repository.Find(s => true);

            if (!string.IsNullOrEmpty(searchTerm))
            {
                var lowerSearchTerm = searchTerm.ToLower();
                query = query.Where(s => s.ServiceName.ToLower().Contains(lowerSearchTerm) || (s.Description != null && s.Description.ToLower().Contains(lowerSearchTerm)));
            }

            var dtoQuery = query.ProjectTo<ServiceDto>(_mapper.ConfigurationProvider);
            return await PagedList<ServiceDto>.CreateAsync(dtoQuery, pageNumber, pageSize);
        }
    }
}
