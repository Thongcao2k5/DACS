using MotoShop.Business.DTOs;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using AutoMapper;
using System.Collections.Generic;
using System.Threading.Tasks;
using MotoShop.Business.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace MotoShop.Business.Services
{
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
            // Nạp thêm danh sách sản phẩm để AutoMapper có thể đếm chính xác số lượng
            var categories = await _uow.Repository<Category>()
                .Find(c => true)
                .Include(c => c.Products)
                .ToListAsync();
                
            return _mapper.Map<IEnumerable<CategoryDto>>(categories);
        }

        public async Task<CategoryDto?> GetByIdAsync(int id)
        {
            var category = await _uow.Repository<Category>()
                .Find(c => c.CategoryId == id)
                .Include(c => c.Products)
                .FirstOrDefaultAsync();
                
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
