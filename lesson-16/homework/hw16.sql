/* ==============================
   LESSON-16: CTEs and Derived Tables
   ============================== */

-----------------------------------
-- EASY TASKS
-----------------------------------

-- 1. Create a numbers table using a recursive query from 1 to 1000
WITH Numbers AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num + 1
    FROM Numbers
    WHERE Num < 1000
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 1000);

-- 2. Total sales per employee (Derived Table)
SELECT e.EmployeeID, e.FirstName, e.LastName, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID;

-- 3. Average salary of employees (CTE)
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT * FROM AvgSalary;

-- 4. Highest sales for each product (Derived Table)
SELECT p.ProductID, p.ProductName, t.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) t ON p.ProductID = t.ProductID;

-- 5. Beginning at 1, double until less than 1,000,000
WITH Doubles AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num * 2
    FROM Doubles
    WHERE Num * 2 < 1000000
)
SELECT * FROM Doubles
OPTION (MAXRECURSION 100);

-- 6. Employees who made more than 5 sales (CTE)
WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS SaleCount
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.*
FROM Employees e
JOIN SalesCount sc ON e.EmployeeID = sc.EmployeeID
WHERE sc.SaleCount > 5;

-- 7. Products with sales greater than $500 (CTE)
WITH ProductSales AS (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.*
FROM Products p
JOIN ProductSales ps ON p.ProductID = ps.ProductID
WHERE ps.TotalSales > 500;

-- 8. Employees with salary above average (CTE)
WITH AvgSal AS (
    SELECT AVG(Salary) AS AvgSalary FROM Employees
)
SELECT *
FROM Employees
WHERE Salary > (SELECT AvgSalary FROM AvgSal);


-----------------------------------
-- MEDIUM TASKS
-----------------------------------

-- 9. Top 5 employees by number of orders (Derived Table)
SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, t.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID
ORDER BY t.OrderCount DESC;

-- 10. Sales per product category (Derived Table)
SELECT p.CategoryID, SUM(s.SalesAmount) AS TotalSales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.CategoryID;

-- 11. Factorial of each value in Numbers1 (Recursive CTE)
WITH Factorial AS (
    SELECT Number, CAST(Number AS BIGINT) AS Fact, Number AS Step
    FROM Numbers1
    UNION ALL
    SELECT f.Number, f.Fact * (f.Step - 1), f.Step - 1
    FROM Factorial f
    WHERE f.Step > 1
)
SELECT Number, MAX(Fact) AS Factorial
FROM Factorial
GROUP BY Number;

-- 12. Split string into characters (Example table)
WITH RECURSIVE_SPLIT AS (
    SELECT Id, String, 1 AS Pos, SUBSTRING(String,1,1) AS CharVal
    FROM Example
    UNION ALL
    SELECT Id, String, Pos+1, SUBSTRING(String, Pos+1, 1)
    FROM RECURSIVE_SPLIT
    WHERE Pos+1 <= LEN(String)
)
SELECT * FROM RECURSIVE_SPLIT
OPTION (MAXRECURSION 100);

-- 13. Sales difference between current month and previous month (CTE)
WITH MonthlySales AS (
    SELECT YEAR(SaleDate) AS Yr, MONTH(SaleDate) AS Mn, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
),
SalesDiff AS (
    SELECT Yr, Mn, TotalSales,
           TotalSales - LAG(TotalSales) OVER (ORDER BY Yr, Mn) AS DiffFromPrev
    FROM MonthlySales
)
SELECT * FROM SalesDiff;

-- 14. Employees with sales over $45000 in each quarter (Derived Table)
SELECT e.EmployeeID, e.FirstName, e.LastName, t.Quarter, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID,
           DATEPART(QUARTER, SaleDate) AS Quarter,
           SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) t ON e.EmployeeID = t.EmployeeID;


-----------------------------------
-- DIFFICULT TASKS
-----------------------------------

-- 15. Fibonacci numbers (Recursive CTE)
WITH Fib (n, a, b) AS (
    SELECT 1, 0, 1
    UNION ALL
    SELECT n+1, b, a+b
    FROM Fib
    WHERE n < 20
)
SELECT n, a AS Fibonacci FROM Fib;

-- 16. Find string where all characters are the same and length > 1
SELECT *
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(Vals) = LEN(REPLACE(Vals, LEFT(Vals,1), '') ) + 1;

-- 17. Numbers sequence like 1, 12, 123... (Example: n=5)
WITH Seq AS (
    SELECT CAST('1' AS VARCHAR(50)) AS Val, 1 AS N
    UNION ALL
    SELECT Val + CAST(N+1 AS VARCHAR(10)), N+1
    FROM Seq
    WHERE N+1 <= 5
)
SELECT * FROM Seq;

-- 18. Employee with most sales in last 6 months (Derived Table)
SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID
ORDER BY t.TotalSales DESC;

-- 19. Remove duplicate integer values & single integer char from string
SELECT PawanName,
       Pawan_slug_name,
       -- Step1: remove duplicate digits using XML split
       (SELECT STRING_AGG(DISTINCT s.value('.', 'VARCHAR(1)'), '')
        FROM STRING_SPLIT(REPLACE(Pawan_slug_name, '-', ''), '') AS s
        WHERE ISNUMERIC(s.value('.', 'VARCHAR(1)')) = 0
       ) AS CleanedName
FROM RemoveDuplicateIntsFromNames;
