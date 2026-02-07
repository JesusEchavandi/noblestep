-- ============================================
-- NOBLESTEP DATABASE - NUEVA INSTALACIÓN
-- Base de datos completa con todas las tablas
-- ============================================

-- Eliminar BD anterior si existe y crear nueva
DROP DATABASE IF EXISTS noblestep_db;
CREATE DATABASE noblestep_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE noblestep_db;

-- ============================================
-- TABLAS DEL SISTEMA ADMINISTRATIVO
-- ============================================

-- Users (Usuarios del sistema admin)
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
    INDEX idx_email (Email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Categories (Categorías de productos)
CREATE TABLE Categories (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(500),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (Name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Products (Productos)
CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(200) NOT NULL,
    Code VARCHAR(50) NULL,
    Brand VARCHAR(100) NOT NULL,
    CategoryId INT NOT NULL,
    Size VARCHAR(20) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    Stock INT NOT NULL,
    Description TEXT NULL,
    ImageUrl VARCHAR(500) NULL,
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    INDEX idx_category (CategoryId),
    INDEX idx_name (Name),
    INDEX idx_brand (Brand),
    INDEX idx_code (Code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Customers (Clientes del sistema)
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

-- Suppliers (Proveedores)
CREATE TABLE Suppliers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100) NOT NULL,
    DocumentNumber VARCHAR(20) NOT NULL UNIQUE,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(200),
    City VARCHAR(100),
    Country VARCHAR(100),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL,
    INDEX idx_name (CompanyName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sales (Ventas)
CREATE TABLE Sales (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    CustomerId INT NOT NULL,
    UserId INT NOT NULL,
    SaleDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Total DECIMAL(18,2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    INDEX idx_customer (CustomerId),
    INDEX idx_user (UserId),
    INDEX idx_date (SaleDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- SaleDetails (Detalles de ventas)
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

-- Purchases (Compras a proveedores)
CREATE TABLE Purchases (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    SupplierId INT NOT NULL,
    UserId INT NOT NULL,
    PurchaseDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    InvoiceNumber VARCHAR(50) NOT NULL,
    Total DECIMAL(18,2) NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'Completed',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SupplierId) REFERENCES Suppliers(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    INDEX idx_supplier (SupplierId),
    INDEX idx_user (UserId),
    INDEX idx_date (PurchaseDate)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PurchaseDetails (Detalles de compras)
CREATE TABLE PurchaseDetails (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    PurchaseId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitCost DECIMAL(18,2) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (PurchaseId) REFERENCES Purchases(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    INDEX idx_purchase (PurchaseId),
    INDEX idx_product (ProductId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLAS DEL E-COMMERCE
-- ============================================

-- EcommerceCustomers (Clientes registrados del e-commerce)
CREATE TABLE EcommerceCustomers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NULL,
    DocumentNumber VARCHAR(20) NULL,
    Address VARCHAR(300) NULL,
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

-- Orders (Pedidos del e-commerce - con y sin sesión)
CREATE TABLE Orders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    EcommerceCustomerId INT NULL,
    
    -- Información del cliente (para compras sin sesión)
    CustomerFullName VARCHAR(100) NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    CustomerPhone VARCHAR(20) NOT NULL,
    CustomerAddress VARCHAR(300) NOT NULL,
    CustomerCity VARCHAR(100) NOT NULL,
    CustomerDistrict VARCHAR(100) NOT NULL,
    CustomerReference VARCHAR(300) NULL,
    CustomerDocumentNumber VARCHAR(20) NULL,
    
    -- Información del pedido
    OrderNumber VARCHAR(50) NOT NULL UNIQUE,
    Subtotal DECIMAL(18,2) NOT NULL,
    ShippingCost DECIMAL(18,2) NOT NULL DEFAULT 0,
    Total DECIMAL(18,2) NOT NULL,
    
    -- Pago
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentDetails TEXT NULL,
    PaymentStatus VARCHAR(50) NOT NULL DEFAULT 'Pending',
    
    -- Estado del pedido
    OrderStatus VARCHAR(50) NOT NULL DEFAULT 'Pending',
    
    -- Facturación
    InvoiceType VARCHAR(20) NOT NULL DEFAULT 'Boleta',
    CompanyName VARCHAR(200) NULL,
    CompanyRUC VARCHAR(20) NULL,
    CompanyAddress VARCHAR(300) NULL,
    
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
    INDEX idx_status (OrderStatus)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- OrderDetails (Detalles de pedidos del e-commerce)
CREATE TABLE OrderDetails (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    
    -- Snapshot del producto al momento del pedido
    ProductName VARCHAR(200) NOT NULL,
    ProductCode VARCHAR(100) NOT NULL,
    ProductSize VARCHAR(50) NULL,
    ProductBrand VARCHAR(100) NULL,
    
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    Subtotal DECIMAL(18,2) NOT NULL,
    
    FOREIGN KEY (OrderId) REFERENCES Orders(Id) ON DELETE CASCADE,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    INDEX idx_order (OrderId),
    INDEX idx_product (ProductId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- DATOS DE PRUEBA
-- ============================================

-- Usuarios del sistema (password: admin123)
INSERT INTO Users (Username, PasswordHash, FullName, Email, Role, IsActive) VALUES
('admin', '$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK', 'Administrador del Sistema', 'admin@noblestep.com', 'Administrator', 1),
('vendedor1', '$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK', 'Juan Vendedor', 'vendedor@noblestep.com', 'Seller', 1);

-- Categorías
INSERT INTO Categories (Name, Description, IsActive) VALUES
('Zapatillas', 'Zapatillas deportivas y casuales', 1),
('Botas', 'Botas para trabajo y montaña', 1),
('Formales', 'Zapatos formales para oficina', 1),
('Sandalias', 'Sandalias y calzado de verano', 1);

-- Productos
INSERT INTO Products (Name, Code, Brand, CategoryId, Size, Price, Stock, Description, IsActive) VALUES
('Nike Air Max 2024', 'NK-AM24-42', 'Nike', 1, '42', 129.99, 25, 'Zapatillas deportivas con tecnología Air Max para máximo confort', 1),
('Adidas Ultraboost', 'AD-UB21-41', 'Adidas', 1, '41', 149.99, 20, 'Zapatillas running con tecnología Boost', 1),
('Clarks Desert Boot', 'CL-DB-42', 'Clarks', 2, '42', 119.99, 15, 'Botas clásicas de cuero genuino', 1),
('Oxford Professional', 'OX-PR-43', 'Oxford', 3, '43', 89.99, 30, 'Zapatos formales elegantes para oficina', 1),
('Timberland Work Boot', 'TB-WB-44', 'Timberland', 2, '44', 179.99, 12, 'Botas de trabajo resistentes e impermeables', 1),
('Puma Running Pro', 'PM-RP-41', 'Puma', 1, '41', 99.99, 35, 'Zapatillas running ligeras y respirables', 1),
('Teva Summer Sandal', 'TV-SS-42', 'Teva', 4, '42', 49.99, 40, 'Sandalias deportivas para verano', 1),
('Reebok Classic', 'RB-CL-42', 'Reebok', 1, '42', 79.99, 28, 'Zapatillas clásicas retro', 1),
('Caterpillar Work', 'CT-WK-43', 'Caterpillar', 2, '43', 159.99, 18, 'Botas industriales con puntera de acero', 1),
('Skechers Comfort', 'SK-CF-41', 'Skechers', 1, '41', 69.99, 45, 'Zapatillas ultra cómodas con memory foam', 1);

-- Clientes del sistema
INSERT INTO Customers (FullName, DocumentNumber, Phone, Email, Address, IsActive) VALUES
('Carlos Rodríguez', '45678912', '987654321', 'carlos.r@email.com', 'Av. Principal 123, Lima', 1),
('Ana Martínez', '78945612', '987123456', 'ana.m@email.com', 'Jr. Los Olivos 456, Miraflores', 1),
('Luis Fernández', '12398745', '956789123', 'luis.f@email.com', 'Calle Las Flores 789, San Isidro', 1);

-- Proveedores
INSERT INTO Suppliers (CompanyName, ContactName, DocumentNumber, Phone, Email, Address, City, Country, IsActive) VALUES
('Nike Perú SAC', 'Roberto Silva', '20456789123', '014567890', 'ventas@nike.pe', 'Av. Javier Prado 2500', 'Lima', 'Perú', 1),
('Adidas Distribution', 'María Torres', '20567891234', '014567891', 'ventas@adidas.pe', 'Av. Larco 1234', 'Lima', 'Perú', 1),
('Calzados Importados SAC', 'Jorge Vargas', '20678912345', '014567892', 'ventas@calzimport.com', 'Jr. Puno 567', 'Lima', 'Perú', 1);

COMMIT;

-- Verificación
SELECT 'Base de datos NOBLESTEP_DB creada exitosamente!' as Resultado;
SELECT COUNT(*) as TotalTablas FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'noblestep_db';
SELECT 'Tablas creadas:' as Info;
SHOW TABLES;
SELECT 'Datos insertados:' as Info;
SELECT 
    'Users' as Tabla, COUNT(*) as Registros FROM Users
UNION ALL SELECT 'Categories', COUNT(*) FROM Categories
UNION ALL SELECT 'Products', COUNT(*) FROM Products
UNION ALL SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL SELECT 'Suppliers', COUNT(*) FROM Suppliers;
