# =============================================
# Script para iniciar Ngrok y exponer MySQL
# =============================================

Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          Iniciando Ngrok para MySQL - NobleStep             ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar si Ngrok está instalado
Write-Host "1. Verificando Ngrok..." -ForegroundColor Yellow
$ngrokInstalled = Get-Command ngrok -ErrorAction SilentlyContinue

if (-not $ngrokInstalled) {
    Write-Host "   ✗ Ngrok no está instalado" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Descarga Ngrok desde: https://ngrok.com/download" -ForegroundColor Yellow
    Write-Host "   Luego ejecuta: ngrok config add-authtoken TU_TOKEN" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit
}

Write-Host "   ✓ Ngrok instalado" -ForegroundColor Green
Write-Host ""

# Verificar si MySQL está corriendo
Write-Host "2. Verificando MySQL..." -ForegroundColor Yellow
$mysqlProcess = Get-Process -Name mysqld -ErrorAction SilentlyContinue

if (-not $mysqlProcess) {
    Write-Host "   ! MySQL no está corriendo" -ForegroundColor Yellow
    Write-Host "   Intentando iniciar MySQL..." -ForegroundColor Yellow
    
    # Intentar iniciar MySQL
    Start-Service MySQL80 -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
    
    $mysqlProcess = Get-Process -Name mysqld -ErrorAction SilentlyContinue
    if (-not $mysqlProcess) {
        Write-Host "   ✗ No se pudo iniciar MySQL automáticamente" -ForegroundColor Red
        Write-Host "   Por favor inicia MySQL manualmente" -ForegroundColor Yellow
        pause
        exit
    }
}

Write-Host "   ✓ MySQL está corriendo" -ForegroundColor Green
Write-Host ""

# Obtener puerto de MySQL (por defecto 3306)
$mysqlPort = 3306
Write-Host "3. Puerto de MySQL: $mysqlPort" -ForegroundColor Yellow
Write-Host ""

# Iniciar Ngrok
Write-Host "4. Iniciando Ngrok..." -ForegroundColor Yellow
Write-Host ""
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  Ngrok iniciado - Presiona Ctrl+C para detener" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANTE:" -ForegroundColor Cyan
Write-Host "1. Copia la URL de Ngrok (tcp://X.tcp.ngrok.io:XXXXX)" -ForegroundColor White
Write-Host "2. Configúrala en Render como variable de entorno" -ForegroundColor White
Write-Host "3. Mantén esta ventana abierta mientras uses el sistema" -ForegroundColor White
Write-Host ""
Write-Host "Formato de Connection String para Render:" -ForegroundColor Yellow
Write-Host 'Server=X.tcp.ngrok.io;Port=XXXXX;Database=noblestepdb;User=root;Password=TU_PASSWORD;' -ForegroundColor Cyan
Write-Host ""

# Iniciar ngrok
ngrok tcp $mysqlPort
