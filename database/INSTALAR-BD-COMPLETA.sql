-- NobleStep Complete Database Setup
-- Includes: System Tables + E-commerce Tables
-- MySQL Database

-- Drop and recreate database
DROP DATABASE IF EXISTS noblestepdb;
CREATE DATABASE noblestepdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE noblestepdb;

-- ==============================================
-- SYSTEM TABLES (Admin Panel)
-- ==============================================

-- Users Table
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
) ENGINE=InnoDB;

-- Categories Table
CREATE TABLE Categories (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(500),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (Name)
) ENGINE=InnoDB;

-- Products Table
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
) ENGINE=InnoDB;

-- Customers Table (System)
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
) ENGINE=InnoDB;

-- Suppliers Table
CREATE TABLE Suppliers (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DocumentNumber VARCHAR(20) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(255),
    IsActive TINYINT(1) NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL,
    INDEX idx_name (Name)
) ENGINE=InnoDB;

-- Sales Table
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
) ENGINE=InnoDB;

-- SaleDetails Table
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
) ENGINE=InnoDB;

-- Purchases Table
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
    INDEX idx_date (PurchaseDate)
) ENGINE=InnoDB;

-- PurchaseDetails Table
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
) ENGINE=InnoDB;

-- ==============================================
-- E-COMMERCE TABLES
-- ==============================================

-- EcommerceCustomers Table
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
) ENGINE=InnoDB;

-- Orders Table
CREATE TABLE Orders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    EcommerceCustomerId INT NULL,
    
    -- Customer Info (for guests)
    CustomerFullName VARCHAR(100) NOT NULL,
    CustomerEmail VARCHAR(100) NOT NULL,
    CustomerPhone VARCHAR(20) NOT NULL,
    CustomerAddress VARCHAR(255) NOT NULL,
    CustomerCity VARCHAR(100) NOT NULL,
    CustomerDistrict VARCHAR(100) NOT NULL,
    CustomerReference VARCHAR(255) NULL,
    CustomerDocumentNumber VARCHAR(20) NULL,
    
    -- Order Info
    OrderNumber VARCHAR(50) NOT NULL UNIQUE,
    Subtotal DECIMAL(18,2) NOT NULL,
    ShippingCost DECIMAL(18,2) NOT NULL DEFAULT 0,
    Total DECIMAL(18,2) NOT NULL,
    
    -- Payment
    PaymentMethod VARCHAR(50) NOT NULL,
    PaymentDetails TEXT NULL,
    PaymentStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
    
    -- Order Status
    OrderStatus VARCHAR(20) NOT NULL DEFAULT 'Pending',
    
    -- Invoice
    InvoiceType VARCHAR(20) NOT NULL DEFAULT 'Boleta',
    CompanyName VARCHAR(200) NULL,
    CompanyRUC VARCHAR(20) NULL,
    CompanyAddress VARCHAR(255) NULL,
    
    -- Dates
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
) ENGINE=InnoDB;

-- OrderDetails Table
CREATE TABLE OrderDetails (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    
    -- Product snapshot
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
) ENGINE=InnoDB;

-- ==============================================
-- SEED DATA
-- ==============================================

-- Users (password: admin123)
INSERT INTO Users (Username, PasswordHash, FullName, Email, Role, IsActive) VALUES
('admin', '$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK', 'System Administrator', 'admin@noblestep.com', 'Administrator', 1),
('seller1', '$2a$11$mSiqqJc66CfN.QSbauOBaexU2tSznqKFHKUKj3KX4D3UaaIGWK4qK', 'John Seller', 'seller@noblestep.com', 'Seller', 1);

-- Categories
INSERT INTO Categories (Name, Description, IsActive) VALUES
('Zapatillas', 'Zapatillas deportivas y casuales', 1),
('Botas', 'Botas para trabajo y montaña', 1),
('Formales', 'Zapatos formales para oficina', 1),
('Sandalias', 'Sandalias y calzado de verano', 1);

-- Products
INSERT INTO Products (Name, Code, Brand, CategoryId, Size, Price, Stock, Description, IsActive) VALUES
('Air Max 2024', 'NIKE-AM24', 'Nike', 1, '42', 129.99, 25, 'Zapatillas deportivas con tecnología Air Max', 1),
('Classic Runner', 'ADID-CR', 'Adidas', 1, '41', 89.99, 30, 'Zapatillas running clásicas', 1),
('Professional Oxford', 'CLAR-OX', 'Clarks', 3, '42', 149.99, 15, 'Zapatos formales Oxford', 1),
('Business Leather', 'COLE-BL', 'Cole Haan', 3, '43', 199.99, 10, 'Zapatos de cuero para negocios', 1),
('Trail Runner Pro', 'SALO-TR', 'Salomon', 1, '42', 159.99, 20, 'Zapatillas para trail running', 1),
('Comfort Loafer', 'SKEC-CL', 'Skechers', 1, '41', 69.99, 40, 'Mocasines cómodos', 1),
('Work Boot', 'TIMB-WB', 'Timberland', 2, '43', 189.99, 15, 'Botas de trabajo resistentes', 1),
('Summer Sandal', 'TEVA-SS', 'Teva', 4, '42', 49.99, 35, 'Sandalias de verano', 1);

-- Customers
INSERT INTO Customers (FullName, DocumentNumber, Phone, Email, IsActive) VALUES
('Juan Pérez', '12345678', '999888777', 'juan.perez@email.com', 1),
('María García', '87654321', '999777666', 'maria.garcia@email.com', 1),
('Carlos López', '11223344', '999666555', 'carlos.lopez@email.com', 1);

-- Suppliers
INSERT INTO Suppliers (Name, DocumentNumber, Phone, Email, Address, IsActive) VALUES
('Nike Distribution SAC', '20123456789', '014567890', 'ventas@nike.com.pe', 'Av. Javier Prado 123, Lima', 1),
('Adidas Peru SAC', '20234567890', '014567891', 'ventas@adidas.com.pe', 'Av. Larco 456, Miraflores', 1),
('Importadora Calzados SA', '20345678901', '014567892', 'ventas@importcalzados.com', 'Jr. Huallaga 789, Lima', 1);

COMMIT;

SELECT 'Database installed successfully!' as Status;
SELECT 'Tables created:' as Info;
SHOW TABLES;
