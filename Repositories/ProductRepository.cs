using AlMaximoTI.Dtos;
using AlMaximoTI.Models;
using AlMaximoTI.Services;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace AlMaximoTI.Repositories
{
    public class ProductRepository : IProductService<ProductDto>
    {
        private readonly string _connectionString = " ";
        public ProductRepository(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection")!;
        }

        public async Task<List<ProductDto>> GetAll()
        {
            List<ProductDto> products = new List<ProductDto>();
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("GetAllProducts", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            ProductDto product = new ProductDto
                            {
                                ID = reader.GetInt32(0),
                                Name = reader.GetString(1),
                                ProductKey = reader.GetString(2),
                                Deleted = reader.GetByte(3) == 1,
                                Price = reader.GetDecimal(4),
                                TypeName = reader.GetString(5)
                            };
                            products.Add(product);
                        }
                    }
                }
            }
            finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
            }
            return products;
        }
        public async Task<ProductDto> Get(int id = 0)
        {
            ProductDto product = new ProductDto();
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("GetProductById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ProductId", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            product = new ProductDto
                            {
                                ID = reader.GetInt32(0),
                                Name = reader.GetString(1),
                                ProductKey = reader.GetString(2),
                                Deleted = reader.GetByte(3) == 1,
                                Price = reader.GetDecimal(4),
                                TypeName = reader.GetString(5)
                            };
                        }
                        else
                        {
                            product = new ProductDto();
                        }
                    }
                }
            }
            finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
            }
            return product;
        }
        public async Task<ProductDto> GetProductSupplier(int id = 0)
        {
            ProductDto product = new ProductDto();
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("GetProductSupplierByProduct", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ProductId", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            product = new ProductDto
                            {
                                Name = reader.GetString(0),
                                SupplierProductKey = reader.GetString(1),
                                SupplierCost = reader.GetDecimal(2),
                                SupplierID = reader.GetInt32(3),
                                ID = reader.GetInt32(4),
                            };
                        }
                        else
                        {
                            product = new ProductDto();
                        }
                    }
                }
            }
            finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
            }
            return product;
        }
        public async Task<List<ProductDto>> GetAllProductSupplier(int id = 0)
        {
            List<ProductDto> products = new List<ProductDto>();
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("GetProductSupplierByProduct", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ProductId", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            ProductDto product = new ProductDto
                            {
                                SupplierName = reader.GetString(0),
                                SupplierProductKey = reader.GetString(1),
                                SupplierCost = reader.GetDecimal(2),
                                SupplierID= reader.GetInt32(3),
                                ID = reader.GetInt32(4)
                            };
                            products.Add(product);
                        }
                    }
                }
            }
            finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
            }
            return products;
        }
        public async Task<ProductDto> Create(ProductDto entity)
        {
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("CreateProduct", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Name", entity.Name);
                    command.Parameters.AddWithValue("@Price", entity.Price);
                    command.Parameters.AddWithValue("@ProductKey", entity.ProductKey);
                    command.Parameters.AddWithValue("@TypeID", entity.TypeID);
                    command.Parameters.AddWithValue("@SupplierID", entity.SupplierID);
                    command.Parameters.AddWithValue("@SupplierProductKey", entity.SupplierProductKey);
                    command.Parameters.AddWithValue("@SupplierCost", entity.SupplierCost);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            entity.ID = reader.GetInt32(0);
                        }
                    }
                }
            }
            finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
            }
            return entity;
        }
        public async Task<ProductDto> Update(ProductDto entity)
        {
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("UpdateProduct", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Name", entity.Name);
                    command.Parameters.AddWithValue("@Price", entity.Price);
                    command.Parameters.AddWithValue("@ProductKey", entity.ProductKey);
                    command.Parameters.AddWithValue("@TypeID", entity.TypeID);
                    command.Parameters.AddWithValue("@ID", entity.ID);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            entity.ID = reader.GetInt32(0);
                            if (entity.ID == 0)
                            {
                                entity = new ProductDto();
                            }
                        }
                    }
                    
                }
            }finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
                entity = new ProductDto();
            }
            return entity;
        }
        public async Task<ProductDto> UpdateProductSupplier(ProductDto entity)
        {
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("UpdateProductSupplier", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@SupplierID", entity.SupplierID);
                    command.Parameters.AddWithValue("@SupplierProductKey", entity.SupplierProductKey);
                    command.Parameters.AddWithValue("@SupplierCost", entity.SupplierCost);
                    command.Parameters.AddWithValue("@ID", entity.ID);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            entity.ID = reader.GetInt32(0);
                            if (entity.ID == 0)
                            {
                                entity = new ProductDto();
                            }
                        }
                    }

                }
            }
            finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
                entity = new ProductDto();
            }
            return entity;
        }
        public async Task<bool> Delete(int id = 0)
        {
            bool response = false;

            if (id == 0)
            {
                return response;
            }
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();
                using (var command = new SqlCommand("DeleteProduct", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ID", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            int result = reader.GetInt32(0);
                            if (result != 0)
                            {
                                response = true;
                            }
                        }
                    }
                    
                    
                }
            }finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
            }
            return response;
        }
        public async Task<bool> DeleteProductSupplier(int id = 0)
        {
            bool response = false;

            if (id == 0)
            {
                return response;
            }
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();
                using (var command = new SqlCommand("DeleteProductSupplier", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ID", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            int result = reader.GetInt32(0);
                            if (result != 0)
                            {
                                response = true;
                            }
                        }
                    }


                }
            }
            finally
            {
                if (connection != null)
                {
                    await connection.CloseAsync();
                }
            }
            return response;
        }

    }
}
