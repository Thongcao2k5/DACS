using System.Text;
using System.Text.RegularExpressions;

namespace MotoShop.Business.Helpers
{
    public static class VietnameseStringHelper
    {
        public static string RemoveVietnameseTone(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return string.Empty;

            var normalizedString = text.Normalize(NormalizationForm.FormD);
            var stringBuilder = new StringBuilder();

            foreach (var c in normalizedString)
            {
                var unicodeCategory = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(c);
                if (unicodeCategory != System.Globalization.UnicodeCategory.NonSpacingMark)
                {
                    stringBuilder.Append(c);
                }
            }

            var result = stringBuilder.ToString().Normalize(NormalizationForm.FormC);
            result = result.Replace('đ', 'd').Replace('Đ', 'D');
            
            return result;
        }

        public static string NormalizeKeyword(string keyword)
        {
            if (string.IsNullOrWhiteSpace(keyword))
                return string.Empty;

            var text = RemoveVietnameseTone(keyword).ToLower();
            
            // Remove special characters and extra spaces
            text = Regex.Replace(text, @"[^\w\s-]", "");
            text = Regex.Replace(text, @"\s+", " ").Trim();
            
            return text;
        }
    }
}
