using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Rendering;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using MotoShop.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class ProductController : Controller
    {
        private readonly IProductRepository _productRepository;
        private readonly IFileService _fileService;
        private readonly IGenericRepository<Category> _categoryRepository;
        private readonly IGenericRepository<Brand> _brandRepository;

        public ProductController(
            IProductRepository productRepository, 
            IFileService fileService,
            IGenericRepository<Category> categoryRepository,
            IGenericRepository<Brand> brandRepository)
        {
            _productRepository = productRepository;
            _fileService = fileService;
            _categoryRepository = categoryRepository;
            _brandRepository = brandRepository;
        }

        public async Task<IActionResult> Index(string? searchTerm, int? categoryId, int? brandId, string? status, string? sort)
        {
            var query = _productRepository.Find(p => true)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(p => p.ProductName.Contains(searchTerm) || 
                                       (p.Variants.Any(v => v.SKU != null && v.SKU.Contains(searchTerm))));
            }

            if (categoryId.HasValue)
            {
                query = query.Where(p => p.CategoryId == categoryId);
            }

            if (brandId.HasValue)
            {
                query = query.Where(p => p.BrandId == brandId);
            }

            if (!string.IsNullOrEmpty(status))
            {
                if (status.ToLower() == "active")
                {
                    query = query.Where(p => p.IsActive);
                }
                else if (status.ToLower() == "inactive")
                {
                    query = query.Where(p => !p.IsActive);
                }
                ViewBag.FilterStatus = status;
            }

            query = sort switch
            {
                "name_asc" => query.OrderBy(p => p.ProductName),
                "name_desc" => query.OrderByDescending(p => p.ProductName),
                "newest" => query.OrderByDescending(p => p.CreatedDate),
                "oldest" => query.OrderBy(p => p.CreatedDate),
                _ => query.OrderByDescending(p => p.CreatedDate)
            };

            var products = await query.ToListAsync();

            var categories = await _categoryRepository.GetAllAsync();
            ViewBag.CategoryList = new SelectList(categories, "CategoryId", "CategoryName", categoryId);

            var brands = await _brandRepository.GetAllAsync();
            ViewBag.BrandList = new SelectList(brands, "BrandId", "BrandName", brandId);

            ViewBag.SortList = new List<SelectListItem>
            {
                new SelectListItem { Value = "newest", Text = "Mới nhất", Selected = sort == "newest" },
                new SelectListItem { Value = "oldest", Text = "Cũ nhất", Selected = sort == "oldest" },
                new SelectListItem { Value = "name_asc", Text = "Tên A-Z", Selected = sort == "name_asc" },
                new SelectListItem { Value = "name_desc", Text = "Tên Z-A", Selected = sort == "name_desc" }
            };

            return View(products);
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            ViewBag.Categories = await _categoryRepository.GetAllAsync();
            ViewBag.Brands = await _brandRepository.GetAllAsync();
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(ProductCreateViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var errors = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                return Json(new { success = false, message = "Dữ liệu không hợp lệ!", errors = errors });
            }

            try
            {
                var product = new Product
                {
                    ProductName = model.ProductName,
                    Slug = model.ProductName.ToLower().Replace(" ", "-"),
                    Description = model.Description,
                    CategoryId = model.CategoryId,
                    BrandId = model.BrandId,
                    IsFeatured = model.IsFeatured,
                    IsActive = model.IsActive,
                    CreatedDate = DateTime.Now,
                    Images = new List<ProductImage>(),
                    Variants = new List<ProductVariant>()
                };

                if (model.Images != null && model.Images.Any())
                {
                    int order = 1;
                    foreach (var file in model.Images)
                    {
                        var paths = await _fileService.SaveProductImageAsync(file, "products");
                        product.Images.Add(new ProductImage { ImageUrl = paths["Full"], IsPrimary = (order == 1), DisplayOrder = order++ });
                    }
                }

                if (model.Variants != null && model.Variants.Any())
                {
                    foreach (var v in model.Variants)
                    {
                        var variant = new ProductVariant
                        {
                            VariantName = v.VariantName,
                            Price = v.Price,
                            SKU = v.SKU,
                            StockQuantity = v.StockQuantity,
                            CreatedDate = DateTime.Now
                        };
                        if (v.StockQuantity > 0)
                        {
                            variant.InventoryTransactions.Add(new InventoryTransaction { TransactionType = "StockIn", Quantity = v.StockQuantity, TransactionDate = DateTime.Now, Note = "Khởi tạo" });
                        }
                        product.Variants.Add(variant);
                    }
                }

                await _productRepository.AddAsync(product);
                await _productRepository.SaveChangesAsync();

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi hệ thống khi khởi tạo sản phẩm: " + ex.Message });
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var product = await _productRepository.Find(p => p.ProductId == id)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .FirstOrDefaultAsync();

            if (product == null) return NotFound();

            ViewBag.Categories = await _categoryRepository.GetAllAsync();
            ViewBag.Brands = await _brandRepository.GetAllAsync();

            return View(product);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int ProductId, string ProductName, int? CategoryId, int? BrandId, string Description, bool IsActive, bool IsFeatured,
            List<VariantViewModel> Variants, 
            List<int> DeletedVariantIds, 
            List<int> DeletedImageIds, 
            string ImageOrdersJson,
            List<IFormFile> NewImages)
        {
            try
            {
                var existingProduct = await _productRepository.Find(p => p.ProductId == ProductId)
                    .Include(p => p.Variants)
                    .Include(p => p.Images)
                    .FirstOrDefaultAsync();

                if (existingProduct == null) return Json(new { success = false, message = "Không tìm thấy sản phẩm trong hệ thống" });

                existingProduct.ProductName = ProductName;
                existingProduct.CategoryId = CategoryId;
                existingProduct.BrandId = BrandId;
                existingProduct.Description = Description;
                existingProduct.IsActive = IsActive;
                existingProduct.IsFeatured = IsFeatured;
                existingProduct.Slug = ProductName.ToLower().Replace(" ", "-");

                if (DeletedVariantIds != null && DeletedVariantIds.Any())
                {
                    var variantsToRemove = existingProduct.Variants.Where(v => DeletedVariantIds.Contains(v.ProductVariantId)).ToList();
                    foreach (var v in variantsToRemove) existingProduct.Variants.Remove(v);
                }

                if (Variants != null)
                {
                    foreach (var vModel in Variants)
                    {
                        var existingVariant = existingProduct.Variants.FirstOrDefault(v => v.ProductVariantId == vModel.ProductVariantId && v.ProductVariantId != 0);
                        if (existingVariant != null)
                        {
                            existingVariant.VariantName = vModel.VariantName;
                            existingVariant.Price = vModel.Price;
                            existingVariant.SKU = vModel.SKU;
                            existingVariant.StockQuantity = vModel.StockQuantity;
                        }
                        else
                        {
                            existingProduct.Variants.Add(new ProductVariant
                            {
                                VariantName = vModel.VariantName,
                                Price = vModel.Price,
                                SKU = vModel.SKU,
                                StockQuantity = vModel.StockQuantity,
                                CreatedDate = DateTime.Now
                            });
                        }
                    }
                }

                if (DeletedImageIds != null && DeletedImageIds.Any())
                {
                    var imagesToRemove = existingProduct.Images.Where(i => DeletedImageIds.Contains(i.ImageId)).ToList();
                    foreach (var img in imagesToRemove)
                    {
                        _fileService.DeleteFile(img.ImageUrl);
                        existingProduct.Images.Remove(img);
                    }
                }

                if (!string.IsNullOrEmpty(ImageOrdersJson))
                {
                    var orders = System.Text.Json.JsonSerializer.Deserialize<List<ImageOrderData>>(ImageOrdersJson);
                    if (orders != null)
                    {
                        foreach (var orderItem in orders)
                        {
                            var img = existingProduct.Images.FirstOrDefault(i => i.ImageId == orderItem.ImageId);
                            if (img != null)
                            {
                                img.DisplayOrder = orderItem.Order;
                                img.IsPrimary = (orderItem.Order == 1);
                            }
                        }
                    }
                }

                if (NewImages != null && NewImages.Any())
                {
                    int maxOrder = existingProduct.Images.Any() ? existingProduct.Images.Max(i => i.DisplayOrder) : 0;
                    foreach (var file in NewImages)
                    {
                        var paths = await _fileService.SaveProductImageAsync(file, "products");
                        if (paths != null && paths.ContainsKey("Full"))
                        {
                            existingProduct.Images.Add(new ProductImage
                            {
                                ImageUrl = paths["Full"],
                                DisplayOrder = ++maxOrder,
                                IsPrimary = (maxOrder == 1)
                            });
                        }
                    }
                }

                await _productRepository.SaveChangesAsync();
                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi hệ thống: " + ex.Message });
            }
        }

        public class ImageOrderData { public int ImageId { get; set; } public int Order { get; set; } }

        [HttpPost]
        public async Task<IActionResult> UpdateImageOrder([FromBody] List<ImageOrderData> model)
        {
            if (model == null || !model.Any()) return BadRequest();

            try
            {
                foreach (var item in model)
                {
                    var image = await _productRepository.FindImageByIdAsync(item.ImageId);
                    if (image != null)
                    {
                        image.DisplayOrder = item.Order;
                        image.IsPrimary = (item.Order == 1);
                        _productRepository.UpdateImage(image);
                    }
                }
                await _productRepository.SaveChangesAsync();
                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message });
            }
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                var product = await _productRepository.Find(p => p.ProductId == id)
                    .Include(p => p.Images)
                    .Include(p => p.Variants)
                    .Include(p => p.Reviews)
                    .FirstOrDefaultAsync();

                if (product == null) return Json(new { success = false, message = "Không tìm thấy sản phẩm" });

                // Kiểm tra xem có đơn hàng nào liên quan không
                // Nếu có, không cho xóa hoặc chỉ nên ẩn đi (IsActive = false)
                // Ở đây ta thực hiện xóa vì yêu cầu là "nút xóa"

                // Xóa ảnh vật lý
                if (product.Images != null)
                {
                    foreach (var img in product.Images)
                    {
                        _fileService.DeleteFile(img.ImageUrl);
                    }
                }

                _productRepository.Delete(product);
                await _productRepository.SaveChangesAsync();

                return Json(new { success = true, message = "Đã xóa sản phẩm thành công" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi khi xóa sản phẩm: " + ex.Message });
            }
        }

        [HttpPost]
        public async Task<IActionResult> DeleteSelected([FromBody] List<int> ids)
        {
            if (ids == null || !ids.Any()) return Json(new { success = false, message = "Không có sản phẩm nào được chọn" });

            try
            {
                var products = await _productRepository.Find(p => ids.Contains(p.ProductId))
                    .Include(p => p.Images)
                    .Include(p => p.Variants)
                    .Include(p => p.Reviews)
                    .ToListAsync();

                foreach (var product in products)
                {
                    if (product.Images != null)
                    {
                        foreach (var img in product.Images)
                        {
                            _fileService.DeleteFile(img.ImageUrl);
                        }
                    }
                }

                _productRepository.RemoveRange(products);
                await _productRepository.SaveChangesAsync();

                return Json(new { success = true, message = $"Đã xóa {products.Count} sản phẩm thành công" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi khi xóa nhiều sản phẩm: " + ex.Message });
            }
        }
    }
}
