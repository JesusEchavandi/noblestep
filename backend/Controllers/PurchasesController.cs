using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NobleStep.Api.Data;
using NobleStep.Api.DTOs;
using NobleStep.Api.Models;
using NobleStep.Api.Helpers;

namespace NobleStep.Api.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class PurchasesController : ControllerBase
{
    private readonly AppDbContext _context;

    public PurchasesController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/Purchases
    [HttpGet]
    public async Task<ActionResult<IEnumerable<PurchaseDto>>> GetPurchases()
    {
        var purchases = await _context.Purchases
            .Include(p => p.Supplier)
            .Include(p => p.Details)
                .ThenInclude(d => d.Product)
            .OrderByDescending(p => p.PurchaseDate)
            .Select(p => new PurchaseDto
            {
                Id = p.Id,
                SupplierId = p.SupplierId,
                SupplierName = p.Supplier.CompanyName,
                PurchaseDate = p.PurchaseDate,
                InvoiceNumber = p.InvoiceNumber,
                Total = p.Total,
                Status = p.Status,
                Notes = p.Notes,
                Details = p.Details.Select(d => new PurchaseDetailDto
                {
                    Id = d.Id,
                    ProductId = d.ProductId,
                    ProductName = d.Product.Name,
                    Quantity = d.Quantity,
                    UnitCost = d.UnitCost,
                    Subtotal = d.Subtotal
                }).ToList()
            })
            .ToListAsync();

        return Ok(purchases);
    }

    // GET: api/Purchases/5
    [HttpGet("{id}")]
    public async Task<ActionResult<PurchaseDto>> GetPurchase(int id)
    {
        var purchase = await _context.Purchases
            .Include(p => p.Supplier)
            .Include(p => p.Details)
                .ThenInclude(d => d.Product)
            .FirstOrDefaultAsync(p => p.Id == id);

        if (purchase == null)
        {
            return NotFound(new { message = "Compra no encontrada" });
        }

        var purchaseDto = new PurchaseDto
        {
            Id = purchase.Id,
            SupplierId = purchase.SupplierId,
            SupplierName = purchase.Supplier.CompanyName,
            PurchaseDate = purchase.PurchaseDate,
            InvoiceNumber = purchase.InvoiceNumber,
            Total = purchase.Total,
            Status = purchase.Status,
            Notes = purchase.Notes,
            Details = purchase.Details.Select(d => new PurchaseDetailDto
            {
                Id = d.Id,
                ProductId = d.ProductId,
                ProductName = d.Product.Name,
                Quantity = d.Quantity,
                UnitCost = d.UnitCost,
                Subtotal = d.Subtotal
            }).ToList()
        };

        return Ok(purchaseDto);
    }

    // POST: api/Purchases
    [HttpPost]
    [Authorize(Roles = "Administrator")]
    public async Task<ActionResult<PurchaseDto>> CreatePurchase(CreatePurchaseDto dto)
    {
        // Validate supplier exists
        var supplier = await _context.Suppliers.FindAsync(dto.SupplierId);
        if (supplier == null)
        {
            return BadRequest(new { message = "Proveedor no encontrado" });
        }

        // Check if invoice number already exists for this supplier
        try
        {
            var existingPurchase = await _context.Purchases
                .Where(p => p.InvoiceNumber == dto.InvoiceNumber)
                .FirstOrDefaultAsync();

            if (existingPurchase != null)
            {
                return BadRequest(new { message = "Ya existe una compra con este número de factura" });
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error checking duplicate invoice: {ex.Message}");
            // Continue anyway
        }

        // Validate products and calculate total
        decimal total = 0;
        var purchaseDetails = new List<PurchaseDetail>();

        foreach (var detail in dto.Details)
        {
            var product = await _context.Products.FindAsync(detail.ProductId);
            if (product == null)
            {
                return BadRequest(new { message = $"Producto con ID {detail.ProductId} no encontrado" });
            }

            var subtotal = detail.Quantity * detail.UnitCost;
            total += subtotal;

            purchaseDetails.Add(new PurchaseDetail
            {
                ProductId = detail.ProductId,
                Quantity = detail.Quantity,
                UnitCost = detail.UnitCost,
                Subtotal = subtotal
            });

            // Update product stock
            product.Stock += detail.Quantity;
            product.UpdatedAt = DateTimeHelper.GetPeruDateTime();
        }

        // Get authenticated user ID
        var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
        if (userIdClaim == null || !int.TryParse(userIdClaim.Value, out int userId))
        {
            return Unauthorized(new { message = "Usuario no autenticado" });
        }

        var purchase = new Purchase
        {
            SupplierId = dto.SupplierId,
            UserId = userId,
            PurchaseDate = dto.PurchaseDate,
            InvoiceNumber = dto.InvoiceNumber,
            Total = total,
            Status = "Completada",
            Notes = dto.Notes,
            Details = purchaseDetails,
            CreatedAt = DateTimeHelper.GetPeruDateTime()
        };

        _context.Purchases.Add(purchase);
        await _context.SaveChangesAsync();

        // Load related data for response
        await _context.Entry(purchase)
            .Reference(p => p.Supplier)
            .LoadAsync();

        await _context.Entry(purchase)
            .Collection(p => p.Details)
            .Query()
            .Include(d => d.Product)
            .LoadAsync();

        var purchaseDto = new PurchaseDto
        {
            Id = purchase.Id,
            SupplierId = purchase.SupplierId,
            SupplierName = purchase.Supplier.CompanyName,
            PurchaseDate = purchase.PurchaseDate,
            InvoiceNumber = purchase.InvoiceNumber,
            Total = purchase.Total,
            Status = purchase.Status,
            Notes = purchase.Notes,
            Details = purchase.Details.Select(d => new PurchaseDetailDto
            {
                Id = d.Id,
                ProductId = d.ProductId,
                ProductName = d.Product.Name,
                Quantity = d.Quantity,
                UnitCost = d.UnitCost,
                Subtotal = d.Subtotal
            }).ToList()
        };

        return CreatedAtAction(nameof(GetPurchase), new { id = purchase.Id }, purchaseDto);
    }

    // GET: api/Purchases/Summary
    [HttpGet("Summary")]
    public async Task<ActionResult<object>> GetPurchasesSummary()
    {
        var totalPurchases = await _context.Purchases
            .Where(p => p.Status == "Completada" || p.Status == "Completed")
            .SumAsync(p => (decimal?)p.Total) ?? 0;

        var totalCount = await _context.Purchases
            .Where(p => p.Status == "Completada" || p.Status == "Completed")
            .CountAsync();

        return Ok(new
        {
            totalPurchases,
            totalCount
        });
    }

    // GET: api/Purchases/ByDateRange
    [HttpGet("ByDateRange")]
    public async Task<ActionResult<object>> GetPurchasesByDateRange([FromQuery] DateTime startDate, [FromQuery] DateTime endDate)
    {
        var purchases = await _context.Purchases
            .Include(p => p.Supplier)
            .Where(p => p.PurchaseDate >= startDate && p.PurchaseDate <= endDate)
            .OrderByDescending(p => p.PurchaseDate)
            .Select(p => new PurchaseDto
            {
                Id = p.Id,
                SupplierId = p.SupplierId,
                SupplierName = p.Supplier.CompanyName,
                PurchaseDate = p.PurchaseDate,
                InvoiceNumber = p.InvoiceNumber,
                Total = p.Total,
                Status = p.Status,
                Notes = p.Notes
            })
            .ToListAsync();

        var totalPurchases = purchases.Sum(p => p.Total);

        return Ok(new
        {
            purchases,
            totalPurchases
        });
    }
}
