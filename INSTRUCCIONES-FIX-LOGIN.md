# 🔧 SOLUCIÓN AL PROBLEMA DE LOGIN

## ❌ Problema Identificado

El hash de contraseña BCrypt en el archivo `database-setup.sql` es **INCORRECTO** y no corresponde a la contraseña "admin123".

### Verificación realizada:
- **Hash en BD**: `$2a$11$5EJ8FdHmPnNvYWFveZNwCeG.L9sJYmQ6JzBqmJrjXxKHI5KGhYGWG`
- **Contraseña**: `admin123`
- **Resultado**: ❌ NO COINCIDE

## ✅ Solución

### Opción 1: Script Automático (RECOMENDADO)

Ejecuta el script PowerShell:

```powershell
.\EJECUTAR-FIX-PASSWORD.ps1
```

### Opción 2: Ejecutar SQL Manualmente

1. Abre tu cliente MySQL (phpMyAdmin, MySQL Workbench, o línea de comandos)

2. Ejecuta el siguiente comando SQL:

```sql
USE noblestepdb;

UPDATE Users 
SET PasswordHash = '$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK' 
WHERE Username IN ('admin', 'seller1');

-- Verificar
SELECT Id, Username, Role, IsActive FROM Users;
```

### Opción 3: Usar el archivo SQL

```bash
mysql -u root -p noblestepdb < database/fix-password-hash.sql
```

## 📋 Credenciales Correctas

Después de aplicar el fix:

| Usuario  | Contraseña | Rol           |
|----------|------------|---------------|
| admin    | admin123   | Administrator |
| seller1  | admin123   | Seller        |

## 🔍 Archivos Creados

1. **database/fix-password-hash.sql** - Script SQL para actualizar la base de datos
2. **EJECUTAR-FIX-PASSWORD.ps1** - Script PowerShell automatizado
3. **INSTRUCCIONES-FIX-LOGIN.md** - Este archivo de instrucciones

## ⚠️ Nota Importante

El problema está en el archivo original `database-setup.sql`. El hash que contiene:
```
$2a$11$5EJ8FdHmPnNvYWFveZNwCeG.L9sJYmQ6JzBqmJrjXxKHI5KGhYGWG
```

**NO corresponde** a la contraseña "admin123". 

El hash correcto que hemos generado es:
```
$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK
```

## 🚀 Próximos Pasos

1. Ejecuta uno de los métodos de solución descritos arriba
2. Inicia el backend: `cd backend && dotnet run`
3. Inicia el frontend: `cd frontend && npm start`
4. Accede a http://localhost:4200
5. Inicia sesión con: **admin** / **admin123**

## ✅ Verificación

Para verificar que el hash es correcto, puedes ejecutar:

```sql
SELECT Username, 
       SUBSTRING(PasswordHash, 1, 30) as HashPreview,
       Role 
FROM Users;
```

El hash debe comenzar con: `$2a$11$mSiqqJc66CfN.QSbauOBae...`
