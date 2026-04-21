using System;
using System.Collections.Generic;
using MotoShop.Data.Models;

namespace MotoShop.Business.DTOs
{
    public class ProductDetailsViewModel
    {
        public Product Product { get; set; }
        public List<Promotion> Vouchers { get; set; }
        public List<Product> RelatedProducts { get; set; }
        public bool CanReview { get; set; }
        public double AverageRating { get; set; }
        public int TotalReviews { get; set; }
        public Dictionary<int, int> RatingStars { get; set; } // [Sao, Số lượng]

        public ProductDetailsViewModel()
        {
            RatingStars = new Dictionary<int, int> { { 5, 0 }, { 4, 0 }, { 3, 0 }, { 2, 0 }, { 1, 0 } };
        }
    }
}
