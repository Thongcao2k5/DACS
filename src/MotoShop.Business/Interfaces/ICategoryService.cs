using MotoShop.Business.DTOs;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface ICategoryService
    {
        Task<IEnumerable<CategoryDto>> GetAllAsync();
        Task<CategoryDto?> GetByIdAsync(int id);
        Task<bool> CreateAsync(CategoryDto categoryDto);
        Task<bool> UpdateAsync(CategoryDto categoryDto);
        Task<bool> DeleteAsync(int id);
    }
}
