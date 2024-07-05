namespace AlMaximoTI.Dtos
{
    public class UpdateProductRequest
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string ProductKey { get; set; }
        public int TypeID { get; set; }
    }
}
