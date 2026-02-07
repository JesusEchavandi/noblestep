-- =============================================
-- NobleStep - Base de Datos COMPLETA en ESPAÑOL
-- Sistema de Gestión de Ventas de Calzado
-- Versión: Final - Enero 2026
-- =============================================

-- Eliminar base de datos si existe
DROP DATABASE IF EXISTS noblestepdb;

-- Crear base de datos con codificación UTF-8
CREATE DATABASE noblestepdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE noblestepdb;

-- =============================================
-- TABLA: usuarios
-- Descripción: Usuarios del sistema (administradores y vendedores)
-- =============================================
CREATE TABLE usuarios (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NombreUsuario VARCHAR(50) NOT NULL UNIQUE,
    ClaveHash VARCHAR(255) NOT NULL,
    NombreCompleto VARCHAR(100) NOT NULL,
    CorreoElectronico VARCHAR(100) NOT NULL,
    Rol VARCHAR(20) NOT NULL, -- 'Administrador' o 'Vendedor'
    EstaActivo BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nombre_usuario (NombreUsuario),
    INDEX idx_rol (Rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: categorias
-- Descripción: Categorías de productos (Deportivo, Casual, etc.)
-- =============================================
CREATE TABLE categorias (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(500),
    EstaActivo BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nombre (Nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: productos
-- Descripción: Productos de calzado disponibles en inventario
-- =============================================
CREATE TABLE productos (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    Marca VARCHAR(100) NOT NULL,
    CategoriaId INT NOT NULL,
    Talla VARCHAR(20) NOT NULL,
    Precio DECIMAL(18,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    EstaActivo BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FechaActualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoriaId) REFERENCES categorias(Id),
    INDEX idx_nombre (Nombre),
    INDEX idx_marca (Marca),
    INDEX idx_categoria (CategoriaId),
    INDEX idx_stock (Stock)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: clientes
-- Descripción: Clientes que realizan compras
-- =============================================
CREATE TABLE clientes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NombreCompleto VARCHAR(100) NOT NULL,
    NumeroDocumento VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(100),
    EstaActivo BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_nombre (NombreCompleto),
    INDEX idx_documento (NumeroDocumento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: proveedores
-- Descripción: Proveedores de productos
-- =============================================
CREATE TABLE proveedores (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NombreEmpresa VARCHAR(100) NOT NULL,
    NombreContacto VARCHAR(100) NOT NULL,
    NumeroDocumento VARCHAR(20) NOT NULL UNIQUE,
    Telefono VARCHAR(15),
    CorreoElectronico VARCHAR(100),
    Direccion VARCHAR(200),
    Ciudad VARCHAR(100),
    Pais VARCHAR(100) DEFAULT 'Perú',
    EstaActivo BOOLEAN DEFAULT TRUE,
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FechaActualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_nombre_empresa (NombreEmpresa),
    INDEX idx_documento (NumeroDocumento)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: ventas
-- Descripción: Registro de ventas realizadas
-- =============================================
CREATE TABLE ventas (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ClienteId INT NOT NULL,
    UsuarioId INT NOT NULL,
    FechaVenta DATETIME DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(18,2) NOT NULL,
    Estado VARCHAR(20) DEFAULT 'Completado', -- 'Completado', 'Cancelado', 'Pendiente'
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClienteId) REFERENCES clientes(Id),
    FOREIGN KEY (UsuarioId) REFERENCES usuarios(Id),
    INDEX idx_fecha_venta (FechaVenta),
    INDEX idx_cliente (ClienteId),
    INDEX idx_usuario (UsuarioId),
    INDEX idx_estado (Estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: detallesventa
-- Descripción: Detalle de productos vendidos en cada venta
-- =============================================
CREATE TABLE detallesventa (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    VentaId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(18,2) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (VentaId) REFERENCES ventas(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductoId) REFERENCES productos(Id),
    INDEX idx_venta (VentaId),
    INDEX idx_producto (ProductoId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: compras
-- Descripción: Registro de compras a proveedores
-- =============================================
CREATE TABLE compras (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ProveedorId INT NOT NULL,
    UsuarioId INT NOT NULL,
    FechaCompra DATETIME DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(18,2) NOT NULL,
    Estado VARCHAR(50) DEFAULT 'Completada', -- 'Completada', 'Pendiente', 'Cancelada'
    FechaCreacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProveedorId) REFERENCES proveedores(Id),
    FOREIGN KEY (UsuarioId) REFERENCES usuarios(Id),
    INDEX idx_fecha_compra (FechaCompra),
    INDEX idx_proveedor (ProveedorId),
    INDEX idx_usuario (UsuarioId),
    INDEX idx_estado (Estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABLA: detallescompra
-- Descripción: Detalle de productos comprados en cada compra
-- =============================================
CREATE TABLE detallescompra (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    CompraId INT NOT NULL,
    ProductoId INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(18,2) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (CompraId) REFERENCES compras(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductoId) REFERENCES productos(Id),
    INDEX idx_compra (CompraId),
    INDEX idx_producto (ProductoId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- DATOS INICIALES - USUARIOS
-- =============================================
-- Contraseña para ambos: admin123
INSERT INTO usuarios (NombreUsuario, ClaveHash, NombreCompleto, CorreoElectronico, Rol, EstaActivo) VALUES
('admin', 'admin123', 'Administrador del Sistema', 'admin@noblestep.com', 'Administrador', 1),
('vendedor1', 'admin123', 'Juan Pérez Vendedor', 'vendedor@noblestep.com', 'Vendedor', 1);

-- =============================================
-- DATOS INICIALES - CATEGORÍAS
-- =============================================
INSERT INTO categorias (Nombre, Descripcion, EstaActivo) VALUES
('Deportivo', 'Calzado deportivo y para ejercicio', 1),
('Casual', 'Calzado casual para uso diario', 1),
('Formal', 'Calzado elegante para eventos formales', 1),
('Sandalias', 'Sandalias y calzado abierto', 1),
('Botas', 'Botas y botines', 1),
('Infantil', 'Calzado para niños y niñas', 1);

-- =============================================
-- DATOS INICIALES - PRODUCTOS
-- =============================================
INSERT INTO productos (Nombre, Marca, CategoriaId, Talla, Precio, Stock, EstaActivo) VALUES
-- Deportivos
('Zapatillas Running Pro', 'Nike', 1, '42', 289.90, 25, 1),
('Zapatillas Air Max', 'Nike', 1, '40', 349.90, 18, 1),
('Zapatillas Ultraboost', 'Adidas', 1, '41', 399.90, 15, 1),
('Zapatillas Gel-Kayano', 'Asics', 1, '43', 329.90, 12, 1),
('Zapatillas Fresh Foam', 'New Balance', 1, '42', 279.90, 20, 1),

-- Casual
('Zapatos Casual Premium', 'Clarks', 2, '41', 189.90, 30, 1),
('Mocasines Cuero', 'Hush Puppies', 2, '42', 159.90, 22, 1),
('Zapatillas Urbanas', 'Converse', 2, '40', 149.90, 35, 1),
('Zapatos Slip-On', 'Vans', 2, '41', 139.90, 28, 1),
('Zapatillas Stan Smith', 'Adidas', 2, '42', 249.90, 20, 1),

-- Formal
('Zapatos Oxford Cuero', 'Bata', 3, '42', 199.90, 15, 1),
('Zapatos Derby Elegantes', 'Guante', 3, '41', 229.90, 12, 1),
('Zapatos Brogue Premium', 'Ecco', 3, '43', 349.90, 8, 1),
('Mocasines Formales', 'Cole Haan', 3, '42', 279.90, 10, 1),

-- Sandalias
('Sandalias Deportivas', 'Teva', 4, '41', 89.90, 40, 1),
('Chancletas Confort', 'Ipanema', 4, '40', 49.90, 50, 1),
('Sandalias Cuero', 'Clarks', 4, '42', 129.90, 25, 1),

-- Botas
('Botas Trekking', 'Columbia', 5, '42', 329.90, 15, 1),
('Botines Chelsea', 'Dr. Martens', 5, '41', 399.90, 10, 1),
('Botas Trabajo', 'Cat', 5, '43', 279.90, 18, 1),

-- Infantil
('Zapatillas Niños', 'Nike', 6, '32', 119.90, 30, 1),
('Zapatos Escolares', 'Bubble Gummers', 6, '30', 89.90, 35, 1),
('Sandalias Niñas', 'Barbie', 6, '28', 59.90, 40, 1);

-- =============================================
-- DATOS INICIALES - CLIENTES
-- =============================================
INSERT INTO clientes (NombreCompleto, NumeroDocumento, Telefono, CorreoElectronico, EstaActivo) VALUES
('Carlos Rodríguez García', '12345678', '987654321', 'carlos.rodriguez@email.com', 1),
('María González López', '23456789', '987654322', 'maria.gonzalez@email.com', 1),
('José Martínez Pérez', '34567890', '987654323', 'jose.martinez@email.com', 1),
('Ana Fernández Ruiz', '45678901', '987654324', 'ana.fernandez@email.com', 1),
('Luis Sánchez Torres', '56789012', '987654325', 'luis.sanchez@email.com', 1),
('Carmen Díaz Morales', '67890123', '987654326', 'carmen.diaz@email.com', 1),
('Pedro Ramírez Castro', '78901234', '987654327', 'pedro.ramirez@email.com', 1),
('Laura Jiménez Ortiz', '89012345', '987654328', 'laura.jimenez@email.com', 1),
('Miguel Ángel Vargas', '90123456', '987654329', 'miguel.vargas@email.com', 1),
('Isabel Romero Núñez', '01234567', '987654330', 'isabel.romero@email.com', 1),
('Francisco Herrera Gil', '11234567', '987654331', 'francisco.herrera@email.com', 1),
('Patricia Navarro Cruz', '22345678', '987654332', 'patricia.navarro@email.com', 1),
('Roberto Silva Medina', '33456789', '987654333', 'roberto.silva@email.com', 1),
('Elena Castro Vega', '44567890', '987654334', 'elena.castro@email.com', 1),
('Daniel Ortega Flores', '55678901', '987654335', 'daniel.ortega@email.com', 1);

-- =============================================
-- DATOS INICIALES - PROVEEDORES
-- =============================================
INSERT INTO proveedores (NombreEmpresa, NombreContacto, NumeroDocumento, Telefono, CorreoElectronico, Direccion, Ciudad, Pais, EstaActivo) VALUES
('Distribuidora Nike Perú SAC', 'Juan Carlos Méndez', '20123456789', '015551234', 'ventas@nike.pe', 'Av. Javier Prado 123', 'Lima', 'Perú', 1),
('Adidas Perú Importaciones', 'María Elena Torres', '20234567890', '015552345', 'pedidos@adidas.pe', 'Av. Larco 456', 'Lima', 'Perú', 1),
('Calzados Bata Perú SA', 'Roberto Campos', '20345678901', '015553456', 'ventas@bata.com.pe', 'Jr. de la Unión 789', 'Lima', 'Perú', 1),
('Importaciones Clarks SAC', 'Carmen Ruiz', '20456789012', '015554567', 'contacto@clarks.pe', 'Av. Benavides 321', 'Lima', 'Perú', 1),
('Distribuidora Deportiva SAC', 'Luis Fernando García', '20567890123', '015555678', 'ventas@distdeportiva.pe', 'Av. Colonial 654', 'Lima', 'Perú', 1);

-- =============================================
-- DATOS DE DEMOSTRACIÓN - VENTAS
-- =============================================
INSERT INTO ventas (ClienteId, UsuarioId, FechaVenta, Total, Estado) VALUES
(1, 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 579.80, 'Completado'),
(2, 2, DATE_SUB(NOW(), INTERVAL 28 DAY), 349.90, 'Completado'),
(3, 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 899.70, 'Completado'),
(4, 2, DATE_SUB(NOW(), INTERVAL 22 DAY), 189.90, 'Completado'),
(5, 1, DATE_SUB(NOW(), INTERVAL 20 DAY), 469.80, 'Completado'),
(6, 2, DATE_SUB(NOW(), INTERVAL 18 DAY), 229.90, 'Completado'),
(7, 1, DATE_SUB(NOW(), INTERVAL 15 DAY), 329.90, 'Completado'),
(8, 2, DATE_SUB(NOW(), INTERVAL 12 DAY), 759.70, 'Completado'),
(9, 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 149.90, 'Completado'),
(10, 2, DATE_SUB(NOW(), INTERVAL 8 DAY), 399.90, 'Completado'),
(11, 1, DATE_SUB(NOW(), INTERVAL 6 DAY), 549.80, 'Completado'),
(12, 2, DATE_SUB(NOW(), INTERVAL 4 DAY), 189.90, 'Completado'),
(13, 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 289.90, 'Completado'),
(14, 2, DATE_SUB(NOW(), INTERVAL 1 DAY), 629.80, 'Completado'),
(15, 1, NOW(), 459.80, 'Completado');

-- =============================================
-- DATOS DE DEMOSTRACIÓN - DETALLES DE VENTAS
-- =============================================
INSERT INTO detallesventa (VentaId, ProductoId, Cantidad, PrecioUnitario, Subtotal) VALUES
-- Venta 1
(1, 1, 2, 289.90, 579.80),
-- Venta 2
(2, 2, 1, 349.90, 349.90),
-- Venta 3
(3, 3, 2, 399.90, 799.80),
(3, 16, 1, 49.90, 49.90),
(3, 22, 1, 59.90, 59.90),
-- Venta 4
(4, 6, 1, 189.90, 189.90),
-- Venta 5
(5, 5, 1, 279.90, 279.90),
(5, 6, 1, 189.90, 189.90),
-- Y así sucesivamente...
(6, 12, 1, 229.90, 229.90),
(7, 4, 1, 329.90, 329.90),
(8, 3, 1, 399.90, 399.90),
(8, 2, 1, 349.90, 349.90),
(9, 8, 1, 149.90, 149.90),
(10, 3, 1, 399.90, 399.90),
(11, 1, 1, 289.90, 289.90),
(11, 7, 1, 159.90, 159.90),
(11, 16, 2, 49.90, 99.80),
(12, 6, 1, 189.90, 189.90),
(13, 1, 1, 289.90, 289.90),
(14, 5, 2, 279.90, 559.80),
(14, 9, 1, 139.90, 139.90),
(15, 11, 2, 199.90, 399.80),
(15, 21, 1, 119.90, 119.90);

-- =============================================
-- DATOS DE DEMOSTRACIÓN - COMPRAS
-- =============================================
INSERT INTO compras (ProveedorId, UsuarioId, FechaCompra, Total, Estado) VALUES
(1, 1, DATE_SUB(NOW(), INTERVAL 45 DAY), 7250.00, 'Completada'),
(2, 1, DATE_SUB(NOW(), INTERVAL 40 DAY), 5990.00, 'Completada'),
(3, 1, DATE_SUB(NOW(), INTERVAL 35 DAY), 3780.00, 'Completada'),
(4, 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 4500.00, 'Completada'),
(5, 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 2800.00, 'Completada'),
(1, 1, DATE_SUB(NOW(), INTERVAL 20 DAY), 5200.00, 'Completada'),
(2, 1, DATE_SUB(NOW(), INTERVAL 15 DAY), 6800.00, 'Completada'),
(3, 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 3200.00, 'Completada'),
(4, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), 4100.00, 'Completada'),
(5, 1, NOW(), 2900.00, 'Completada');

-- =============================================
-- DATOS DE DEMOSTRACIÓN - DETALLES DE COMPRAS
-- =============================================
INSERT INTO detallescompra (CompraId, ProductoId, Cantidad, PrecioUnitario, Subtotal) VALUES
-- Compra 1 - Nike
(1, 1, 25, 200.00, 5000.00),
(1, 2, 15, 250.00, 3750.00),
-- Compra 2 - Adidas
(2, 3, 15, 280.00, 4200.00),
(2, 10, 18, 180.00, 3240.00),
-- Compra 3 - Bata
(3, 11, 15, 140.00, 2100.00),
(3, 12, 12, 160.00, 1920.00),
-- Compra 4 - Clarks
(4, 6, 30, 130.00, 3900.00),
(4, 17, 20, 90.00, 1800.00),
-- Compra 5 - Distribuidora
(5, 4, 12, 230.00, 2760.00),
(5, 21, 30, 80.00, 2400.00),
-- Y el resto de las compras
(6, 1, 20, 200.00, 4000.00),
(6, 5, 15, 190.00, 2850.00),
(7, 3, 12, 280.00, 3360.00),
(7, 10, 20, 180.00, 3600.00),
(8, 11, 10, 140.00, 1400.00),
(8, 13, 8, 240.00, 1920.00),
(9, 6, 25, 130.00, 3250.00),
(9, 17, 18, 90.00, 1620.00),
(10, 15, 15, 60.00, 900.00),
(10, 16, 40, 35.00, 1400.00),
(10, 22, 25, 40.00, 1000.00);

-- =============================================
-- FIN DEL SCRIPT
-- =============================================

SELECT 'Base de datos NobleStep creada exitosamente en ESPAÑOL' AS Estado;
SELECT 'Tablas: usuarios, categorias, productos, clientes, proveedores, ventas, detallesventa, compras, detallescompra' AS TablesEnEspanol;

-- Verificar datos cargados
SELECT 
    (SELECT COUNT(*) FROM usuarios) AS Usuarios,
    (SELECT COUNT(*) FROM categorias) AS Categorias,
    (SELECT COUNT(*) FROM productos) AS Productos,
    (SELECT COUNT(*) FROM clientes) AS Clientes,
    (SELECT COUNT(*) FROM proveedores) AS Proveedores,
    (SELECT COUNT(*) FROM ventas) AS Ventas,
    (SELECT COUNT(*) FROM compras) AS Compras;
