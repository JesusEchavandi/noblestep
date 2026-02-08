# 🚀 Guía Completa de Despliegue - NobleStep

Esta guía te llevará paso a paso para desplegar NobleStep usando **GitHub + Render + Ngrok + Vercel**.

## 📋 Arquitectura de Despliegue

```
┌─────────────────────────────────────────────────────────────┐
│                      STACK DE DESPLIEGUE                    │
├─────────────────────────────────────────────────────────────┤
│  Frontend (E-commerce)  →  Vercel/Netlify (GRATIS)         │
│  Frontend (Admin)       →  Vercel/Netlify (GRATIS)         │
│  Backend (API)          →  Render (GRATIS)                  │
│  Base de Datos (MySQL)  →  Local + Ngrok (GRATIS)          │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 PARTE 1: Preparación Inicial

### 1.1 Verificar Requisitos

Asegúrate de tener instalado:
- ✅ Git
- ✅ Node.js 18+
- ✅ .NET 8.0 SDK
- ✅ MySQL 8.0+
- ✅ Ngrok

### 1.2 Verificar Cuentas Necesarias

Crea cuentas gratuitas en:
- ✅ [GitHub](https://github.com) - Para el código
- ✅ [Render](https://render.com) - Para el backend
- ✅ [Vercel](https://vercel.com) - Para el frontend
- ✅ [Ngrok](https://ngrok.com) - Para exponer MySQL

---

## 🗄️ PARTE 2: Configurar Base de Datos y Ngrok

### 2.1 Instalar la Base de Datos

1. Abre MySQL Workbench o la consola de MySQL:
```bash
mysql -u root -p
```

2. Ejecuta el script de base de datos:
```sql
source database/BASE-DATOS-DEFINITIVA.sql
```

O desde PowerShell:
```powershell
Get-Content database/BASE-DATOS-DEFINITIVA.sql | mysql -u root -p
```

### 2.2 Configurar MySQL para Acceso Remoto

1. Ejecuta el script de configuración:
```sql
source CONFIGURAR-MYSQL-NGROK.sql
```

2. Edita el archivo `my.ini` o `my.cnf` de MySQL:
   - **Windows**: `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`
   - **Linux/Mac**: `/etc/mysql/my.cnf`

3. Busca y cambia:
```ini
bind-address = 127.0.0.1
```
Por:
```ini
bind-address = 0.0.0.0
```

4. Reinicia MySQL:
```powershell
# Windows
Restart-Service MySQL80

# Linux/Mac
sudo systemctl restart mysql
```

### 2.3 Instalar y Configurar Ngrok

1. Descarga Ngrok: https://ngrok.com/download

2. Registra una cuenta y obtén tu token de autenticación

3. Configura Ngrok:
```bash
ngrok config add-authtoken TU_TOKEN_AQUI
```

4. Inicia Ngrok con el script:
```powershell
.\INICIAR-NGROK.ps1
```

5. **IMPORTANTE**: Copia la URL que aparece:
```
tcp://0.tcp.ngrok.io:12345
```

6. **NO CIERRES** esta ventana - Ngrok debe estar corriendo siempre

---

## 🔧 PARTE 3: Desplegar Backend en Render

### 3.1 Preparar el Repositorio en GitHub

1. Asegúrate de que todo esté commiteado:
```bash
git add .
git commit -m "Preparar para despliegue en Render"
git push origin main
```

### 3.2 Crear Servicio en Render

1. Ve a [Render Dashboard](https://dashboard.render.com)

2. Click en **"New +"** → **"Web Service"**

3. Conecta tu repositorio de GitHub: `JesusEchavandi/noblestep-fullstack`

4. Configura el servicio:
   - **Name**: `noblestep-api`
   - **Region**: `Oregon (US West)` o el más cercano
   - **Branch**: `main`
   - **Runtime**: `Docker`
   - **Plan**: `Free`

### 3.3 Configurar Variables de Entorno

En Render, ve a **Environment** y agrega:

```
ConnectionStrings__DefaultConnection
Server=0.tcp.ngrok.io;Port=12345;Database=noblestepdb;User=root;Password=TU_PASSWORD;

JwtSettings__SecretKey
tu-clave-super-secreta-minimo-32-caracteres-muy-segura

JwtSettings__Issuer
NobleStepAPI

JwtSettings__Audience
NobleStepClient

JwtSettings__ExpirationMinutes
1440

App__FrontendUrl
https://tu-ecommerce.vercel.app

ASPNETCORE_ENVIRONMENT
Production
```

**⚠️ IMPORTANTE**: 
- Reemplaza `0.tcp.ngrok.io:12345` con tu URL de Ngrok
- Reemplaza `TU_PASSWORD` con tu contraseña de MySQL
- Reemplaza `tu-clave-super-secreta...` con una clave segura

### 3.4 Deploy

1. Click en **"Create Web Service"**

2. Espera a que termine el build (puede tardar 5-10 minutos)

3. Una vez desplegado, copia tu URL:
```
https://noblestep-api.onrender.com
```

4. Prueba la API:
```
https://noblestep-api.onrender.com/health
```

---

## 🌐 PARTE 4: Desplegar Frontend en Vercel

### 4.1 Configurar Variables de Entorno del Frontend

1. Edita `frontend/projects/ecommerce/src/environments/environment.prod.ts`:
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'
};
```

2. Edita `frontend/src/environments/environment.prod.ts` (para el admin):
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'
};
```

3. Commit y push:
```bash
git add .
git commit -m "Configurar URLs de producción"
git push origin main
```

### 4.2 Desplegar E-commerce en Vercel

1. Ve a [Vercel Dashboard](https://vercel.com/dashboard)

2. Click en **"Add New..."** → **"Project"**

3. Importa tu repositorio de GitHub

4. Configura el proyecto:
   - **Project Name**: `noblestep-ecommerce`
   - **Framework Preset**: `Angular`
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build:ecommerce`
   - **Output Directory**: `dist/ecommerce/browser`

5. Click en **"Deploy"**

6. Espera a que termine (2-5 minutos)

7. Copia tu URL:
```
https://noblestep-ecommerce.vercel.app
```

### 4.3 Desplegar Sistema Admin en Vercel (Opcional)

Repite el proceso pero con:
- **Project Name**: `noblestep-admin`
- **Build Command**: `npm run build`
- **Output Directory**: `dist/browser`

---

## 🔄 PARTE 5: Actualizar URLs Cruzadas

### 5.1 Actualizar Backend con URL del Frontend

1. En Render, actualiza la variable de entorno:
```
App__FrontendUrl = https://noblestep-ecommerce.vercel.app
```

2. Click en **"Manual Deploy"** → **"Deploy latest commit"**

### 5.2 Verificar CORS

El backend ya está configurado para aceptar peticiones del frontend en producción.

---

## ✅ PARTE 6: Verificación Final

### 6.1 Probar el E-commerce

1. Abre: `https://noblestep-ecommerce.vercel.app`

2. Verifica:
   - ✅ Se cargan los productos
   - ✅ Puedes agregar al carrito
   - ✅ Puedes registrarte/iniciar sesión
   - ✅ Puedes hacer un pedido de prueba

### 6.2 Probar el Sistema Admin

1. Abre: `https://noblestep-admin.vercel.app` (si lo desplegaste)

2. Inicia sesión:
   - **Usuario**: `admin`
   - **Contraseña**: `admin123`

3. Verifica:
   - ✅ Dashboard se carga
   - ✅ Productos se listan
   - ✅ Puedes crear/editar productos
   - ✅ Pedidos del e-commerce aparecen

### 6.3 Probar la Conexión a MySQL

En el admin, verifica que los datos se guardan correctamente:
1. Crea un producto nuevo
2. Verifica en tu MySQL local que se guardó
3. Refresca la página - debe aparecer

---

## 🚨 Solución de Problemas Comunes

### Error: "Cannot connect to MySQL"
- ✅ Verifica que Ngrok esté corriendo
- ✅ Verifica que la URL de Ngrok sea correcta en Render
- ✅ Verifica que MySQL esté corriendo localmente

### Error: "CORS policy"
- ✅ Verifica que `App__FrontendUrl` esté configurado correctamente
- ✅ Redeploy del backend después de cambiar variables

### Error: "404 Not Found" en Vercel
- ✅ Verifica que el `Output Directory` sea correcto
- ✅ Verifica que el build command sea correcto

### Render tarda mucho en arrancar
- ✅ Normal en el plan gratuito (puede tardar 1-2 minutos)
- ✅ Después de inactividad, tarda ~30 segundos en despertar

---

## 📝 Mantenimiento

### Mantener Ngrok Corriendo

**Opción 1**: Mantener tu PC encendida con el script `INICIAR-NGROK.ps1`

**Opción 2**: Usar un servidor local siempre encendido (Raspberry Pi, etc.)

**Opción 3** (Recomendado para producción): 
- Migrar a una base de datos en la nube:
  - [PlanetScale](https://planetscale.com) - Gratis hasta 5GB
  - [Railway](https://railway.app) - Gratis $5/mes de crédito
  - [Supabase](https://supabase.com) - Gratis con PostgreSQL

### Actualizar el Sistema

1. Haz cambios en tu código local
2. Commit y push a GitHub:
```bash
git add .
git commit -m "Descripción de cambios"
git push origin main
```
3. Render y Vercel se actualizan automáticamente

---

## 🎉 ¡Listo!

Tu sistema NobleStep está completamente desplegado:

- 🛍️ **E-commerce**: https://noblestep-ecommerce.vercel.app
- 🖥️ **Admin**: https://noblestep-admin.vercel.app
- 🔌 **API**: https://noblestep-api.onrender.com
- 🗄️ **Base de Datos**: MySQL Local + Ngrok

---

## 📞 Soporte

Si tienes problemas:
1. Revisa los logs en Render Dashboard
2. Revisa los logs en Vercel Dashboard
3. Verifica que Ngrok esté corriendo
4. Consulta la documentación de cada servicio
