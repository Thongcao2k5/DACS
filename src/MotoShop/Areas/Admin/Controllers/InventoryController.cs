using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    public class InventoryController : Controller
    {
        private readonly MotoShopDbContext _context;

        public InventoryController(MotoShopDbContext context)
        {
            _context = context;
        }

        // Xem tồn kho hiện tại
        public async Task<IActionResult> Index()
        {
            var stock = await _context.ProductVariants
                .Include(pv => pv.Product)
                .Include(pv => pv.BaseUnit)
                .ToListAsync();
            return View(stock);
        }

        // Xem lịch sử nhập xuất
        public async Task<IActionResult> History()
        {
            var history = await _context.InventoryTransactions
                .Include(t => t.ProductVariant)
                    .ThenInclude(pv => pv.Product)
                .OrderByDescending(t => t.TransactionDate)
                .ToListAsync();
            return View(history);
        }

        // Cập nhật kho (Nhập hàng)
        [HttpPost]
        public async Task<IActionResult> UpdateStock(int variantId, int quantity, string note)
        {
            var variant = await _context.ProductVariants.FindAsync(variantId);
            if (variant == null) return Json(new { success = false, message = "Không tìm thấy sản phẩm" });

            // Cập nhật số lượng tồn (tính nhanh)
            variant.StockQuantity += quantity;

            // Lưu lịch sử giao dịch
            var transaction = new InventoryTransaction
            {
                ProductVariantId = variantId,
                Quantity = quantity,
                TransactionType = quantity >= 0 ? "IN" : "OUT",
                TransactionDate = DateTime.Now,
                Note = note
            };

            _context.InventoryTransactions.Add(transaction);
            await _context.SaveChangesAsync();

            return Json(new { success = true });
        }
    }
}
