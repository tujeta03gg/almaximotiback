namespace AlMaximoTI.Dtos
{
    public class CreateProductRequest
    {
        public string name { get; set; }
        public decimal price { get; set; }
        public string productKey { get; set; }
        public int typeID { get; set; }
        public int supplierID { get; set; }
        public string supplierProductKey { get; set; }
        public decimal supplierCost { get; set; }
    }
}
