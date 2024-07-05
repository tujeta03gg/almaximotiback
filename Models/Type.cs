namespace AlMaximoTI.Models
{
    public class Type
    {
        protected int ID { get; set; }
        protected string Name { get; set; }
        protected string Description { get; set; }
        protected bool Deleted { get; set; }
        protected DateTime CreateDate { get; set; }
        protected DateTime UpdateDate { get; set; }
    }
}
