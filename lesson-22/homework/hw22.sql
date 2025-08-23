go 
use Revise_And_Check_Class22

CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

--puzzle 1
--Compute Running Total Sales per Customer

with cte as 
(
select *,
	sum(total_amount) over (partition by customer_id 
						order by order_date  
						rows between unbounded preceding and current row ) as harkungi
from sales_data
) select * from cte 

--puzzle 2
--Count the Number of Orders per Product Category

select *,
	count(sale_id) over (partition by product_category )
from sales_data

OR

SELECT product_category, COUNT(sale_id) AS total_orders
FROM sales_data
GROUP BY product_category;

--puzzle 3
--Find the Maximum Total Amount per Product Category

select *,
	MAX(total_amount) OVER (PARTITION BY PRODUCT_CATEGORY) AS MAX_AMOUNT_OF_THE_CATEGORIES
from sales_data

OR

SELECT product_category,
MAX(total_amount) AS MAX_AMOUNT_OF_THE_CATEGORIES
FROM sales_data
GROUP BY product_category

--PUZZLE 4
--Find the Minimum Price of Products per Product Category

SELECT *,
	MIN(total_amount) OVER (PARTITION BY PRODUCT_CATEGORY) AS MIN_AMOUNT_OF_CATEGORIES
FROM sales_data

OR

SELECT product_category,
	MIN(total_amount) AS MIN_TOTAL_AMOUNT
FROM sales_data
GROUP BY product_category

--PUZZLE 5
--Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)

SELECT *,
	AVG(total_amount) OVER (ORDER BY ORDER_DATE ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
FROM sales_data

--PUZZLE 6
--Find the Total Sales per Region

SELECT *,
	SUM(total_amount) OVER (PARTITION BY Region) AS TotalAmountEachOfTheRegion
FROM sales_data

or

select region,
	sum(total_amount) as TotalAmountEachOfTheRegion
from sales_data
group by region

--puzzle 7
--Compute the Rank of Customers Based on Their Total Purchase Amount

select customer_id,
		customer_name,
	sum(total_amount) as toplam_fiyat,
	rank() over (order by sum(total_amount) desc) as NechtaMartaHaridQilgani
from sales_data
group by customer_id, customer_name

--puzzle 8
--Calculate the Difference Between Current and Previous Sale Amount per Customer

select *,
	total_amount - lag(total_amount) over 
	(partition by customer_id 
	order by order_date )
from sales_data

--puzzle 9
--Find the Top 3 Most Expensive Products in Each Category

select  *,
	MAX(unit_price) over (partition by product_category )	
from sales_data

or

select product_category, product_name,
	max(unit_price)  
from sales_data
group by product_category, product_name 
order by product_name

--puzzle 10
--Compute the Cumulative Sum of Sales Per Region by Order Date

select *,
	sum(total_amount) over (
	partition by region 
	order by order_date 
	rows between unbounded preceding and current row ) as CumulativeTotal
from sales_data

--puzzle 11
--Compute Cumulative Revenue per Product Category

select *,
	sum(total_amount) over (
		partition by product_category
		order by order_date
		rows between unbounded preceding and current row) as CumulativeRevenue
from sales_data

--puzzle 12
--Here you need to find out the sum of previous values. Please go through the sample input and expected output.

create table Sample_Table (id int)
 
insert into Sample_Table (id)values 
(1),
(2),
(3),
(4),
(5)

select *,
		sum(id) over (
		order by id 
		rows between unbounded preceding and current row
	)as dsda
from Sample_Table


--puzzle 13
--Sum of Previous Values to Current Value

CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

select *,
	sum(Value) over (
	order by value 
	rows between 1 preceding and current row)
from OneColumn

--puzzle 14
--Find customers who have purchased items from more than one product_category

select * from
(
select *,
	count(product_category) over (partition by customer_id) as CategoryCount
from sales_data
) as sdja
where CategoryCount > 1

--puzzle 15
--Find Customers with Above-Average Spending in Their Region

with cte as 
(
select *,
       avg(total_amount) over (partition by region) as AbovePurchase
from sales_data
) select * from cte 
where total_amount > AbovePurchase

--or


SELECT customer_id,
       customer_name,
       total_amount
FROM sales_data s
JOIN (
    SELECT region,
           AVG(total_amount) AS avg_region_spending
    FROM sales_data
    GROUP BY region
) r
ON s.region = r.region
WHERE s.total_amount > r.avg_region_spending
ORDER BY s.region, s.total_amount DESC;

--puzzle 16
--Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.

select *,
	dense_rank() over (
	partition by region
	order by total_amount desc) as RanklanganHolati
from sales_data

--puzzle 17
--Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.

select *,
	sum(total_amount) over (
	partition by customer_id
	order by order_date)
from sales_data

--puzzle 18
--Calculate the sales growth rate (growth_rate) for each month compared to the previous month.

select year(order_date),
		month(order_date),
		sum(total_amount),
	lag(sum(total_amount) over (order by year(order_date), month(order_date)) as prev_monthly_sales
	(sum(total_amount) - lag(sum(total_amount)
from sales_data\

--puzzle 19
--Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)

with cte as 
(
select *,
	lag(total_amount) over (
	partition by customer_id 
	order by order_date) as PreSales
from sales_data
) select * from cte 
where total_amount > PreSales

select * from sales_data
order by customer_name

--puzzle 20
--Identify Products that prices are above the average product price

select * from
(
select *,
	avg(total_amount) over (partition by product_category) as norma
from sales_data
) as sub
where total_amount > norma

--puzzle 21
--In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. The challenge here is to do this in a single select. For more details please see the sample input and expected output.

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

select *,
   case
   when row_number () over (partition by grp order by Id) = 1
	then sum(Val1 + Val2) over (partition by grp)
	else null
	end as sss
from MyData

--puzzle 22
--Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.

CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

WITH cte AS 
(
    SELECT 
        ID,
        Cost,
        Quantity,
        SUM(Cost) OVER (PARTITION BY ID) AS TotalCost,
        SUM(Quantity) OVER (PARTITION BY ID) AS TotalQuantity,
        ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ID) AS rn
    FROM TheSumPuzzle
)
SELECT ID, TotalCost, TotalQuantity
FROM cte
WHERE rn = 1
ORDER BY ID;

--puzzle 23
--From following set of integers, write an SQL statement to determine the expected outputs

CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

WITH Numbers AS (
    SELECT 7 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n + 1 <= 54
)
SELECT n AS MissingSeat
FROM Numbers
LEFT JOIN Seats s ON s.SeatNumber = n
WHERE s.SeatNumber IS NULL
OPTION (MAXRECURSION 0);

