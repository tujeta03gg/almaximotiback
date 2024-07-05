using AlMaximoTI.Dtos;
using AlMaximoTI.Services;
using System.Data.SqlClient;
using System.Data;

namespace AlMaximoTI.Repositories
{
    public class SelectRepository: ISelectService<SelectDto>
    {
        private readonly string _connectionString = " ";
        public SelectRepository(IConfiguration config)
        {
            _connectionString = config.GetConnectionString("DefaultConnection")!;
        }

        public async Task<List<SelectDto>> GetSelectTypes()
        {
            List<SelectDto> types = new List<SelectDto>();
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("GetAllTypes", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            SelectDto type = new SelectDto
                            {
                                ID = reader.GetInt32(reader.GetOrdinal("ID")),
                                Name = reader.GetString(reader.GetOrdinal("Name")),
                                Description = reader.GetString(reader.GetOrdinal("Description"))
                            };
                            types.Add(type);
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
            return types;
        }
    

        public async Task<List<SelectDto>> GetSelectSuppliers()
        {
            List<SelectDto> suppliers = new List<SelectDto>();
            SqlConnection connection = null;
            try
            {
                connection = new SqlConnection(_connectionString);
                await connection.OpenAsync();

                using (var command = new SqlCommand("GetAllSuppliers", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            SelectDto supplier = new SelectDto
                            {
                                ID = reader.GetInt32(reader.GetOrdinal("ID")),
                                Name = reader.GetString(reader.GetOrdinal("Name")),
                                Description = reader.GetString(reader.GetOrdinal("Description"))
                            };
                            suppliers.Add(supplier);
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
            return suppliers;
        }
    }
}
