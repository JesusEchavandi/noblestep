# 🔍 DIAGNÓSTICO: Dashboard No Carga Datos

## ✅ Problemas Identificados y Solucionados

### 1. Backend - Código Correcto ✓
- **DashboardController.cs**: Todos los endpoints implementados correctamente
- **DashboardDto.cs**: DTOs bien definidos
- **Endpoints disponibles**:
  - `GET /api/dashboard/metrics` - Métricas generales
  - `GET /api/dashboard/sales-chart` - Datos de gráficos
  - `GET /api/dashboard/top-products` - Top productos
  - `GET /api/dashboard/low-stock` - Productos con bajo stock
  - `GET /api/dashboard/recent-sales` - Ventas recientes

### 2. Frontend - Configuración Correcta ✓
- **dashboard.service.ts**: URLs correctas apuntando a `localhost:5062`
- **dashboard.component.ts**: Implementación correcta con gráficos Chart.js
- **Autenticación**: Token JWT en interceptor

### 3. Base de Datos - Tablas Verificadas ✓
- ✓ Tabla `Users` existe
- ✓ Tabla `Products` existe
- ✓ Tabla `Sales` existe
- ✓ Tabla `SaleDetails` existe
- ✓ Tabla `Customers` existe
- ✓ Tabla `Suppliers` existe
- ✓ Tabla `Purchases` existe
- ✓ Tabla `PurchaseDetails` existe

## ⚠️ Problema Principal: Inicio del Backend

El backend necesita iniciarse correctamente en un proceso separado para que el frontend pueda conectarse.

### Síntomas:
- Login funciona cuando el backend está corriendo
- Dashboard no carga datos cuando el backend no responde
- Error: "No es posible conectar con el servidor remoto"

## ✅ Solución Implementada

### Archivo Creado: `INICIAR-SISTEMA-COMPLETO.ps1`

Este script:
1. ✓ Limpia procesos anteriores
2. ✓ Verifica la base de datos
3. ✓ Inicia el backend en ventana separada
4. ✓ Espera y verifica que el backend responda
5. ✓ Inicia el frontend en ventana separada
6. ✓ Proporciona instrucciones claras

## 🚀 Cómo Usar el Sistema

### Paso 1: Iniciar el Sistema
```powershell
.\INICIAR-SISTEMA-COMPLETO.ps1
```

Este script abrirá **DOS ventanas**:
- **Ventana 1**: Backend (puerto 5062)
- **Ventana 2**: Frontend (puerto 4200)

### Paso 2: Esperar
- Backend: ~10 segundos
- Frontend: ~30-60 segundos (verás "Compiled successfully!")

### Paso 3: Acceder
1. Abre: http://localhost:4200
2. Login: `admin` / `admin123`
3. El dashboard cargará automáticamente con todos los datos

## 📊 Endpoints del Dashboard

### 1. Métricas Generales
```http
GET /api/dashboard/metrics
Authorization: Bearer {token}
```

**Respuesta:**
```json
{
  "totalSales": 0,
  "totalSalesCount": 0,
  "todaySales": 0,
  "todaySalesCount": 0,
  "monthSales": 0,
  "monthSalesCount": 0,
  "totalProducts": 8,
  "activeProducts": 8,
  "lowStockProducts": 0,
  "totalCustomers": 4,
  "totalSuppliers": 3,
  "totalPurchases": 0,
  "totalPurchasesCount": 0,
  "averageSaleAmount": 0
}
```

### 2. Gráfico de Ventas
```http
GET /api/dashboard/sales-chart
Authorization: Bearer {token}
```

**Respuesta:**
```json
{
  "last7Days": [
    {
      "date": "2026-02-02T00:00:00",
      "total": 0,
      "count": 0
    }
  ],
  "last6Months": [
    {
      "year": 2025,
      "month": 9,
      "monthName": "septiembre",
      "total": 0,
      "count": 0
    }
  ]
}
```

### 3. Top Productos
```http
GET /api/dashboard/top-products?limit=5
Authorization: Bearer {token}
```

### 4. Bajo Stock
```http
GET /api/dashboard/low-stock?threshold=10
Authorization: Bearer {token}
```

### 5. Ventas Recientes
```http
GET /api/dashboard/recent-sales?limit=10
Authorization: Bearer {token}
```

## 🐛 Debugging

### Si el Dashboard No Carga:

1. **Verificar Backend**
   - Revisa la ventana del backend
   - Debe decir: "Now listening on: http://localhost:5062"
   - Prueba: http://localhost:5062 (debe abrir Swagger)

2. **Verificar Frontend**
   - Revisa la ventana del frontend
   - Debe decir: "✔ Compiled successfully!"
   - Abre consola del navegador (F12) para ver errores

3. **Verificar Autenticación**
   - Asegúrate de hacer login correctamente
   - El token JWT debe guardarse en localStorage
   - Abre DevTools > Application > Local Storage

4. **Verificar Red**
   - Abre DevTools > Network
   - Filtra por "dashboard"
   - Verifica que las peticiones se hagan con status 200

### Errores Comunes:

| Error | Causa | Solución |
|-------|-------|----------|
| `No es posible conectar` | Backend no está corriendo | Ejecuta `INICIAR-SISTEMA-COMPLETO.ps1` |
| `401 Unauthorized` | Token inválido/expirado | Vuelve a hacer login |
| `404 Not Found` | Endpoint incorrecto | Verifica la URL en dashboard.service.ts |
| `CORS Error` | CORS mal configurado | Verifica Program.cs (ya está OK) |

## 📝 Datos de Prueba

La base de datos incluye:
- ✓ 2 Usuarios (admin, seller1)
- ✓ 4 Categorías
- ✓ 8 Productos
- ✓ 4 Clientes
- ✓ 3 Proveedores

**Para generar datos de ventas y ver el dashboard con información:**
1. Inicia sesión
2. Ve a "Ventas" > "Nueva Venta"
3. Crea algunas ventas de prueba
4. Regresa al Dashboard
5. Los datos se mostrarán en los gráficos

## ✅ Conclusión

**Backend**: ✓ Código correcto, sin errores  
**Frontend**: ✓ Código correcto, configuración OK  
**Base de Datos**: ✓ Estructura completa  
**Problema**: ⚠️ Inicio del backend en proceso separado

**Solución**: Usar `INICIAR-SISTEMA-COMPLETO.ps1` para iniciar todo correctamente.
