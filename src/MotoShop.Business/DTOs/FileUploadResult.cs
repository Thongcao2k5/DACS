using System.Collections.Generic;

namespace MotoShop.Business.DTOs
{
    public class FileUploadResult
    {
        public bool IsSuccess { get; init; }
        public string? ErrorMessage { get; init; }
        public string? FilePath { get; init; }
        public Dictionary<string, string>? ImagePaths { get; init; }

        public static FileUploadResult Success(string filePath) =>
            new() { IsSuccess = true, FilePath = filePath };

        public static FileUploadResult SuccessWithPaths(Dictionary<string, string> paths) =>
            new() { IsSuccess = true, ImagePaths = paths };

        public static FileUploadResult Fail(string error) =>
            new() { IsSuccess = false, ErrorMessage = error };
    }
}
