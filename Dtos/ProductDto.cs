namespace AlMaximoTI.Dtos
{
    public class ProductDto
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string ProductKey { get; set; }
        public bool Deleted { get; set; }
        public decimal Price { get; set; }
        public string TypeName { get; set; }
        public int TypeID { get; set; }
        public int SupplierID { get; set; }
        public string SupplierProductKey { get; set; }
        public decimal SupplierCost { get; set; }
        public string SupplierName { get; set; }

    }
}
