using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NobleStep.Api.Data;
using NobleStep.Api.DTOs;

namespace NobleStep.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/admin/ecommerce-orders")]
public class AdminEcommerceOrdersController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly ILogger<AdminEcommerceOrdersController> _logger;

    public AdminEcommerceOrdersController(
        AppDbContext context,
        ILogger<AdminEcommerceOrdersController> logger)
    {
        _context = context;
        _logger = logger;
    }

    // GET: api/admin/ecommerce-orders
    [HttpGet]
    public async Task<ActionResult<List<OrderResponseDto>>> GetAllOrders(
        [FromQuery] string? status = null,
        [FromQuery] string? paymentStatus = null)
    {
        try
        {
            var query = _context.Orders
                .Include(o => o.OrderDetails)
                .ThenInclude(od => od.Product)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(status))
            {
                query = query.Where(o => o.OrderStatus == status);
            }

            if (!string.IsNullOrWhiteSpace(paymentStatus))
            {
                query = query.Where(o => o.PaymentStatus == paymentStatus);
            }

            var orders = await query
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();

            var response = orders.Select(order => new OrderResponseDto
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
            }).ToList();

            return Ok(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error obteniendo pedidos del e-commerce");
            return StatusCode(500, new { message = "Error interno del servidor" });
        }
    }

    // PUT: api/admin/ecommerce-orders/{id}/status
    [HttpPut("{id}/status")]
    public async Task<ActionResult> UpdateOrderStatus(int id, [FromBody] UpdateOrderStatusDto dto)
    {
        try
        {
            var order = await _context.Orders.FindAsync(id);

            if (order == null)
            {
                return NotFound(new { message = "Pedido no encontrado" });
            }

            if (!string.IsNullOrWhiteSpace(dto.OrderStatus))
            {
                order.OrderStatus = dto.OrderStatus;

                // Actualizar fechas según el estado
                if (dto.OrderStatus == "Processing" && order.ProcessedDate == null)
                {
                    order.ProcessedDate = DateTime.UtcNow;
                }
                else if (dto.OrderStatus == "Shipped" && order.ShippedDate == null)
                {
                    order.ShippedDate = DateTime.UtcNow;
                }
                else if (dto.OrderStatus == "Delivered" && order.DeliveredDate == null)
                {
                    order.DeliveredDate = DateTime.UtcNow;
                }
            }

            if (!string.IsNullOrWhiteSpace(dto.PaymentStatus))
            {
                order.PaymentStatus = dto.PaymentStatus;
            }

            order.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            _logger.LogInformation("Pedido {OrderNumber} actualizado", order.OrderNumber);
            return Ok(new { message = "Pedido actualizado exitosamente" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error actualizando pedido {OrderId}", id);
            return StatusCode(500, new { message = "Error interno del servidor" });
        }
    }
}
