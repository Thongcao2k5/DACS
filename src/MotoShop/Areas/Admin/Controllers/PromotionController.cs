using ClosedXML.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Business.DTOs;
using MotoShop.Business.Interfaces;
using MotoShop.Data.Data;
using MotoShop.Data.Enums;
using MotoShop.Data.Models;
using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    public class PromotionController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IEmailService _emailService;

        public PromotionController(MotoShopDbContext context, IEmailService emailService)
        {
            _context = context;
            _emailService = emailService;
        }

        public async Task<IActionResult> Index(string? searchTerm, string? type, string? isActive, string? timeStatus, int page = 1, int pageSize = 10)
        {
            page = Math.Max(1, page);
            pageSize = Math.Clamp(pageSize, 1, 100);

            var query = GetFilteredPromotionsQuery(searchTerm, type, isActive, timeStatus);
            var totalItems = await query.CountAsync();
            var now = DateTime.Now;

            var promotions = await query
                .OrderByDescending(p => p.Priority)
                .ThenByDescending(p => p.StartDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(p => new PromotionDto
                {
                    Id = p.Id,
                    Name = p.Name,
                    Slug = p.Slug,
                    Description = p.Description,
                    PromotionType = p.PromotionType.ToString(),
                    DiscountType = p.DiscountType.ToString(),
                    DiscountValue = p.DiscountValue,
                    MaxDiscountAmount = p.MaxDiscountAmount,
                    MinOrderAmount = p.MinOrderAmount,
                    CouponCode = p.CouponCode,
                    StartDate = p.StartDate.ToString("yyyy-MM-ddTHH:mm"),
                    EndDate = p.EndDate.ToString("yyyy-MM-ddTHH:mm"),
                    UsageLimit = p.UsageLimit,
                    UsedCount = p.UsedCount,
                    IsActive = p.IsActive,
                    IsFeatured = p.IsFeatured,
                    Priority = p.Priority,
                    BannerImage = p.BannerImage,
                    BackgroundColor = p.BackgroundColor,
                    ApplyType = p.ApplyType.ToString(),
                    ProductCount = p.PromotionProducts.Count,
                    ProductIds = p.PromotionProducts.Select(pp => pp.ProductId).ToList(),
                    CategoryIds = p.PromotionCategories.Select(pc => pc.CategoryId).ToList(),
                    ProductVariantIds = p.PromotionProductVariants.Select(pv => pv.ProductVariantId).ToList(),
                    StatusText = !p.IsActive ? "Tam dung" : p.StartDate > now ? "Sap dien ra" : p.EndDate < now ? "Da ket thuc" : "Dang ap dung",
                    StatusClass = !p.IsActive ? "badge-paused" : p.StartDate > now ? "badge-upcoming" : p.EndDate < now ? "badge-expired" : "badge-active"
                })
                .ToListAsync();

            ViewBag.Products = await _context.Products
                .AsNoTracking()
                .Where(p => !p.IsDeleted)
                .OrderBy(p => p.ProductName)
                .Select(p => new
                {
                    p.ProductId,
                    p.ProductName,
                    p.CategoryId,
                    CategoryName = p.Category != null ? p.Category.CategoryName : "Chua phan loai",
                    p.IsActive,
                    StockQuantity = p.Variants.Sum(v => v.StockQuantity),
                    Price = p.Variants.OrderBy(v => v.Price).Select(v => v.Price).FirstOrDefault()
                })
                .ToListAsync();

            ViewBag.Categories = await _context.Categories
                .AsNoTracking()
                .OrderBy(c => c.CategoryName)
                .Select(c => new { c.CategoryId, c.CategoryName })
                .ToListAsync();

            ViewBag.ProductVariants = await _context.ProductVariants
                .AsNoTracking()
                .Include(v => v.Product)
                .Where(v => !v.Product.IsDeleted)
                .OrderBy(v => v.Product.ProductName)
                .Select(v => new { v.ProductVariantId, v.VariantName, v.SKU, ProductName = v.Product.ProductName })
                .ToListAsync();

            ViewBag.SearchTerm = searchTerm;
            ViewBag.Type = type;
            ViewBag.IsActive = isActive;
            ViewBag.TimeStatus = timeStatus;
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(promotions);
        }

        private IQueryable<Promotion> GetFilteredPromotionsQuery(string? searchTerm, string? type, string? isActive, string? timeStatus)
        {
            var query = _context.Promotions.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                query = query.Where(p => p.Name.Contains(searchTerm) || (p.CouponCode != null && p.CouponCode.Contains(searchTerm)));
            }

            if (!string.IsNullOrWhiteSpace(type) && Enum.TryParse<PromotionType>(type, true, out var promotionType))
            {
                query = query.Where(p => p.PromotionType == promotionType);
            }

            if (!string.IsNullOrWhiteSpace(isActive) && bool.TryParse(isActive, out var active))
            {
                query = query.Where(p => p.IsActive == active);
            }

            if (!string.IsNullOrWhiteSpace(timeStatus))
            {
                var now = DateTime.Now;
                query = timeStatus switch
                {
                    "running" => query.Where(p => p.StartDate <= now && p.EndDate >= now),
                    "upcoming" => query.Where(p => p.StartDate > now),
                    "expired" => query.Where(p => p.EndDate < now),
                    _ => query
                };
            }

            return query;
        }

        [HttpPost]
        public async Task<IActionResult> Save(Promotion promotion, int[] productIds, int[] categoryIds, int[] productVariantIds)
        {
            if (string.IsNullOrWhiteSpace(promotion.Name))
            {
                return Json(new { success = false, message = "Tên khuyến mãi là bắt buộc." });
            }

            if (promotion.EndDate < promotion.StartDate)
                return Json(new { success = false, message = "Ngay ket thuc khong duoc nho hon ngay bat dau." });

            if (promotion.DiscountValue <= 0)
                return Json(new { success = false, message = "Gia tri giam phai lon hon 0." });

            if (promotion.DiscountType == DiscountType.Percent && promotion.DiscountValue > 100)
                return Json(new { success = false, message = "Giam theo phan tram khong duoc vuot qua 100%." });

            var hasScope = promotion.ApplyType switch
            {
                PromotionApplyType.All => true,
                PromotionApplyType.Category => categoryIds != null && categoryIds.Length > 0,
                PromotionApplyType.Product => productIds != null && productIds.Length > 0,
                PromotionApplyType.ProductVariantSKU => productVariantIds != null && productVariantIds.Length > 0,
                _ => false
            };
            if (!hasScope)
                return Json(new { success = false, message = "Vui long chon doi tuong ap dung cho pham vi khuyen mai." });

            var isNew = promotion.Id == 0;
            promotion.Slug = string.IsNullOrWhiteSpace(promotion.Slug) ? GenerateSlug(promotion.Name) : promotion.Slug;
            promotion.CouponCode = string.IsNullOrWhiteSpace(promotion.CouponCode) ? null : promotion.CouponCode.Trim().ToUpperInvariant();

            if (promotion.PromotionType != PromotionType.Voucher)
            {
                promotion.CouponCode = null;
            }

            if (promotion.PromotionType != PromotionType.Voucher && promotion.PromotionType != PromotionType.OrderDiscount)
            {
                promotion.MinOrderAmount = null;
            }

            if (promotion.PromotionType != PromotionType.Campaign)
            {
                promotion.BannerImage = null;
                promotion.BackgroundColor = null;
            }

            var strategy = _context.Database.CreateExecutionStrategy();
            return await strategy.ExecuteAsync(async () =>
            {
                using var transaction = await _context.Database.BeginTransactionAsync();
                try
                {
                    Promotion saved;
                    if (isNew)
                    {
                        promotion.CreatedAt = DateTime.Now;
                        promotion.UpdatedAt = DateTime.Now;
                        _context.Promotions.Add(promotion);
                        saved = promotion;
                    }
                    else
                    {
                        saved = await _context.Promotions.FirstOrDefaultAsync(p => p.Id == promotion.Id)
                            ?? throw new InvalidOperationException("Không tìm thấy chương trình khuyến mãi.");

                        saved.Name = promotion.Name;
                        saved.Slug = promotion.Slug;
                        saved.Description = promotion.Description;
                        saved.PromotionType = promotion.PromotionType;
                        saved.DiscountType = promotion.DiscountType;
                        saved.ApplyType = promotion.ApplyType;
                        saved.DiscountValue = promotion.DiscountValue;
                        saved.MaxDiscountAmount = promotion.MaxDiscountAmount;
                        saved.MinOrderAmount = promotion.MinOrderAmount;
                        saved.CouponCode = promotion.CouponCode;
                        saved.StartDate = promotion.StartDate;
                        saved.EndDate = promotion.EndDate;
                        saved.UsageLimit = promotion.UsageLimit;
                        saved.IsActive = promotion.IsActive;
                        saved.IsFeatured = promotion.IsFeatured;
                        saved.Priority = promotion.Priority;
                        saved.BannerImage = promotion.BannerImage;
                        saved.BackgroundColor = promotion.BackgroundColor;
                        saved.UpdatedAt = DateTime.Now;
                    }

                    await _context.SaveChangesAsync();

                    var existingLinks = _context.PromotionProducts.Where(pp => pp.PromotionId == saved.Id);
                    _context.PromotionProducts.RemoveRange(existingLinks);
                    _context.PromotionCategories.RemoveRange(_context.PromotionCategories.Where(pc => pc.PromotionId == saved.Id));
                    _context.PromotionProductVariants.RemoveRange(_context.PromotionProductVariants.Where(pv => pv.PromotionId == saved.Id));

                    if (saved.ApplyType == PromotionApplyType.Product)
                    {
                        if (productIds != null && productIds.Length > 0)
                        {
                            foreach (var productId in productIds.Distinct())
                            {
                                _context.PromotionProducts.Add(new PromotionProduct { PromotionId = saved.Id, ProductId = productId });
                            }
                        }
                    }
                    else if (saved.ApplyType == PromotionApplyType.Category && categoryIds != null)
                    {
                        foreach (var categoryId in categoryIds.Distinct())
                            _context.PromotionCategories.Add(new PromotionCategory { PromotionId = saved.Id, CategoryId = categoryId });
                    }
                    else if (saved.ApplyType == PromotionApplyType.ProductVariantSKU && productVariantIds != null)
                    {
                        foreach (var productVariantId in productVariantIds.Distinct())
                            _context.PromotionProductVariants.Add(new PromotionProductVariant { PromotionId = saved.Id, ProductVariantId = productVariantId });
                    }

                    await _context.SaveChangesAsync();
                    await transaction.CommitAsync();

                    if (isNew && saved.IsActive)
                    {
                        await SendPromotionNewsletterAsync(saved);
                    }

                return Json(new { success = true, message = isNew ? "Thêm khuyến mãi thành công." : "Cập nhật khuyến mãi thành công." });
                }
                catch (Exception ex)
                {
                    await transaction.RollbackAsync();
                    var errorMsg = ex.Message;
                    if (ex.InnerException != null)
                    {
                        errorMsg += " | Inner: " + ex.InnerException.Message;
                        if (ex.InnerException.InnerException != null)
                        {
                            errorMsg += " | Details: " + ex.InnerException.InnerException.Message;
                        }
                    }
                    return Json(new { success = false, message = "Lỗi khi lưu khuyến mãi: " + errorMsg });
                }
            });
        }

        [HttpGet]
        public async Task<IActionResult> GetProducts(int promotionId, string? searchTerm, int? categoryId)
        {
            var promotion = await _context.Promotions.FindAsync(promotionId);
            if (promotion == null) return NotFound();

            var assignedProductIds = await _context.PromotionProducts
                .Where(pp => pp.PromotionId == promotionId)
                .Select(pp => pp.ProductId)
                .ToListAsync();

            var productsQuery = _context.Products
                .Include(p => p.Variants)
                .Where(p => !p.IsDeleted)
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchTerm))
                productsQuery = productsQuery.Where(p => p.ProductName.Contains(searchTerm));

            if (categoryId.HasValue)
                productsQuery = productsQuery.Where(p => p.CategoryId == categoryId);

            var products = await productsQuery.Select(p => new
            {
                p.ProductId,
                p.ProductName,
                IsAssigned = assignedProductIds.Contains(p.ProductId),
                BasePrice = p.Variants.OrderBy(v => v.Price).Select(v => v.Price).FirstOrDefault(),
                Stock = p.Variants.Sum(v => v.StockQuantity)
            }).ToListAsync();

            var result = products.Select(p => new
            {
                p.ProductId,
                p.ProductName,
                p.IsAssigned,
                p.BasePrice,
                p.Stock,
                DiscountedPrice = CalculateDiscount(p.BasePrice, promotion)
            });

            return Json(result);
        }

        [HttpPost]
        public async Task<IActionResult> BulkDelete(int[] ids)
        {
            if (ids == null || ids.Length == 0) return Json(new { success = false });

            var links = _context.PromotionProducts.Where(pp => ids.Contains(pp.PromotionId));
            _context.PromotionProducts.RemoveRange(links);
            _context.PromotionCategories.RemoveRange(_context.PromotionCategories.Where(pc => ids.Contains(pc.PromotionId)));
            _context.PromotionProductVariants.RemoveRange(_context.PromotionProductVariants.Where(pv => ids.Contains(pv.PromotionId)));

            var promos = await _context.Promotions.Where(p => ids.Contains(p.Id)).ToListAsync();
            _context.Promotions.RemoveRange(promos);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = $"Da xoa {promos.Count} khuyen mai." });
        }

        [HttpPost]
        public async Task<IActionResult> Deactivate(int id)
        {
            var promo = await _context.Promotions.FindAsync(id);
            if (promo == null) return Json(new { success = false });

            promo.IsActive = false;
            promo.UpdatedAt = DateTime.Now;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        public async Task<IActionResult> ExportExcel(string? searchTerm, string? type, string? isActive, string? timeStatus)
        {
            var promotions = await GetFilteredPromotionsQuery(searchTerm, type, isActive, timeStatus)
                .Include(p => p.PromotionProducts)
                .ToListAsync();

            using var workbook = new XLWorkbook();
            var worksheet = workbook.Worksheets.Add("Khuyen mai");

            string[] headers = { "Ten", "Loai", "Giam gia", "Bat dau", "Ket thuc", "Luot dung", "Trang thai" };
            for (var i = 0; i < headers.Length; i++) worksheet.Cell(1, i + 1).Value = headers[i];

            var row = 1;
            var now = DateTime.Now;
            foreach (var p in promotions)
            {
                row++;
                worksheet.Cell(row, 1).Value = p.Name;
                worksheet.Cell(row, 2).Value = p.PromotionType.ToString();
                worksheet.Cell(row, 3).Value = p.DiscountType == DiscountType.Percent ? p.DiscountValue + "%" : p.DiscountValue.ToString("N0") + "d";
                worksheet.Cell(row, 4).Value = p.StartDate.ToString("dd/MM/yyyy HH:mm");
                worksheet.Cell(row, 5).Value = p.EndDate.ToString("dd/MM/yyyy HH:mm");
                worksheet.Cell(row, 6).Value = p.UsageLimit.HasValue ? $"{p.UsedCount}/{p.UsageLimit}" : p.UsedCount.ToString();
                worksheet.Cell(row, 7).Value = !p.IsActive ? "Tam dung" : p.StartDate > now ? "Sap dien ra" : p.EndDate < now ? "Da ket thuc" : "Dang ap dung";
            }

            worksheet.Columns().AdjustToContents();
            using var stream = new MemoryStream();
            workbook.SaveAs(stream);
            return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", $"KhuyenMai_{DateTime.Now:yyyyMMdd}.xlsx");
        }

        [HttpPost]
        public async Task<IActionResult> AssignProducts(int promotionId, int[] productIds)
        {
            var existing = _context.PromotionProducts.Where(pp => pp.PromotionId == promotionId);
            _context.PromotionProducts.RemoveRange(existing);

            foreach (var productId in productIds.Distinct())
            {
                _context.PromotionProducts.Add(new PromotionProduct { PromotionId = promotionId, ProductId = productId });
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Cap nhat san pham ap dung thanh cong." });
        }

        private async Task SendPromotionNewsletterAsync(Promotion promotion)
        {
            try
            {
                var subscribers = await _context.Database.SqlQueryRaw<string>("SELECT Email FROM NewsletterSubscriptions WHERE IsActive = 1").ToListAsync();
                foreach (var email in subscribers)
                {
                    await _emailService.SendPromotionEmailAsync(
                        email,
                        promotion.Name,
                        promotion.Description ?? "Uu dai moi tai MotoShop.",
                        promotion.StartDate.ToString("dd/MM/yyyy"),
                        promotion.EndDate.ToString("dd/MM/yyyy"));
                }
            }
            catch
            {
            }
        }

        private static decimal CalculateDiscount(decimal price, Promotion promotion)
        {
            var discounted = promotion.DiscountType == DiscountType.Percent
                ? price * (1 - promotion.DiscountValue / 100m)
                : price - promotion.DiscountValue;

            return Math.Clamp(discounted, 0, price);
        }

        private static string GenerateSlug(string name)
        {
            var slug = name.Trim().ToLowerInvariant();
            slug = Regex.Replace(slug, @"[^a-z0-9\s-]", string.Empty);
            slug = Regex.Replace(slug, @"\s+", "-");
            slug = Regex.Replace(slug, @"-+", "-");
            return string.IsNullOrWhiteSpace(slug) ? $"promotion-{Guid.NewGuid():N}" : slug.Trim('-');
        }
    }
}
