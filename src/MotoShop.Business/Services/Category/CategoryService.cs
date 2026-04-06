using MotoShop.Business.DTOs;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryDto>> GetAllAsync();
        Task<CategoryDto?> GetByIdAsync(int id);
        Task<bool> CreateAsync(CategoryDto categoryDto);
        Task<bool> UpdateAsync(CategoryDto categoryDto);
        Task<bool> DeleteAsync(int id);
    }

    public class CategoryService : ICategoryService
    {
        private readonly IUnitOfWork _uow;
        private readonly IMapper _mapper;

        public CategoryService(IUnitOfWork uow, IMapper mapper)
        {
            _uow = uow;
            _mapper = mapper;
        }

        public async Task<IEnumerable<CategoryDto>> GetAllAsync()
        {
            var categories = await _uow.Repository<Category>().GetAllAsync();
            return _mapper.Map<IEnumerable<CategoryDto>>(categories);
        }

        public async Task<CategoryDto?> GetByIdAsync(int id)
        {
            var category = await _uow.Repository<Category>().GetByIdAsync(id);
            return _mapper.Map<CategoryDto>(category);
        }

        public async Task<bool> CreateAsync(CategoryDto categoryDto)
        {
            var category = _mapper.Map<Category>(categoryDto);
            await _uow.Repository<Category>().AddAsync(category);
            return await _uow.CompleteAsync() > 0;
        }

        public async Task<bool> UpdateAsync(CategoryDto categoryDto)
        {
            var category = _mapper.Map<Category>(categoryDto);
            _uow.Repository<Category>().Update(category);
            return await _uow.CompleteAsync() > 0;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            await _uow.Repository<Category>().DeleteAsync(id);
            return await _uow.CompleteAsync() > 0;
        }
    }
}
