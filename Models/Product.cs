using System;

namespace AlMaximoTI.Models
{
    public class Product
    {

        public int ID { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string ProductKey { get; set; }
        public int TypeID { get; set; }
        public bool Deleted { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime UpdateDate { get; set; }

    }
}
