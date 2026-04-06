using MotoShop.Business.DTOs;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public interface IBrandService
    {
        Task<IEnumerable<BrandDto>> GetAllAsync();
        Task<BrandDto?> GetByIdAsync(int id);
        Task<bool> CreateAsync(BrandDto brandDto);
        Task<bool> UpdateAsync(BrandDto brandDto);
        Task<bool> DeleteAsync(int id);
    }

    public class BrandService : IBrandService
    {
        private readonly IUnitOfWork _uow;
        private readonly IMapper _mapper;

        public BrandService(IUnitOfWork uow, IMapper mapper)
        {
            _uow = uow;
            _mapper = mapper;
        }

        public async Task<IEnumerable<BrandDto>> GetAllAsync()
        {
            var brands = await _uow.Repository<Brand>().GetAllAsync();
            return _mapper.Map<IEnumerable<BrandDto>>(brands);
        }

        public async Task<BrandDto?> GetByIdAsync(int id)
        {
            var brand = await _uow.Repository<Brand>().GetByIdAsync(id);
            return _mapper.Map<BrandDto>(brand);
        }

        public async Task<bool> CreateAsync(BrandDto brandDto)
        {
            var brand = _mapper.Map<Brand>(brandDto);
            await _uow.Repository<Brand>().AddAsync(brand);
            return await _uow.CompleteAsync() > 0;
        }

        public async Task<bool> UpdateAsync(BrandDto brandDto)
        {
            var brand = _mapper.Map<Brand>(brandDto);
            _uow.Repository<Brand>().Update(brand);
            return await _uow.CompleteAsync() > 0;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            await _uow.Repository<Brand>().DeleteAsync(id);
            return await _uow.CompleteAsync() > 0;
        }
    }
}
