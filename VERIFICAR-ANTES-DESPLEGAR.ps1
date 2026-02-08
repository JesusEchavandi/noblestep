# =============================================
# Script de Verificación Pre-Despliegue
# =============================================

$ErrorActionPreference = "SilentlyContinue"

Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     Verificación Pre-Despliegue - NobleStep                  ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# 1. Verificar Git
Write-Host "1. Git y GitHub" -ForegroundColor Yellow
$gitInstalled = Get-Command git -ErrorAction SilentlyContinue
if ($gitInstalled) {
    Write-Host "   ✓ Git instalado" -ForegroundColor Green
    
    # Verificar repositorio remoto
    $remote = git remote -v 2>$null
    if ($remote) {
        Write-Host "   ✓ Repositorio GitHub configurado" -ForegroundColor Green
        $remote | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
    } else {
        Write-Host "   ✗ No hay repositorio remoto configurado" -ForegroundColor Red
        $allGood = $false
    }
    
    # Verificar cambios sin commitear
    $status = git status --porcelain 2>$null
    if ($status) {
        Write-Host "   ⚠ Hay cambios sin commitear" -ForegroundColor Yellow
        Write-Host "     Ejecuta: git add . && git commit -m 'mensaje'" -ForegroundColor Gray
    } else {
        Write-Host "   ✓ No hay cambios pendientes" -ForegroundColor Green
    }
} else {
    Write-Host "   ✗ Git no instalado" -ForegroundColor Red
    $allGood = $false
}
Write-Host ""

# 2. Verificar Base de Datos
Write-Host "2. Base de Datos" -ForegroundColor Yellow
if (Test-Path "database/BASE-DATOS-DEFINITIVA.sql") {
    Write-Host "   ✓ Script SQL encontrado" -ForegroundColor Green
} else {
    Write-Host "   ✗ Script SQL no encontrado" -ForegroundColor Red
    $allGood = $false
}
Write-Host ""

# 3. Verificar Archivos de Configuración
Write-Host "3. Archivos de Configuración" -ForegroundColor Yellow

$configFiles = @(
    "Dockerfile",
    "render.yaml",
    ".dockerignore",
    "vercel.json",
    "INICIAR-NGROK.ps1",
    "CONFIGURAR-MYSQL-NGROK.sql"
)

foreach ($file in $configFiles) {
    if (Test-Path $file) {
        Write-Host "   ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $file (falta)" -ForegroundColor Red
        $allGood = $false
    }
}
Write-Host ""

# 4. Verificar Backend
Write-Host "4. Backend (.NET)" -ForegroundColor Yellow
if (Test-Path "backend/NobleStep.Api.csproj") {
    Write-Host "   ✓ Proyecto .NET encontrado" -ForegroundColor Green
    
    # Verificar appsettings
    if (Test-Path "backend/appsettings.json") {
        Write-Host "   ✓ appsettings.json" -ForegroundColor Green
    }
    if (Test-Path "backend/appsettings.Production.json") {
        Write-Host "   ✓ appsettings.Production.json" -ForegroundColor Green
    }
} else {
    Write-Host "   ✗ Proyecto .NET no encontrado" -ForegroundColor Red
    $allGood = $false
}
Write-Host ""

# 5. Verificar Frontend
Write-Host "5. Frontend (Angular)" -ForegroundColor Yellow
if (Test-Path "frontend/package.json") {
    Write-Host "   ✓ package.json encontrado" -ForegroundColor Green
    
    # Verificar scripts
    $packageJson = Get-Content "frontend/package.json" -Raw | ConvertFrom-Json
    if ($packageJson.scripts."build:ecommerce") {
        Write-Host "   ✓ Script build:ecommerce" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Script build:ecommerce falta" -ForegroundColor Red
        $allGood = $false
    }
    
    if ($packageJson.scripts."vercel-build") {
        Write-Host "   ✓ Script vercel-build" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Script vercel-build falta" -ForegroundColor Red
        $allGood = $false
    }
    
    # Verificar environments
    if (Test-Path "frontend/projects/ecommerce/src/environments/environment.prod.ts") {
        Write-Host "   ✓ environment.prod.ts (ecommerce)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠ environment.prod.ts (ecommerce) no encontrado" -ForegroundColor Yellow
    }
    
    if (Test-Path "frontend/src/environments/environment.prod.ts") {
        Write-Host "   ✓ environment.prod.ts (admin)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠ environment.prod.ts (admin) no encontrado" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ✗ package.json no encontrado" -ForegroundColor Red
    $allGood = $false
}
Write-Host ""

# 6. Verificar Ngrok
Write-Host "6. Ngrok" -ForegroundColor Yellow
$ngrokInstalled = Get-Command ngrok -ErrorAction SilentlyContinue
if ($ngrokInstalled) {
    Write-Host "   ✓ Ngrok instalado" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Ngrok no instalado" -ForegroundColor Yellow
    Write-Host "     Descarga: https://ngrok.com/download" -ForegroundColor Gray
}
Write-Host ""

# 7. Verificar Guías de Despliegue
Write-Host "7. Documentación" -ForegroundColor Yellow
$docs = @(
    "GUIA-DESPLIEGUE-COMPLETA.md",
    "DESPLEGAR-PASO-A-PASO.md",
    "RESUMEN-DESPLIEGUE.md",
    "README.md"
)

foreach ($doc in $docs) {
    if (Test-Path $doc) {
        Write-Host "   ✓ $doc" -ForegroundColor Green
    } else {
        Write-Host "   ✗ $doc (falta)" -ForegroundColor Red
    }
}
Write-Host ""

# Resumen Final
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
if ($allGood) {
    Write-Host "   ✅ TODO LISTO PARA DESPLEGAR" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 PRÓXIMOS PASOS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Ejecutar: git push origin main" -ForegroundColor White
    Write-Host "2. Ejecutar: .\INICIAR-NGROK.ps1" -ForegroundColor White
    Write-Host "3. Seguir: DESPLEGAR-PASO-A-PASO.md" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "   ⚠ FALTAN ALGUNOS ARCHIVOS O CONFIGURACIONES" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   Revisa los errores arriba y corrígelos antes de desplegar" -ForegroundColor White
    Write-Host ""
}

Write-Host "📖 Consulta las guías completas:" -ForegroundColor Cyan
Write-Host "   • DESPLEGAR-PASO-A-PASO.md (guía rápida)" -ForegroundColor Gray
Write-Host "   • GUIA-DESPLIEGUE-COMPLETA.md (guía detallada)" -ForegroundColor Gray
Write-Host "   • RESUMEN-DESPLIEGUE.md (resumen ejecutivo)" -ForegroundColor Gray
Write-Host ""
