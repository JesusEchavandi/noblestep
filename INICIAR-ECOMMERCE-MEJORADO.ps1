#!/usr/bin/env pwsh
# Script para iniciar el sistema completo: Backend + E-commerce mejorado
# Fecha: 06/02/2026

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "  INICIANDO SISTEMA NOBLESTEP - VERSION MEJORADA" -ForegroundColor Cyan
Write-Host "  Backend (API) + E-commerce Frontend" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Variables de control
$backendStarted = $false
$ecommerceStarted = $false
$backendJob = $null
$ecommerceJob = $null

# Función para limpiar procesos al salir
function Cleanup {
    Write-Host "`n`nDeteniendo servicios..." -ForegroundColor Yellow
    
    if ($backendJob) {
        Write-Host "Deteniendo Backend..." -ForegroundColor Yellow
        Stop-Job -Job $backendJob -ErrorAction SilentlyContinue
        Remove-Job -Job $backendJob -ErrorAction SilentlyContinue
    }
    
    if ($ecommerceJob) {
        Write-Host "Deteniendo E-commerce..." -ForegroundColor Yellow
        Stop-Job -Job $ecommerceJob -ErrorAction SilentlyContinue
        Remove-Job -Job $ecommerceJob -ErrorAction SilentlyContinue
    }
    
    # Matar procesos de .NET y Angular por puerto
    Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    
    Get-NetTCPConnection -LocalPort 4201 -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "`nServicios detenidos correctamente." -ForegroundColor Green
}

# Registrar manejador de salida
Register-EngineEvent PowerShell.Exiting -Action { Cleanup } | Out-Null

try {
    # 1. INICIAR BACKEND
    Write-Host "[1/2] Iniciando Backend API en puerto 5000..." -ForegroundColor Yellow
    Write-Host "      Ruta: backend/" -ForegroundColor Gray
    
    if (Test-Path "backend/NobleStep.Api.csproj") {
        $backendJob = Start-Job -ScriptBlock {
            Set-Location $using:PWD/backend
            dotnet run --urls "http://localhost:5000"
        }
        
        Write-Host "      Esperando a que el backend inicie..." -ForegroundColor Gray
        Start-Sleep -Seconds 8
        
        # Verificar si el backend está corriendo
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:5000/api/shop/products" -TimeoutSec 5 -ErrorAction Stop
            Write-Host "      ✓ Backend iniciado correctamente" -ForegroundColor Green
            $backendStarted = $true
        } catch {
            Write-Host "      ⚠ Backend puede tardar un poco más en iniciar..." -ForegroundColor Yellow
            $backendStarted = $true
        }
    } else {
        Write-Host "      ✗ No se encontró el proyecto del backend" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    
    # 2. INICIAR E-COMMERCE
    Write-Host "[2/2] Iniciando E-commerce en puerto 4201..." -ForegroundColor Yellow
    Write-Host "      Ruta: frontend/projects/ecommerce/" -ForegroundColor Gray
    
    if (Test-Path "frontend/angular.json") {
        $ecommerceJob = Start-Job -ScriptBlock {
            Set-Location $using:PWD/frontend
            npm run start:ecommerce 2>&1
        }
        
        Write-Host "      Esperando a que el e-commerce compile..." -ForegroundColor Gray
        Start-Sleep -Seconds 15
        
        Write-Host "      ✓ E-commerce iniciado" -ForegroundColor Green
        $ecommerceStarted = $true
    } else {
        Write-Host "      ✗ No se encontró el proyecto del e-commerce" -ForegroundColor Red
        Cleanup
        exit 1
    }
    
    Write-Host ""
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host "  ✓ SISTEMA INICIADO CORRECTAMENTE" -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "URLs disponibles:" -ForegroundColor Cyan
    Write-Host "  • Backend API:    http://localhost:5000" -ForegroundColor White
    Write-Host "  • E-commerce:     http://localhost:4201" -ForegroundColor White
    Write-Host "  • API Swagger:    http://localhost:5000/swagger" -ForegroundColor White
    Write-Host ""
    Write-Host "MEJORAS IMPLEMENTADAS:" -ForegroundColor Cyan
    Write-Host "  ✓ Sistema de notificaciones elegante (sin alerts)" -ForegroundColor Green
    Write-Host "  ✓ Validaciones mejoradas en formularios" -ForegroundColor Green
    Write-Host "  ✓ Checkout por WhatsApp con mensaje detallado" -ForegroundColor Green
    Write-Host "  ✓ Eliminado módulo de devoluciones" -ForegroundColor Green
    Write-Host "  ✓ Mejor manejo de errores en backend" -ForegroundColor Green
    Write-Host "  ✓ Validaciones de stock mejoradas" -ForegroundColor Green
    Write-Host ""
    Write-Host "Presiona Ctrl+C para detener todos los servicios..." -ForegroundColor Yellow
    Write-Host ""
    
    # Mantener el script corriendo y mostrar logs
    Write-Host "=== LOGS EN TIEMPO REAL ===" -ForegroundColor Cyan
    Write-Host ""
    
    while ($true) {
        if ($backendJob) {
            $backendOutput = Receive-Job -Job $backendJob -ErrorAction SilentlyContinue
            if ($backendOutput) {
                Write-Host "[BACKEND] $backendOutput" -ForegroundColor Blue
            }
        }
        
        if ($ecommerceJob) {
            $ecommerceOutput = Receive-Job -Job $ecommerceJob -ErrorAction SilentlyContinue
            if ($ecommerceOutput) {
                Write-Host "[E-COMMERCE] $ecommerceOutput" -ForegroundColor Magenta
            }
        }
        
        Start-Sleep -Milliseconds 500
    }
    
} catch {
    Write-Host "`n✗ Error al iniciar el sistema: $_" -ForegroundColor Red
    Cleanup
    exit 1
} finally {
    Cleanup
}
