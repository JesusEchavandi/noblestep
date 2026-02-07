# Script para iniciar el E-Commerce NobleStep Shop
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   INICIANDO NOBLESTEP E-COMMERCE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar si Node.js está instalado
Write-Host "Verificando Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "   ✓ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ ERROR: Node.js no está instalado" -ForegroundColor Red
    Write-Host "   Por favor instala Node.js desde https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Verificar si .NET está instalado
Write-Host "Verificando .NET..." -ForegroundColor Yellow
try {
    $dotnetVersion = dotnet --version
    Write-Host "   ✓ .NET version: $dotnetVersion" -ForegroundColor Green
} catch {
    Write-Host "   ✗ ERROR: .NET no está instalado" -ForegroundColor Red
    Write-Host "   Por favor instala .NET desde https://dotnet.microsoft.com/download" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "1. Verificando Backend..." -ForegroundColor Yellow
$backendRunning = Get-Process | Where-Object {$_.ProcessName -like "*dotnet*"} | Select-Object -First 1

if ($backendRunning) {
    Write-Host "   ✓ Backend ya está corriendo" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Backend no está corriendo. Iniciando..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd backend; Write-Host 'Iniciando Backend API...' -ForegroundColor Cyan; dotnet run" -WindowStyle Normal
    Write-Host "   ✓ Backend iniciándose en http://localhost:5000" -ForegroundColor Green
    Write-Host "   Esperando 8 segundos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 8
}

Write-Host ""
Write-Host "2. Verificando puertos del E-commerce..." -ForegroundColor Yellow
$port4201 = netstat -ano | findstr :4201
if ($port4201) {
    Write-Host "   ⚠ Puerto 4201 ya está en uso. Deteniendo proceso..." -ForegroundColor Yellow
    $processId = ($port4201 -split '\s+')[-1]
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "3. Iniciando E-commerce Frontend..." -ForegroundColor Yellow

# Cambiar al directorio del frontend
Set-Location -Path "frontend"

# Verificar si node_modules existe
if (-not (Test-Path "node_modules")) {
    Write-Host "   📦 Instalando dependencias de Node.js..." -ForegroundColor Yellow
    npm install
}

Write-Host "   🚀 Iniciando servidor de desarrollo del E-commerce..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   E-COMMERCE INICIADO EXITOSAMENTE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📱 E-commerce:        http://localhost:4201" -ForegroundColor Cyan
Write-Host "🔧 Backend API:       http://localhost:5000" -ForegroundColor Cyan
Write-Host "📚 Swagger API Docs:  http://localhost:5000/swagger" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Yellow
Write-Host ""

# Iniciar el e-commerce en el puerto 4201
npm start -- --project ecommerce --port 4201 --open
