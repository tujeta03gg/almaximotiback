using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using AlMaximoTI.Models;
using AlMaximoTI.Services;
using AlMaximoTI.Dtos;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace AlMaximoTI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductController : ControllerBase
    {
        private readonly ILogger<ProductController> _logger;
        private readonly IProductService<ProductDto> _productDtoService;


        public ProductController(ILogger<ProductController> logger, IProductService<ProductDto> productDtoService)
        {
            _logger = logger;
            _productDtoService = productDtoService;
        }

        [HttpGet("all", Name = "GetAllProducts")]
        public async Task<IActionResult> GetAllProducts()
        {
            IEnumerable<ProductDto> products = await _productDtoService.GetAll();
            //parse ProductDto to ProductSimple
            List<ProductSimple> productsList = new List<ProductSimple>();
            foreach (ProductDto product in products) {
                ProductSimple productModel = new ProductSimple();
                productModel.ID = product.ID;
                productModel.Name = product.Name;
                productModel.ProductKey = product.ProductKey;
                productModel.Deleted = product.Deleted;
                productModel.Price = product.Price;
                productModel.TypeName = product.TypeName;
                productsList.Add(productModel);
            }
            return Ok(productsList);
        }

        [HttpGet("{id}", Name = "Get")]
        public async Task<ActionResult<ProductDto>> Get(int id)
        {
            var product = await _productDtoService.Get(id);
            if (product == null)
            {
                return NotFound();
            }

            ProductSimple productModel = new ProductSimple();
            productModel.ID = product.ID;
            productModel.Name = product.Name;
            productModel.ProductKey = product.ProductKey;    
            productModel.Deleted = product.Deleted;
            productModel.Price = product.Price;
            productModel.TypeName = product.TypeName;

            return Ok(productModel);

        }

        [HttpGet("products/{id}", Name = "GetAllProductsSupplier")]
        public async Task<IActionResult> GetAllProductsSupplier(int id)
        {
            IEnumerable<ProductDto> products = await _productDtoService.GetAllProductSupplier(id);
            List<ProductSupplierDto> productsList = new List<ProductSupplierDto>();
            foreach (ProductDto product in products)
            {
                ProductSupplierDto productModel = new ProductSupplierDto();
                productModel.ID = product.ID;
                productModel.Name = product.SupplierName;
                productModel.SupplierProductKey = product.SupplierProductKey;
                productModel.SupplierCost = product.SupplierCost;
                productModel.SupplierID = product.SupplierID;
                productsList.Add(productModel);
            }

            return Ok(productsList);
        }

        [HttpGet("productsSupplier/{id}", Name = "GetProductSupplier")]
        public async Task<IActionResult> GetProductSupplier(int id)
        {
            var product = await _productDtoService.GetProductSupplier(id);
            if (product == null)
            {
                return NotFound();
            }

            ProductSupplierDto productModel = new ProductSupplierDto();
            productModel.ID = product.ID;
            productModel.Name = product.Name;
            productModel.SupplierProductKey = product.SupplierProductKey;
            productModel.SupplierCost = product.SupplierCost;
            productModel.SupplierID = product.SupplierID;

            return Ok(productModel);
        }

        [HttpPost("add", Name = "Create")]
        public async Task<ActionResult> Create([FromBody] CreateProductRequest request)
        {
            ProductDto productDto = new ProductDto();
            productDto.Name = request.name;
            productDto.Price = request.price;
            productDto.ProductKey = request.productKey;
            productDto.TypeID = request.typeID;
            productDto.SupplierID = request.supplierID;
            productDto.SupplierProductKey = request.supplierProductKey;
            productDto.SupplierCost = request.supplierCost;

            ProductDto response = await _productDtoService.Create(productDto);
            return Ok(response);
            
        }

        [HttpPut("modify", Name = "ModifyProduct")]
        public async Task<ActionResult> Update([FromBody] UpdateProductRequest request)
        {
            ProductDto productDto = new ProductDto();
            productDto.Name = request.Name;
            productDto.Price = request.Price;
            productDto.ProductKey = request.ProductKey;
            productDto.TypeID = request.TypeID;
            productDto.ID = request.ID;

            ProductDto response = await _productDtoService.Update(productDto);
            return Ok(response);
        }

        [HttpPut("modifyProduct", Name = "UpdateProductSupplier")]
        public async Task<ActionResult> UpdateProductSupplier([FromBody] UpdateProductSupplerDto request)
        {
            ProductDto productDto = new ProductDto();
            productDto.SupplierID = request.SupplierID;
            productDto.SupplierProductKey = request.SupplierProductKey;
            productDto.SupplierCost = request.SupplierCost;
            productDto.ID = request.ID;

            ProductDto response = await _productDtoService.UpdateProductSupplier(productDto);
            return Ok(response);
        }

        [HttpDelete("remove", Name = "RemoveProduct")]
        public async Task<ActionResult> Delete([FromBody] DeleteProductRequest request)
        {
            bool response = await _productDtoService.Delete(request.ID);

            return Ok(response);
        }

        [HttpDelete("removeProduct", Name = "RemoveProductSupplier")]
        public async Task<ActionResult> DeleteProductSupplier([FromBody] DeleteProductRequest request)
        {
            bool response = await _productDtoService.DeleteProductSupplier(request.ID);

            return Ok(response);
        }
    }
}
