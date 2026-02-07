using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NobleStep.Api.Data;
using NobleStep.Api.DTOs;
using NobleStep.Api.Models;
using NobleStep.Api.Services;
using System.Text.Json;

namespace NobleStep.Api.Controllers;

[ApiController]
[Route("api/ecommerce/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IEmailService _emailService;
    private readonly ILogger<OrdersController> _logger;

    public OrdersController(
        AppDbContext context,
        IEmailService emailService,
        ILogger<OrdersController> logger)
    {
        _context = context;
        _emailService = emailService;
        _logger = logger;
    }

    // POST: api/ecommerce/orders
    [HttpPost]
    public async Task<ActionResult<OrderResponseDto>> CreateOrder([FromBody] CreateOrderDto dto)
    {
        using var transaction = await _context.Database.BeginTransactionAsync();
        
        try
        {
            // Validaciones básicas
            if (string.IsNullOrWhiteSpace(dto.CustomerFullName) || 
                string.IsNullOrWhiteSpace(dto.CustomerEmail) ||
                string.IsNullOrWhiteSpace(dto.CustomerPhone) ||
                dto.Items == null || !dto.Items.Any())
            {
                return BadRequest(new { message = "Faltan datos requeridos" });
            }

            // Obtener ID de cliente si está autenticado
            int? customerId = null;
            var customerIdClaim = User.FindFirst("customerId");
            if (customerIdClaim != null && int.TryParse(customerIdClaim.Value, out var id))
            {
                customerId = id;
            }

            // Calcular totales
            decimal subtotal = 0;
            var orderDetails = new List<OrderDetail>();

            foreach (var item in dto.Items)
            {
                var product = await _context.Products.FindAsync(item.ProductId);
                if (product == null)
                {
                    return BadRequest(new { message = $"Producto {item.ProductId} no encontrado" });
                }

                if (product.Stock < item.Quantity)
                {
                    return BadRequest(new { message = $"Stock insuficiente para {product.Name}" });
                }

                var itemSubtotal = item.UnitPrice * item.Quantity;
                subtotal += itemSubtotal;

                orderDetails.Add(new OrderDetail
                {
                    ProductId = item.ProductId,
                    ProductName = product.Name,
                    ProductCode = product.Brand,
                    ProductSize = product.Size,
                    ProductBrand = product.Brand,
                    Quantity = item.Quantity,
                    UnitPrice = item.UnitPrice,
                    Subtotal = itemSubtotal
                });

                // Reducir stock
                product.Stock -= item.Quantity;
                product.UpdatedAt = DateTime.UtcNow;
            }

            // Calcular envío
            decimal shippingCost = subtotal >= 100 ? 0 : 10;
            decimal total = subtotal + shippingCost;

            // Generar número de orden
            var orderNumber = $"ORD-{DateTime.UtcNow:yyyyMMdd}-{Guid.NewGuid().ToString("N").Substring(0, 8).ToUpper()}";

            // Crear orden
            var order = new Order
            {
                EcommerceCustomerId = customerId,
                OrderNumber = orderNumber,
                CustomerFullName = dto.CustomerFullName,
                CustomerEmail = dto.CustomerEmail,
                CustomerPhone = dto.CustomerPhone,
                CustomerAddress = dto.CustomerAddress,
                CustomerCity = dto.CustomerCity,
                CustomerDistrict = dto.CustomerDistrict,
                CustomerReference = dto.CustomerReference,
                CustomerDocumentNumber = dto.CustomerDocumentNumber,
                Subtotal = subtotal,
                ShippingCost = shippingCost,
                Total = total,
                PaymentMethod = dto.PaymentMethod,
                PaymentDetails = dto.PaymentDetails,
                PaymentStatus = "Pending",
                OrderStatus = "Pending",
                InvoiceType = dto.InvoiceType,
                CompanyName = dto.CompanyName,
                CompanyRUC = dto.CompanyRUC,
                CompanyAddress = dto.CompanyAddress,
                OrderDate = DateTime.UtcNow,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                OrderDetails = orderDetails
            };

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            // Enviar email de confirmación (no bloqueante)
            try
            {
                await _emailService.SendOrderConfirmationEmailAsync(
                    order.CustomerEmail, 
                    order.OrderNumber, 
                    order.CustomerFullName);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "No se pudo enviar email de confirmación para orden {OrderNumber}", orderNumber);
            }

            // Preparar respuesta
            var response = MapOrderToDto(order);

            _logger.LogInformation("Orden creada: {OrderNumber}", orderNumber);
            return Ok(response);
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            _logger.LogError(ex, "Error creando orden");
            return StatusCode(500, new { message = "Error interno del servidor" });
        }
    }

    // GET: api/ecommerce/orders/my-orders
    [Authorize]
    [HttpGet("my-orders")]
    public async Task<ActionResult<List<OrderResponseDto>>> GetMyOrders()
    {
        try
        {
            var customerIdClaim = User.FindFirst("customerId");
            if (customerIdClaim == null || !int.TryParse(customerIdClaim.Value, out var customerId))
            {
                return Unauthorized(new { message = "No autorizado" });
            }

            var orders = await _context.Orders
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.Product)
                .Where(o => o.EcommerceCustomerId == customerId)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            var response = orders.Select(MapOrderToDto).ToList();

            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error obteniendo órdenes del cliente");
            return StatusCode(500, new { message = "Error interno del servidor" });
        }
    }

    // GET: api/ecommerce/orders/{id}
    [HttpGet("{id}")]
    public async Task<ActionResult<OrderResponseDto>> GetOrder(int id)
    {
        try
        {
            var order = await _context.Orders
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.Product)
                .FirstOrDefaultAsync(o => o.Id == id);

            if (order == null)
            {
                return NotFound(new { message = "Orden no encontrada" });
            }

            // Verificar autorización
            var customerIdClaim = User.FindFirst("customerId");
            if (customerIdClaim != null && int.TryParse(customerIdClaim.Value, out var customerId))
            {
                if (order.EcommerceCustomerId != customerId)
                {
                    return Forbid();
                }
            }

            var response = MapOrderToDto(order);
            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error obteniendo orden {OrderId}", id);
            return StatusCode(500, new { message = "Error interno del servidor" });
        }
    }

    private OrderResponseDto MapOrderToDto(Order order)
    {
        return new OrderResponseDto
        {
            Id = order.Id,
            OrderNumber = order.OrderNumber,
            CustomerFullName = order.CustomerFullName,
            CustomerEmail = order.CustomerEmail,
            CustomerPhone = order.CustomerPhone,
            CustomerAddress = order.CustomerAddress,
            CustomerCity = order.CustomerCity,
            CustomerDistrict = order.CustomerDistrict,
            CustomerReference = order.CustomerReference,
            Subtotal = order.Subtotal,
            ShippingCost = order.ShippingCost,
            Total = order.Total,
            PaymentMethod = order.PaymentMethod,
            PaymentStatus = order.PaymentStatus,
            OrderStatus = order.OrderStatus,
            InvoiceType = order.InvoiceType,
            CompanyName = order.CompanyName,
            CompanyRUC = order.CompanyRUC,
            OrderDate = order.OrderDate,
            DeliveredDate = order.DeliveredDate,
            Items = order.OrderDetails.Select(od => new OrderDetailResponseDto
            {
                Id = od.Id,
                ProductId = od.ProductId,
                ProductName = od.ProductName,
                ProductCode = od.ProductCode,
                ProductSize = od.ProductSize,
                Quantity = od.Quantity,
                UnitPrice = od.UnitPrice,
                Subtotal = od.Subtotal
            }).ToList()
        };
    }
}
