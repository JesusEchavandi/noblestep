-- =============================================
-- Configurar MySQL para acceso remoto via Ngrok
-- =============================================

-- 1. Crear usuario root que pueda conectarse desde cualquier host
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'tu_password_seguro';

-- 2. Otorgar todos los privilegios en la base de datos noblestepdb
GRANT ALL PRIVILEGES ON noblestepdb.* TO 'root'@'%';

-- 3. Otorgar privilegios adicionales (opcional pero recomendado)
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON noblestepdb.* TO 'root'@'%';

-- 4. Aplicar los cambios
FLUSH PRIVILEGES;

-- 5. Verificar que el usuario fue creado correctamente
SELECT User, Host FROM mysql.user WHERE User = 'root';

-- =============================================
-- RESULTADO ESPERADO:
-- =============================================
-- Deberías ver algo como:
-- +------+-----------+
-- | User | Host      |
-- +------+-----------+
-- | root | %         |
-- | root | localhost |
-- +------+-----------+

-- =============================================
-- NOTAS IMPORTANTES:
-- =============================================
-- 1. '%' significa "desde cualquier host" (necesario para Ngrok)
-- 2. Cambia 'tu_password_seguro' por una contraseña fuerte
-- 3. Esta configuración es necesaria para que Render pueda conectarse vía Ngrok
-- 4. Asegúrate de que MySQL esté configurado para aceptar conexiones remotas

-- =============================================
-- CONFIGURACIÓN ADICIONAL DE MySQL:
-- =============================================
-- Si tienes problemas de conexión, verifica:
-- 1. El archivo my.ini o my.cnf debe tener:
--    bind-address = 0.0.0.0
-- 2. Reinicia MySQL después de cambiar la configuración

-- =============================================
-- SEGURIDAD PARA PRODUCCIÓN:
-- =============================================
-- Para mayor seguridad, considera:
-- 1. Usar un usuario específico (no root)
-- 2. Usar contraseña fuerte (mínimo 16 caracteres)
-- 3. Limitar privilegios solo a lo necesario
-- 4. Usar SSL/TLS para las conexiones

-- Ejemplo de usuario más seguro:
-- CREATE USER 'noblestep_user'@'%' IDENTIFIED BY 'ContraseñaMuySegura123!@#';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON noblestepdb.* TO 'noblestep_user'@'%';
-- FLUSH PRIVILEGES;
