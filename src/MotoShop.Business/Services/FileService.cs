using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using MotoShop.Business.Interfaces;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;
using SixLabors.ImageSharp.Formats.Jpeg;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Business.Services
{
    public class FileService : IFileService
    {
        private readonly IWebHostEnvironment _environment;
        private readonly string[] _allowedExtensions = { ".jpg", ".jpeg", ".png", ".webp" };

        public FileService(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        public async Task<string> SaveFileAsync(IFormFile file, string subFolder)
        {
            if (file == null) return null;

            var extension = Path.GetExtension(file.FileName).ToLower();
            if (!_allowedExtensions.Contains(extension))
                throw new InvalidOperationException("Invalid file type.");

            var wwwrootPath = _environment.WebRootPath;
            var folderPath = Path.Combine(wwwrootPath, "uploads", subFolder);

            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            var fileName = $"{Guid.NewGuid()}{extension}";
            var fullPath = Path.Combine(folderPath, fileName);

            using (var stream = new FileStream(fullPath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            return $"/uploads/{subFolder}/{fileName}";
        }

        public async Task<Dictionary<string, string>> SaveProductImageAsync(IFormFile file, string subFolder)
        {
            if (file == null) return null;

            // Chỉ lưu 1 file duy nhất, không Resize để tăng tốc độ tối đa
            var extension = Path.GetExtension(file.FileName).ToLower();
            if (string.IsNullOrEmpty(extension)) extension = ".jpg";
            
            var fileName = $"{Guid.NewGuid()}{extension}";
            var wwwrootPath = _environment.WebRootPath;
            var baseFolder = Path.Combine("uploads", subFolder);
            var folderPath = Path.Combine(wwwrootPath, baseFolder);

            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            var fullPath = Path.Combine(folderPath, fileName);
            var relativePath = $"/{baseFolder}/{fileName}".Replace("\\", "/");

            using (var stream = new FileStream(fullPath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            var results = new Dictionary<string, string>
            {
                { "Full", relativePath },
                { "Medium", relativePath }, // Dùng chung 1 ảnh để tránh lỗi code chỗ khác
                { "Thumb", relativePath }
            };

            return results;
        }

        public void DeleteFile(string fileUrl)
        {
            if (string.IsNullOrEmpty(fileUrl)) return;

            var wwwrootPath = _environment.WebRootPath;
            var filePath = Path.Combine(wwwrootPath, fileUrl.TrimStart('/'));

            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }
            
            // Also try to delete thumb/medium versions if it's a product image
            if (fileUrl.Contains("-full"))
            {
                var thumbPath = Path.Combine(wwwrootPath, fileUrl.Replace("-full", "-thumb").TrimStart('/'));
                var mediumPath = Path.Combine(wwwrootPath, fileUrl.Replace("-full", "-medium").TrimStart('/'));
                if (File.Exists(thumbPath)) File.Delete(thumbPath);
                if (File.Exists(mediumPath)) File.Delete(mediumPath);
            }
        }
    }
}
