using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Interfaces;
using MotoShop.Data.Models;
using MotoShop.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

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

        public async Task<IActionResult> Index(string? status)
        {
            var query = _productRepository.Find(p => true)
                .Include(p => p.Category)
                .Include(p => p.Brand)
                .Include(p => p.Images)
                .Include(p => p.Variants)
                .AsQueryable();

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

            var products = await query.ToListAsync();

            ViewBag.Categories = await _categoryRepository.GetAllAsync();
            ViewBag.Brands = await _brandRepository.GetAllAsync();

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
            if (ModelState.IsValid)
            {
                var product = new Product
                {
                    ProductName = model.ProductName,
                    Slug = model.ProductName.ToLower().Replace(" ", "-"), // Demo logic slug
                    Description = model.Description,
                    CategoryId = model.CategoryId,
                    BrandId = model.BrandId,
                    IsFeatured = model.IsFeatured,
                    IsActive = model.IsActive,
                    CreatedDate = DateTime.Now
                };

                // Xử lý upload nhiều ảnh
                if (model.Images != null && model.Images.Count > 0)
                {
                    int order = 1;
                    foreach (var file in model.Images)
                    {
                        var imagePaths = await _fileService.SaveProductImageAsync(file, "products");
                        
                        var productImage = new ProductImage
                        {
                            ImageUrl = imagePaths["Full"], // Lưu ảnh full vào DB
                            IsPrimary = (order == 1), // Ảnh đầu tiên là ảnh chính
                            DisplayOrder = order++
                        };
                        
                        product.Images.Add(productImage);
                    }
                }

                await _productRepository.AddAsync(product);
                await _productRepository.SaveChangesAsync();

                return RedirectToAction(nameof(Index));
            }

            ViewBag.Categories = await _categoryRepository.GetAllAsync();
            ViewBag.Brands = await _brandRepository.GetAllAsync();
            return View(model);
        }

        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var product = await _productRepository.Find(p => p.ProductId == id)
                .Include(p => p.Images)
                .FirstOrDefaultAsync();

            if (product == null) return NotFound();

            ViewBag.Categories = await _categoryRepository.GetAllAsync();
            ViewBag.Brands = await _brandRepository.GetAllAsync();

            return View(product);
        }

        [HttpPost]
        public async Task<IActionResult> UpdateImageOrder([FromBody] List<ImageOrderModel> model)
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
                        if (item.Order == 1) image.IsPrimary = true;
                        else image.IsPrimary = false;
                        
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

        public class ImageOrderModel
        {
            public int ImageId { get; set; }
            public int Order { get; set; }
        }
    }
}
