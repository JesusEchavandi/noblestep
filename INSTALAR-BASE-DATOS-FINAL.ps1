# ====================================================================
# SCRIPT DE INSTALACIÓN DE BASE DE DATOS - VERSIÓN FINAL CORREGIDA
# ====================================================================
# Este script instala la base de datos con el hash BCrypt correcto
# ====================================================================

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "  INSTALACIÓN DE BASE DE DATOS - NobleStep" -ForegroundColor Cyan
Write-Host "  Versión Corregida con Hash BCrypt Válido" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

# Buscar MySQL
$mysqlPaths = @(
    "C:\xampp\mysql\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
    "C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\wamp\bin\mysql\mysql8.0.23\bin\mysql.exe",
    "C:\wamp64\bin\mysql\mysql8.0.23\bin\mysql.exe"
)

$mysqlExe = $null
foreach ($path in $mysqlPaths) {
    if (Test-Path $path) {
        $mysqlExe = $path
        Write-Host "✓ MySQL encontrado: $mysqlExe" -ForegroundColor Green
        break
    }
}

if (-not $mysqlExe) {
    Write-Host "✗ No se encontró MySQL" -ForegroundColor Red
    Write-Host "`nPor favor, ejecuta manualmente:" -ForegroundColor Yellow
    Write-Host "mysql -u root -p < database/database-setup-CORREGIDO.sql" -ForegroundColor Cyan
    exit
}

Write-Host "`nProbando conexión a MySQL..." -ForegroundColor Cyan

# Probar contraseñas comunes
$passwords = @("", "root", "123456", "password", "admin")
$connected = $false
$workingPassword = ""

foreach ($pwd in $passwords) {
    $pwdDisplay = if ($pwd -eq "") { "(sin contraseña)" } else { $pwd }
    Write-Host "  Probando: $pwdDisplay" -ForegroundColor Gray
    
    $testCmd = "SELECT 1;"
    $result = if ($pwd -eq "") {
        $testCmd | & $mysqlExe -u root 2>&1
    } else {
        $testCmd | & $mysqlExe -u root "-p$pwd" 2>&1
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Conexión exitosa" -ForegroundColor Green
        $connected = $true
        $workingPassword = $pwd
        break
    }
}

if (-not $connected) {
    Write-Host "`n✗ No se pudo conectar automáticamente" -ForegroundColor Red
    Write-Host "`nEjecuta manualmente:" -ForegroundColor Yellow
    Write-Host "mysql -u root -p < database/database-setup-CORREGIDO.sql" -ForegroundColor Cyan
    exit
}

Write-Host "`n✓ Instalando base de datos..." -ForegroundColor Cyan
Write-Host "  Archivo: database/database-setup-CORREGIDO.sql" -ForegroundColor Gray

if ($workingPassword -eq "") {
    Get-Content "database/database-setup-CORREGIDO.sql" | & $mysqlExe -u root
} else {
    Get-Content "database/database-setup-CORREGIDO.sql" | & $mysqlExe -u root "-p$workingPassword"
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n=====================================================================" -ForegroundColor Green
    Write-Host "  ✓ ¡BASE DE DATOS INSTALADA CORRECTAMENTE!" -ForegroundColor Green
    Write-Host "=====================================================================" -ForegroundColor Green
    
    Write-Host "`n📊 TABLAS CREADAS:" -ForegroundColor Cyan
    Write-Host "  ✓ Users (Usuarios)" -ForegroundColor White
    Write-Host "  ✓ Categories (Categorías)" -ForegroundColor White
    Write-Host "  ✓ Suppliers (Proveedores)" -ForegroundColor White
    Write-Host "  ✓ Products (Productos)" -ForegroundColor White
    Write-Host "  ✓ Customers (Clientes)" -ForegroundColor White
    Write-Host "  ✓ Purchases (Compras)" -ForegroundColor White
    Write-Host "  ✓ PurchaseDetails (Detalles de Compras)" -ForegroundColor White
    Write-Host "  ✓ Sales (Ventas)" -ForegroundColor White
    Write-Host "  ✓ SaleDetails (Detalles de Ventas)" -ForegroundColor White
    
    Write-Host "`n📋 CREDENCIALES DE ACCESO:" -ForegroundColor Cyan
    Write-Host "  👤 Usuario: admin    | 🔑 Contraseña: admin123 | 👔 Rol: Administrator" -ForegroundColor White
    Write-Host "  👤 Usuario: seller1  | 🔑 Contraseña: admin123 | 🛒 Rol: Seller" -ForegroundColor White
    
    Write-Host "`n🎯 DATOS DE PRUEBA:" -ForegroundColor Cyan
    Write-Host "  ✓ 4 Categorías" -ForegroundColor White
    Write-Host "  ✓ 3 Proveedores" -ForegroundColor White
    Write-Host "  ✓ 8 Productos" -ForegroundColor White
    Write-Host "  ✓ 4 Clientes" -ForegroundColor White
    
    Write-Host "`n🚀 SIGUIENTE PASO:" -ForegroundColor Cyan
    Write-Host "  Ejecuta: .\INICIAR-SISTEMA.ps1" -ForegroundColor White
    Write-Host "  O inicia backend y frontend manualmente" -ForegroundColor Gray
    
} else {
    Write-Host "`n✗ Error al instalar la base de datos" -ForegroundColor Red
    Write-Host "Revisa los mensajes de error arriba" -ForegroundColor Yellow
}

Write-Host ""
