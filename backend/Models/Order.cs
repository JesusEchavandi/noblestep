namespace NobleStep.Api.Models;

public class Order
{
    public int Id { get; set; }
    public int? EcommerceCustomerId { get; set; }
    
    // Información del cliente (para pedidos sin sesión)
    public string CustomerFullName { get; set; } = string.Empty;
    public string CustomerEmail { get; set; } = string.Empty;
    public string CustomerPhone { get; set; } = string.Empty;
    public string CustomerAddress { get; set; } = string.Empty;
    public string CustomerCity { get; set; } = string.Empty;
    public string CustomerDistrict { get; set; } = string.Empty;
    public string? CustomerReference { get; set; }
    public string? CustomerDocumentNumber { get; set; }
    
    // Información del pedido
    public string OrderNumber { get; set; } = string.Empty;
    public decimal Subtotal { get; set; }
    public decimal ShippingCost { get; set; }
    public decimal Total { get; set; }
    
    // Pago
    public string PaymentMethod { get; set; } = string.Empty; // yape, card, transfer
    public string? PaymentDetails { get; set; } // JSON con detalles del pago
    public string PaymentStatus { get; set; } = "Pending"; // Pending, Confirmed, Rejected
    
    // Estado del pedido
    public string OrderStatus { get; set; } = "Pending"; // Pending, Processing, Shipped, Delivered, Cancelled
    
    // Facturación
    public string InvoiceType { get; set; } = "Boleta"; // Boleta, Factura
    public string? CompanyName { get; set; }
    public string? CompanyRUC { get; set; }
    public string? CompanyAddress { get; set; }
    
    // Fechas
    public DateTime OrderDate { get; set; } = DateTime.UtcNow;
    public DateTime? ProcessedDate { get; set; }
    public DateTime? ShippedDate { get; set; }
    public DateTime? DeliveredDate { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    
    // Navigation properties
    public EcommerceCustomer? EcommerceCustomer { get; set; }
    public ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
}
