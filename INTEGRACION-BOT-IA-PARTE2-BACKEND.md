# 🔧 IMPLEMENTACIÓN BACKEND - BOT DE IA

## PASO 1: Crear Servicio de IA

### 1.1 Instalar Paquete NuGet
```bash
cd backend
dotnet add package Azure.AI.OpenAI --version 1.0.0-beta.12
# O usar directamente HTTP client para OpenAI API
```

### 1.2 Crear AIService.cs
```csharp
// backend/Services/AIService.cs
using System.Text.Json;
using Microsoft.Extensions.Options;

namespace NobleStep.Api.Services;

public class AIService
{
    private readonly HttpClient _httpClient;
    private readonly string _apiKey;
    private readonly ILogger<AIService> _logger;

    public AIService(HttpClient httpClient, IConfiguration config, ILogger<AIService> logger)
    {
        _httpClient = httpClient;
        _apiKey = config["OpenAI:ApiKey"] ?? throw new ArgumentNullException("OpenAI:ApiKey");
        _logger = logger;
    }

    public async Task<string> GetChatResponse(string userMessage, List<ChatMessage> conversationHistory)
    {
        var request = new
        {
            model = "gpt-4-turbo-preview",
            messages = conversationHistory.Select(m => new { role = m.Role, content = m.Content }).ToList(),
            temperature = 0.7,
            max_tokens = 500
        };

        _httpClient.DefaultRequestHeaders.Authorization = 
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", _apiKey);

        var response = await _httpClient.PostAsJsonAsync(
            "https://api.openai.com/v1/chat/completions", 
            request
        );

        if (!response.IsSuccessStatusCode)
        {
            _logger.LogError($"OpenAI API error: {response.StatusCode}");
            throw new Exception("Error al comunicarse con OpenAI");
        }

        var result = await response.Content.ReadFromJsonAsync<OpenAIResponse>();
        return result?.Choices?.FirstOrDefault()?.Message?.Content ?? "Lo siento, no pude procesar tu solicitud.";
    }
}

public class ChatMessage
{
    public string Role { get; set; } = "user"; // system, user, assistant
    public string Content { get; set; } = "";
}

public class OpenAIResponse
{
    public List<OpenAIChoice> Choices { get; set; } = new();
}

public class OpenAIChoice
{
    public OpenAIMessage Message { get; set; } = new();
}

public class OpenAIMessage
{
    public string Content { get; set; } = "";
}
```

### 1.3 Registrar Servicio
```csharp
// Program.cs
builder.Services.AddHttpClient<AIService>();
builder.Services.AddScoped<AIService>();
```

### 1.4 Agregar Configuración
```json
// appsettings.json
{
  "OpenAI": {
    "ApiKey": "sk-tu-api-key-aqui"
  }
}
```
