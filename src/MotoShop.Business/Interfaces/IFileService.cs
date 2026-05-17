using Microsoft.AspNetCore.Http;
using MotoShop.Business.DTOs;
using System.Threading.Tasks;

namespace MotoShop.Business.Interfaces
{
    public interface IFileService
    {
        Task<FileUploadResult> SaveFileAsync(IFormFile file, string subFolder);
        Task<FileUploadResult> SaveProductImageAsync(IFormFile file, string subFolder);
        void DeleteFile(string fileName);
    }
}
