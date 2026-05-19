using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using MotoShop.Data.Models;
using MotoShop.Models.ViewModels;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    [Authorize]
    public class AddressController : Controller
    {
        private readonly MotoShopDbContext _context;
        private readonly UserManager<IdentityUser> _userManager;

        public AddressController(MotoShopDbContext context, UserManager<IdentityUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        private async Task<int> GetCurrentCustomerIdAsync()
        {
            var identityId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == identityId);
            return customer?.CustomerId ?? 0;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var identityId = _userManager.GetUserId(User);
            var customer = await _context.Customers.FirstOrDefaultAsync(c => c.UserId == identityId);
            if (customer == null) return RedirectToAction("Login", "Account");
            
            ViewBag.Customer = customer;
            int customerId = customer.CustomerId;
            
            var addresses = await _context.AddressesNew
                .Where(a => a.CustomerId == customerId)
                .OrderByDescending(a => a.IsDefault)
                .Select(a => new AddressViewModel
                {
                    Id = a.Id,
                    FullName = a.FullName ?? "",
                    Phone = a.Phone ?? "",
                    Province = a.Province ?? "",
                    District = a.District ?? "",
                    Ward = a.Ward ?? "",
                    Street = a.Street ?? "",
                    IsDefault = a.IsDefault
                })
                .ToListAsync();

            return View(addresses);
        }

        [HttpGet]
        public async Task<IActionResult> GetAddress(int id)
        {
            int customerId = await GetCurrentCustomerIdAsync();
            var addr = await _context.AddressesNew.FirstOrDefaultAsync(a => a.Id == id && a.CustomerId == customerId);
            if (addr == null) return NotFound();
            return Json(new {
                id = addr.Id,
                fullName = addr.FullName,
                phone = addr.Phone,
                province = addr.Province,
                district = addr.District,
                ward = addr.Ward,
                street = addr.Street,
                isDefault = addr.IsDefault,
                districtId = addr.DistrictId,
                wardCode = addr.WardCode
            });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddAddress([FromBody] AddressFormViewModel model)
        {
            if (!ModelState.IsValid) return Json(new { success = false, message = "Dữ liệu không hợp lệ" });

            int customerId = await GetCurrentCustomerIdAsync();
            if (customerId == 0) return Json(new { success = false, message = "Phiên làm việc hết hạn" });

            bool isFirstAddress = !await _context.AddressesNew.AnyAsync(a => a.CustomerId == customerId);
            if (isFirstAddress) model.IsDefault = true;

            if (model.IsDefault)
            {
                var defaults = await _context.AddressesNew.Where(a => a.CustomerId == customerId && a.IsDefault).ToListAsync();
                foreach (var d in defaults) d.IsDefault = false;
            }

            var newAddress = new AddressNew
            {
                CustomerId = customerId,
                FullName = model.FullName,
                Phone = model.Phone,
                Province = model.Province,
                District = model.District,
                Ward = model.Ward,
                Street = model.Street,
                IsDefault = model.IsDefault,
                DistrictId = model.DistrictId,
                WardCode = model.WardCode
            };

            _context.AddressesNew.Add(newAddress);
            await _context.SaveChangesAsync();

            return Json(new { success = true, message = "Thêm địa chỉ thành công", id = newAddress.Id });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> EditAddress([FromBody] AddressFormViewModel model)
        {
            if (!ModelState.IsValid || !model.Id.HasValue) return Json(new { success = false, message = "Dữ liệu không hợp lệ" });

            int customerId = await GetCurrentCustomerIdAsync();
            var addr = await _context.AddressesNew.FirstOrDefaultAsync(a => a.Id == model.Id && a.CustomerId == customerId);
            
            if (addr == null) return Json(new { success = false, message = "Không tìm thấy địa chỉ" });

            if (model.IsDefault && !addr.IsDefault)
            {
                var defaults = await _context.AddressesNew.Where(a => a.CustomerId == customerId && a.IsDefault).ToListAsync();
                foreach (var d in defaults) d.IsDefault = false;
            }

            addr.FullName = model.FullName;
            addr.Phone = model.Phone;
            addr.Province = model.Province;
            addr.District = model.District;
            addr.Ward = model.Ward;
            addr.Street = model.Street;
            addr.IsDefault = model.IsDefault;
            addr.DistrictId = model.DistrictId;
            addr.WardCode = model.WardCode;

            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Cập nhật thành công" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteAddress([FromBody] DeleteRequest req)
        {
            int customerId = await GetCurrentCustomerIdAsync();
            var addr = await _context.AddressesNew.FirstOrDefaultAsync(a => a.Id == req.Id && a.CustomerId == customerId);

            if (addr == null) return Json(new { success = false, message = "Không tìm thấy địa chỉ" });

            if (addr.IsDefault)
            {
                bool hasOther = await _context.AddressesNew.AnyAsync(a => a.CustomerId == customerId && a.Id != req.Id);
                if (hasOther) return Json(new { success = false, message = "Không thể xóa địa chỉ mặc định. Hãy đặt địa chỉ khác làm mặc định trước." });
            }

            _context.AddressesNew.Remove(addr);
            await _context.SaveChangesAsync();
            return Json(new { success = true, message = "Đã xóa địa chỉ" });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SetDefault([FromBody] DeleteRequest req)
        {
            int customerId = await GetCurrentCustomerIdAsync();
            
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var defaults = await _context.AddressesNew.Where(a => a.CustomerId == customerId && a.IsDefault).ToListAsync();
                foreach (var d in defaults) d.IsDefault = false;
                await _context.SaveChangesAsync();

                var addr = await _context.AddressesNew.FirstOrDefaultAsync(a => a.Id == req.Id && a.CustomerId == customerId);
                if (addr != null)
                {
                    addr.IsDefault = true;
                    await _context.SaveChangesAsync();
                }

                await transaction.CommitAsync();
                return Json(new { success = true, message = "Đã đặt làm địa chỉ mặc định" });
            }
            catch
            {
                await transaction.RollbackAsync();
                return Json(new { success = false, message = "Có lỗi xảy ra" });
            }
        }

        public class DeleteRequest { public int Id { get; set; } }
    }
}
