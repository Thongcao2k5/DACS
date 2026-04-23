using System;
using System.Collections.Generic;

namespace MotoShop.Models.ViewModels
{
    // PHẦN 2 — C# MODELS & VIEWMODEL

    public class OrderListViewModel
    {
        public List<OrderCardViewModel> Orders { get; set; } = new List<OrderCardViewModel>();
        public string CurrentStatus { get; set; } = "all";  // tab đang active
        public int TotalCount { get; set; }
        public int CurrentPage { get; set; } = 1;
        public int TotalPages { get; set; }
    }

    public class OrderCardViewModel
    {
        public int Id { get; set; }
        public string OrderCode { get; set; } = string.Empty;
        public DateTime OrderDate { get; set; }
        public string Status { get; set; } = string.Empty;
        public string StatusLabel { get; set; } = string.Empty;   // "Đang giao hàng", "Đã hoàn thành"...
        public string StatusBadgeClass { get; set; } = string.Empty; // CSS class badge tương ứng
        public decimal TotalAmount { get; set; }
        public List<OrderItemViewModel> Items { get; set; } = new List<OrderItemViewModel>();
        public bool CanCancel { get; set; }       // chỉ true khi Status = DangXuLy
        public bool CanReorder { get; set; }      // chỉ true khi Status = DaHoanThanh
        public bool CanTrack { get; set; }        // chỉ true khi Status = DangGiao
    }

    public class OrderItemViewModel
    {
        public string ProductName { get; set; } = string.Empty;
        public string ProductImage { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
    }

    // Thêm Detail ViewModel nếu cần
    public class OrderDetailViewModel
    {
        public OrderCardViewModel OrderInfo { get; set; } = new OrderCardViewModel();
        public string ShippingAddress { get; set; } = string.Empty;
        public decimal ShippingFee { get; set; }
        public string? VoucherCode { get; set; }
        public decimal Discount { get; set; }
        public List<OrderStatusStepViewModel> Timeline { get; set; } = new List<OrderStatusStepViewModel>();
    }

    public class OrderStatusStepViewModel
    {
        public string Status { get; set; } = string.Empty;
        public DateTime ChangedDate { get; set; }
        public bool IsCompleted { get; set; }
        public string Description { get; set; } = string.Empty;
    }
}
