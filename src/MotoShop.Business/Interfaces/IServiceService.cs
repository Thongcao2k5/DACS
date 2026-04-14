using MotoShop.Business.DTOs;
using MotoShop.Business.Helpers;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IServiceService
    {
        Task<IEnumerable<ServiceDto>> GetAllAsync();
        Task<ServiceDto> GetByIdAsync(int id);
        Task<PagedList<ServiceDto>> GetPagedAsync(string searchTerm, int pageNumber, int pageSize);
    }
}
