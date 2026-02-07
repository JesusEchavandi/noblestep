namespace NobleStep.Api.Models;

public class Sale
{
    public int Id { get; set; }
    public int CustomerId { get; set; }
    public int UserId { get; set; }
    public DateTime SaleDate { get; set; } = DateTime.Now;
    public decimal Total { get; set; }
    public string Status { get; set; } = "Completed";
    public DateTime CreatedAt { get; set; } = DateTime.Now;
    
    // Esta propiedad no está en la BD pero se usa en el controlador
    // Se puede ignorar al mapear, o quitar del controlador
    public string? PaymentMethod { get; set; }
    
    // Navigation properties
    public Customer Customer { get; set; } = null!;
    public User User { get; set; } = null!;
    public ICollection<SaleDetail> SaleDetails { get; set; } = new List<SaleDetail>();
}
