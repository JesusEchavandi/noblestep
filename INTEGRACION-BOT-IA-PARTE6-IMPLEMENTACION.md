# 🚀 GUÍA DE IMPLEMENTACIÓN COMPLETA

## PASO A PASO PARA INTEGRAR EL BOT

### 📋 CHECKLIST DE IMPLEMENTACIÓN

#### Día 1: Backend Base
- [ ] Instalar paquete OpenAI
- [ ] Crear AIService.cs
- [ ] Crear ChatController.cs
- [ ] Agregar configuración OpenAI en appsettings.json
- [ ] Registrar servicios en Program.cs
- [ ] Probar endpoint con Postman

#### Día 2: Funciones del Bot
- [ ] Implementar función check_stock
- [ ] Implementar función sales_today
- [ ] Implementar función top_products
- [ ] Implementar función search_customer
- [ ] Implementar función search_products
- [ ] Probar cada función individualmente

#### Día 3: Frontend
- [ ] Crear ChatService
- [ ] Crear ChatComponent
- [ ] Implementar UI del chat
- [ ] Agregar estilos CSS
- [ ] Integrar en MainLayoutComponent

#### Día 4: Optimizaciones
- [ ] Agregar manejo de errores
- [ ] Implementar historial de conversación
- [ ] Agregar loading states
- [ ] Mejorar detección de intenciones
- [ ] Testing de UI

#### Día 5: Pulido y Deploy
- [ ] Testing end-to-end
- [ ] Ajustar prompts del sistema
- [ ] Documentar uso
- [ ] Deploy a producción

---

## 🔑 OBTENER API KEY DE OPENAI

### Paso 1: Crear cuenta en OpenAI
```
1. Ve a: https://platform.openai.com/signup
2. Crea una cuenta (puedes usar Google)
3. Verifica tu email
```

### Paso 2: Agregar método de pago
```
1. Ve a: https://platform.openai.com/account/billing
2. Agrega una tarjeta de crédito
3. Configura límites de gasto (recomendado: $10/mes para empezar)
```

### Paso 3: Generar API Key
```
1. Ve a: https://platform.openai.com/api-keys
2. Click en "Create new secret key"
3. Copia la key (empieza con "sk-...")
4. Guárdala de forma segura (no se podrá ver de nuevo)
```

### Paso 4: Configurar en tu proyecto
```json
// appsettings.json
{
  "OpenAI": {
    "ApiKey": "sk-tu-key-aqui"
  }
}

// appsettings.Development.json (para desarrollo)
{
  "OpenAI": {
    "ApiKey": "sk-tu-key-de-desarrollo"
  }
}
```

**⚠️ IMPORTANTE:** Nunca subas tu API key a GitHub. Agrégala a `.gitignore`

---

## 💰 COSTOS ESTIMADOS

### Modelo GPT-4-Turbo (Recomendado)
```
Input: $0.01 por 1K tokens
Output: $0.03 por 1K tokens

Ejemplo real:
- Mensaje usuario: ~50 tokens
- Respuesta bot: ~150 tokens
- Contexto sistema: ~100 tokens
Total por mensaje: ~300 tokens = $0.009 (menos de 1 centavo)

Para 1000 mensajes/mes: ~$9
```

### Modelo GPT-3.5-Turbo (Más económico)
```
Input: $0.0005 por 1K tokens
Output: $0.0015 por 1K tokens

Para 1000 mensajes/mes: ~$0.60
```

### Recomendación:
- **Desarrollo**: GPT-3.5-Turbo
- **Producción**: GPT-4-Turbo (mejor calidad)

---

## 🧪 TESTING

### Test 1: Probar Backend con Postman

```http
POST http://localhost:5062/api/chat/message
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json

{
  "message": "¿Cuánto vendimos hoy?",
  "history": []
}
```

**Respuesta esperada:**
```json
{
  "message": "💰 VENTAS DE HOY (02/02/2026):\n- Total vendido: S/ 1,425.00\n- Número de ventas: 3\n- Ticket promedio: S/ 475.00",
  "timestamp": "2026-02-02T17:45:00"
}
```

### Test 2: Probar Funciones Específicas

```javascript
// Test en navegador (Console)
const testMessages = [
  "¿Cuánto vendimos hoy?",
  "Muéstrame el top 5 de productos",
  "¿Hay stock de Air Max?",
  "¿Cómo hago una devolución?",
  "Buscar cliente Juan Pérez"
];

testMessages.forEach(msg => {
  fetch('http://localhost:5062/api/chat/message', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + localStorage.getItem('token')
    },
    body: JSON.stringify({ message: msg, history: [] })
  })
  .then(r => r.json())
  .then(data => console.log(msg, '→', data.message));
});
```

---

## 🎯 INTEGRACIÓN EN EL LAYOUT

### Agregar el chat al MainLayoutComponent

```typescript
// frontend/src/app/layout/main-layout.component.ts
import { ChatComponent } from '../chat/chat.component';

@Component({
  // ...
  imports: [
    // ... otros imports
    ChatComponent
  ]
})
```

```html
<!-- frontend/src/app/layout/main-layout.component.html -->
<div class="main-layout">
  <!-- Navbar -->
  <nav>...</nav>
  
  <!-- Sidebar -->
  <aside>...</aside>
  
  <!-- Main content -->
  <main>
    <router-outlet></router-outlet>
  </main>
  
  <!-- Bot de IA (siempre visible) -->
  <app-chat></app-chat>
</div>
```

---

## 🔒 SEGURIDAD

### 1. Proteger la API Key
```csharp
// Usar User Secrets en desarrollo
dotnet user-secrets init
dotnet user-secrets set "OpenAI:ApiKey" "sk-tu-key-aqui"
```

### 2. Limitar Uso por Usuario
```csharp
// Implementar rate limiting
[RateLimit(PermitLimit = 10, Window = "00:01:00")] // 10 mensajes por minuto
public async Task<ActionResult<ChatResponse>> SendMessage()
```

### 3. Validar Entrada
```csharp
// Sanitizar input del usuario
if (request.Message.Length > 500)
    return BadRequest("Mensaje muy largo");

if (string.IsNullOrWhiteSpace(request.Message))
    return BadRequest("Mensaje vacío");
```

### 4. No exponer datos sensibles
```csharp
// Filtrar información confidencial
private string SanitizeOutput(string response)
{
    // Ocultar números de tarjeta, contraseñas, etc.
    return response;
}
```

---

## 📊 MÉTRICAS Y MONITOREO

### Agregar logging de conversaciones
```csharp
public async Task<ActionResult<ChatResponse>> SendMessage([FromBody] ChatRequest request)
{
    // Log de uso
    _logger.LogInformation($"Chat message from user {userId}: {request.Message}");
    
    // Guardar en BD para análisis
    await SaveChatMetrics(userId, request.Message, response);
}

private async Task SaveChatMetrics(int userId, string question, string answer)
{
    var metric = new ChatMetric
    {
        UserId = userId,
        Question = question,
        Answer = answer,
        Timestamp = DateTime.Now,
        TokensUsed = EstimateTokens(question + answer)
    };
    
    _context.ChatMetrics.Add(metric);
    await _context.SaveChangesAsync();
}
```

### Dashboard de métricas del bot
```sql
-- Consultas útiles
-- Preguntas más frecuentes
SELECT Question, COUNT(*) as Frequency
FROM ChatMetrics
GROUP BY Question
ORDER BY Frequency DESC
LIMIT 10;

-- Uso por usuario
SELECT u.Username, COUNT(*) as MessagesCount
FROM ChatMetrics cm
JOIN Users u ON cm.UserId = u.Id
GROUP BY u.Username;

-- Costo estimado
SELECT 
  DATE(Timestamp) as Date,
  SUM(TokensUsed) as TotalTokens,
  (SUM(TokensUsed) / 1000.0) * 0.03 as EstimatedCost
FROM ChatMetrics
GROUP BY DATE(Timestamp);
```

---

## 🎨 PERSONALIZACIONES AVANZADAS

### 1. Agregar Comandos Especiales
```typescript
// Frontend: Detectar comandos
if (message.startsWith('/')) {
  this.handleCommand(message);
  return;
}

handleCommand(cmd: string) {
  const parts = cmd.split(' ');
  switch(parts[0]) {
    case '/help':
      this.showHelp();
      break;
    case '/clear':
      this.clearChat();
      break;
    case '/export':
      this.exportChat();
      break;
  }
}
```

### 2. Soporte de Voz
```typescript
// Web Speech API
startVoiceInput() {
  const recognition = new (window as any).webkitSpeechRecognition();
  recognition.lang = 'es-PE';
  recognition.onresult = (event: any) => {
    this.userInput = event.results[0][0].transcript;
    this.sendMessage();
  };
  recognition.start();
}

speakResponse(text: string) {
  const utterance = new SpeechSynthesisUtterance(text);
  utterance.lang = 'es-PE';
  window.speechSynthesis.speak(utterance);
}
```

### 3. Sugerencias Inteligentes
```typescript
// Autocompletar basado en historial
getSuggestions(partial: string): string[] {
  const commonQuestions = [
    '¿Cuánto vendimos hoy?',
    'Mostrar top 5 productos',
    '¿Hay stock de ',
    'Buscar cliente ',
    '¿Cuál es la política de devoluciones?'
  ];
  
  return commonQuestions.filter(q => 
    q.toLowerCase().includes(partial.toLowerCase())
  );
}
```

Continúa en siguiente archivo...
