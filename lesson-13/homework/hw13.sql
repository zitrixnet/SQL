/* =====================================
   EASY
===================================== */

-- Puzzle 1: emp_id + first_name + last_name
SELECT CAST(emp_id AS VARCHAR) + '-' + first_name + ' ' + last_name AS EmpFullName
FROM employees;

-- Puzzle 2: Replace '124' with '999' in phone_number
UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

-- Puzzle 3: First name + length where starts with A, J, or M
SELECT first_name AS FirstName,
       LEN(first_name) AS NameLength
FROM employees
WHERE first_name LIKE 'A%' OR first_name LIKE 'J%' OR first_name LIKE 'M%'
ORDER BY first_name;

-- Puzzle 4: Total salary per manager_id
SELECT manager_id, SUM(salary) AS TotalSalary
FROM employees
GROUP BY manager_id;

-- Puzzle 5: Year + highest value from Max1, Max2, Max3
SELECT year,
       (SELECT MAX(v) FROM (VALUES (Max1), (Max2), (Max3)) AS value(v)) AS HighestValue
FROM TestMax;

-- Puzzle 6: Odd numbered movies, description not boring
SELECT *
FROM cinema
WHERE id % 2 = 1 AND description <> 'boring';

-- Puzzle 7: Sort by Id, but Id=0 last
SELECT *
FROM SingleOrder
ORDER BY CASE WHEN id = 0 THEN 1 ELSE 0 END, id;

-- Puzzle 8: First non-null value from columns
SELECT COALESCE(col1, col2, col3, col4) AS FirstNonNull
FROM person;


/* =====================================
   MEDIUM
===================================== */

-- Puzzle 9: Products grouped by price range
SELECT productname,
       CASE
            WHEN price < 100 THEN 'Low'
            WHEN price BETWEEN 100 AND 500 THEN 'Mid'
            WHEN price > 500 THEN 'High'
       END AS PriceCategory
FROM Products;

-- Puzzle 10: Pivot years into columns
SELECT district_name, [2012], [2013]
INTO Population_Each_Year
FROM City_Population
PIVOT (
    SUM(population)
    FOR year IN ([2012], [2013])
) AS pvt;

-- Puzzle 11: Pivot cities into columns
SELECT year, [Bektemir], [Chilonzor], [Yakkasaroy]
INTO Population_Each_City
FROM City_Population
PIVOT (
    SUM(population)
    FOR city IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS pvt;

-- Puzzle 12: Wildcard search for 'oo'
SELECT productname
FROM Products
WHERE productname LIKE '%oo%';

-- Puzzle 13: Top 3 customers by total invoice amount
SELECT TOP 3 CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- Puzzle 14: Unpivot Population_Each_Year to original format
SELECT district_name, year, population
FROM Population_Each_Year
UNPIVOT (
    population FOR year IN ([2012], [2013])
) AS unpvt;

-- Puzzle 15: Join Products and Sales to count sold items
SELECT p.ProductName, COUNT(s.SaleID) AS TimesSold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;


/* =====================================
   HARD
===================================== */

-- Puzzle 16: Find employees earning more than their managers
SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;

-- Puzzle 17: Remove duplicate emails from Person table
DELETE p
FROM Person p
JOIN Person p2
  ON p.email = p2.email
 AND p.id > p2.id;

-- Puzzle 18: Students and attended exams cross join subjects
SELECT s.student_id, s.student_name, sub.subject_name,
       COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id
 AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
