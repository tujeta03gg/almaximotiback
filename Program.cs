using AlMaximoTI.Controllers;
using AlMaximoTI.Dtos;
using AlMaximoTI.Models;
using AlMaximoTI.Repositories;
using AlMaximoTI.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

//declare serices
builder.Services.AddScoped<IProductService<ProductDto>, ProductRepository>();
builder.Services.AddScoped<ISelectService<SelectDto>, SelectRepository>();
//builder.Services.AddScoped<ILogger<HomeController>, _logger>();


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(op =>
{
    op.AddPolicy("AllowAllOrigins", builder => builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
}   
);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    
}
app.UseSwagger();
app.UseSwaggerUI();

app.UseCors("AllowAllOrigins");

app.UseAuthorization();

app.MapControllers();

app.Run();
