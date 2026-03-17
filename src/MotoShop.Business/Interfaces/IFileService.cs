using Microsoft.AspNetCore.Http;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IFileService
    {
        Task<string> SaveFileAsync(IFormFile file, string subFolder);
        Task<Dictionary<string, string>> SaveProductImageAsync(IFormFile file, string subFolder);
        void DeleteFile(string fileName);
    }
}
