easy bolim


-- 1. Minimal product narxi
SELECT MIN(Price) AS MinPrice FROM Products;

-- 2. Eng katta ish haqi
SELECT MAX(Salary) AS MaxSalary FROM Employees;

-- 3. Customers jadvalidagi satrlar soni
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 4. Unikal product kategoriyalar soni
SELECT COUNT(DISTINCT Category) AS UniqueCategories FROM Products;

-- 5. ID=7 mahsulot uchun jami savdo miqdori
SELECT SUM(SaleAmount) AS TotalSalesForProduct7 FROM Sales WHERE ProductID = 7;

-- 6. Xodimlarning o‘rtacha yoshi
SELECT AVG(CAST(Age AS FLOAT)) AS AverageAge FROM Employees;

-- 7. Har bir bo‘limdagi xodimlar soni
SELECT DepartmentName, COUNT(*) AS EmployeeCount FROM Employees GROUP BY DepartmentName;

-- 8. Kategoriya bo‘yicha minimal va maksimal narx
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice FROM Products GROUP BY Category;

-- 9. Har bir mijoz uchun jami savdo
SELECT CustomerID, SUM(SaleAmount) AS TotalSalesPerCustomer FROM Sales GROUP BY CustomerID;

-- 10. 5 dan ko‘p xodim bor bo‘limlarni filtrlang
SELECT DepartmentName, COUNT(*) AS EmployeeCount FROM Employees GROUP BY DepartmentName HAVING COUNT(*) > 5;



medium bolim

-- 11. Har bir product kategoriyasi bo‘yicha jami va o‘rtacha savdo miqdori (Sales jadvalidan)
SELECT p.Category, 
       SUM(s.SaleAmount) AS TotalSales, 
       AVG(s.SaleAmount) AS AverageSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.Category;

-- 12. HR bo‘limidagi xodimlar soni (Employees jadvalidan)
SELECT COUNT(*) AS HR_EmployeeCount
FROM Employees
WHERE DepartmentName = 'HR';

-- 13. Har bir bo‘lim uchun eng katta va eng kichik ish haqi (Employees jadvalidan)
SELECT DepartmentName, 
       MAX(Salary) AS MaxSalary, 
       MIN(Salary) AS MinSalary
FROM Employees
GROUP BY DepartmentName;

-- 14. Har bir bo‘lim uchun o‘rtacha ish haqi (Employees jadvalidan)
SELECT DepartmentName, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentName;

-- 15. Har bir bo‘lim uchun o‘rtacha ish haqi va xodimlar soni (Employees jadvalidan)
SELECT DepartmentName, 
       AVG(Salary) AS AverageSalary, 
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- 16. O‘rtacha narxi 400 dan katta bo‘lgan product kategoriyalari (Products jadvalidan)
SELECT Category, AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

-- 17. Har yili jami savdo miqdori (Sales jadvalidan)
SELECT YEAR(SaleDate) AS SaleYear, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);

-- 18. Kamida 3 ta buyurtma bergan mijozlar ro‘yxati (Orders jadvalidan)
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 3;

-- 19. O‘rtacha ish haqi 60000 dan katta bo‘lgan bo‘limlar (Employees jadvalidan)
SELECT DepartmentName, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000;


hard bolim

-- 20. Har bir product kategoriyasi uchun o‘rtacha narx va 150 dan katta o‘rtacha narxga ega kategoriyalarni filtrlash
SELECT Category, AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150;

-- 21. Har bir mijoz uchun jami savdo miqdorini hisoblash va jami savdosi 1500 dan katta bo‘lgan mijozlarni filtrlash
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

-- 22. Har bir bo‘lim uchun jami va o‘rtacha ish haqini hisoblash va o‘rtacha ish haqi 65000 dan katta bo‘lgan bo‘limlarni filtrlash
SELECT DepartmentName, 
       SUM(Salary) AS TotalSalary, 
       AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;

-- 23. TSQL2012.sales.orders jadvalidan buyurtmalarning jami miqdorini hisoblash va eng kam xaridlarni (50 dan kichik yoki katta) ko‘rsatish (ma’lumotlar bazasi so‘ralgan)
-- (TSQL2012 bazasini hozirda qo‘lda kiritmaganmiz, shu yerda nazariy kod)
SELECT CustomerID, 
       SUM(TotalAmount) AS TotalAmountOver50, 
       MIN(TotalAmount) AS LeastPurchase
FROM Orders
WHERE Quantity > 50
GROUP BY CustomerID;

-- 24. Har oy va yil bo‘yicha jami savdo va noyob mahsulotlar sonini hisoblash, kamida 2 ta mahsulot sotilgan oylarni filtrlash (Orders jadvalidan)
SELECT YEAR(OrderDate) AS OrderYear, 
       MONTH(OrderDate) AS OrderMonth,
       SUM(TotalAmount) AS TotalSales,
       COUNT(DISTINCT ProductID) AS UniqueProductsSold
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING COUNT(DISTINCT ProductID) >= 2;

-- 25. Har yili uchun eng kichik va eng katta buyurtma miqdorini topish (Orders jadvalidan)
SELECT YEAR(OrderDate) AS OrderYear,
       MIN(Quantity) AS MinOrderQuantity,
       MAX(Quantity) AS MaxOrderQuantity
FROM Orders
GROUP BY YEAR(OrderDate);
