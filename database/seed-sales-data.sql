-- Script para agregar datos de ventas de prueba al dashboard
-- Base de datos: noblestep_db

USE noblestep_db;

-- Insertar ventas de prueba
INSERT INTO sales (CustomerId, UserId, SaleDate, Total, Status, CreatedAt) VALUES
-- Ventas de hoy
(1, 1, NOW(), 259.98, 'Completed', NOW()),
(2, 1, NOW(), 189.98, 'Completed', NOW()),

-- Ventas de ayer
(1, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 299.97, 'Completed', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(3, 1, DATE_SUB(NOW(), INTERVAL 1 DAY), 149.99, 'Completed', DATE_SUB(NOW(), INTERVAL 1 DAY)),

-- Ventas hace 2 días
(2, 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 329.96, 'Completed', DATE_SUB(NOW(), INTERVAL 2 DAY)),

-- Ventas hace 3 días
(1, 1, DATE_SUB(NOW(), INTERVAL 3 DAY), 229.97, 'Completed', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 1, DATE_SUB(NOW(), INTERVAL 3 DAY), 179.98, 'Completed', DATE_SUB(NOW(), INTERVAL 3 DAY)),

-- Ventas hace 5 días
(3, 1, DATE_SUB(NOW(), INTERVAL 5 DAY), 269.97, 'Completed', DATE_SUB(NOW(), INTERVAL 5 DAY)),

-- Ventas del mes pasado
(1, 1, DATE_SUB(NOW(), INTERVAL 1 MONTH), 399.95, 'Completed', DATE_SUB(NOW(), INTERVAL 1 MONTH)),
(2, 1, DATE_SUB(NOW(), INTERVAL 1 MONTH), 289.97, 'Completed', DATE_SUB(NOW(), INTERVAL 1 MONTH)),

-- Ventas hace 2 meses
(1, 1, DATE_SUB(NOW(), INTERVAL 2 MONTH), 449.96, 'Completed', DATE_SUB(NOW(), INTERVAL 2 MONTH)),
(3, 1, DATE_SUB(NOW(), INTERVAL 2 MONTH), 199.98, 'Completed', DATE_SUB(NOW(), INTERVAL 2 MONTH));

-- Obtener IDs de las ventas recién insertadas
SET @sale1 = LAST_INSERT_ID();
SET @sale2 = @sale1 + 1;
SET @sale3 = @sale1 + 2;
SET @sale4 = @sale1 + 3;
SET @sale5 = @sale1 + 4;
SET @sale6 = @sale1 + 5;
SET @sale7 = @sale1 + 6;
SET @sale8 = @sale1 + 7;
SET @sale9 = @sale1 + 8;
SET @sale10 = @sale1 + 9;
SET @sale11 = @sale1 + 10;
SET @sale12 = @sale1 + 11;

-- Insertar detalles de ventas
-- Venta 1 (hoy)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale1, 1, 2, 129.99, 259.98);

-- Venta 2 (hoy)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale2, 4, 2, 89.99, 179.98),
(@sale2, 10, 1, 69.99, 69.99);

-- Venta 3 (ayer)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale3, 2, 2, 149.99, 299.98);

-- Venta 4 (ayer)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale4, 2, 1, 149.99, 149.99);

-- Venta 5 (hace 2 días)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale5, 5, 2, 179.99, 359.98);

-- Venta 6 (hace 3 días)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale6, 1, 1, 129.99, 129.99),
(@sale6, 6, 1, 99.99, 99.99);

-- Venta 7 (hace 3 días)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale7, 8, 2, 79.99, 159.98),
(@sale7, 10, 1, 69.99, 69.99);

-- Venta 8 (hace 5 días)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale8, 3, 2, 119.99, 239.98),
(@sale8, 7, 1, 49.99, 49.99);

-- Venta 9 (mes pasado)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale9, 1, 2, 129.99, 259.98),
(@sale9, 2, 1, 149.99, 149.99);

-- Venta 10 (mes pasado)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale10, 4, 3, 89.99, 269.97),
(@sale10, 10, 1, 69.99, 69.99);

-- Venta 11 (hace 2 meses)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale11, 5, 2, 179.99, 359.98),
(@sale11, 1, 1, 129.99, 129.99);

-- Venta 12 (hace 2 meses)
INSERT INTO saledetails (SaleId, ProductId, Quantity, UnitPrice, Subtotal) VALUES
(@sale12, 8, 2, 79.99, 159.98),
(@sale12, 7, 1, 49.99, 49.99);

-- Actualizar stock de productos (reducir por las ventas)
UPDATE products SET Stock = Stock - 4 WHERE Id = 1;  -- Nike Air Max
UPDATE products SET Stock = Stock - 3 WHERE Id = 2;  -- Adidas
UPDATE products SET Stock = Stock - 2 WHERE Id = 3;  -- Clarks
UPDATE products SET Stock = Stock - 5 WHERE Id = 4;  -- Oxford
UPDATE products SET Stock = Stock - 4 WHERE Id = 5;  -- Timberland
UPDATE products SET Stock = Stock - 1 WHERE Id = 6;  -- Puma
UPDATE products SET Stock = Stock - 2 WHERE Id = 7;  -- Teva
UPDATE products SET Stock = Stock - 4 WHERE Id = 8;  -- Reebok
UPDATE products SET Stock = Stock - 3 WHERE Id = 10; -- Skechers

COMMIT;

-- Verificar resultados
SELECT 'Ventas creadas:' as Info, COUNT(*) as Total FROM sales;
SELECT 'Detalles de venta creados:' as Info, COUNT(*) as Total FROM saledetails;
SELECT 'Total vendido:' as Info, SUM(Total) as Total FROM sales WHERE Status = 'Completed';

SELECT 'Productos más vendidos:' as Info;
SELECT 
    p.Name, 
    SUM(sd.Quantity) as CantidadVendida,
    SUM(sd.Subtotal) as TotalVentas
FROM saledetails sd
JOIN products p ON sd.ProductId = p.Id
GROUP BY p.Name
ORDER BY TotalVentas DESC
LIMIT 5;
