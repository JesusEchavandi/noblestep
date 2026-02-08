# 🚀 Despliegue Rápido - NobleStep

## ✅ Checklist Pre-Despliegue

Antes de comenzar, asegúrate de tener:
- [ ] Cuenta en [GitHub](https://github.com)
- [ ] Cuenta en [Render](https://render.com)
- [ ] Cuenta en [Vercel](https://vercel.com)
- [ ] Cuenta en [Ngrok](https://ngrok.com)
- [ ] MySQL corriendo localmente
- [ ] Base de datos instalada (ejecutar `database/BASE-DATOS-DEFINITIVA.sql`)

---

## 📍 PASO 1: Configurar MySQL y Ngrok (10 minutos)

### 1.1 Configurar MySQL para acceso remoto

```bash
# Ejecutar desde MySQL
mysql -u root -p < CONFIGURAR-MYSQL-NGROK.sql
```

### 1.2 Iniciar Ngrok

```powershell
# Ejecutar el script
.\INICIAR-NGROK.ps1
```

**📋 COPIA ESTA URL** (ejemplo):
```
tcp://0.tcp.ngrok.io:12345
```

> ⚠️ **IMPORTANTE**: Mantén esta ventana abierta todo el tiempo

---

## 📍 PASO 2: Subir Código a GitHub (5 minutos)

```bash
# Verificar que estás en la rama main
git branch

# Agregar todos los archivos
git add .

# Hacer commit
git commit -m "Preparar para despliegue"

# Subir a GitHub
git push origin main
```

---

## 📍 PASO 3: Desplegar Backend en Render (15 minutos)

### 3.1 Crear Web Service

1. Ve a: https://dashboard.render.com
2. Click: **New +** → **Web Service**
3. Conecta: Tu repositorio `noblestep-fullstack`
4. Configurar:
   - **Name**: `noblestep-api`
   - **Branch**: `main`
   - **Runtime**: `Docker`
   - **Plan**: `Free`

### 3.2 Variables de Entorno

Agrega estas variables (click en **Add Environment Variable**):

| Key | Value |
|-----|-------|
| `ConnectionStrings__DefaultConnection` | `Server=0.tcp.ngrok.io;Port=12345;Database=noblestepdb;User=root;Password=TU_PASSWORD;` |
| `JwtSettings__SecretKey` | `clave-super-secreta-minimo-32-caracteres-cambiar-en-produccion` |
| `JwtSettings__Issuer` | `NobleStepAPI` |
| `JwtSettings__Audience` | `NobleStepClient` |
| `JwtSettings__ExpirationMinutes` | `1440` |
| `ASPNETCORE_ENVIRONMENT` | `Production` |

> ⚠️ **REEMPLAZA**:
> - `0.tcp.ngrok.io:12345` con tu URL de Ngrok
> - `TU_PASSWORD` con tu contraseña de MySQL

### 3.3 Deploy

1. Click: **Create Web Service**
2. Espera 5-10 minutos
3. **📋 COPIA LA URL**: `https://noblestep-api.onrender.com`

---

## 📍 PASO 4: Configurar URLs del Frontend (5 minutos)

### 4.1 Editar archivo de producción del E-commerce

Archivo: `frontend/projects/ecommerce/src/environments/environment.prod.ts`

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'
};
```

### 4.2 Editar archivo de producción del Admin

Archivo: `frontend/src/environments/environment.prod.ts`

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'
};
```

### 4.3 Subir cambios

```bash
git add .
git commit -m "Configurar API URL de producción"
git push origin main
```

---

## 📍 PASO 5: Desplegar E-commerce en Vercel (10 minutos)

### 5.1 Importar Proyecto

1. Ve a: https://vercel.com/new
2. Click: **Import** en tu repositorio
3. Configurar:

| Campo | Valor |
|-------|-------|
| **Project Name** | `noblestep-ecommerce` |
| **Framework Preset** | `Angular` |
| **Root Directory** | `frontend` |
| **Build Command** | `npm run build:ecommerce` |
| **Output Directory** | `dist/ecommerce/browser` |

### 5.2 Deploy

1. Click: **Deploy**
2. Espera 3-5 minutos
3. **📋 COPIA LA URL**: `https://noblestep-ecommerce.vercel.app`

---

## 📍 PASO 6: Actualizar Backend con URL del Frontend (5 minutos)

### 6.1 En Render Dashboard

1. Ve a tu servicio `noblestep-api`
2. Tab: **Environment**
3. Agregar nueva variable:

| Key | Value |
|-----|-------|
| `App__FrontendUrl` | `https://noblestep-ecommerce.vercel.app` |

### 6.2 Redeploy

1. Click: **Manual Deploy** → **Deploy latest commit**
2. Espera 2-3 minutos

---

## 📍 PASO 7: Desplegar Admin en Vercel (Opcional - 10 minutos)

Repite el **PASO 5** pero con:

| Campo | Valor |
|-------|-------|
| **Project Name** | `noblestep-admin` |
| **Build Command** | `npm run build` |
| **Output Directory** | `dist/browser` |

---

## ✅ PASO 8: Verificación Final

### 8.1 Probar E-commerce

1. Abre: `https://noblestep-ecommerce.vercel.app`
2. Verifica:
   - ✅ Se cargan productos
   - ✅ Carrito funciona
   - ✅ Registro funciona
   - ✅ Login funciona

### 8.2 Probar Admin

1. Abre: `https://noblestep-admin.vercel.app`
2. Login:
   - Usuario: `admin`
   - Password: `admin123`
3. Verifica:
   - ✅ Dashboard carga
   - ✅ Productos se listan
   - ✅ Puedes crear productos

### 8.3 Probar Conexión MySQL

En el admin:
1. Crea un producto nuevo
2. Verifica en MySQL local que se guardó:
```sql
USE noblestepdb;
SELECT * FROM Products ORDER BY Id DESC LIMIT 5;
```

---

## 🎉 ¡LISTO! Tu sistema está desplegado

### URLs Finales:

- 🛍️ **E-commerce**: https://noblestep-ecommerce.vercel.app
- 🖥️ **Admin**: https://noblestep-admin.vercel.app  
- 🔌 **API**: https://noblestep-api.onrender.com

---

## 🚨 Problemas Comunes

### Error: "Cannot connect to database"
- ✅ Verifica que Ngrok esté corriendo
- ✅ Copia la URL correcta de Ngrok a Render
- ✅ Verifica password de MySQL

### Error: "CORS blocked"
- ✅ Verifica `App__FrontendUrl` en Render
- ✅ Redeploy del backend

### Render dice "Build failed"
- ✅ Verifica que Dockerfile esté en la raíz
- ✅ Verifica que el repositorio esté actualizado

### Vercel dice "Build failed"
- ✅ Verifica comandos de build en la configuración
- ✅ Verifica que `frontend/package.json` tenga el script `vercel-build`

---

## 📞 Siguiente Paso

Una vez que todo funcione, considera:
1. Configurar un dominio personalizado
2. Migrar a una base de datos en la nube (PlanetScale, Railway)
3. Configurar email real para recuperación de contraseñas

---

**⏱️ Tiempo Total Estimado**: 50-60 minutos

**💰 Costo Total**: $0 (Todo gratis)
