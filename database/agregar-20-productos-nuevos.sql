-- ========================================
-- SCRIPT: Agregar 20 Productos Nuevos
-- Fecha: 7 de Febrero, 2026
-- Descripción: Productos variados para demostración
-- ========================================

USE noblestep_db;

-- Insertar 20 productos nuevos distribuidos en las 4 categorías existentes
INSERT INTO Products (Code, Name, Brand, CategoryId, Size, Price, Stock, Description, IsActive, CreatedAt, UpdatedAt)
VALUES
-- Zapatillas (CategoryId = 1)
('PROD-021', 'Zapatillas Nike Air Max 270', 'Nike', 1, '42', 499.00, 25, 'Zapatillas deportivas con tecnología Air, suela de espuma, diseño moderno y cómodo', 1, NOW(), NOW()),
('PROD-022', 'Zapatillas Adidas Ultraboost', 'Adidas', 1, '41', 599.00, 18, 'Zapatillas running con tecnología Boost, máximo confort y respuesta energética', 1, NOW(), NOW()),
('PROD-023', 'Zapatillas Puma RS-X', 'Puma', 1, '40', 399.00, 30, 'Zapatillas urbanas retro, diseño llamativo, ideal para uso casual', 1, NOW(), NOW()),
('PROD-024', 'Zapatillas New Balance 574', 'New Balance', 1, '43', 349.00, 22, 'Zapatillas clásicas con suela ENCAP, comodidad todo el día', 1, NOW(), NOW()),
('PROD-025', 'Zapatillas Converse All Star', 'Converse', 1, '39', 189.00, 45, 'Zapatillas icónicas de lona, estilo atemporal y versátil', 1, NOW(), NOW()),

-- Botas (CategoryId = 2)
('PROD-026', 'Botas Timberland Premium 6"', 'Timberland', 2, '42', 699.00, 15, 'Botas impermeables de cuero premium, ideales para trekking y uso rudo', 1, NOW(), NOW()),
('PROD-027', 'Botas Dr. Martens 1460', 'Dr. Martens', 2, '41', 549.00, 20, 'Botas de cuero suave, icónicas, con suela AirWair resistente', 1, NOW(), NOW()),
('PROD-028', 'Botas Caterpillar Colorado', 'Caterpillar', 2, '43', 459.00, 18, 'Botas de trabajo con puntera de acero, resistentes y duraderas', 1, NOW(), NOW()),
('PROD-029', 'Botas Columbia Newton Ridge', 'Columbia', 2, '40', 399.00, 25, 'Botas de montaña impermeables, tracción superior en terrenos difíciles', 1, NOW(), NOW()),
('PROD-030', 'Botas North Face Thermoball', 'The North Face', 2, '42', 589.00, 12, 'Botas térmicas aisladas, perfectas para clima frío extremo', 1, NOW(), NOW()),

-- Formales (CategoryId = 3)
('PROD-031', 'Zapatos Oxford Clarks', 'Clarks', 3, '42', 449.00, 20, 'Zapatos Oxford de cuero genuino, elegantes para ocasiones formales', 1, NOW(), NOW()),
('PROD-032', 'Mocasines Gucci Horsebit', 'Gucci', 3, '41', 1299.00, 8, 'Mocasines de lujo con detalle metálico, estilo italiano premium', 1, NOW(), NOW()),
('PROD-033', 'Zapatos Derby Florsheim', 'Florsheim', 3, '43', 399.00, 15, 'Zapatos Derby clásicos, cómodos y elegantes para oficina', 1, NOW(), NOW()),
('PROD-034', 'Zapatos Monk Strap Magnanni', 'Magnanni', 3, '42', 699.00, 10, 'Zapatos con hebilla doble, artesanía española de alta calidad', 1, NOW(), NOW()),
('PROD-035', 'Zapatos Brogue Allen Edmonds', 'Allen Edmonds', 3, '41', 799.00, 12, 'Zapatos brogue con perforaciones decorativas, estilo clásico británico', 1, NOW(), NOW()),

-- Sandalias (CategoryId = 4)
('PROD-036', 'Sandalias Birkenstock Arizona', 'Birkenstock', 4, '42', 299.00, 30, 'Sandalias ortopédicas con plantilla contorneada, máximo confort', 1, NOW(), NOW()),
('PROD-037', 'Sandalias Teva Hurricane XLT2', 'Teva', 4, '41', 249.00, 25, 'Sandalias deportivas con correas ajustables, ideales para aventuras', 1, NOW(), NOW()),
('PROD-038', 'Sandalias Reef Fanning', 'Reef', 4, '40', 179.00, 35, 'Sandalias playeras con abrebotellas en la suela, estilo surfer', 1, NOW(), NOW()),
('PROD-039', 'Sandalias Havaianas Slim', 'Havaianas', 4, '39', 89.00, 50, 'Chanclas brasileñas de caucho, ligeras y coloridas para verano', 1, NOW(), NOW()),
('PROD-040', 'Sandalias Keen Newport H2', 'Keen', 4, '43', 349.00, 20, 'Sandalias híbridas con protección de dedos, perfectas para agua y tierra', 1, NOW(), NOW());

-- Verificar inserción
SELECT 
    COUNT(*) as 'Productos Agregados',
    MIN(CreatedAt) as 'Primer Producto',
    MAX(CreatedAt) as 'Último Producto'
FROM Products 
WHERE Code LIKE 'PROD-0%' AND Code >= 'PROD-021';

-- Mostrar resumen por categoría
SELECT 
    c.Name as Categoría,
    COUNT(p.Id) as 'Cantidad de Productos',
    MIN(p.Price) as 'Precio Mínimo',
    MAX(p.Price) as 'Precio Máximo',
    AVG(p.Price) as 'Precio Promedio'
FROM Products p
INNER JOIN Categories c ON p.CategoryId = c.Id
WHERE p.Code LIKE 'PROD-0%' AND p.Code >= 'PROD-021'
GROUP BY c.Name
ORDER BY COUNT(p.Id) DESC;

-- Productos agregados ordenados por precio
SELECT 
    Code as Código,
    Name as Producto,
    Brand as Marca,
    CONCAT('S/ ', FORMAT(Price, 2)) as Precio,
    Stock,
    (SELECT Name FROM Categories WHERE Id = CategoryId) as Categoría
FROM Products
WHERE Code LIKE 'PROD-0%' AND Code >= 'PROD-021'
ORDER BY Price DESC;
