namespace AlMaximoTI.Models
{
    public class ProductSupplier
    {
        protected int ID { get; set; }
        protected Product ProductId { get; set; }
        protected Supplier SupplierId { get; set; }
        protected string SupplierProductKey { get; set; }
        protected decimal SupplierCost { get; set; }
        protected bool Deleted { get; set; }
        protected DateTime CreateDate { get; set; }
        protected DateTime UpdateDate { get; set; }

    }
}
