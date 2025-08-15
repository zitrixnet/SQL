-----------------------------------
-- LEVEL 1: BASIC SUBQUERIES
-----------------------------------

-- 1. Find Employees with Minimum Salary
SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- 2. Find Products Above Average Price
SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);


-----------------------------------
-- LEVEL 2: NESTED SUBQUERIES WITH CONDITIONS
-----------------------------------

-- 3. Find Employees in Sales Department
SELECT *
FROM employees
WHERE department_id = (
    SELECT id FROM departments WHERE department_name = 'Sales'
);

-- 4. Find Customers with No Orders
SELECT *
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM orders
);


-----------------------------------
-- LEVEL 3: AGGREGATION AND GROUPING IN SUBQUERIES
-----------------------------------

-- 5. Find Products with Max Price in Each Category
SELECT p.*
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
);

-- 6. Find Employees in Department with Highest Average Salary
SELECT *
FROM employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);


-----------------------------------
-- LEVEL 4: CORRELATED SUBQUERIES
-----------------------------------

-- 7. Find Employees Earning Above Department Average
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- 8. Find Students with Highest Grade per Course
SELECT s.student_id, s.name, g.course_id, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);


-----------------------------------
-- LEVEL 5: SUBQUERIES WITH RANKING AND COMPLEX CONDITIONS
-----------------------------------

-- 9. Find Third-Highest Price per Category
SELECT product_name, price, category_id
FROM (
    SELECT product_name, price, category_id,
           DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rnk
    FROM products
) t
WHERE rnk = 3;

-- 10. Find Employees whose Salary Between Company Average and Department Max Salary
SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees)
  AND salary < (
      SELECT MAX(salary)
      FROM employees
      WHERE department_id = e.department_id
  );
