# 🚀 Guía de Inicio Rápido - NobleStep E-commerce

## ⚡ Inicio Rápido (1 minuto)

### Opción 1: Script Automático (Recomendado)
```powershell
.\INICIAR-ECOMMERCE.ps1
```

Este script:
- ✅ Verifica que Node.js y .NET estén instalados
- ✅ Inicia el backend automáticamente (si no está corriendo)
- ✅ Verifica que el puerto 4201 esté disponible
- ✅ Instala dependencias si es necesario
- ✅ Inicia el e-commerce y abre el navegador

### Opción 2: Inicio Manual

#### Paso 1: Iniciar Backend
```powershell
cd backend
dotnet run
```

#### Paso 2: Iniciar E-commerce (en otra terminal)
```powershell
cd frontend
npm install  # Solo la primera vez
npm start -- --project ecommerce --port 4201 --open
```

## 🌐 URLs de Acceso

Una vez iniciado, accede a:

- **🛍️ E-commerce:** http://localhost:4201
- **🔧 Backend API:** http://localhost:5000
- **📚 API Docs:** http://localhost:5000/swagger

## 📋 Requisitos Previos

Antes de iniciar, asegúrate de tener instalado:

1. **Node.js** (v18 o superior)
   - Descarga: https://nodejs.org/
   - Verifica: `node --version`

2. **.NET SDK** (v8.0)
   - Descarga: https://dotnet.microsoft.com/download
   - Verifica: `dotnet --version`

3. **MySQL** (v8.0 o superior)
   - Debe estar corriendo en `localhost:3306`
   - Base de datos: `noblestepdb`

## 🎯 Primera Vez

Si es tu primera vez ejecutando el e-commerce:

1. **Instalar dependencias del frontend:**
   ```powershell
   cd frontend
   npm install
   ```

2. **Verificar que la base de datos esté configurada:**
   - Ejecuta el script de base de datos si no lo has hecho
   - Archivo: `INSTALAR-BASE-DATOS-FINAL.ps1`

3. **Ejecutar el script de inicio:**
   ```powershell
   .\INICIAR-ECOMMERCE.ps1
   ```

## 🔧 Solución de Problemas

### Error: "Puerto 4201 ya está en uso"
```powershell
# Detener el proceso que usa el puerto
netstat -ano | findstr :4201
# Luego terminar el proceso con el PID mostrado
taskkill /PID [número] /F
```

### Error: "Backend no responde"
1. Verifica que MySQL esté corriendo
2. Revisa la configuración en `backend/appsettings.json`
3. Asegúrate que la base de datos existe

### Error: "Module not found"
```powershell
cd frontend
npm install
```

### Error: "Angular CLI not found"
```powershell
npm install -g @angular/cli
```

## 📱 Funcionalidades del E-commerce

Una vez iniciado, podrás:

1. **Ver productos destacados** en la página de inicio
2. **Explorar el catálogo** completo con filtros
3. **Buscar productos** por nombre o marca
4. **Filtrar por categoría** y rango de precio
5. **Ver detalles** de cada producto
6. **Agregar al carrito** productos disponibles
7. **Gestionar el carrito** de compras
8. **Enviar consultas** a través del formulario de contacto

## 🎨 Personalización Rápida

### Cambiar el puerto del e-commerce
En `frontend/angular.json`:
```json
"serve": {
  "options": {
    "port": 4201  // Cambiar aquí
  }
}
```

### Cambiar URL del backend
En `frontend/projects/ecommerce/src/app/services/shop.service.ts`:
```typescript
private apiUrl = 'http://localhost:5000/api/shop';
```

### Cambiar información de contacto
En `frontend/projects/ecommerce/src/app/components/footer/footer.component.ts`

## 📊 Datos de Prueba

El e-commerce mostrará automáticamente:
- ✅ Productos con stock > 0
- ✅ Todas las categorías activas
- ✅ Precios en Soles (S/)
- ✅ Información de stock en tiempo real

## 🔄 Actualizaciones en Vivo

El e-commerce se actualiza automáticamente con:
- Los productos agregados desde el sistema de gestión
- Cambios en el stock
- Nuevas categorías
- Actualizaciones de precios

**Todo en tiempo real** ✨

## 📞 Soporte

Si tienes problemas:
1. Revisa esta guía completa
2. Verifica el archivo `README-ECOMMERCE.md`
3. Consulta los logs en la consola

---

**¡Listo! Tu e-commerce está funcionando** 🎉
