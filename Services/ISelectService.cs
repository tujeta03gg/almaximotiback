namespace AlMaximoTI.Services
{
    public interface ISelectService<T> where T : class
    {
        Task<List<T>> GetSelectTypes();
        Task<List<T>> GetSelectSuppliers();
    }
}
