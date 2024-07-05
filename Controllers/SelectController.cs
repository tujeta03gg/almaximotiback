using AlMaximoTI.Dtos;
using AlMaximoTI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace AlMaximoTI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SelectController : ControllerBase
    {
        private readonly ILogger<SelectController> _logger;
        private readonly ISelectService<SelectDto> _selectDtoService;

        public SelectController(ILogger<SelectController> logger, ISelectService<SelectDto> selectDtoService)
        {
            _logger = logger;
            _selectDtoService = selectDtoService;
        }

        [HttpGet("get_types", Name = "Types")]
        public async Task<IActionResult> GetAllTypes()
        {
            IEnumerable<SelectDto> list = await _selectDtoService.GetSelectTypes();
            return Ok(list);
        }

        [HttpGet("get_suppliers", Name = "Suppliers")]
        public async Task<IActionResult> GetAllSuppliers()
        {
            IEnumerable<SelectDto> list = await _selectDtoService.GetSelectSuppliers();
            return Ok(list);
        }
    }
}
