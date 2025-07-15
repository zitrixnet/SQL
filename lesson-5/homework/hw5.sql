easy bolim
-- 1. Alias bilan oddiy SELECT
SELECT 
    ProductName AS Name,
    Price AS Cost
FROM Products;

-- 2. UNION orqali ikkita jadvalni birlashtirish
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 3. CASE bilan shartli ustun yaratish
SELECT 
    ProductName,
    Price,
    CASE 
        WHEN Price > 100 THEN 'Expensive'
        WHEN Price > 50 THEN 'Moderate'
        ELSE 'Cheap'
    END AS PriceCategory
FROM Products;

-- 4. IIF (SQL Server uchun CASE qisqargani)
SELECT 
    ProductName,
    StockQuantity,
    IIF(StockQuantity > 50, 'Yes', 'No') AS InStock
FROM Products;

-- 5. Simple IF blok yordamida tekshirish
DECLARE @stock INT = 120;

IF @stock > 100
    PRINT 'Stock is sufficient';
ELSE
    PRINT 'Stock is low';

-- 6. WHILE sikl yordamida oddiy hisoblash
DECLARE @i INT = 1;

WHILE @i <= 5
BEGIN
    PRINT @i;
    SET @i = @i + 1;
END;

-- 7. Alias bilan jadvallarni JOIN qilish
SELECT 
    c.FirstName,
    s.ProductID,
    s.SaleAmount
FROM Sales s
INNER JOIN Customers c ON s.CustomerID = c.CustomerID;


medium bolim 
  
-- 1. INNER JOIN orqali ma’lumot olish
SELECT 
    s.SaleID,
    p.ProductName,
    c.FirstName AS CustomerFirstName,
    s.SaleAmount
FROM Sales s
INNER JOIN Products p ON s.ProductID = p.ProductID
INNER JOIN Customers c ON s.CustomerID = c.CustomerID;

-- 2. LEFT JOIN bilan mavjud bo‘lmagan mijozlarni ko‘rsatish
SELECT 
    c.CustomerID,
    c.FirstName,
    o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- 3. GROUP BY bilan umumiy sotuv summasini hisoblash
SELECT 
    ProductID,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID;

-- 4. HAVING bilan filtrlash (1000 dan ko‘p sotilgan mahsulotlar)
SELECT 
    ProductID,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID
HAVING SUM(SaleAmount) > 1000;

-- 5. UNION ALL bilan bir necha jadvalni qo‘shish
SELECT CustomerID, SaleAmount, SaleDate FROM Sales
UNION ALL
SELECT CustomerID, TotalAmount, InvoiceDate FROM Invoices;

-- 6. EXCEPT orqali farqni topish (Sales’da bor, Invoices’da yo‘q)
SELECT CustomerID FROM Sales
EXCEPT
SELECT CustomerID FROM Invoices;

-- 7. INTERSECT orqali umumiy mijozlarni topish
SELECT CustomerID FROM Sales
INTERSECT
SELECT CustomerID FROM Invoices;

-- 8. CASE bilan ko‘p shartli ustun yaratish
SELECT 
    OrderID,
    Quantity,
    CASE 
        WHEN Quantity > 10 THEN 'Bulk'
        WHEN Quantity BETWEEN 5 AND 10 THEN 'Medium'
        ELSE 'Small'
    END AS OrderSize
FROM Orders;

-- 9. IIF bilan shartli ustun
SELECT 
    OrderID,
    TotalAmount,
    IIF(TotalAmount > 500, 'High', 'Low') AS AmountCategory
FROM Orders;

-- 10. WHILE sikli yordamida ma’lumot chiqarish (masalan, 1 dan 10 gacha)
DECLARE @num INT = 1;
WHILE @num <= 10
BEGIN
    PRINT 'Number: ' + CAST(@num AS VARCHAR(10));
    SET @num = @num + 1;
END;


hard bolim

-- 1. ROW_NUMBER() yordamida har bir mijoz uchun sotuvlarni tartiblash (eng so‘nggi sotuvdan boshlab)
SELECT 
    SaleID,
    CustomerID,
    SaleDate,
    SaleAmount,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleDate DESC) AS SaleRank
FROM Sales;

-- 2. CTE (Common Table Expression) bilan yillik umumiy daromad hisoblash
WITH YearlySales AS (
    SELECT 
        YEAR(SaleDate) AS SaleYear,
        SUM(SaleAmount) AS TotalYearlySales
    FROM Sales
    GROUP BY YEAR(SaleDate)
)
SELECT * FROM YearlySales
WHERE TotalYearlySales > 5000;

-- 3. Recursive CTE orqali ketma-ket sanalarni chiqarish (masalan, 2023-01-01 dan 2023-01-10 gacha)
WITH DateSequence AS (
    SELECT CAST('2023-01-01' AS DATE) AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateSequence
    WHERE DateValue < '2023-01-10'
)
SELECT * FROM DateSequence
OPTION (MAXRECURSION 0);

-- 4. PIVOT yordamida yil bo‘yicha mijozlarning sotuv summasi jadvalini yaratish
SELECT CustomerID, [2023], [2024], [2025]
FROM (
    SELECT CustomerID, YEAR(SaleDate) AS SaleYear, SaleAmount
    FROM Sales
) AS SourceTable
PIVOT (
    SUM(SaleAmount)
    FOR SaleYear IN ([2023], [2024], [2025])
) AS PivotTable;

-- 5. CUBE yordamida mahsulot va mijoz bo‘yicha jami sotuvlar
SELECT 
    ProductID,
    CustomerID,
    SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CUBE (ProductID, CustomerID);

-- 6. MERGE operatori yordamida yangi ma’lumotlarni Sales jadvaliga qo‘shish yoki yangilash
MERGE Sales AS Target
USING (VALUES
    (41, 1, 1, '2023-03-01', 175.00),
    (42, 2, 2, '2023-03-02', 225.00)
) AS Source (SaleID, ProductID, CustomerID, SaleDate, SaleAmount)
ON Target.SaleID = Source.SaleID
WHEN MATCHED THEN
    UPDATE SET SaleAmount = Source.SaleAmount, SaleDate = Source.SaleDate
WHEN NOT MATCHED THEN
    INSERT (SaleID, ProductID, CustomerID, SaleDate, SaleAmount)
    VALUES (Source.SaleID, Source.ProductID, Source.CustomerID, Source.SaleDate, Source.SaleAmount);

-- 7. JSON FORMAT yordamida Orders jadvalidagi ma’lumotlarni JSON formatga chiqarish
SELECT 
    OrderID,
    CustomerID,
    ProductID,
    OrderDate,
    Quantity,
    TotalAmount
FROM Orders
FOR JSON AUTO;

-- 8. APPLY operatori bilan har bir mijoz uchun oxirgi 3 ta sotuvni olish (CROSS APPLY)
SELECT 
    c.CustomerID,
    c.FirstName,
    s.SaleID,
    s.SaleDate,
    s.SaleAmount
FROM Customers c
CROSS APPLY (
    SELECT TOP 3 *
    FROM Sales s
    WHERE s.CustomerID = c.CustomerID
    ORDER BY s.SaleDate DESC
) s;

-- 9. TRY_CAST yordamida noto‘g‘ri ma’lumotlarni tozalash (agar SaleAmount noto‘g‘ri bo‘lsa, 0 ga o‘zgartirish)
SELECT 
    SaleID,
    TRY_CAST(SaleAmount AS DECIMAL(10,2)) AS CleanSaleAmount
FROM Sales;

-- 10. Window funksiyalar bilan umumiy va o‘rtacha sotuvlarni ko‘rsatish
SELECT 
    SaleID,
    CustomerID,
    SaleAmount,
    SUM(SaleAmount) OVER () AS TotalSales,
    AVG(SaleAmount) OVER () AS AverageSale
FROM Sales;
