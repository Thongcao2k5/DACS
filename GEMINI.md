# Project Instructions: MotoShop DACS

## Product & Variant Data Management
To maintain the integrity of the E-commerce system and ensure the UI (Shopee-style) functions correctly, all product data must follow these rules:

1. **1 Product = Multiple Variants:**
   - Always group different versions of the same product under a single `ProductId`.
   - Example: "Bi nồi Malossi" is one Product; weights "9g", "10g", "11g" are its Variants.

2. **No Split Products:**
   - Do NOT create separate Product entries for each variant (e.g., "Bi nồi 9g" and "Bi nồi 10g" as separate products). This breaks the group selection UI.

3. **Consistent Attributes:**
   - Attribute Names and Values must be standardized to prevent UI clutter.
   - Use: "Trọng lượng" (Weight) with values like "9g", "10g".
   - Avoid: Mixing "9g", "9 gram", "0.01kg" for the same attribute.

4. **Unique SKU:**
   - Every `ProductVariant` MUST have a unique SKU (Stock Keeping Unit).
   - Format suggestion: `[BRAND]-[MODEL]-[VARIANT]`. Example: `MAL-VIS-09G`.

## Frontend Conventions
- **Variant Selection:** Uses `selectAttr`, `checkVariants`, and `updateUrl` in `Details.cshtml`.
- **URL Synchronization:** The `variantId` is tracked in the URL query string to allow sharing specific variant links.
- **Cart Handling:** `handleAddToCart` and `handleBuyNow` must always accept `variantId` and `quantity`.
