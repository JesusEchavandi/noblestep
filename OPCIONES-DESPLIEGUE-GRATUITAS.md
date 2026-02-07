# 💰 OPCIONES DE DESPLIEGUE GRATUITAS Y ECONÓMICAS

## 🎯 OBJETIVO: Desplegar NobleStep con $0 - $5 USD/mes

---

## 🆓 OPCIÓN 1: 100% GRATIS - RENDER + VERCEL + NEON

### **Configuración:**
- **Backend (.NET):** Render (Plan gratuito)
- **Frontend Admin:** Vercel (Gratis)
- **Frontend Ecommerce:** Vercel (Gratis)
- **Base de Datos:** Neon (PostgreSQL gratis) o PlanetScale (MySQL gratis)

### **Características:**
- ✅ **Costo:** $0 USD/mes permanentemente
- ✅ **SSL:** Incluido gratis
- ✅ **Despliegue:** Automático con Git
- ✅ **Límites razonables** para proyectos pequeños-medianos

### **Limitaciones:**
- ⚠️ Backend se "duerme" después de 15 min de inactividad (demora 30-60s en despertar)
- ⚠️ 750 horas/mes de backend (suficiente para 1 instancia 24/7)
- ⚠️ Base de datos: 3GB de almacenamiento (Neon) o 5GB (PlanetScale)
- ⚠️ Ancho de banda limitado: 100GB/mes

### **Servicios Específicos:**

#### **1. Render (Backend .NET)**
- URL: https://render.com
- Plan: Free ($0/mes)
- ✅ 512 MB RAM
- ✅ Shared CPU
- ✅ 750 horas/mes
- ✅ Auto-sleep después de inactividad
- ✅ Deploy automático desde GitHub

#### **2. Vercel (Frontends)**
- URL: https://vercel.com
- Plan: Hobby ($0/mes)
- ✅ Bandwidth: 100GB/mes
- ✅ Builds: Ilimitados
- ✅ Proyectos: Ilimitados
- ✅ SSL automático
- ✅ CDN global

#### **3A. Neon (PostgreSQL - Requiere migrar desde MySQL)**
- URL: https://neon.tech
- Plan: Free ($0/mes)
- ✅ 3GB de almacenamiento
- ✅ 1 proyecto
- ✅ Ramas ilimitadas
- ⚠️ Requiere convertir de MySQL a PostgreSQL

#### **3B. PlanetScale (MySQL - Compatible directo)**
- URL: https://planetscale.com
- Plan: Hobby ($0/mes)
- ✅ 5GB de almacenamiento
- ✅ 1 billion lecturas/mes
- ✅ 10 millones escrituras/mes
- ✅ MySQL compatible (no requiere cambios)
- ⚠️ 1 base de datos por cuenta gratis

### **Pasos para Implementar:**

```bash
# 1. Preparar Backend para Render
# En appsettings.json, usar variable de entorno
"ConnectionStrings": {
  "DefaultConnection": "${DATABASE_URL}"
}

# 2. Crear render.yaml en raíz del proyecto
services:
  - type: web
    name: noblestep-api
    env: dotnet
    buildCommand: dotnet publish -c Release
    startCommand: dotnet bin/Release/net8.0/NobleStep.Api.dll
    envVars:
      - key: ASPNETCORE_ENVIRONMENT
        value: Production
      - key: DATABASE_URL
        fromDatabase:
          name: noblestep_db
          property: connectionString

# 3. Subir a GitHub
git init
git add .
git commit -m "Deploy to Render"
git push origin main

# 4. En Render Dashboard:
# - Conectar repositorio GitHub
# - Seleccionar render.yaml
# - Agregar base de datos PlanetScale

# 5. En Vercel:
# - Importar repo (2 veces, una por frontend)
# - Frontend Admin: dist/noblestep-web
# - Frontend Ecommerce: dist/ecommerce
# - Variables de entorno: API_URL = https://noblestep-api.onrender.com
```

### **Resultado:**
- ✅ Backend: https://tu-api.onrender.com
- ✅ Admin: https://tu-admin.vercel.app
- ✅ Ecommerce: https://tu-tienda.vercel.app
- ✅ Costo total: **$0/mes**

---

## 🆓 OPCIÓN 2: GRATIS CON NETLIFY + RAILWAY

### **Configuración:**
- **Backend + DB:** Railway (Plan gratuito - $5 crédito/mes)
- **Frontends:** Netlify (Gratis)

### **Características:**
- ✅ **Costo:** $0-2 USD/mes (depende del uso)
- ✅ **Railway:** $5 USD de crédito mensual gratis
- ✅ **Sin auto-sleep** en Railway
- ✅ **MySQL nativo** (no requiere migración)

### **Railway - Plan Gratis:**
- $5 USD de crédito mensual
- Uso típico: $2-4/mes para tu proyecto
- Si usas todo el crédito: proyecto se pausa hasta próximo mes
- Sin tarjeta de crédito requerida

### **Netlify - Plan Gratis:**
- 100GB bandwidth/mes
- 300 minutos de build/mes
- Formularios: 100 submissions/mes
- ✅ Ideal para frontends Angular

### **Pasos:**

```bash
# 1. Railway
# - Crear cuenta en railway.app
# - New Project → Deploy from GitHub
# - Seleccionar repo backend
# - Agregar MySQL database
# - Variables de entorno automáticas

# 2. Netlify
# - Conectar GitHub repo
# - Build command: npm run build
# - Publish directory: dist/noblestep-web
# - Repetir para ecommerce
```

### **Resultado:**
- ✅ Backend: https://tu-api.railway.app
- ✅ Admin: https://tu-admin.netlify.app
- ✅ Ecommerce: https://tu-tienda.netlify.app
- ✅ Costo: **$0-2/mes** (dentro del crédito gratis)

---

## 💵 OPCIÓN 3: CASI GRATIS - ORACLE CLOUD (Always Free)

### **Configuración:**
- **Todo en Oracle Cloud Always Free Tier**

### **Características:**
- ✅ **Costo:** $0 USD/mes PERMANENTEMENTE
- ✅ **Recursos generosos:** 1-4 vCPUs, 1-24GB RAM
- ✅ **2 VMs gratuitas** (Ampere ARM)
- ✅ **200GB storage**
- ✅ **10TB bandwidth/mes**
- ✅ **MySQL Database gratis**

### **Oracle Always Free Tier Incluye:**
- 2 AMD Compute VMs (1GB RAM cada una)
- O 4 Arm-based Ampere A1 cores y 24GB RAM
- 2 Block Volumes (100GB total)
- 10GB Object Storage
- Autonomous Database (2 instancias)
- Load Balancer

### **Lo que puedes hacer:**
```
VM1 (Ampere): 
├── Backend .NET 8
├── MySQL 8.0
├── Nginx
└── Frontend Admin + Ecommerce (servidos por Nginx)

Todo en 1 servidor con recursos suficientes
```

### **Complejidad:** ⭐⭐⭐⭐ (Requiere conocimiento de Linux)

### **Pasos:**
1. Crear cuenta Oracle Cloud (requiere tarjeta pero NO se cobra)
2. Crear VM Ampere (ARM64)
3. Instalar Ubuntu 22.04
4. Configurar .NET, MySQL, Nginx
5. Desplegar aplicación

### **Resultado:**
- ✅ Todo en tu propio servidor
- ✅ IP pública gratis
- ✅ Costo: **$0/mes PARA SIEMPRE**
- ⚠️ Requiere mantener actividad (crear recursos cada 60 días)

---

## 💵 OPCIÓN 4: FLY.IO - $0-3/mes

### **Configuración:**
- **Backend:** Fly.io (Plan gratis)
- **Frontends:** Cloudflare Pages (Gratis)
- **Base de Datos:** Fly.io PostgreSQL o Supabase (Gratis)

### **Fly.io - Plan Gratis Incluye:**
- 3 VMs compartidas (256MB RAM cada una)
- 3GB almacenamiento persistente
- 160GB bandwidth/mes
- SSL incluido

### **Cloudflare Pages - Gratis:**
- Builds ilimitados
- Bandwidth ilimitado
- 500 builds/mes
- Workers gratis (100k requests/día)

### **Características:**
- ✅ **Costo:** $0-3 USD/mes
- ✅ **Sin auto-sleep**
- ✅ **Excelente performance**
- ✅ **Deploy con flyctl CLI**

### **Resultado:**
- ✅ Backend: https://tu-api.fly.dev
- ✅ Frontends: https://tu-admin.pages.dev
- ✅ Costo: **$0-3/mes**

---

## 💵 OPCIÓN 5: KOYEB - $0-5/mes

### **Configuración:**
- **Backend:** Koyeb (Plan gratis)
- **Frontends:** GitHub Pages o Surge.sh (Gratis)
- **Base de Datos:** Aiven (MySQL gratis) o Supabase (PostgreSQL gratis)

### **Koyeb - Plan Gratis:**
- 2 servicios web
- 512MB RAM por servicio
- Shared CPU
- SSL automático
- ✅ NO se duerme como Render

### **GitHub Pages - Gratis:**
- 1GB almacenamiento
- 100GB bandwidth/mes
- Build con GitHub Actions
- ✅ Perfecto para frontends estáticos

### **Aiven - MySQL Gratis:**
- 1 servicio MySQL
- Shared plan (recursos compartidos)
- 30 días gratis, luego $9/mes
- Alternativa: Supabase PostgreSQL (gratis permanente)

### **Resultado:**
- ✅ Backend: https://tu-api.koyeb.app
- ✅ Admin: https://tu-usuario.github.io/admin
- ✅ Ecommerce: https://tu-usuario.github.io/shop
- ✅ Costo: **$0/mes** (si usas Supabase para BD)

---

## 💵 OPCIÓN 6: CYCLIC.SH + VERCEL - $0-3/mes

### **Configuración:**
- **Backend:** Cyclic.sh (Gratis para Node, requiere adaptación)
- **Frontends:** Vercel (Gratis)
- **Base de Datos:** MongoDB Atlas (Gratis) o CockroachDB (Gratis)

### ⚠️ **Limitación:**
- Cyclic NO soporta .NET directamente
- Necesitarías migrar backend a Node.js/Express

### **Alternativa mejor:** Usar Railway o Render en su lugar

---

## 🎯 COMPARATIVA OPCIONES GRATUITAS

| Opción | Costo/mes | Auto-Sleep | MySQL Directo | Complejidad |
|--------|-----------|------------|---------------|-------------|
| **Render + Vercel + PlanetScale** | $0 | ✅ Sí (15min) | ✅ Sí | ⭐⭐ |
| **Railway + Netlify** | $0-2 | ❌ No | ✅ Sí | ⭐⭐ |
| **Oracle Cloud Always Free** | $0 | ❌ No | ✅ Sí | ⭐⭐⭐⭐⭐ |
| **Fly.io + Cloudflare** | $0-3 | ❌ No | ⚠️ PostgreSQL | ⭐⭐⭐ |
| **Koyeb + GitHub Pages** | $0 | ❌ No | ⚠️ Requiere Supabase | ⭐⭐⭐ |

---

## 🏆 MI RECOMENDACIÓN FINAL (GRATIS/ECONÓMICO)

### **🥇 Opción 1: RAILWAY + NETLIFY**
**Costo:** $0-2/mes  
**Por qué:**
- ✅ Más fácil de configurar
- ✅ Sin auto-sleep
- ✅ MySQL nativo (sin migración)
- ✅ $5 crédito mensual gratis
- ✅ Si gastas todo, solo pausas hasta próximo mes

**Limitación:** Requiere monitorear uso mensual

---

### **🥈 Opción 2: RENDER + VERCEL + PLANETSCALE**
**Costo:** $0/mes  
**Por qué:**
- ✅ 100% gratis permanente
- ✅ Fácil de configurar
- ✅ MySQL compatible

**Limitación:** Backend se duerme (30-60s primer request)

---

### **🥉 Opción 3: ORACLE CLOUD ALWAYS FREE**
**Costo:** $0/mes PERMANENTE  
**Por qué:**
- ✅ Recursos MUY generosos
- ✅ Control total
- ✅ Sin limitaciones de auto-sleep
- ✅ Escalable

**Limitación:** Requiere conocimientos de Linux/DevOps

---

## 📊 TABLA RESUMEN COSTOS ANUALES

| Opción | Mes | Año | Gratis Inicial |
|--------|-----|-----|----------------|
| Railway + Netlify | $0-2 | $0-24 | Permanente |
| Render + Vercel | $0 | $0 | Permanente |
| Oracle Cloud | $0 | $0 | Permanente |
| Fly.io | $0-3 | $0-36 | Permanente |
| Koyeb | $0 | $0 | Permanente |

**VS.**

| Opción Paga | Mes | Año |
|-------------|-----|-----|
| Azure | $33 | $396 |
| DigitalOcean | $24 | $288 |
| AWS | $30 | $360 |

---

## 🚀 PRÓXIMOS PASOS

### **Si eliges Railway + Netlify:**
1. Crear cuenta en railway.app (sin tarjeta)
2. Crear cuenta en netlify.com (sin tarjeta)
3. Conectar tu GitHub
4. 3 clicks y está desplegado

### **Si eliges Render + Vercel:**
1. Crear cuenta en render.com
2. Crear cuenta en vercel.com
3. Crear cuenta en planetscale.com
4. Conectar repos y desplegar

### **Si eliges Oracle Cloud:**
1. Crear cuenta (requiere tarjeta pero no se cobra)
2. Crear VM Ampere
3. Configurar servidor (requiere Linux)
4. Desplegar aplicación

---

## 💡 TIPS PARA AHORRAR MÁS

1. **Usa CDN gratis:** Cloudflare (proxy gratis, protección DDoS)
2. **Comprime assets:** Reduce bandwidth
3. **Lazy loading:** Carga imágenes bajo demanda
4. **Cacheo agresivo:** Reduce requests a backend
5. **Optimiza builds:** Reduce tamaño de bundles Angular

---

## 🆘 ¿NECESITAS AYUDA?

**Puedo ayudarte con:**
- ✅ Guía paso a paso de la opción que elijas
- ✅ Scripts de configuración automática
- ✅ Migración de MySQL a PostgreSQL (si necesitas)
- ✅ Optimización para reducir costos
- ✅ CI/CD con GitHub Actions

**¿Cuál opción te gusta más?** 😊
