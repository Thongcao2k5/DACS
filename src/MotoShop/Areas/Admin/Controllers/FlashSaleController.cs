using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System.Linq;
using System.Threading.Tasks;
using MotoShop.Business.DTOs;
using AutoMapper;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class FlashSaleController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IMapper _mapper;

        public FlashSaleController(MotoShopDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<IActionResult> Index()
        {
            var flashSales = await _context.FlashSales
                .Include(f => f.FlashSaleProducts)
                .OrderByDescending(f => f.StartDate)
                .ToListAsync();

            var dtos = _mapper.Map<List<FlashSaleDto>>(flashSales);
            return View(dtos);
        }

        public IActionResult Create()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> GetDetails(int id)
        {
            var flashSale = await _context.FlashSales.FindAsync(id);
            if (flashSale == null) return NotFound();
            return Json(new {
                flashSaleId = flashSale.FlashSaleId,
                title = flashSale.Title,
                description = flashSale.Description,
                startDate = flashSale.StartDate.ToString("yyyy-MM-ddTHH:mm"),
                endDate = flashSale.EndDate.ToString("yyyy-MM-ddTHH:mm"),
                isActive = flashSale.IsActive
            });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Upsert(FlashSale flashSale)
        {
            if (ModelState.IsValid)
            {
                if (flashSale.FlashSaleId > 0)
                {
                    _context.Update(flashSale);
                }
                else
                {
                    _context.Add(flashSale);
                }
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            
            var flashSales = await _context.FlashSales
                .Include(f => f.FlashSaleProducts)
                .OrderByDescending(f => f.StartDate)
                .ToListAsync();

            var dtos = _mapper.Map<List<FlashSaleDto>>(flashSales);
            return View("Index", dtos);
        }

        [HttpGet]
        public async Task<IActionResult> GetAllProducts()
        {
            var products = await _context.Products
                .Where(p => !p.IsDeleted && p.IsActive)
                .Select(p => new {
                    productId = p.ProductId,
                    productName = p.ProductName
                })
                .OrderBy(p => p.productName)
                .ToListAsync();
            return Json(products);
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            var flashSale = await _context.FlashSales.FindAsync(id);
            if (flashSale == null) return Json(new { success = false, message = "Không tìm thấy chương trình" });

            _context.FlashSales.Remove(flashSale);
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        private bool FlashSaleExists(int id)
        {
            return _context.FlashSales.Any(e => e.FlashSaleId == id);
        }

        // AJAX Actions for Product Management
        [HttpGet]
        public async Task<IActionResult> GetProducts(int flashSaleId)
        {
            var products = await _context.FlashSaleProducts
                .Where(fp => fp.FlashSaleId == flashSaleId)
                .Include(fp => fp.Product)
                    .ThenInclude(p => p!.Variants)
                .Select(fp => new FlashSaleProductDto
                {
                    Id = fp.Id,
                    FlashSaleId = fp.FlashSaleId,
                    ProductId = fp.ProductId,
                    ProductName = fp.Product != null ? fp.Product.ProductName : "N/A",
                    FlashSalePrice = fp.FlashSalePrice,
                    Quantity = fp.Quantity,
                    SoldQuantity = fp.SoldQuantity,
                    OriginalPrice = (fp.Product != null && fp.Product.Variants.Any()) ? fp.Product.Variants.Min(v => v.Price) : 0
                })
                .ToListAsync();

            return Json(products);
        }

        [HttpPost]
        public async Task<IActionResult> AddProduct(int flashSaleId, int productId, decimal price, int quantity)
        {
            var exists = await _context.FlashSaleProducts.AnyAsync(fp => fp.FlashSaleId == flashSaleId && fp.ProductId == productId);
            if (exists) return Json(new { success = false, message = "Sản phẩm đã có trong Flash Sale này" });

            // Validation: Flash Sale Price must be lower than the current min price
            var minPrice = await _context.ProductVariants
                .Where(v => v.ProductId == productId)
                .MinAsync(v => (decimal?)v.Price) ?? 0;

            if (price >= minPrice)
            {
                return Json(new { success = false, message = $"Giá Flash Sale ({price:N0}₫) phải thấp hơn giá bán hiện tại ({minPrice:N0}₫)" });
            }

            var fp = new FlashSaleProduct
            {
                FlashSaleId = flashSaleId,
                ProductId = productId,
                FlashSalePrice = price,
                Quantity = quantity,
                SoldQuantity = 0
            };

            _context.FlashSaleProducts.Add(fp);
            await _context.SaveChangesAsync();

            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> RemoveProduct(int id)
        {
            var fp = await _context.FlashSaleProducts.FindAsync(id);
            if (fp == null) return Json(new { success = false });

            _context.FlashSaleProducts.Remove(fp);
            await _context.SaveChangesAsync();

            return Json(new { success = true });
        }
    }
}
