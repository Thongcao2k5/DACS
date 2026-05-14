using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MotoShop.Data.Models
{
    [Table("PromotionProducts")]
    public class PromotionProduct
    {
        [Key]
        public int Id { get; set; }

        public int PromotionId { get; set; }
        public int ProductId { get; set; }

        [ForeignKey(nameof(PromotionId))]
        public virtual Promotion? Promotion { get; set; }

        [ForeignKey(nameof(ProductId))]
        public virtual Product? Product { get; set; }
    }
}
