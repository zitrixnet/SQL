/* ==============================
   EASY
============================== */

-- 1) emp_id + first_name + last_name formatida ko‘rsatish
SELECT CAST(emp_id AS VARCHAR) + '-' + first_name + ' ' + last_name AS EmpFullName
FROM employees;

-- 2) phone_number ichidagi '124'ni '999'ga almashtirish
UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

-- 3) A, J yoki M harfi bilan boshlanuvchi ism + uzunligi
SELECT first_name AS FirstName,
       LEN(first_name) AS NameLength
FROM employees
WHERE first_name LIKE 'A%' OR first_name LIKE 'J%' OR first_name LIKE 'M%'
ORDER BY first_name;

-- 4) Har bir manager_id bo‘yicha umumiy maosh
SELECT manager_id, SUM(salary) AS TotalSalary
FROM employees
GROUP BY manager_id;

-- 5) Har bir yilda Max1, Max2, Max3 ichidan eng kattasini topish
SELECT year,
       (SELECT MAX(v) FROM (VALUES (Max1), (Max2), (Max3)) AS value(v)) AS HighestValue
FROM TestMax;

-- 6) Id toq bo‘lgan va description 'boring' bo‘lmagan kinolar
SELECT *
FROM cinema
WHERE id % 2 = 1 AND description <> 'boring';

-- 7) Id bo‘yicha sort qilish, ammo Id=0 eng oxirda
SELECT *
FROM SingleOrder
ORDER BY CASE WHEN id = 0 THEN 1 ELSE 0 END, id;

-- 8) Birinchi bo‘sh bo‘lmagan qiymatni olish
SELECT COALESCE(col1, col2, col3, col4) AS FirstNonNull
FROM person;


/* ==============================
   MEDIUM
============================== */

-- 9) Mahsulotlarni narx oralig‘iga ko‘ra guruhlash
SELECT productname,
       CASE
            WHEN price < 100 THEN 'Low'
            WHEN price BETWEEN 100 AND 500 THEN 'Mid'
            WHEN price > 500 THEN 'High'
       END AS PriceCategory
FROM Products;

-- 10) Yillarni ustun qilib Pivot qilish
SELECT district_name, [2012], [2013]
INTO Population_Each_Year
FROM City_Population
PIVOT (
    SUM(population)
    FOR year IN ([2012], [2013])
) AS pvt;

-- 11) Shaharlarni ustun qilib Pivot qilish
SELECT year, [Bektemir], [Chilonzor], [Yakkasaroy]
INTO Population_Each_City
FROM City_Population
PIVOT (
    SUM(population)
    FOR city IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS pvt;

-- 12) Nomi ichida 'oo' bo‘lgan mahsulotlar
SELECT productname
FROM Products
WHERE productname LIKE '%oo%';

-- 13) Eng ko‘p pul sarflagan Top 3 mijoz
SELECT TOP 3 CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

-- 14) Population_Each_Year jadvalini Unpivot qilib asl holiga keltirish
SELECT district_name, year, population
FROM Population_Each_Year
UNPIVOT (
    population FOR year IN ([2012], [2013])
) AS unpvt;

-- 15) Products va Sales join qilib nechta sotilganini topish
SELECT p.ProductName, COUNT(s.SaleID) AS TimesSold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductName;


/* ==============================
   HARD
============================== */

-- 16) O‘z boshlig‘idan ko‘p maosh olgan xodimlar
SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;

-- 17) Person jadvalidan dublikat email’larni o‘chirish
DELETE p
FROM Person p
JOIN Person p2
  ON p.email = p2.email
 AND p.id > p2.id;

-- 18) Students × Subjects cross join, attended_exams sanash
SELECT s.student_id, s.student_name, sub.subject_name,
       COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
  ON s.student_id = e.student_id
 AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
