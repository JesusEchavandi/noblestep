# ====================================================================
# SCRIPT PARA CORREGIR EL HASH DE CONTRASEÑA EN LA BASE DE DATOS
# ====================================================================
# 
# PROBLEMA IDENTIFICADO:
# El hash de contraseña en database-setup.sql es INCORRECTO
# No corresponde a la contraseña "admin123"
#
# SOLUCIÓN:
# Este script actualizará el hash a uno correcto
# ====================================================================

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "  CORRECCIÓN DE CONTRASEÑAS - NobleStep" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "PROBLEMA ENCONTRADO:" -ForegroundColor Yellow
Write-Host "  El hash BCrypt en la base de datos NO corresponde a 'admin123'" -ForegroundColor White
Write-Host ""

Write-Host "SOLUCIÓN:" -ForegroundColor Green
Write-Host "  1. Ejecutar el script SQL: database/fix-password-hash.sql" -ForegroundColor White
Write-Host "  2. O ejecutar manualmente el comando SQL que aparece abajo" -ForegroundColor White
Write-Host ""

# Prompt for MySQL password
$mysqlPassword = Read-Host "Ingrese la contraseña de MySQL root" -AsSecureString
$mysqlPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($mysqlPassword)
)

Write-Host "`nBuscando MySQL..." -ForegroundColor Cyan

$mysqlPaths = @(
    "C:\xampp\mysql\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
    "C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin\mysql.exe",
    "C:\wamp\bin\mysql\mysql8.0.23\bin\mysql.exe"
)

$mysqlExe = $null
foreach ($path in $mysqlPaths) {
    if (Test-Path $path) {
        $mysqlExe = $path
        Write-Host "✓ MySQL encontrado: $mysqlExe" -ForegroundColor Green
        break
    }
}

if ($mysqlExe) {
    Write-Host "`nEjecutando corrección..." -ForegroundColor Cyan
    
    $sqlCommand = @"
USE noblestepdb;
UPDATE Users SET PasswordHash = '`$2a`$11`$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK' WHERE Username IN ('admin', 'seller1');
SELECT Id, Username, Role, IsActive, 'OK' as Status FROM Users;
"@
    
    $sqlCommand | & $mysqlExe -u root "-p$mysqlPasswordPlain" noblestepdb
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✓ ¡CONTRASEÑAS ACTUALIZADAS CORRECTAMENTE!" -ForegroundColor Green
        Write-Host "`nCredenciales actualizadas:" -ForegroundColor Cyan
        Write-Host "  Usuario: admin    | Contraseña: admin123" -ForegroundColor White
        Write-Host "  Usuario: seller1  | Contraseña: admin123" -ForegroundColor White
        Write-Host "`n✓ Ahora puedes iniciar sesión en el sistema" -ForegroundColor Green
    } else {
        Write-Host "`n✗ Error al actualizar. Intenta manualmente." -ForegroundColor Red
    }
} else {
    Write-Host "✗ No se encontró MySQL" -ForegroundColor Red
    Write-Host "`nEjecuta este comando MANUALMENTE en MySQL:" -ForegroundColor Yellow
    Write-Host "---------------------------------------------------------------------" -ForegroundColor Gray
    Write-Host "USE noblestepdb;" -ForegroundColor White
    Write-Host "UPDATE Users SET PasswordHash = '`$2a`$11`$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK' WHERE Username IN ('admin', 'seller1');" -ForegroundColor White
    Write-Host "SELECT * FROM Users;" -ForegroundColor White
    Write-Host "---------------------------------------------------------------------" -ForegroundColor Gray
}

Write-Host "`nPresiona cualquier tecla para continuar..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
