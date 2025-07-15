-- 1. Top 5 employees
SELECT TOP 5 * FROM Employees;

-- 2. Unique Categories from Products
SELECT DISTINCT Category FROM Products;

-- 3. Products with Price > 100
SELECT * FROM Products WHERE Price > 100;

-- 4. Customers whose FirstName starts with 'A'
SELECT * FROM Customers WHERE FirstName LIKE 'A%';

-- 5. Products ordered by Price ascending
SELECT * FROM Products ORDER BY Price ASC;

-- 6. Employees with Salary >= 60000 and Department = 'HR'
SELECT * FROM Employees WHERE Salary >= 60000 AND DepartmentName = 'HR';

-- 7. Replace NULL Email with 'noemail@example.com'
SELECT EmployeeID, FirstName, LastName,
       ISNULL(Email, 'noemail@example.com') AS Email,
       DepartmentName, Salary
FROM Employees;

-- 8. Products with Price BETWEEN 50 AND 100
SELECT * FROM Products WHERE Price BETWEEN 50 AND 100;

-- 9. DISTINCT on Category and ProductName
SELECT DISTINCT Category, ProductName FROM Products;

-- 10. DISTINCT + ORDER BY ProductName DESC
SELECT DISTINCT Category, ProductName FROM Products ORDER BY ProductName DESC;
-- 11. Top 10 products ordered by Price DESC
SELECT TOP 10 * FROM Products ORDER BY Price DESC;

-- 12. COALESCE FirstName or LastName in Employees
SELECT EmployeeID, COALESCE(FirstName, LastName) AS Name FROM Employees;

-- 13. DISTINCT Category and Price
SELECT DISTINCT Category, Price FROM Products;

-- 14. Employees Age between 30 and 40 or Department = 'Marketing'
SELECT * FROM Employees
WHERE (Age BETWEEN 30 AND 40) OR DepartmentName = 'Marketing';

-- 15. OFFSET-FETCH rows 11-20 by Salary DESC
SELECT * FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- 16. Products with Price <= 1000 and Stock > 50 ordered by Stock ASC
SELECT * FROM Products
WHERE Price <= 1000 AND StockQuantity > 50
ORDER BY StockQuantity ASC;

-- 17. Products where ProductName contains 'e'
SELECT * FROM Products
WHERE ProductName LIKE '%e%';

-- 18. Employees in HR, IT, or Finance
SELECT * FROM Employees
WHERE DepartmentName IN ('HR', 'IT', 'Finance');

-- 19. Customers ordered by City ASC and PostalCode DESC
SELECT * FROM Customers
ORDER BY City ASC, PostalCode DESC;

-- 20. Top 5 products by total sales amount (sum)
SELECT TOP 5 p.ProductID, p.ProductName, SUM(s.SaleAmount) AS TotalSales
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSales DESC;

-- 21. Combine FirstName and LastName as FullName
SELECT EmployeeID,
       COALESCE(FirstName, '') + ' ' + COALESCE(LastName, '') AS FullName
FROM Employees;

-- 22. DISTINCT Category, ProductName, Price for Price > 50
SELECT DISTINCT Category, ProductName, Price
FROM Products
WHERE Price > 50;

-- 23. Products where Price < 10% of average price
SELECT * FROM Products
WHERE Price < (SELECT AVG(Price)*0.1 FROM Products);

-- 24. Employees Age < 30 and Department HR or IT
SELECT * FROM Employees
WHERE Age < 30 AND DepartmentName IN ('HR', 'IT');

-- 25. Customers whose Email contains '@gmail.com'
SELECT * FROM Customers
WHERE Email LIKE '%@gmail.com';

-- 26. Employees with Salary greater than ALL salaries in Sales department
SELECT * FROM Employees
WHERE Salary > ALL (SELECT Salary FROM Employees WHERE DepartmentName = 'Sales');

-- 27. Orders placed in last 180 days from latest date in Orders
SELECT * FROM Orders
WHERE OrderDate BETWEEN DATEADD(DAY, -180, (SELECT MAX(OrderDate) FROM Orders))
                    AND (SELECT MAX(OrderDate) FROM Orders);
