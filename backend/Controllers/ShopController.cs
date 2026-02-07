using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NobleStep.Api.Data;
using NobleStep.Api.DTOs;

namespace NobleStep.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ShopController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly ILogger<ShopController> _logger;

    public ShopController(AppDbContext context, ILogger<ShopController> logger)
    {
        _context = context;
        _logger = logger;
    }

    // GET: api/shop/products - Obtener productos activos para el catálogo público
    [HttpGet("products")]
    public async Task<ActionResult<IEnumerable<ProductShopDto>>> GetProducts(
        [FromQuery] int? categoryId = null,
        [FromQuery] string? search = null,
        [FromQuery] decimal? minPrice = null,
        [FromQuery] decimal? maxPrice = null,
        [FromQuery] bool? inStock = null)
    {
        try
        {
            var query = _context.Products
                .Include(p => p.Category)
                .Where(p => p.Stock > 0) // Solo productos con stock
                .AsQueryable();

            // Filtrar por categoría
            if (categoryId.HasValue)
            {
                query = query.Where(p => p.CategoryId == categoryId.Value);
            }

            // Búsqueda por nombre o marca
            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(p => p.Name.Contains(search) || p.Brand.Contains(search));
            }

            // Filtrar por rango de precio
            if (minPrice.HasValue)
            {
                query = query.Where(p => p.Price >= minPrice.Value);
            }

            if (maxPrice.HasValue)
            {
                query = query.Where(p => p.Price <= maxPrice.Value);
            }

            // Filtrar por disponibilidad
            if (inStock.HasValue && inStock.Value)
            {
                query = query.Where(p => p.Stock > 0);
            }

            var products = await query
                .OrderByDescending(p => p.UpdatedAt)
                .Select(p => new ProductShopDto
                {
                    Id = p.Id,
                    Code = p.Brand,
                    Name = p.Name,
                    Description = p.Size,
                    SalePrice = p.Price,
                    Stock = p.Stock,
                    CategoryId = p.CategoryId,
                    CategoryName = p.Category != null ? p.Category.Name : "Sin categoría",
                    ImageUrl = null
                })
                .ToListAsync();

            return Ok(products);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error obteniendo productos para el catálogo");
            return StatusCode(500, "Error interno del servidor");
        }
    }

    // GET: api/shop/products/{id} - Obtener detalle de un producto
    [HttpGet("products/{id}")]
    public async Task<ActionResult<ProductShopDto>> GetProduct(int id)
    {
        try
        {
            if (id <= 0)
            {
                return BadRequest(new { message = "ID de producto inválido" });
            }

            var product = await _context.Products
                .Include(p => p.Category)
                .Where(p => p.Id == id && p.Stock > 0)
                .Select(p => new ProductShopDto
                {
                    Id = p.Id,
                    Code = p.Brand,
                    Name = p.Name,
                    Description = p.Size,
                    SalePrice = p.Price,
                    Stock = p.Stock,
                    CategoryId = p.CategoryId,
                    CategoryName = p.Category != null ? p.Category.Name : "Sin categoría",
                    ImageUrl = null
                })
                .FirstOrDefaultAsync();

            if (product == null)
            {
                return NotFound(new { message = "Producto no encontrado o sin stock disponible" });
            }

            return Ok(product);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error obteniendo detalle del producto {ProductId}", id);
            return StatusCode(500, new { message = "Error interno del servidor" });
        }
    }

    // GET: api/shop/categories - Obtener categorías con productos disponibles
    [HttpGet("categories")]
    public async Task<ActionResult<IEnumerable<CategoryShopDto>>> GetCategories()
    {
        try
        {
            var categories = await _context.Categories
                .Where(c => c.Products.Any(p => p.Stock > 0))
                .Select(c => new CategoryShopDto
                {
                    Id = c.Id,
                    Name = c.Name,
                    Description = c.Description,
                    ProductCount = c.Products.Count(p => p.Stock > 0)
                })
                .OrderBy(c => c.Name)
                .ToListAsync();

            return Ok(categories);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error obteniendo categorías");
            return StatusCode(500, "Error interno del servidor");
        }
    }

    // GET: api/shop/products/featured - Obtener productos destacados (últimos agregados con stock)
    [HttpGet("products/featured")]
    public async Task<ActionResult<IEnumerable<ProductShopDto>>> GetFeaturedProducts([FromQuery] int limit = 8)
    {
        try
        {
            // Validar límite
            if (limit <= 0 || limit > 50)
            {
                limit = 8; // Valor por defecto
            }

            var products = await _context.Products
                .Include(p => p.Category)
                .Where(p => p.Stock > 0)
                .OrderByDescending(p => p.CreatedAt)
                .Take(limit)
                .Select(p => new ProductShopDto
                {
                    Id = p.Id,
                    Code = p.Brand,
                    Name = p.Name,
                    Description = p.Size,
                    SalePrice = p.Price,
                    Stock = p.Stock,
                    CategoryId = p.CategoryId,
                    CategoryName = p.Category != null ? p.Category.Name : "Sin categoría",
                    ImageUrl = null
                })
                .ToListAsync();

            return Ok(products);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error obteniendo productos destacados");
            return StatusCode(500, new { message = "Error interno del servidor" });
        }
    }

    // POST: api/shop/contact - Recibir consultas de contacto
    [HttpPost("contact")]
    public async Task<ActionResult> SubmitContact([FromBody] ContactDto contact)
    {
        try
        {
            // Validar datos del contacto
            if (string.IsNullOrWhiteSpace(contact.Name))
            {
                return BadRequest(new { message = "El nombre es requerido" });
            }

            if (string.IsNullOrWhiteSpace(contact.Email))
            {
                return BadRequest(new { message = "El email es requerido" });
            }

            if (string.IsNullOrWhiteSpace(contact.Phone))
            {
                return BadRequest(new { message = "El teléfono es requerido" });
            }

            if (string.IsNullOrWhiteSpace(contact.Message))
            {
                return BadRequest(new { message = "El mensaje es requerido" });
            }

            // Validar formato de email
            if (!contact.Email.Contains("@") || !contact.Email.Contains("."))
            {
                return BadRequest(new { message = "Email inválido" });
            }

            // Por ahora solo registramos en logs
            // En el futuro se puede guardar en BD o enviar email
            _logger.LogInformation(
                "Consulta de contacto recibida - Nombre: {Name}, Email: {Email}, Teléfono: {Phone}, Mensaje: {Message}", 
                contact.Name, contact.Email, contact.Phone, contact.Message
            );

            return Ok(new { 
                success = true,
                message = "Consulta enviada exitosamente. Nos pondremos en contacto pronto." 
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error procesando consulta de contacto");
            return StatusCode(500, new { 
                success = false,
                message = "Error interno del servidor" 
            });
        }
    }
}
