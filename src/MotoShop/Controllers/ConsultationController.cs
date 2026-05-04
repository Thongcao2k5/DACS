using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MotoShop.Data.Data;
using System;
using System.Threading.Tasks;

namespace MotoShop.Controllers
{
    public class ConsultationController : Controller
    {
        private readonly MotoShopDbContext _context;

        public ConsultationController(MotoShopDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        [IgnoreAntiforgeryToken]
        public async Task<IActionResult> Submit([FromBody] ConsultationRequest request)
        {
            if (string.IsNullOrEmpty(request.Phone)) 
                return Json(new { success = false, message = "Vui lòng nhập số điện thoại" });

            // Logic thêm mới vào database mà không dùng Model cũ (để tránh conflict)
            // Sử dụng execute sql raw để cực kỳ an toàn cho code hiện tại
            string sql = "INSERT INTO Consultations (CustomerName, Phone, Message, ProductId, CreatedAt) VALUES ({0}, {1}, {2}, {3}, {4})";
            await _context.Database.ExecuteSqlRawAsync(sql, request.Name ?? "Khách hàng", request.Phone, request.Message ?? "", request.ProductId, DateTime.Now);

            return Json(new { success = true, message = "Cảm ơn bạn! Chúng tôi sẽ liên hệ tư vấn sớm nhất." });
        }

        public class ConsultationRequest
        {
            public string? Name { get; set; }
            public string? Phone { get; set; }
            public string? Message { get; set; }
            public int? ProductId { get; set; }
        }
    }
}
