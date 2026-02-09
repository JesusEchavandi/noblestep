# ============================================
# Script de Verificación Pre-Despliegue Cloud
# NobleStep - Sistema Completo
# ============================================

Write-Host "🚀 VERIFICACIÓN PRE-DESPLIEGUE - NOBLESTEP" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$errores = 0
$advertencias = 0

# ============================================
# 1. VERIFICAR ESTRUCTURA DEL PROYECTO
# ============================================
Write-Host "📁 1. Verificando estructura del proyecto..." -ForegroundColor Yellow

$archivosRequeridos = @(
    "backend/NobleStep.Api.csproj",
    "backend/Program.cs",
    "backend/appsettings.json",
    "backend/appsettings.Production.json",
    "Dockerfile",
    ".dockerignore",
    "frontend/package.json",
    "frontend/angular.json",
    "frontend/src/environments/environment.prod.ts",
    "frontend/projects/ecommerce/src/environments/environment.prod.ts",
    "database/BASE-DATOS-DEFINITIVA.sql"
)

foreach ($archivo in $archivosRequeridos) {
    if (Test-Path $archivo) {
        Write-Host "   ✅ $archivo" -ForegroundColor Green
    } else {
        Write-Host "   ❌ FALTA: $archivo" -ForegroundColor Red
        $errores++
    }
}

Write-Host ""

# ============================================
# 2. VERIFICAR CONFIGURACIÓN DEL BACKEND
# ============================================
Write-Host "⚙️  2. Verificando configuración del backend..." -ForegroundColor Yellow

# Verificar que Program.cs tenga CORS dinámico
$programCs = Get-Content "backend/Program.cs" -Raw
if ($programCs -match "App:FrontendUrl") {
    Write-Host "   ✅ CORS configurado dinámicamente" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  CORS no está configurado dinámicamente" -ForegroundColor Yellow
    $advertencias++
}

# Verificar health check endpoint
if ($programCs -match "/api/health") {
    Write-Host "   ✅ Health check endpoint configurado" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Health check endpoint no configurado" -ForegroundColor Yellow
    $advertencias++
}

Write-Host ""

# ============================================
# 3. VERIFICAR DOCKERFILE
# ============================================
Write-Host "🐳 3. Verificando Dockerfile..." -ForegroundColor Yellow

$dockerfile = Get-Content "Dockerfile" -Raw
if ($dockerfile -match "dotnet/aspnet:8.0") {
    Write-Host "   ✅ Imagen base .NET 8 correcta" -ForegroundColor Green
} else {
    Write-Host "   ❌ Imagen base incorrecta" -ForegroundColor Red
    $errores++
}

if ($dockerfile -match "EXPOSE") {
    Write-Host "   ✅ Puerto expuesto" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Puerto no expuesto explícitamente" -ForegroundColor Yellow
    $advertencias++
}

Write-Host ""

# ============================================
# 4. VERIFICAR CONFIGURACIÓN DE FRONTEND
# ============================================
Write-Host "🎨 4. Verificando configuración de frontend..." -ForegroundColor Yellow

# Verificar environment.prod.ts del Admin
$adminEnv = Get-Content "frontend/src/environments/environment.prod.ts" -Raw
if ($adminEnv -match "production: true") {
    Write-Host "   ✅ Admin - modo producción habilitado" -ForegroundColor Green
} else {
    Write-Host "   ❌ Admin - modo producción NO habilitado" -ForegroundColor Red
    $errores++
}

# Verificar environment.prod.ts del Ecommerce
$ecommerceEnv = Get-Content "frontend/projects/ecommerce/src/environments/environment.prod.ts" -Raw
if ($ecommerceEnv -match "production: true") {
    Write-Host "   ✅ Ecommerce - modo producción habilitado" -ForegroundColor Green
} else {
    Write-Host "   ❌ Ecommerce - modo producción NO habilitado" -ForegroundColor Red
    $errores++
}

# Verificar package.json
$packageJson = Get-Content "frontend/package.json" -Raw | ConvertFrom-Json
if ($packageJson.scripts."build:ecommerce") {
    Write-Host "   ✅ Script build:ecommerce configurado" -ForegroundColor Green
} else {
    Write-Host "   ❌ Script build:ecommerce NO configurado" -ForegroundColor Red
    $errores++
}

if ($packageJson.scripts."vercel-build") {
    Write-Host "   ✅ Script vercel-build configurado" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Script vercel-build no configurado" -ForegroundColor Yellow
    $advertencias++
}

Write-Host ""

# ============================================
# 5. VERIFICAR ARCHIVOS DE DESPLIEGUE
# ============================================
Write-Host "📦 5. Verificando archivos de configuración de despliegue..." -ForegroundColor Yellow

if (Test-Path "render.yaml") {
    Write-Host "   ✅ render.yaml presente" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  render.yaml no encontrado" -ForegroundColor Yellow
    $advertencias++
}

if (Test-Path "vercel.json") {
    Write-Host "   ✅ vercel.json presente" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  vercel.json no encontrado" -ForegroundColor Yellow
    $advertencias++
}

if (Test-Path "netlify.toml") {
    Write-Host "   ✅ netlify.toml presente" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  netlify.toml no encontrado (opcional)" -ForegroundColor Gray
}

Write-Host ""

# ============================================
# 6. VERIFICAR BASE DE DATOS
# ============================================
Write-Host "🗄️  6. Verificando script de base de datos..." -ForegroundColor Yellow

if (Test-Path "database/BASE-DATOS-DEFINITIVA.sql") {
    $sqlSize = (Get-Item "database/BASE-DATOS-DEFINITIVA.sql").Length / 1KB
    Write-Host "   ✅ Script SQL presente ($('{0:N2}' -f $sqlSize) KB)" -ForegroundColor Green
    
    $sqlContent = Get-Content "database/BASE-DATOS-DEFINITIVA.sql" -Raw
    if ($sqlContent -match "CREATE DATABASE") {
        Write-Host "   ✅ Incluye creación de base de datos" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  No incluye CREATE DATABASE" -ForegroundColor Yellow
        $advertencias++
    }
    
    if ($sqlContent -match "INSERT INTO") {
        Write-Host "   ✅ Incluye datos de ejemplo" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  No incluye datos de ejemplo" -ForegroundColor Yellow
        $advertencias++
    }
} else {
    Write-Host "   ❌ Script SQL no encontrado" -ForegroundColor Red
    $errores++
}

Write-Host ""

# ============================================
# 7. VERIFICAR GIT
# ============================================
Write-Host "🔧 7. Verificando repositorio Git..." -ForegroundColor Yellow

if (Test-Path ".git") {
    Write-Host "   ✅ Repositorio Git inicializado" -ForegroundColor Green
    
    # Verificar estado de Git
    $gitStatus = git status --porcelain 2>$null
    if ($LASTEXITCODE -eq 0) {
        if ([string]::IsNullOrWhiteSpace($gitStatus)) {
            Write-Host "   ✅ No hay cambios sin commitear" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Hay cambios sin commitear" -ForegroundColor Yellow
            $advertencias++
        }
        
        # Verificar remote
        $gitRemote = git remote -v 2>$null
        if ($gitRemote -match "github.com") {
            Write-Host "   ✅ Remote de GitHub configurado" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Remote de GitHub no configurado" -ForegroundColor Yellow
            $advertencias++
        }
    }
} else {
    Write-Host "   ❌ Repositorio Git no inicializado" -ForegroundColor Red
    $errores++
}

Write-Host ""

# ============================================
# 8. VERIFICAR DEPENDENCIAS
# ============================================
Write-Host "📚 8. Verificando dependencias..." -ForegroundColor Yellow

# Verificar Node.js
$nodeVersion = node --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Node.js instalado: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "   ❌ Node.js no instalado" -ForegroundColor Red
    $errores++
}

# Verificar npm
$npmVersion = npm --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ npm instalado: v$npmVersion" -ForegroundColor Green
} else {
    Write-Host "   ❌ npm no instalado" -ForegroundColor Red
    $errores++
}

# Verificar .NET
$dotnetVersion = dotnet --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ .NET instalado: v$dotnetVersion" -ForegroundColor Green
} else {
    Write-Host "   ❌ .NET no instalado" -ForegroundColor Red
    $errores++
}

# Verificar Docker (opcional)
$dockerVersion = docker --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Docker instalado: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "   ℹ️  Docker no instalado (opcional para desarrollo local)" -ForegroundColor Gray
}

Write-Host ""

# ============================================
# RESUMEN
# ============================================
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "📊 RESUMEN DE VERIFICACIÓN" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($errores -eq 0 -and $advertencias -eq 0) {
    Write-Host "✅ ¡PERFECTO! Todo está listo para desplegar" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "   1. Sigue la guía: DESPLIEGUE-COMPLETO-CLOUD.md" -ForegroundColor White
    Write-Host "   2. Comienza con la base de datos en Railway" -ForegroundColor White
    Write-Host "   3. Luego despliega el backend en Render" -ForegroundColor White
    Write-Host "   4. Finalmente despliega los frontends en Vercel" -ForegroundColor White
} elseif ($errores -eq 0) {
    Write-Host "⚠️  HAY ADVERTENCIAS (pero puedes continuar)" -ForegroundColor Yellow
    Write-Host "   Advertencias: $advertencias" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Revisa las advertencias arriba antes de continuar" -ForegroundColor White
} else {
    Write-Host "❌ HAY ERRORES QUE DEBES CORREGIR" -ForegroundColor Red
    Write-Host "   Errores: $errores" -ForegroundColor Red
    Write-Host "   Advertencias: $advertencias" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   Corrige los errores antes de desplegar" -ForegroundColor White
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Retornar código de salida
if ($errores -gt 0) {
    exit 1
} else {
    exit 0
}
