using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Business.Interfaces;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Areas.Admin.Controllers
{
    [Area("Admin")]
    [Authorize(Roles = "Admin")]
    [Route("Admin/[controller]/[action]")]
    [Route("Admin/Banner")]
    public class SliderBannerController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly IFileService _fileService;

        public SliderBannerController(MotoShopDbContext context, IFileService fileService)
        {
            _context = context;
            _fileService = fileService;
        }

        [Route("")]
        public async Task<IActionResult> Index()
        {
            var sliders = await _context.Sliders.OrderBy(s => s.Position).ToListAsync();
            var banners = await _context.Banners.ToListAsync();

            ViewBag.Sliders = sliders;
            ViewBag.Banners = banners;
            return View();
        }

        #region Slider Actions
        [HttpPost]
        public async Task<IActionResult> SaveSlider(Slider slider, IFormFile? imageFile)
        {
            if (slider.SliderId == 0)
            {
                if (imageFile != null)
                {
                    var uploadResult = await _fileService.SaveFileAsync(imageFile, "sliders");
                    if (!uploadResult.IsSuccess) return Json(new { success = false, message = uploadResult.ErrorMessage });
                    slider.ImageUrl = uploadResult.FilePath;
                }
                _context.Sliders.Add(slider);
            }
            else
            {
                var existing = await _context.Sliders.FindAsync(slider.SliderId);
                if (existing == null) return Json(new { success = false, message = "Không tìm thấy Slider" });

                existing.Title = slider.Title;
                existing.LinkUrl = slider.LinkUrl;
                existing.IsActive = slider.IsActive;
                if (imageFile != null)
                {
                    var uploadResult = await _fileService.SaveFileAsync(imageFile, "sliders");
                    if (!uploadResult.IsSuccess) return Json(new { success = false, message = uploadResult.ErrorMessage });
                    if (!string.IsNullOrEmpty(existing.ImageUrl)) _fileService.DeleteFile(existing.ImageUrl);
                    existing.ImageUrl = uploadResult.FilePath;
                }
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Lưu Slider thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> ToggleSlider(int id)
        {
            var slider = await _context.Sliders.FindAsync(id);
            if (slider == null) return Json(new { success = false });
            slider.IsActive = !slider.IsActive;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> UpdateSliderOrder([FromBody] int[] ids)
        {
            if (ids == null) return BadRequest();
            for (int i = 0; i < ids.Length; i++)
            {
                var slider = await _context.Sliders.FindAsync(ids[i]);
                if (slider != null) slider.Position = i + 1;
            }
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteSlider(int id)
        {
            var slider = await _context.Sliders.FindAsync(id);
            if (slider == null) return Json(new { success = false });
            if (!string.IsNullOrEmpty(slider.ImageUrl)) _fileService.DeleteFile(slider.ImageUrl);
            _context.Sliders.Remove(slider);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa Slider" });
        }
        #endregion

        #region Banner Actions
        [HttpPost]
        public async Task<IActionResult> SaveBanner(Banner banner, IFormFile? imageFile)
        {
            if (banner.BannerId == 0)
            {
                if (imageFile != null)
                {
                    var uploadResult = await _fileService.SaveFileAsync(imageFile, "banners");
                    if (!uploadResult.IsSuccess) return Json(new { success = false, message = uploadResult.ErrorMessage });
                    banner.ImageUrl = uploadResult.FilePath;
                }
                _context.Banners.Add(banner);
            }
            else
            {
                var existing = await _context.Banners.FindAsync(banner.BannerId);
                if (existing == null) return Json(new { success = false, message = "Không tìm thấy Banner" });

                existing.Title = banner.Title;
                existing.LinkUrl = banner.LinkUrl;
                existing.IsActive = banner.IsActive;
                if (imageFile != null)
                {
                    var uploadResult = await _fileService.SaveFileAsync(imageFile, "banners");
                    if (!uploadResult.IsSuccess) return Json(new { success = false, message = uploadResult.ErrorMessage });
                    if (!string.IsNullOrEmpty(existing.ImageUrl)) _fileService.DeleteFile(existing.ImageUrl);
                    existing.ImageUrl = uploadResult.FilePath;
                }
            }

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Lưu Banner thành công" });
        }

        [HttpPost]
        public async Task<IActionResult> ToggleBanner(int id)
        {
            var banner = await _context.Banners.FindAsync(id);
            if (banner == null) return Json(new { success = false });
            banner.IsActive = !banner.IsActive;
            await _context.SaveChangesAsync();
            return Json(new { success = true });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteBanner(int id)
        {
            var banner = await _context.Banners.FindAsync(id);
            if (banner == null) return Json(new { success = false });
            if (!string.IsNullOrEmpty(banner.ImageUrl)) _fileService.DeleteFile(banner.ImageUrl);
            _context.Banners.Remove(banner);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa Banner" });
        }
        #endregion
    }
}
