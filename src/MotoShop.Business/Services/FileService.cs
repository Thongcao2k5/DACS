using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Processing;
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
        private readonly string[] _allowedMimeTypes = { "image/jpeg", "image/png", "image/webp" };

        public FileService(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        public async Task<FileUploadResult> SaveFileAsync(IFormFile file, string subFolder)
        {
            if (file == null) return FileUploadResult.Fail("Không có file.");

            var extension = Path.GetExtension(file.FileName).ToLower();
            if (!_allowedExtensions.Contains(extension))
                return FileUploadResult.Fail("Định dạng file không được hỗ trợ. Chỉ chấp nhận JPG, PNG, WEBP.");

            if (!_allowedMimeTypes.Contains(file.ContentType.ToLower()))
                return FileUploadResult.Fail("Loại MIME không hợp lệ.");

            if (file.Length > 5 * 1024 * 1024)
                return FileUploadResult.Fail("Kích thước file tối đa là 5MB.");

            var wwwrootPath = _environment.WebRootPath;
            var folderPath = Path.Combine(wwwrootPath, "uploads", subFolder);
            if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

            var fileName = $"{Guid.NewGuid()}{extension}";
            var fullPath = Path.Combine(folderPath, fileName);

            using var ms = new MemoryStream();
            await file.CopyToAsync(ms);
            var bytes = ms.ToArray();

            if (!IsValidImage(bytes))
                return FileUploadResult.Fail("Nội dung file không phải ảnh hợp lệ.");

            ms.Position = 0;
            using var stream = new FileStream(fullPath, FileMode.Create);
            await ms.CopyToAsync(stream);

            return FileUploadResult.Success($"/uploads/{subFolder}/{fileName}");
        }

        public async Task<FileUploadResult> SaveProductImageAsync(IFormFile file, string subFolder)
        {
            if (file == null) return FileUploadResult.Fail("Không có file.");

            var extension = Path.GetExtension(file.FileName).ToLower();
            if (!_allowedExtensions.Contains(extension))
                return FileUploadResult.Fail("Định dạng file không được hỗ trợ. Chỉ chấp nhận JPG, PNG, WEBP.");

            if (!_allowedMimeTypes.Contains(file.ContentType.ToLower()))
                return FileUploadResult.Fail("Loại MIME không hợp lệ.");

            if (file.Length > 5 * 1024 * 1024)
                return FileUploadResult.Fail("Kích thước file tối đa là 5MB.");

            using var ms = new MemoryStream();
            await file.CopyToAsync(ms);
            var bytes = ms.ToArray();

            if (!IsValidImage(bytes))
                return FileUploadResult.Fail("Nội dung file không phải ảnh hợp lệ.");

            ms.Position = 0;

            var fileName = $"{Guid.NewGuid()}{extension}";
            var wwwrootPath = _environment.WebRootPath;
            var baseFolder = Path.Combine("uploads", subFolder);
            var folderPath = Path.Combine(wwwrootPath, baseFolder);
            if (!Directory.Exists(folderPath)) Directory.CreateDirectory(folderPath);

            var fullPath = Path.Combine(folderPath, fileName);
            var relativePath = $"/{baseFolder}/{fileName}".Replace("\\", "/");

            using (var image = await Image.LoadAsync(ms))
            {
                if (image.Width > 800 || image.Height > 800)
                {
                    image.Mutate(x => x.Resize(new ResizeOptions
                    {
                        Size = new Size(800, 800),
                        Mode = ResizeMode.Max
                    }));
                }
                await image.SaveAsync(fullPath);
            }

            return FileUploadResult.SuccessWithPaths(new Dictionary<string, string>
            {
                { "Full", relativePath }, { "Medium", relativePath }, { "Thumb", relativePath }
            });
        }

        private bool IsValidImage(byte[] bytes)
        {
            if (bytes.Length < 4) return false;

            // JPEG: FF D8 FF
            if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF)
                return true;
            // PNG: 89 50 4E 47
            if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47)
                return true;
            // WEBP: 52 49 46 46 (RIFF)
            if (bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46)
                return true;

            return false;
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
