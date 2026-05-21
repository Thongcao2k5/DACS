namespace MotoShop.Data.Enums
{
    public enum PromotionType
    {
        FlashSale,
        Voucher,
        ProductDiscount,
        OrderDiscount,
        Campaign
    }

    public enum DiscountType
    {
        Percent,
        Fixed
    }

    public enum PromotionApplyType
    {
        All,
        Category,
        Product,
        ProductVariantSKU
    }
}
