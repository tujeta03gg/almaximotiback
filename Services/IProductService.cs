namespace AlMaximoTI.Services

{
    public interface IProductService<T> where T : class
    {
        Task<List<T>> GetAll();
        Task<T> Get(int id);
        Task<T> Create(T entity);
        Task<T> Update(T entity);
        Task<bool> Delete(int id);
        Task<List<T>> GetAllProductSupplier(int id);
        Task<T> GetProductSupplier(int id);
        Task<T> UpdateProductSupplier(T entity);
        Task<bool> DeleteProductSupplier(int id);

    }
}
