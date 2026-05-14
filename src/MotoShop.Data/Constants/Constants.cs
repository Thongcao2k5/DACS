namespace MotoShop.Data.Constants
{
    public static class OrderStatusConst
    {
        public const string Pending = "Pending";
        public const string Processing = "Processing";
        public const string DangXuLy = "DangXuLy";
        public const string Shipping = "Shipping";
        public const string DangGiao = "DangGiao";
        public const string Completed = "Completed";
        public const string DaHoanThanh = "DaHoanThanh";
        public const string Cancelled = "Cancelled";
        public const string DaHuy = "DaHuy";
    }

    public static class PaymentStatusConst
    {
        public const string Unpaid = "Unpaid";
        public const string Paid = "Paid";
        public const string Failed = "Failed";
    }

    public static class ReviewStatusConst
    {
        public const string Pending = "Pending";
        public const string Approved = "Approved";
        public const string Rejected = "Rejected";
    }

    public static class BookingStatusConst
    {
        public const string Pending = "Pending";
        public const string Confirmed = "Confirmed";
        public const string Completed = "Completed";
        public const string Cancelled = "Cancelled";
    }

    public static class CacheKeys
    {
        public const string HomeCategories = "home_categories";
        public const string HomeFeatured = "home_featured_8";
        public const string HomeBestSelling = "home_bestselling_4";
        public const string HomeNewProducts = "home_new_products";
        public const string HomeFlashSale = "home_flash_sale";
        public const string HomeBrandProducts = "home_brand_products";
        public const string HomeCategoryProducts = "home_category_products";
        public const string HomeFeaturedPromotions = "home_featured_promotions";
    }
}