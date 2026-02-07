using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NobleStep.Api.Data;
using NobleStep.Api.DTOs;
using NobleStep.Api.Models;

namespace NobleStep.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class SalesController : ControllerBase
{
    private readonly AppDbContext _context;

    public SalesController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<SaleDto>>> GetSales()
    {
        var sales = await _context.Sales
            .Include(s => s.Customer)
            .Include(s => s.SaleDetails)
            .ThenInclude(sd => sd.Product)
            .OrderByDescending(s => s.SaleDate)
            .Select(s => new SaleDto
            {
                Id = s.Id,
                CustomerId = s.CustomerId,
                CustomerName = s.Customer.FullName,
                SaleDate = s.SaleDate,
                Total = s.Total,
                Status = s.Status,
                PaymentMethod = s.PaymentMethod,
                Details = s.SaleDetails.Select(sd => new SaleDetailDto
                {
                    ProductId = sd.ProductId,
                    ProductName = sd.Product.Name,
                    Quantity = sd.Quantity,
                    UnitPrice = sd.UnitPrice,
                    Subtotal = sd.Subtotal
                }).ToList()
            })
            .ToListAsync();

        return Ok(sales);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<SaleDto>> GetSale(int id)
    {
        var sale = await _context.Sales
            .Include(s => s.Customer)
            .Include(s => s.SaleDetails)
            .ThenInclude(sd => sd.Product)
            .FirstOrDefaultAsync(s => s.Id == id);

        if (sale == null)
            return NotFound();

        var saleDto = new SaleDto
        {
            Id = sale.Id,
            CustomerId = sale.CustomerId,
            CustomerName = sale.Customer.FullName,
            SaleDate = sale.SaleDate,
            Total = sale.Total,
            Status = sale.Status,
            PaymentMethod = sale.PaymentMethod,            Details = sale.SaleDetails.Select(sd => new SaleDetailDto
            {
                ProductId = sd.ProductId,
                ProductName = sd.Product.Name,
                Quantity = sd.Quantity,
                UnitPrice = sd.UnitPrice,
                Subtotal = sd.Subtotal
            }).ToList()
        };

        return Ok(saleDto);
    }

    [HttpPost]
    public async Task<ActionResult<SaleDto>> CreateSale([FromBody] CreateSaleDto createDto)
    {
        // Get current user ID from JWT token
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
            return Unauthorized();

        // Verify customer exists
        var customer = await _context.Customers.FindAsync(createDto.CustomerId);
        if (customer == null)
            return BadRequest(new { message = "Customer not found" });

        // Verify products and stock availability
        var productIds = createDto.Details.Select(d => d.ProductId).ToList();
        var products = await _context.Products
            .Where(p => productIds.Contains(p.Id) && p.IsActive)
            .ToListAsync();

        if (products.Count != productIds.Count)
            return BadRequest(new { message = "One or more products not found or inactive" });

        // Check stock availability
        foreach (var detail in createDto.Details)
        {
            var product = products.First(p => p.Id == detail.ProductId);
            if (product.Stock < detail.Quantity)
                return BadRequest(new { message = $"Insufficient stock for product: {product.Name}" });
        }

        // Create sale
        var sale = new Sale
        {
            CustomerId = createDto.CustomerId,
            UserId = userId,
            SaleDate = DateTime.Now,
            Status = "Completed",
            PaymentMethod = createDto.PaymentMethod
        };

        decimal total = 0;
        foreach (var detail in createDto.Details)
        {
            var product = products.First(p => p.Id == detail.ProductId);
            var subtotal = product.Price * detail.Quantity;

            var saleDetail = new SaleDetail
            {
                ProductId = detail.ProductId,
                Quantity = detail.Quantity,
                UnitPrice = product.Price,
                Subtotal = subtotal
            };

            sale.SaleDetails.Add(saleDetail);
            total += subtotal;

            // Update stock
            product.Stock -= detail.Quantity;
        }

        sale.Total = total;

        _context.Sales.Add(sale);
        await _context.SaveChangesAsync();

        // Load navigation properties for response
        await _context.Entry(sale).Reference(s => s.Customer).LoadAsync();
        await _context.Entry(sale).Collection(s => s.SaleDetails).LoadAsync();
        foreach (var detail in sale.SaleDetails)
        {
            await _context.Entry(detail).Reference(sd => sd.Product).LoadAsync();
        }

        var saleDto = new SaleDto
        {
            Id = sale.Id,
            CustomerId = sale.CustomerId,
            CustomerName = sale.Customer.FullName,
            SaleDate = sale.SaleDate,
            Total = sale.Total,
            Status = sale.Status,
            PaymentMethod = sale.PaymentMethod,            Details = sale.SaleDetails.Select(sd => new SaleDetailDto
            {
                ProductId = sd.ProductId,
                ProductName = sd.Product.Name,
                Quantity = sd.Quantity,
                UnitPrice = sd.UnitPrice,
                Subtotal = sd.Subtotal
            }).ToList()
        };

        return CreatedAtAction(nameof(GetSale), new { id = sale.Id }, saleDto);
    }

    [HttpGet("reports/by-date")]
    public async Task<ActionResult> GetSalesByDate([FromQuery] DateTime? startDate, [FromQuery] DateTime? endDate)
    {
        var query = _context.Sales.AsQueryable();

        if (startDate.HasValue)
            query = query.Where(s => s.SaleDate >= startDate.Value);

        if (endDate.HasValue)
            query = query.Where(s => s.SaleDate <= endDate.Value);

        var sales = await query
            .Include(s => s.Customer)
            .Where(s => s.Status == "Completed")
            .OrderByDescending(s => s.SaleDate)
            .Select(s => new
            {
                s.Id,
                s.SaleDate,
                CustomerName = s.Customer.FullName,
                s.Total,
                s.Status
            })
            .ToListAsync();

        var totalSales = sales.Sum(s => s.Total);

        return Ok(new
        {
            sales,
            totalSales,
            count = sales.Count
        });
    }

    [HttpGet("reports/best-selling")]
    public async Task<ActionResult> GetBestSellingProducts([FromQuery] int limit = 10)
    {
        var bestSelling = await _context.SaleDetails
            .Include(sd => sd.Product)
            .GroupBy(sd => new { sd.ProductId, sd.Product.Name })
            .Select(g => new
            {
                ProductId = g.Key.ProductId,
                ProductName = g.Key.Name,
                TotalQuantity = g.Sum(sd => sd.Quantity),
                TotalRevenue = g.Sum(sd => sd.Subtotal)
            })
            .OrderByDescending(x => x.TotalQuantity)
            .Take(limit)
            .ToListAsync();

        return Ok(bestSelling);
    }

    [HttpGet("reports/total")]
    public async Task<ActionResult> GetTotalSales()
    {
        var totalSales = await _context.Sales
            .Where(s => s.Status == "Completed")
            .SumAsync(s => s.Total);

        var totalCount = await _context.Sales
            .Where(s => s.Status == "Completed")
            .CountAsync();

        return Ok(new
        {
            totalSales,
            totalCount
        });
    }
}
