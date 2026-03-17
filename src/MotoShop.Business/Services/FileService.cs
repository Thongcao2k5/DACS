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

            var extension = ".jpg"; // Force to jpg for consistency
            var fileName = Guid.NewGuid().ToString();
            var wwwrootPath = _environment.WebRootPath;
            var baseFolder = Path.Combine("uploads", subFolder);
            var folderPath = Path.Combine(wwwrootPath, baseFolder);

            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            var results = new Dictionary<string, string>();

            using var image = await Image.LoadAsync(file.OpenReadStream());
            
            // 1. Save Original (Optimized)
            var originalName = $"{fileName}-full{extension}";
            var originalPath = Path.Combine(folderPath, originalName);
            await image.SaveAsJpegAsync(originalPath, new JpegEncoder { Quality = 80 });
            results.Add("Full", $"/{baseFolder}/{originalName}");

            // 2. Save Medium (Width: 600)
            var mediumName = $"{fileName}-medium{extension}";
            var mediumPath = Path.Combine(folderPath, mediumName);
            using (var mediumImg = image.Clone(x => x.Resize(new ResizeOptions { 
                Size = new Size(600, 0), 
                Mode = ResizeMode.Max 
            })))
            {
                await mediumImg.SaveAsJpegAsync(mediumPath, new JpegEncoder { Quality = 75 });
                results.Add("Medium", $"/{baseFolder}/{mediumName}");
            }

            // 3. Save Thumbnail (150x150 Square)
            var thumbName = $"{fileName}-thumb{extension}";
            var thumbPath = Path.Combine(folderPath, thumbName);
            using (var thumbImg = image.Clone(x => x.Resize(new ResizeOptions { 
                Size = new Size(150, 150), 
                Mode = ResizeMode.Crop 
            })))
            {
                await thumbImg.SaveAsJpegAsync(thumbPath, new JpegEncoder { Quality = 70 });
                results.Add("Thumb", $"/{baseFolder}/{thumbName}");
            }

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
