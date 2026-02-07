namespace NobleStep.Api.DTOs;

public class CreateOrderDto
{
    // Cliente
    public string CustomerFullName { get; set; } = string.Empty;
    public string CustomerEmail { get; set; } = string.Empty;
    public string CustomerPhone { get; set; } = string.Empty;
    public string CustomerAddress { get; set; } = string.Empty;
    public string CustomerCity { get; set; } = string.Empty;
    public string CustomerDistrict { get; set; } = string.Empty;
    public string? CustomerReference { get; set; }
    public string? CustomerDocumentNumber { get; set; }
    
    // Pago
    public string PaymentMethod { get; set; } = string.Empty;
    public string? PaymentDetails { get; set; }
    
    // Facturación
    public string InvoiceType { get; set; } = "Boleta";
    public string? CompanyName { get; set; }
    public string? CompanyRUC { get; set; }
    public string? CompanyAddress { get; set; }
    
    // Productos
    public List<OrderItemDto> Items { get; set; } = new();
}

public class OrderItemDto
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
}

public class OrderResponseDto
{
    public int Id { get; set; }
    public string OrderNumber { get; set; } = string.Empty;
    public string CustomerFullName { get; set; } = string.Empty;
    public string CustomerEmail { get; set; } = string.Empty;
    public string CustomerPhone { get; set; } = string.Empty;
    public string CustomerAddress { get; set; } = string.Empty;
    public string CustomerCity { get; set; } = string.Empty;
    public string CustomerDistrict { get; set; } = string.Empty;
    public string? CustomerReference { get; set; }
    
    public decimal Subtotal { get; set; }
    public decimal ShippingCost { get; set; }
    public decimal Total { get; set; }
    
    public string PaymentMethod { get; set; } = string.Empty;
    public string PaymentStatus { get; set; } = string.Empty;
    public string OrderStatus { get; set; } = string.Empty;
    
    public string InvoiceType { get; set; } = string.Empty;
    public string? CompanyName { get; set; }
    public string? CompanyRUC { get; set; }
    
    public DateTime OrderDate { get; set; }
    public DateTime? DeliveredDate { get; set; }
    
    public List<OrderDetailResponseDto> Items { get; set; } = new();
}

public class OrderDetailResponseDto
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public string ProductCode { get; set; } = string.Empty;
    public string? ProductSize { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal Subtotal { get; set; }
}

public class UpdateOrderStatusDto
{
    public string OrderStatus { get; set; } = string.Empty;
    public string? PaymentStatus { get; set; }
}
