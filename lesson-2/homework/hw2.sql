create table employees (empid int, name varchar(50), salary decimal(10,2))

insert into employees values (10, 'John', 7000.00)
insert into employees values (11, 'Tim', 6000.20)
insert into employees values (12, 'Luna', 8000.50)

select * from employees

update employees
set salary = 8000
where empid = 10
 
delete from employees
where empid = 11

alter table employees
alter column name varchar(100)

alter table employees
add department varchar(50)


select * from employees

alter table employees
alter column salary float

create table departments (
departmentid int
primary key,
departmentname varchar(50)
)

truncate table employees

2 medium

UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000

select * from employees

DELETE FROM Employees

ALTER TABLE Employees
DROP COLUMN Department;

EXEC sp_rename 'Employees', 'StaffMembers'

select * from StaffMembers

DROP TABLE Departments

3 advanced

CREATE TABLE Products (
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Category VARCHAR(50),
Price DECIMAL(10,2),
Description VARCHAR(200))

select * from Products

ALTER TABLE Products
ADD CONSTRAINT chk_Price CHECK (Price > 0);

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

select * from Products
 
 INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description, StockQuantity)
VALUES
(1, 'Laptop', 'Electronics', 1200.00, 'High performance laptop', 30),
(2, 'Coffee Mug', 'Kitchenware', 15.50, 'Ceramic mug', 100),
(3, 'Desk Chair', 'Furniture', 85.75, 'Ergonomic chair', 20),
(4, 'Smartphone', 'Electronics', 800.00, 'Latest model smartphone', 50),
(5, 'Notebook', 'Stationery', 2.50, 'College ruled notebook', 200);

SELECT *
INTO Products_Backup
FROM Products;

EXEC sp_rename 'Products', 'Inventory';

select * from Inventory

ALTER TABLE Inventory
DROP CONSTRAINT chk_Price;

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

CREATE TABLE Inventory_New (
    ProductCode INT IDENTITY(1000,5) PRIMARY KEY,
    ProductID INT,
    ProductName VARCHAR(100),
    ProductCategory VARCHAR(50),
    Price FLOAT,
    Description VARCHAR(200),
    StockQuantity INT DEFAULT 50)
