#!/usr/bin/env pwsh
# Script para iniciar y probar el sistema e-commerce completo

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   SISTEMA E-COMMERCE CON AUTENTICACIÓN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Función para verificar si un puerto está en uso
function Test-Port {
    param($Port)
    try {
        $connection = New-Object System.Net.Sockets.TcpClient("localhost", $Port)
        $connection.Close()
        return $true
    } catch {
        return $false
    }
}

# Verificar puertos
Write-Host "1. Verificando puertos..." -ForegroundColor Yellow
$backendPort = 5000
$adminPort = 4200
$ecommercePort = 4201

if (Test-Port $backendPort) {
    Write-Host "   ⚠️  Puerto $backendPort ya está en uso (Backend)" -ForegroundColor Red
} else {
    Write-Host "   ✅ Puerto $backendPort disponible" -ForegroundColor Green
}

if (Test-Port $adminPort) {
    Write-Host "   ⚠️  Puerto $adminPort ya está en uso (Admin)" -ForegroundColor Red
} else {
    Write-Host "   ✅ Puerto $adminPort disponible" -ForegroundColor Green
}

if (Test-Port $ecommercePort) {
    Write-Host "   ⚠️  Puerto $ecommercePort ya está en uso (E-commerce)" -ForegroundColor Red
} else {
    Write-Host "   ✅ Puerto $ecommercePort disponible" -ForegroundColor Green
}

Write-Host ""
Write-Host "2. Verificando archivos necesarios..." -ForegroundColor Yellow

$files = @(
    "backend/Controllers/EcommerceAuthController.cs",
    "backend/Controllers/OrdersController.cs",
    "backend/Controllers/AdminEcommerceOrdersController.cs",
    "backend/Models/EcommerceCustomer.cs",
    "backend/Models/Order.cs",
    "backend/Services/EmailService.cs",
    "frontend/src/app/ecommerce-orders/ecommerce-orders.component.ts"
)

$allFilesExist = $true
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file no encontrado" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host ""
    Write-Host "❌ Faltan archivos necesarios. No se puede continuar." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Verificando configuración de email..." -ForegroundColor Yellow
$appsettingsPath = "backend/appsettings.json"
if (Test-Path $appsettingsPath) {
    $appsettings = Get-Content $appsettingsPath -Raw | ConvertFrom-Json
    
    if ($appsettings.Email.SmtpPassword -eq "your-gmail-app-password-here") {
        Write-Host "   ⚠️  Email NO configurado. Edita backend/appsettings.json" -ForegroundColor Yellow
        Write-Host "      Ver: CONFIGURAR-EMAIL-GMAIL.md" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ Email configurado" -ForegroundColor Green
    }
} else {
    Write-Host "   ❌ appsettings.json no encontrado" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   INICIANDO SISTEMA..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Iniciar Backend
Write-Host "Iniciando Backend API (Puerto 5000)..." -ForegroundColor Green
Start-Process pwsh -ArgumentList "-NoExit", "-Command", "cd backend; dotnet run" -WindowStyle Normal

Start-Sleep -Seconds 3

# Iniciar Frontend Admin
Write-Host "Iniciando Frontend Admin (Puerto 4200)..." -ForegroundColor Green
Start-Process pwsh -ArgumentList "-NoExit", "-Command", "cd frontend; npm start" -WindowStyle Normal

Start-Sleep -Seconds 2

# Iniciar Frontend E-commerce
Write-Host "Iniciando Frontend E-commerce (Puerto 4201)..." -ForegroundColor Green
Start-Process pwsh -ArgumentList "-NoExit", "-Command", "cd frontend; npm run start:ecommerce" -WindowStyle Normal

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   SISTEMA INICIANDO..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Esperando que los servicios inicien..." -ForegroundColor Yellow
Write-Host "Esto puede tomar 30-60 segundos..." -ForegroundColor Yellow
Write-Host ""

# Esperar un poco más
Start-Sleep -Seconds 10

Write-Host "========================================" -ForegroundColor Green
Write-Host "   ✅ SISTEMA INICIADO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "URLs del sistema:" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Backend API:" -ForegroundColor Yellow
Write-Host "   http://localhost:5000" -ForegroundColor White
Write-Host "   http://localhost:5000/swagger (Documentación API)" -ForegroundColor White
Write-Host ""
Write-Host "👨‍💼 Panel de Administración:" -ForegroundColor Yellow
Write-Host "   http://localhost:4200" -ForegroundColor White
Write-Host "   http://localhost:4200/ecommerce-orders (Pedidos E-commerce)" -ForegroundColor White
Write-Host ""
Write-Host "🛍️ E-commerce (Tienda):" -ForegroundColor Yellow
Write-Host "   http://localhost:4201" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   FUNCIONALIDADES DISPONIBLES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "En el E-commerce (http://localhost:4201):" -ForegroundColor Green
Write-Host "  ✅ Registrarse como nuevo usuario" -ForegroundColor White
Write-Host "  ✅ Iniciar sesión" -ForegroundColor White
Write-Host "  ✅ Recuperar contraseña por email" -ForegroundColor White
Write-Host "  ✅ Comprar CON sesión iniciada" -ForegroundColor White
Write-Host "  ✅ Comprar SIN sesión (invitado)" -ForegroundColor White
Write-Host "  ✅ Ver historial en 'Mi Cuenta'" -ForegroundColor White
Write-Host "  ✅ Actualizar perfil" -ForegroundColor White
Write-Host ""
Write-Host "En el Panel Admin (http://localhost:4200):" -ForegroundColor Green
Write-Host "  ✅ Ver TODOS los pedidos del e-commerce" -ForegroundColor White
Write-Host "  ✅ Filtrar por estado" -ForegroundColor White
Write-Host "  ✅ Ver detalles de pedidos" -ForegroundColor White
Write-Host "  ✅ Actualizar estado de pedidos" -ForegroundColor White
Write-Host "  ✅ Estadísticas de ventas" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   DOCUMENTACIÓN DISPONIBLE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📖 GUIA-COMPLETA-ECOMMERCE-CON-AUTH.md" -ForegroundColor Yellow
Write-Host "   - Guía completa de todas las funcionalidades" -ForegroundColor White
Write-Host ""
Write-Host "📧 CONFIGURAR-EMAIL-GMAIL.md" -ForegroundColor Yellow
Write-Host "   - Cómo configurar el envío de emails" -ForegroundColor White
Write-Host ""
Write-Host "🧪 PRUEBAS-SISTEMA-COMPLETO.md" -ForegroundColor Yellow
Write-Host "   - Plan de pruebas paso a paso" -ForegroundColor White
Write-Host ""
Write-Host "📋 RESUMEN-FUNCIONALIDADES-ECOMMERCE-AUTH.md" -ForegroundColor Yellow
Write-Host "   - Resumen técnico de lo implementado" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   PASOS SIGUIENTES" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "1. ⚙️  Configurar email (si no lo has hecho):" -ForegroundColor Cyan
Write-Host "     - Lee: CONFIGURAR-EMAIL-GMAIL.md" -ForegroundColor White
Write-Host "     - Edita: backend/appsettings.json" -ForegroundColor White
Write-Host ""
Write-Host "2. 👤 Crear cuenta de usuario:" -ForegroundColor Cyan
Write-Host "     - Ve a: http://localhost:4201" -ForegroundColor White
Write-Host "     - Clic en icono de usuario" -ForegroundColor White
Write-Host "     - Regístrate con tu email" -ForegroundColor White
Write-Host ""
Write-Host "3. 🛒 Hacer una compra de prueba:" -ForegroundColor Cyan
Write-Host "     - Agrega productos al carrito" -ForegroundColor White
Write-Host "     - Ve al checkout" -ForegroundColor White
Write-Host "     - Completa el pedido" -ForegroundColor White
Write-Host ""
Write-Host "4. 📊 Ver el pedido en el panel admin:" -ForegroundColor Cyan
Write-Host "     - Ve a: http://localhost:4200" -ForegroundColor White
Write-Host "     - Inicia sesión como admin" -ForegroundColor White
Write-Host "     - Ve a 'Pedidos E-commerce'" -ForegroundColor White
Write-Host ""
Write-Host "5. 🧪 Ejecutar pruebas completas:" -ForegroundColor Cyan
Write-Host "     - Sigue: PRUEBAS-SISTEMA-COMPLETO.md" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   ¡SISTEMA LISTO! 🎉" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Presiona Ctrl+C en cada ventana para detener los servicios" -ForegroundColor Yellow
Write-Host ""
