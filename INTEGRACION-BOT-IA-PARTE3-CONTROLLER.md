# 🎮 CONTROLADOR DEL BOT - ChatController

## PASO 2: Crear ChatController con Function Calling

### 2.1 Crear ChatController.cs
```csharp
// backend/Controllers/ChatController.cs
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using NobleStep.Api.Data;
using NobleStep.Api.Services;
using System.Text.Json;

namespace NobleStep.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ChatController : ControllerBase
{
    private readonly AIService _aiService;
    private readonly AppDbContext _context;
    private readonly ILogger<ChatController> _logger;

    public ChatController(AIService aiService, AppDbContext context, ILogger<ChatController> logger)
    {
        _aiService = aiService;
        _context = context;
        _logger = logger;
    }

    [HttpPost("message")]
    public async Task<ActionResult<ChatResponse>> SendMessage([FromBody] ChatRequest request)
    {
        try
        {
            // Construir contexto del sistema
            var systemPrompt = BuildSystemPrompt();
            
            var messages = new List<ChatMessage>
            {
                new ChatMessage { Role = "system", Content = systemPrompt }
            };

            // Agregar historial de conversación
            messages.AddRange(request.History ?? new List<ChatMessage>());
            
            // Agregar mensaje del usuario
            messages.Add(new ChatMessage { Role = "user", Content = request.Message });

            // Detectar intención y ejecutar función si es necesario
            var intent = DetectIntent(request.Message);
            
            string response;
            if (intent != null)
            {
                // Ejecutar función específica
                var functionResult = await ExecuteFunction(intent, request.Message);
                
                // Agregar resultado como contexto para la IA
                messages.Add(new ChatMessage 
                { 
                    Role = "system", 
                    Content = $"Resultado de la consulta: {functionResult}" 
                });
            }

            // Obtener respuesta de la IA
            response = await _aiService.GetChatResponse(request.Message, messages);

            return Ok(new ChatResponse
            {
                Message = response,
                Timestamp = DateTime.Now
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error en chat");
            return StatusCode(500, new { message = "Error al procesar mensaje" });
        }
    }

    private string BuildSystemPrompt()
    {
        return @"Eres un asistente virtual para NobleStep, una tienda de calzado en Perú.

TU ROL:
- Ayudar a vendedores y clientes con información sobre productos, ventas e inventario
- Responder preguntas sobre el sistema de gestión
- Proporcionar datos de ventas y reportes cuando se soliciten

CAPACIDADES:
- Consultar stock de productos
- Buscar información de clientes
- Obtener métricas de ventas
- Generar reportes básicos
- Responder preguntas sobre políticas de la tienda

REGLAS:
1. Siempre responde en español de Perú
2. Usa moneda en Soles (S/)
3. Sé amable, profesional y conciso
4. Si no tienes información, dilo claramente
5. Sugiere acciones específicas cuando sea apropiado

POLÍTICA DE DEVOLUCIONES:
- 30 días para cambios
- Producto debe estar sin uso y con etiquetas
- Requiere comprobante de compra

HORARIO:
- Lunes a Sábado: 9:00 AM - 8:00 PM
- Domingo: 10:00 AM - 6:00 PM";
    }

    private string? DetectIntent(string message)
    {
        message = message.ToLower();

        // Detección simple de intenciones
        if (message.Contains("stock") || message.Contains("inventario") || message.Contains("hay"))
            return "check_stock";
        
        if (message.Contains("vend") && (message.Contains("hoy") || message.Contains("día")))
            return "sales_today";
        
        if (message.Contains("top") || message.Contains("más vendido"))
            return "top_products";
        
        if (message.Contains("cliente") && message.Contains("buscar"))
            return "search_customer";
        
        if (message.Contains("producto") && (message.Contains("buscar") || message.Contains("mostrar")))
            return "search_products";

        return null;
    }

    private async Task<string> ExecuteFunction(string intent, string message)
    {
        try
        {
            return intent switch
            {
                "check_stock" => await CheckStock(message),
                "sales_today" => await GetSalesToday(),
                "top_products" => await GetTopProducts(),
                "search_customer" => await SearchCustomer(message),
                "search_products" => await SearchProducts(message),
                _ => "No pude ejecutar esa acción."
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error ejecutando función: {intent}");
            return "Error al ejecutar la consulta.";
        }
    }

    private async Task<string> CheckStock(string message)
    {
        // Extraer nombre del producto (simplificado)
        var products = await _context.Products
            .Where(p => p.IsActive)
            .Take(50)
            .ToListAsync();

        var result = new System.Text.StringBuilder();
        result.AppendLine("📦 INVENTARIO ACTUAL:");
        
        foreach (var product in products.Take(10))
        {
            var status = product.Stock > 10 ? "✅" : product.Stock > 0 ? "⚠️" : "❌";
            result.AppendLine($"{status} {product.Name} (Talla {product.Size}): {product.Stock} unidades");
        }

        return result.ToString();
    }

    private async Task<string> GetSalesToday()
    {
        var today = DateTime.Now.Date;
        
        var sales = await _context.Sales
            .Where(s => s.SaleDate.Date == today)
            .ToListAsync();

        var total = sales.Sum(s => s.Total);
        var count = sales.Count;
        var avgTicket = count > 0 ? total / count : 0;

        return $@"💰 VENTAS DE HOY ({today:dd/MM/yyyy}):
- Total vendido: S/ {total:N2}
- Número de ventas: {count}
- Ticket promedio: S/ {avgTicket:N2}";
    }

    private async Task<string> GetTopProducts()
    {
        var sales = await _context.SaleDetails
            .Include(sd => sd.Product)
            .GroupBy(sd => new { sd.ProductId, sd.Product.Name })
            .Select(g => new
            {
                ProductName = g.Key.Name,
                TotalSold = g.Sum(sd => sd.Quantity),
                Revenue = g.Sum(sd => sd.Subtotal)
            })
            .OrderByDescending(x => x.TotalSold)
            .Take(5)
            .ToListAsync();

        var result = new System.Text.StringBuilder();
        result.AppendLine("🏆 TOP 5 PRODUCTOS MÁS VENDIDOS:");
        
        int position = 1;
        foreach (var item in sales)
        {
            result.AppendLine($"{position}. {item.ProductName}: {item.TotalSold} unidades - S/ {item.Revenue:N2}");
            position++;
        }

        return result.ToString();
    }

    private async Task<string> SearchCustomer(string message)
    {
        // Extraer nombre/documento del mensaje (simplificado)
        var customers = await _context.Customers
            .Where(c => c.IsActive)
            .Take(5)
            .ToListAsync();

        if (!customers.Any())
            return "No encontré clientes con ese criterio.";

        var result = new System.Text.StringBuilder();
        result.AppendLine("👥 CLIENTES ENCONTRADOS:");
        
        foreach (var customer in customers)
        {
            result.AppendLine($"- {customer.FullName} (DNI: {customer.DocumentNumber}) - {customer.Phone}");
        }

        return result.ToString();
    }

    private async Task<string> SearchProducts(string message)
    {
        var products = await _context.Products
            .Include(p => p.Category)
            .Where(p => p.IsActive)
            .Take(10)
            .ToListAsync();

        if (!products.Any())
            return "No encontré productos disponibles.";

        var result = new System.Text.StringBuilder();
        result.AppendLine("👟 PRODUCTOS DISPONIBLES:");
        
        foreach (var product in products)
        {
            result.AppendLine($"- {product.Name} {product.Brand} (Talla {product.Size}) - S/ {product.Price:N2} - Stock: {product.Stock}");
        }

        return result.ToString();
    }
}

public class ChatRequest
{
    public string Message { get; set; } = "";
    public List<ChatMessage>? History { get; set; }
}

public class ChatResponse
{
    public string Message { get; set; } = "";
    public DateTime Timestamp { get; set; }
}
```

## 2.2 Modelo de Conversación en BD (Opcional)

```sql
CREATE TABLE ChatConversations (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NOT NULL,
    StartDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    LastMessageDate DATETIME NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

CREATE TABLE ChatMessages (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ConversationId INT NOT NULL,
    Role VARCHAR(20) NOT NULL, -- 'user' or 'assistant'
    Content TEXT NOT NULL,
    Timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ConversationId) REFERENCES ChatConversations(Id) ON DELETE CASCADE
);
```
