-- =============================================
-- NobleStep - BASE DE DATOS DEFINITIVA
-- Sistema de Gestión de Ventas de Calzado + E-commerce
-- Versión: Definitiva - Febrero 2026
-- =============================================
-- Incluye:
-- 1. Tablas del Sistema Web (Administración)
-- 2. Tablas del E-commerce (Tienda Online)
-- 3. Datos iniciales completos
-- 4. Datos de demostración
-- =============================================

-- Usar base de datos railway existente
USE railway;


-- =============================================
-- SECCIÓN 1: TABLAS DEL SISTEMA WEB
-- =============================================

-- Tabla: Users (Usuarios del sistema administrativo)
CREATE TABLE Users (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (Username),
    INDEX idx_email (Email),
    INDEX idx_role (Role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Categories (Categorías de productos)
CREATE TABLE Categories (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(500),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (Name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Products (Productos de calzado)
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL,
    Code VARCHAR(50) NULL,
    Brand VARCHAR(100) NOT NULL,
    CategoryId INT NOT NULL,
    Size VARCHAR(20) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    Stock INT NOT NULL DEFAULT 0,
    Description TEXT NULL,
    ImageUrl VARCHAR(500) NULL,
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    INDEX idx_category (CategoryId),
    INDEX idx_name (Name),
    INDEX idx_brand (Brand),
    INDEX idx_code (Code),
    INDEX idx_stock (Stock)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Customers (Clientes del sistema)
CREATE TABLE Customers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DocumentNumber VARCHAR(20) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(255),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_document (DocumentNumber),
    INDEX idx_name (FullName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Suppliers (Proveedores)
CREATE TABLE Suppliers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DocumentNumber VARCHAR(20) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(255),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (Name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Sales (Ventas del sistema)
CREATE TABLE Sales (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    CustomerId INT NOT NULL,
    UserId INT NOT NULL,
    SaleDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(18,2) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Completed',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    INDEX idx_customer (CustomerId),
    INDEX idx_user (UserId),
    INDEX idx_date (SaleDate),
    INDEX idx_status (Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: SaleDetails (Detalles de ventas)
CREATE TABLE SaleDetails (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SaleId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (SaleId) REFERENCES Sales(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    INDEX idx_sale (SaleId),
    INDEX idx_product (ProductId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Purchases (Compras a proveedores)
CREATE TABLE Purchases (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SupplierId INT NOT NULL,
    UserId INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(18,2) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Completed',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    INDEX idx_supplier (SupplierId),
    INDEX idx_user (UserId),
    INDEX idx_date (PurchaseDate),
    INDEX idx_status (Status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: PurchaseDetails (Detalles de compras)
CREATE TABLE PurchaseDetails (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    PurchaseId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (PurchaseId) REFERENCES Purchases(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    INDEX idx_purchase (PurchaseId),
    INDEX idx_product (ProductId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- SECCIÓN 2: TABLAS DEL E-COMMERCE
-- =============================================

-- Tabla: EcommerceCustomers (Clientes de la tienda online)
CREATE TABLE EcommerceCustomers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NULL,
    DocumentNumber VARCHAR(20) NULL,
    Address VARCHAR(255) NULL,
    City VARCHAR(100) NULL,
    District VARCHAR(100) NULL,
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    EmailVerified TINYINT(1) NOT NULL DEFAULT 0,
    PasswordResetToken VARCHAR(500) NULL,
    PasswordResetExpires DATETIME NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: Orders (Pedidos del e-commerce)
CREATE TABLE Orders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    EcommerceCustomerId INT NULL,
    
    -- Información del cliente (para invitados)
    CustomerFullName VARCHAR(100) NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    CustomerPhone VARCHAR(20) NOT NULL,
    CustomerAddress VARCHAR(255) NOT NULL,
    CustomerCity VARCHAR(100) NOT NULL,
    CustomerDistrict VARCHAR(100) NOT NULL,
    CustomerReference VARCHAR(255) NULL,
    CustomerDocumentNumber VARCHAR(20) NULL,
    
    -- Información del pedido
    OrderNumber VARCHAR(50) NOT NULL UNIQUE,
    Subtotal DECIMAL(18,2) NOT NULL,
    ShippingCost DECIMAL(18,2) NOT NULL DEFAULT 0,
    Total DECIMAL(18,2) NOT NULL,
    
    -- Pago
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentDetails TEXT NULL,
    PaymentStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
    
    -- Estado del pedido
    OrderStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
    
    -- Facturación
    InvoiceType VARCHAR(20) NOT NULL DEFAULT 'Boleta',
    CompanyName VARCHAR(200) NULL,
    CompanyRUC VARCHAR(20) NULL,
    CompanyAddress VARCHAR(255) NULL,
    
    -- Fechas
    OrderDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ProcessedDate DATETIME NULL,
    ShippedDate DATETIME NULL,
    DeliveredDate DATETIME NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (EcommerceCustomerId) REFERENCES EcommerceCustomers(Id) ON DELETE SET NULL,
    INDEX idx_customer (EcommerceCustomerId),
    INDEX idx_order_number (OrderNumber),
    INDEX idx_order_date (OrderDate),
    INDEX idx_email (CustomerEmail),
    INDEX idx_status (OrderStatus),
    INDEX idx_payment_status (PaymentStatus)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla: OrderDetails (Detalles de pedidos)
CREATE TABLE OrderDetails (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    
    -- Snapshot del producto
    ProductName VARCHAR(200) NOT NULL,
    ProductCode VARCHAR(50) NULL,
    ProductSize VARCHAR(20) NULL,
    ProductBrand VARCHAR(100) NULL,
    
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    
    FOREIGN KEY (OrderId) REFERENCES Orders(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    INDEX idx_order (OrderId),
    INDEX idx_product (ProductId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- SECCIÓN 3: DATOS INICIALES
-- =============================================

-- ============= USUARIOS =============
-- Password para todos: admin123
-- Hash generado con BCrypt
INSERT INTO Users (Username, PasswordHash, FullName, Email, Role, IsActive) VALUES
('admin', '$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK', 'Administrador del Sistema', 'admin@noblestep.com', 'Administrator', 1),
('vendedor1', '$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK', 'Juan Pérez Vendedor', 'vendedor@noblestep.com', 'Seller', 1);

-- ============= CATEGORÍAS =============
INSERT INTO Categories (Name, Description, IsActive) VALUES
('Zapatillas', 'Zapatillas deportivas y casuales para todo uso', 1),
('Botas', 'Botas para trabajo, montaña y uso rudo', 1),
('Formales', 'Zapatos formales para oficina y eventos', 1),
('Sandalias', 'Sandalias y calzado abierto para verano', 1);

-- ============= PRODUCTOS =============
INSERT INTO Products (Name, Code, Brand, CategoryId, Size, Price, Stock, Description, ImageUrl, IsActive) VALUES
-- Zapatillas (CategoryId = 1)
('Nike Air Max 2024', 'NIKE-AM24', 'Nike', 1, '42', 499.90, 50, 'Zapatillas deportivas con tecnología Air Max, máxima comodidad y estilo urbano', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', 1),
('Adidas Ultraboost 22', 'ADID-UB22', 'Adidas', 1, '41', 599.90, 35, 'Zapatillas running con tecnología Boost, respuesta energética superior', 'https://images.unsplash.com/photo-1608231387042-66d1773070a5', 1),
('Puma RS-X', 'PUMA-RSX', 'Puma', 1, '40', 399.90, 40, 'Zapatillas urbanas retro, diseño llamativo y comodidad todo el día', 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa', 1),
('New Balance 574', 'NB-574', 'New Balance', 1, '43', 349.90, 45, 'Zapatillas clásicas con suela ENCAP, perfectas para uso diario', 'https://images.unsplash.com/photo-1539185441755-769473a23570', 1),
('Converse All Star', 'CONV-AS', 'Converse', 1, '39', 189.90, 60, 'Zapatillas icónicas de lona, estilo atemporal y versátil', 'https://images.unsplash.com/photo-1605348532760-6753d2c43329', 1),
('Reebok Classic', 'REEB-CL', 'Reebok', 1, '42', 279.90, 38, 'Zapatillas clásicas retro, comodidad y estilo vintage', 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a', 1),
('Vans Old Skool', 'VANS-OS', 'Vans', 1, '41', 249.90, 42, 'Zapatillas skate clásicas, resistentes y con estilo urbano', 'https://images.unsplash.com/photo-1543508282-6319a3e2621f', 1),
('Asics Gel-Kayano', 'ASIC-GK', 'Asics', 1, '43', 549.90, 25, 'Zapatillas running profesionales con tecnología GEL', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff', 1),

-- Botas (CategoryId = 2)
('Timberland Premium 6"', 'TIMB-P6', 'Timberland', 2, '42', 699.90, 30, 'Botas impermeables de cuero premium, ideales para trekking', 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f', 1),
('Dr. Martens 1460', 'DRM-1460', 'Dr. Martens', 2, '41', 549.90, 28, 'Botas de cuero icónicas con suela AirWair resistente', 'https://images.unsplash.com/photo-1582897298507-4b39bcdeac3b', 1),
('Caterpillar Colorado', 'CAT-COL', 'Caterpillar', 2, '43', 459.90, 35, 'Botas de trabajo con puntera de acero, resistentes y duraderas', 'https://images.unsplash.com/photo-1605812860427-4024433a70fd', 1),
('Columbia Newton Ridge', 'COLM-NR', 'Columbia', 2, '40', 399.90, 32, 'Botas de montaña impermeables, tracción superior', 'https://images.unsplash.com/photo-1520639888713-7851133b1ed0', 1),
('The North Face Thermoball', 'TNF-TB', 'The North Face', 2, '42', 589.90, 20, 'Botas térmicas aisladas para clima frío extremo', 'https://images.unsplash.com/photo-1542840410-3092f99611a3', 1),

-- Formales (CategoryId = 3)
('Clarks Oxford', 'CLAR-OX', 'Clarks', 3, '42', 449.90, 25, 'Zapatos Oxford de cuero genuino, elegantes y versátiles', 'https://images.unsplash.com/photo-1533867617858-e7b97e060509', 1),
('Cole Haan Derby', 'COLE-DB', 'Cole Haan', 3, '41', 399.90, 22, 'Zapatos Derby clásicos, cómodos y elegantes para oficina', 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4', 1),
('Florsheim Monk Strap', 'FLOR-MS', 'Florsheim', 3, '43', 699.90, 15, 'Zapatos con hebilla doble, estilo sofisticado', 'https://images.unsplash.com/photo-1582897298507-4b39bcdeac3b', 1),
('Ecco Brogue', 'ECCO-BR', 'Ecco', 3, '42', 799.90, 18, 'Zapatos brogue con perforaciones decorativas, estilo clásico', 'https://images.unsplash.com/photo-1478181153992-6e3d2a19f1e0', 1),
('Bata Business', 'BATA-BU', 'Bata', 3, '41', 299.90, 30, 'Zapatos de negocios de cuero, calidad y confort', 'https://images.unsplash.com/photo-1549298916-b41d501d3772', 1),

-- Sandalias (CategoryId = 4)
('Birkenstock Arizona', 'BIRK-AZ', 'Birkenstock', 4, '42', 299.90, 40, 'Sandalias ortopédicas con plantilla contorneada', 'https://images.unsplash.com/photo-1603487742131-4160ec999306', 1),
('Teva Hurricane XLT2', 'TEVA-HX', 'Teva', 4, '41', 249.90, 35, 'Sandalias deportivas con correas ajustables', 'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d', 1),
('Reef Fanning', 'REEF-FA', 'Reef', 4, '40', 179.90, 45, 'Sandalias playeras con diseño abrebotellas', 'https://images.unsplash.com/photo-1598989667727-8a1e4e0b8f6e', 1),
('Havaianas Slim', 'HAVA-SL', 'Havaianas', 4, '39', 89.90, 70, 'Chanclas brasileñas de caucho, ligeras y coloridas', 'https://images.unsplash.com/photo-1562834802-1bbb18d7aaef', 1),
('Keen Newport H2', 'KEEN-NH', 'Keen', 4, '43', 349.90, 28, 'Sandalias híbridas con protección de dedos', 'https://images.unsplash.com/photo-1560343090-f0409e92791a', 1),
('Crocs Classic', 'CROC-CL', 'Crocs', 4, '42', 149.90, 55, 'Sandalias de espuma ultraligeras y cómodas', 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633', 1);

-- ============= CLIENTES =============
INSERT INTO Customers (FullName, DocumentNumber, Phone, Email, Address, IsActive) VALUES
('Carlos Rodríguez García', '12345678', '987654321', 'carlos.rodriguez@email.com', 'Av. Arequipa 1234, Lima', 1),
('María González López', '23456789', '987654322', 'maria.gonzalez@email.com', 'Jr. Lampa 567, Lima', 1),
('José Martínez Pérez', '34567890', '987654323', 'jose.martinez@email.com', 'Av. La Marina 890, Callao', 1),
('Ana Fernández Ruiz', '45678901', '987654324', 'ana.fernandez@email.com', 'Calle Los Cedros 123, San Isidro', 1),
('Luis Sánchez Torres', '56789012', '987654325', 'luis.sanchez@email.com', 'Av. Benavides 456, Miraflores', 1),
('Carmen Díaz Morales', '67890123', '987654326', 'carmen.diaz@email.com', 'Jr. Huallaga 789, Lima Centro', 1),
('Pedro Ramírez Castro', '78901234', '987654327', 'pedro.ramirez@email.com', 'Av. Javier Prado 321, San Borja', 1),
('Laura Jiménez Ortiz', '89012345', '987654328', 'laura.jimenez@email.com', 'Calle Las Flores 654, Surco', 1),
('Miguel Ángel Vargas', '90123456', '987654329', 'miguel.vargas@email.com', 'Av. Universitaria 987, Los Olivos', 1),
('Isabel Romero Núñez', '01234567', '987654330', 'isabel.romero@email.com', 'Jr. Ancash 159, Breña', 1);

-- ============= PROVEEDORES =============
INSERT INTO Suppliers (Name, DocumentNumber, Phone, Email, Address, IsActive) VALUES
('Distribuidora Nike Perú SAC', '20123456789', '015551234', 'ventas@nike.pe', 'Av. Javier Prado Este 123, Lima', 1),
('Adidas Perú Importaciones', '20234567890', '015552345', 'pedidos@adidas.pe', 'Av. Larco 456, Miraflores', 1),
('Calzados Bata Perú SA', '20345678901', '015553456', 'ventas@bata.com.pe', 'Jr. de la Unión 789, Lima', 1),
('Importaciones Clarks SAC', '20456789012', '015554567', 'contacto@clarks.pe', 'Av. Benavides 321, Surco', 1),
('Distribuidora Deportiva SAC', '20567890123', '015555678', 'ventas@distdeportiva.pe', 'Av. Colonial 654, Callao', 1);

-- =============================================
-- SECCIÓN 4: DATOS DE DEMOSTRACIÓN
-- =============================================

-- ============= VENTAS =============
INSERT INTO Sales (CustomerId, UserId, SaleDate, Total, Status) VALUES
(1, 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 899.80, 'Completed'),
(2, 2, DATE_SUB(NOW(), INTERVAL 28 DAY), 599.90, 'Completed'),
(3, 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 1049.80, 'Completed'),
(4, 2, DATE_SUB(NOW(), INTERVAL 22 DAY), 449.90, 'Completed'),
(5, 1, DATE_SUB(NOW(), INTERVAL 20 DAY), 749.80, 'Completed'),
(6, 2, DATE_SUB(NOW(), INTERVAL 18 DAY), 549.90, 'Completed'),
(7, 1, DATE_SUB(NOW(), INTERVAL 15 DAY), 699.90, 'Completed'),
(8, 2, DATE_SUB(NOW(), INTERVAL 12 DAY), 989.70, 'Completed'),
(9, 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 349.90, 'Completed'),
(10, 2, DATE_SUB(NOW(), INTERVAL 8 DAY), 599.90, 'Completed'),
(1, 1, DATE_SUB(NOW(), INTERVAL 6 DAY), 849.80, 'Completed'),
(2, 2, DATE_SUB(NOW(), INTERVAL 4 DAY), 449.90, 'Completed'),
(3, 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 499.90, 'Completed'),
(4, 2, DATE_SUB(NOW(), INTERVAL 1 DAY), 899.80, 'Completed'),
(5, 1, NOW(), 649.80, 'Completed');

-- ============= DETALLES DE VENTAS =============
INSERT INTO SaleDetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
-- Venta 1
(1, 1, 1, 499.90, 499.90),
(1, 5, 2, 189.90, 379.80),
-- Venta 2
(2, 2, 1, 599.90, 599.90),
-- Venta 3
(3, 1, 1, 499.90, 499.90),
(3, 3, 1, 399.90, 399.90),
(3, 22, 1, 89.90, 89.90),
-- Venta 4
(4, 14, 1, 449.90, 449.90),
-- Venta 5
(5, 6, 1, 279.90, 279.90),
(5, 7, 1, 249.90, 249.90),
(5, 19, 1, 249.90, 249.90),
-- Venta 6
(6, 10, 1, 549.90, 549.90),
-- Venta 7
(7, 9, 1, 699.90, 699.90),
-- Venta 8
(8, 8, 1, 549.90, 549.90),
(8, 14, 1, 449.90, 449.90),
-- Venta 9
(9, 4, 1, 349.90, 349.90),
-- Venta 10
(10, 2, 1, 599.90, 599.90),
-- Venta 11
(11, 1, 1, 499.90, 499.90),
(11, 4, 1, 349.90, 349.90),
-- Venta 12
(12, 14, 1, 449.90, 449.90),
-- Venta 13
(13, 1, 1, 499.90, 499.90),
-- Venta 14
(14, 2, 1, 599.90, 599.90),
(14, 5, 1, 189.90, 189.90),
(14, 21, 1, 179.90, 179.90),
-- Venta 15
(15, 3, 1, 399.90, 399.90),
(15, 7, 1, 249.90, 249.90);

-- ============= COMPRAS =============
INSERT INTO Purchases (SupplierId, UserId, PurchaseDate, Total, Status) VALUES
(1, 1, DATE_SUB(NOW(), INTERVAL 60 DAY), 15000.00, 'Completed'),
(2, 1, DATE_SUB(NOW(), INTERVAL 55 DAY), 12000.00, 'Completed'),
(3, 1, DATE_SUB(NOW(), INTERVAL 50 DAY), 8500.00, 'Completed'),
(4, 1, DATE_SUB(NOW(), INTERVAL 45 DAY), 10000.00, 'Completed'),
(5, 1, DATE_SUB(NOW(), INTERVAL 40 DAY), 6500.00, 'Completed'),
(1, 1, DATE_SUB(NOW(), INTERVAL 30 DAY), 11000.00, 'Completed'),
(2, 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 9500.00, 'Completed'),
(3, 1, DATE_SUB(NOW(), INTERVAL 20 DAY), 7200.00, 'Completed'),
(4, 1, DATE_SUB(NOW(), INTERVAL 15 DAY), 8800.00, 'Completed'),
(5, 1, DATE_SUB(NOW(), INTERVAL 10 DAY), 5900.00, 'Completed');

-- ============= DETALLES DE COMPRAS =============
INSERT INTO PurchaseDetails (PurchaseId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
-- Compra 1 - Nike
(1, 1, 50, 300.00, 15000.00),
-- Compra 2 - Adidas
(2, 2, 35, 350.00, 12250.00),
-- Compra 3 - Clarks
(3, 14, 25, 250.00, 6250.00),
(3, 15, 22, 220.00, 4840.00),
-- Compra 4 - Importaciones
(4, 9, 30, 420.00, 12600.00),
-- Compra 5 - Distribuidora
(5, 6, 38, 170.00, 6460.00),
-- Compra 6 - Nike
(6, 1, 35, 300.00, 10500.00),
(6, 8, 25, 330.00, 8250.00),
-- Compra 7 - Adidas
(7, 2, 20, 350.00, 7000.00),
(7, 3, 40, 240.00, 9600.00),
-- Compra 8 - Bata
(8, 18, 18, 480.00, 8640.00),
-- Compra 9 - Clarks
(9, 14, 20, 250.00, 5000.00),
(9, 16, 15, 200.00, 3000.00),
-- Compra 10 - Distribuidora
(10, 19, 35, 150.00, 5250.00),
(10, 20, 45, 110.00, 4950.00);

-- =============================================
-- VERIFICACIÓN Y MENSAJES FINALES
-- =============================================

COMMIT;

-- Mostrar resumen de instalación
SELECT '✓ Base de datos NobleStep creada exitosamente' AS Estado;
SELECT 'Sistema Web + E-commerce integrados' AS Descripcion;

-- Verificar datos cargados
SELECT 
    (SELECT COUNT(*) FROM Users) AS Usuarios,
    (SELECT COUNT(*) FROM Categories) AS Categorias,
    (SELECT COUNT(*) FROM Products) AS Productos,
    (SELECT COUNT(*) FROM Customers) AS Clientes,
    (SELECT COUNT(*) FROM Suppliers) AS Proveedores,
    (SELECT COUNT(*) FROM Sales) AS Ventas,
    (SELECT COUNT(*) FROM Purchases) AS Compras,
    (SELECT COUNT(*) FROM EcommerceCustomers) AS ClientesEcommerce,
    (SELECT COUNT(*) FROM Orders) AS PedidosEcommerce;

-- Mostrar tablas creadas
SHOW TABLES;
