# 🚀 GUÍA PASO A PASO: RENDER + VERCEL (100% GRATIS)

## 🎯 LO QUE VAS A CONSEGUIR

- ✅ **Backend .NET 8** en Render (gratis)
- ✅ **Frontend Admin** en Vercel (gratis)
- ✅ **Frontend Ecommerce** en Vercel (gratis)
- ✅ **Base de Datos MySQL** en PlanetScale (gratis)
- ✅ **SSL/HTTPS** automático (gratis)
- ✅ **Despliegue automático** con Git
- ✅ **Costo Total: $0/mes permanente**

**Tiempo estimado:** 15-20 minutos ⏱️

---

## ⚠️ LIMITACIONES (Plan Gratuito)

### **Render Free Tier:**
- ✅ 750 horas/mes (suficiente para 1 app 24/7)
- ✅ 512 MB RAM
- ✅ Shared CPU
- ⚠️ **Auto-sleep:** Backend se duerme después de 15 minutos de inactividad
- ⚠️ **Demora al despertar:** 30-60 segundos en el primer request
- ✅ 100 GB bandwidth/mes

### **Vercel Free Tier:**
- ✅ Proyectos ilimitados
- ✅ 100 GB bandwidth/mes
- ✅ Builds ilimitados
- ✅ Sin auto-sleep
- ✅ CDN global

### **PlanetScale Free Tier:**
- ✅ 5 GB almacenamiento
- ✅ 1 billion lecturas/mes
- ✅ 10 millones escrituras/mes
- ✅ 1 base de datos
- ⚠️ Requiere tarjeta de crédito (NO se cobra)

---

## 📋 REQUISITOS PREVIOS

1. **Cuenta GitHub** (crear en https://github.com si no tienes)
2. **Git instalado** en tu computadora
3. **Tu proyecto** listo localmente
4. **Email** para verificar cuentas
5. **Tarjeta de crédito** (solo para PlanetScale, NO se cobra)

---

## 🗂️ PARTE 1: PREPARAR TU PROYECTO PARA GIT

### **Paso 1: Crear repositorio en GitHub**

1. Ve a https://github.com
2. Click en **"New repository"** (botón verde +)
3. Nombre: `noblestep-fullstack`
4. Descripción: `NobleStep - Sistema de Gestión y Ecommerce`
5. **Visibilidad:** Public (o Private si prefieres)
6. ✅ NO marcar "Add README"
7. Click **"Create repository"**

### **Paso 2: Subir tu código a GitHub**

```bash
# Abrir terminal en la carpeta de tu proyecto (donde están backend y frontend)
cd D:/PROYE  # Ajusta a tu ruta

# Inicializar Git (si no está inicializado)
git init

# Crear .gitignore para evitar subir archivos innecesarios
```

**Crear archivo `.gitignore` en la raíz del proyecto:**

```gitignore
# .NET
backend/bin/
backend/obj/
backend/publish/
*.user
*.suo
*.cache

# Angular
frontend/node_modules/
frontend/dist/
frontend/.angular/
frontend/package-lock.json

# Archivos del sistema
.DS_Store
Thumbs.db
*.log

# Variables de entorno sensibles
appsettings.Development.json
.env
.env.local

# Carpetas temporales
tmp/
temp/
CORRIENDO_06_02_2026/
ESPAÑOL/
```

```bash
# Agregar archivos
git add .

# Primer commit
git commit -m "Initial commit: NobleStep project"

# Conectar con GitHub (reemplaza TU_USUARIO)
git remote add origin https://github.com/TU_USUARIO/noblestep-fullstack.git

# Subir código
git branch -M main
git push -u origin main
```

### **Paso 3: Verificar en GitHub**

1. Recarga la página de tu repositorio en GitHub
2. Deberías ver todas las carpetas: `backend/`, `frontend/`, `database/`, etc.

---

## 🗄️ PARTE 2: CONFIGURAR BASE DE DATOS (PLANETSCALE)

### **Paso 1: Crear cuenta en PlanetScale**

1. Ve a https://planetscale.com
2. Click **"Sign up"**
3. Opción más fácil: **"Continue with GitHub"**
4. Autorizar PlanetScale

### **Paso 2: Crear base de datos**

1. Click **"Create a database"**
2. Nombre: `noblestep-db`
3. Región: **AWS / us-east-1** (Virginia - más cercano)
4. Plan: **Hobby** (gratis)
5. Click **"Create database"**

**Espera 1-2 minutos** mientras se crea la base de datos.

### **Paso 3: Obtener credenciales de conexión**

1. En tu base de datos, ve a **"Connect"**
2. Framework: Selecciona **"ASP.NET"**
3. Verás una connection string como:

```
Server=aws.connect.psdb.cloud;Database=noblestep-db;Uid=xxxxxxxxx;Pwd=pscale_pw_xxxxxxxxx;SslMode=VerifyFull
```

**⚠️ GUARDA ESTO - lo necesitarás después**

### **Paso 4: Importar tu base de datos**

**Opción A: Usar PlanetScale CLI (Recomendado)**

```bash
# Instalar PlanetScale CLI
# Windows (con Scoop):
scoop install planetscale

# macOS:
brew install planetscale/tap/pscale

# Autenticar
pscale auth login

# Conectar a la base de datos
pscale connect noblestep-db main --port 3309

# En otra terminal, importar
mysql -h 127.0.0.1 -P 3309 -u root < database/BD_FINAL.sql
```

**Opción B: Usar interfaz web (Más fácil)**

1. En PlanetScale, ve a **"Console"**
2. Ejecuta manualmente las queries importantes:

```sql
-- Crear tabla Products (ejemplo)
CREATE TABLE Products (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  Code VARCHAR(50),
  Name VARCHAR(200),
  Brand VARCHAR(100),
  CategoryId INT,
  Size VARCHAR(50),
  Price DECIMAL(10,2),
  Stock INT,
  Description TEXT,
  IsActive BOOLEAN,
  CreatedAt DATETIME,
  UpdatedAt DATETIME
);

-- Insertar productos de prueba
INSERT INTO Products (Code, Name, Brand, CategoryId, Size, Price, Stock, Description, IsActive, CreatedAt, UpdatedAt)
VALUES ('PROD-001', 'Zapatilla Nike', 'Nike', 1, '42', 299.99, 10, 'Zapatilla deportiva', 1, NOW(), NOW());

-- Repite para todas tus tablas...
```

**Opción C: Migrar desde tu MySQL local (Más rápido)**

```bash
# Exportar desde tu MySQL local
mysqldump -u root noblestep_db > noblestep_export.sql

# Conectar a PlanetScale con proxy
pscale connect noblestep-db main --port 3309

# Importar
mysql -h 127.0.0.1 -P 3309 -u root < noblestep_export.sql
```

---

## 🖥️ PARTE 3: DESPLEGAR BACKEND EN RENDER

### **Paso 1: Crear cuenta en Render**

1. Ve a https://render.com
2. Click **"Get Started"**
3. **"Sign up with GitHub"** (más fácil)
4. Autorizar Render

### **Paso 2: Preparar configuración del Backend**

**Crear archivo `render.yaml` en la raíz de tu proyecto:**

```yaml
services:
  - type: web
    name: noblestep-api
    env: dotnet
    region: oregon
    plan: free
    buildCommand: dotnet publish backend/NobleStep.Api.csproj -c Release -o publish
    startCommand: cd publish && dotnet NobleStep.Api.dll
    envVars:
      - key: ASPNETCORE_ENVIRONMENT
        value: Production
      - key: ASPNETCORE_URLS
        value: http://0.0.0.0:10000
      - key: ConnectionStrings__DefaultConnection
        sync: false
```

**Actualizar `backend/appsettings.json`:**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=noblestep_db;User=root;Password=root;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "Jwt": {
    "Key": "TU_CLAVE_SECRETA_MUY_LARGA_MINIMO_32_CARACTERES_AQUI",
    "Issuer": "NobleStep",
    "Audience": "NobleStepUsers"
  }
}
```

**Subir cambios a GitHub:**

```bash
git add .
git commit -m "Add Render configuration"
git push
```

### **Paso 3: Crear servicio en Render**

1. En Render Dashboard, click **"New +"** → **"Web Service"**
2. **"Connect a repository"** → Selecciona `noblestep-fullstack`
3. Render detectará el `render.yaml` automáticamente
4. Click **"Apply"**

### **Paso 4: Configurar variables de entorno**

1. En tu servicio, ve a **"Environment"**
2. Click **"Add Environment Variable"**

```
Key: ConnectionStrings__DefaultConnection
Value: Server=aws.connect.psdb.cloud;Database=noblestep-db;Uid=xxxxxxxxx;Pwd=pscale_pw_xxxxxxxxx;SslMode=VerifyFull

Key: Jwt__Key
Value: TU_CLAVE_SECRETA_MUY_LARGA_MINIMO_32_CARACTERES_AQUI
```

3. Click **"Save Changes"**

### **Paso 5: Desplegar**

1. Render iniciará el build automáticamente
2. Espera 5-10 minutos (primera vez tarda más)
3. Cuando veas **"Live"** en verde, está listo 🎉
4. Tu URL será: `https://noblestep-api.onrender.com`

### **Paso 6: Probar el backend**

```bash
# Probar endpoint
curl https://noblestep-api.onrender.com/api/products
```

⚠️ **Recuerda:** El backend se duerme después de 15 minutos. El primer request tardará 30-60s.

---

## 🎨 PARTE 4: DESPLEGAR FRONTEND ADMIN EN VERCEL

### **Paso 1: Crear cuenta en Vercel**

1. Ve a https://vercel.com
2. Click **"Sign Up"**
3. **"Continue with GitHub"**
4. Autorizar Vercel

### **Paso 2: Preparar el Frontend Admin**

**Actualizar `frontend/src/environments/environment.ts`:**

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'
};
```

**Crear `vercel.json` en `frontend/`:**

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist/noblestep-web/browser",
  "framework": "angular",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

**Subir cambios:**

```bash
git add .
git commit -m "Configure frontend for Vercel"
git push
```

### **Paso 3: Importar proyecto a Vercel**

1. En Vercel Dashboard, click **"Add New..."** → **"Project"**
2. **"Import Git Repository"**
3. Selecciona `noblestep-fullstack`
4. Click **"Import"**

### **Paso 4: Configurar el proyecto**

```
Project Name: noblestep-admin
Framework Preset: Angular
Root Directory: frontend
Build Command: npm run build
Output Directory: dist/noblestep-web/browser
Install Command: npm install
```

### **Paso 5: Variables de entorno (Opcional)**

Si necesitas variables:

```
Name: API_URL
Value: https://noblestep-api.onrender.com/api
```

### **Paso 6: Desplegar**

1. Click **"Deploy"**
2. Espera 2-3 minutos
3. Cuando veas **"Congratulations!"**, está listo 🎉
4. Tu URL será: `https://noblestep-admin.vercel.app`

---

## 🛒 PARTE 5: DESPLEGAR FRONTEND ECOMMERCE EN VERCEL

### **Paso 1: Preparar el Frontend Ecommerce**

**Actualizar `frontend/projects/ecommerce/src/environments/environment.ts`:**

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://noblestep-api.onrender.com/api'
};
```

**Crear `vercel.json` en `frontend/projects/ecommerce/`:**

```json
{
  "buildCommand": "npm run build:ecommerce",
  "outputDirectory": "dist/ecommerce/browser",
  "framework": "angular",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

**Subir cambios:**

```bash
git add .
git commit -m "Configure ecommerce for Vercel"
git push
```

### **Paso 2: Crear nuevo proyecto en Vercel**

1. En Vercel Dashboard, click **"Add New..."** → **"Project"**
2. Selecciona nuevamente `noblestep-fullstack`
3. Click **"Import"**

### **Paso 3: Configurar el proyecto**

```
Project Name: noblestep-shop
Framework Preset: Angular
Root Directory: frontend
Build Command: npm run build:ecommerce
Output Directory: dist/ecommerce/browser
Install Command: npm install
```

### **Paso 4: Desplegar**

1. Click **"Deploy"**
2. Espera 2-3 minutos
3. Tu URL será: `https://noblestep-shop.vercel.app`

---

## 🔧 PARTE 6: CONFIGURAR CORS EN EL BACKEND

**Editar `backend/Program.cs`:**

```csharp
var builder = WebApplication.CreateBuilder(args);

// Agregar CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontends", policy =>
    {
        policy.WithOrigins(
            "https://noblestep-admin.vercel.app",
            "https://noblestep-shop.vercel.app",
            "http://localhost:4200",
            "http://localhost:4201"
        )
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials();
    });
});

// ... resto del código

var app = builder.Build();

// Usar CORS
app.UseCors("AllowFrontends");

// ... resto del código
```

**Subir cambios:**

```bash
git add .
git commit -m "Configure CORS for production"
git push
```

Render redesplegará automáticamente (2-3 minutos).

---

## ✅ PARTE 7: VERIFICAR QUE TODO FUNCIONE

### **Checklist:**

- [ ] Backend en Render: `https://noblestep-api.onrender.com/api/products`
- [ ] Frontend Admin: `https://noblestep-admin.vercel.app`
- [ ] Frontend Ecommerce: `https://noblestep-shop.vercel.app`
- [ ] Base de datos en PlanetScale con productos
- [ ] CORS configurado correctamente
- [ ] Login funciona en ambos frontends
- [ ] Productos se muestran en ecommerce

### **Probar:**

1. **Backend API:**
```bash
curl https://noblestep-api.onrender.com/api/products
```

2. **Frontend Admin:**
- Ir a `https://noblestep-admin.vercel.app`
- Login con usuario: `admin` / contraseña: `admin123`
- Verificar que carguen datos

3. **Frontend Ecommerce:**
- Ir a `https://noblestep-shop.vercel.app`
- Verificar que se muestren productos
- Probar agregar al carrito

---

## 🔄 PARTE 8: CONFIGURAR DEPLOYS AUTOMÁTICOS

**¡Ya está configurado!** 🎉

Cada vez que hagas `git push`, automáticamente:
- ✅ Render redespliegará el backend
- ✅ Vercel redespliegará ambos frontends

```bash
# Hacer cambios en tu código
# ...

# Subir cambios
git add .
git commit -m "Fix: corregir bug en login"
git push

# Espera 2-3 minutos y tus cambios estarán en producción
```

---

## 🌐 PARTE 9: CONFIGURAR DOMINIO PERSONALIZADO (OPCIONAL)

### **Si tienes un dominio (ej: noblestep.com):**

#### **En Vercel (Frontend Admin):**

1. En tu proyecto → **"Settings"** → **"Domains"**
2. Agregar: `admin.noblestep.com`
3. Configurar DNS según instrucciones de Vercel

#### **En Vercel (Frontend Ecommerce):**

1. En tu proyecto → **"Settings"** → **"Domains"**
2. Agregar: `shop.noblestep.com` o `noblestep.com`
3. Configurar DNS

#### **En Render (Backend):**

1. En tu servicio → **"Settings"** → **"Custom Domains"**
2. Agregar: `api.noblestep.com`
3. Configurar DNS con CNAME

---

## 📊 PARTE 10: MONITOREO Y MANTENIMIENTO

### **Ver logs del Backend (Render):**

1. En Render Dashboard → Tu servicio
2. Tab **"Logs"**
3. Ver logs en tiempo real

### **Ver logs de Frontends (Vercel):**

1. En Vercel Dashboard → Tu proyecto
2. Tab **"Deployments"**
3. Click en un deployment → **"View Logs"**

### **Redeploy manual:**

**Backend (Render):**
1. En tu servicio → **"Manual Deploy"** → **"Deploy latest commit"**

**Frontend (Vercel):**
1. En tu proyecto → **"Deployments"**
2. Click en el último → **"Redeploy"**

---

## 🆘 TROUBLESHOOTING

### **Problema: Backend tarda mucho en responder**

**Causa:** Auto-sleep (se durmió después de 15 minutos)

**Solución:**
- Primera petición tarda 30-60s (normal en plan gratuito)
- Alternativas:
  - Usar servicio de "keep-alive" (ping cada 14 minutos)
  - Actualizar a plan pagado ($7/mes sin auto-sleep)

**Keep-alive gratis:**
```javascript
// Crear cron-job gratis en cron-job.org
URL: https://noblestep-api.onrender.com/api/health
Intervalo: Cada 14 minutos
```

### **Problema: "502 Bad Gateway" en Render**

**Solución:**
```bash
# Verificar logs en Render
# Común: Error de conexión a base de datos

# Verificar connection string en Environment Variables
# Asegúrate que sea correcta de PlanetScale
```

### **Problema: Frontends no se conectan al backend**

**Solución:**
```typescript
// Verificar environment.ts
apiUrl: 'https://noblestep-api.onrender.com/api'  // Sin "/" al final

// Verificar CORS en backend (Program.cs)
// Debe incluir URLs exactas de Vercel
```

### **Problema: "Failed to build" en Vercel**

**Solución:**
```bash
# Verificar Build Command
npm run build  # Para admin
npm run build:ecommerce  # Para ecommerce

# Verificar Output Directory
dist/noblestep-web/browser  # Admin
dist/ecommerce/browser  # Ecommerce
```

### **Problema: Base de datos PlanetScale sin datos**

**Solución:**
```bash
# Verificar conexión
pscale connect noblestep-db main --port 3309

# Re-importar
mysql -h 127.0.0.1 -P 3309 -u root < database/BD_FINAL.sql

# O usar Console en web de PlanetScale
```

---

## 💰 COSTOS Y LÍMITES

### **Plan Gratuito - Límites:**

**Render:**
- 750 horas/mes (31 días * 24h = suficiente)
- 512 MB RAM
- Auto-sleep después de 15 minutos
- 100 GB bandwidth

**Vercel:**
- Bandwidth: 100 GB/mes
- Builds: Ilimitados
- Proyectos: Ilimitados

**PlanetScale:**
- Almacenamiento: 5 GB
- Lecturas: 1 billion/mes
- Escrituras: 10 millones/mes

### **¿Cuándo actualizar a plan pagado?**

- Si necesitas **sin auto-sleep**: Render Pro $7/mes
- Si superas **100 GB bandwidth**: Vercel Pro $20/mes
- Si necesitas **más de 5 GB BD**: PlanetScale $29/mes

---

## 🎉 ¡FELICIDADES!

**Tu aplicación NobleStep está desplegada en producción GRATIS!**

**URLs Finales:**
- 🛒 **Ecommerce:** https://noblestep-shop.vercel.app
- 🔧 **Admin:** https://noblestep-admin.vercel.app
- 🔌 **API:** https://noblestep-api.onrender.com/api

**Costo:** **$0/mes permanente**

---

## 📚 RECURSOS ADICIONALES

- Render Docs: https://render.com/docs
- Vercel Docs: https://vercel.com/docs
- PlanetScale Docs: https://planetscale.com/docs
- GitHub Actions (CI/CD): https://github.com/features/actions

---

**¿Necesitas ayuda con algún paso?** 😊
