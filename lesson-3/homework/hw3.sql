Define and explain the purpose of BULK INSERT in SQL Server.
BULK INSERT — bu SQL Serverda katta hajmdagi ma’lumotlarni (odatda fayldan) jadvalga tez va samarali yuklash uchun ishlatiladigan buyruqdir. Masalan, CSV yoki matn fayldan ko‘p satrni tezda import qilish uchun ishlatiladi.

2. List four file formats that can be imported into SQL Server.

CSV (Comma-Separated Values)

TXT (Text file)

Excel (XLS, XLSX) — to‘g‘ridan-to‘g‘ri emas, lekin SSIS yoki OPENROWSET yordamida

XML

CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10,2)
);

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Phone', 699.99),
(2, 'Laptop', 1200.50),
(3, 'Tablet', 350.00);

ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

ALTER TABLE Products
ADD CategoryID INT;

CREATE TABLE Categories (
  CategoryID INT PRIMARY KEY,
  CategoryName VARCHAR(50) UNIQUE
);

9. Explain the difference between NULL and NOT NULL.

NULL — bu qiymat yo‘qligini bildiradi, ya’ni ustunda hech qanday ma’lumot yo‘q.

NOT NULL — ustun qiymati bo‘sh bo‘lishi mumkin emas, har doim ma’lumot bo‘lishi shart.

10. Explain the purpose of the IDENTITY column in SQL Server.
IDENTITY — bu ustun avtomatik tarzda ketma-ket raqamlar (odatda birma-bir oshib boruvchi) yaratadi. Masalan, har yangi satr qo‘shilganda avtomatik ID berish uchun ishlatiladi.

11. Explain the differences between PRIMARY KEY and UNIQUE KEY.

PRIMARY KEY — jadvalda har doim noyob va NOT NULL bo‘lgan ustun yoki ustunlar to‘plami. Har bir jadvalda faqat bitta bo‘lishi mumkin.

UNIQUE KEY — ustundagi qiymatlar noyob bo‘lishi kerak, lekin NOT NULL bo‘lishi shart emas va bir nechta UNIQUE constraint bo‘lishi mumkin.

BULK INSERT Products
FROM 'C:\Data\products.txt'
WITH (
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '\n',
  FIRSTROW = 2
);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive CHECK (Price > 0);

ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  CustomerName VARCHAR(50),
  Age INT,
  CONSTRAINT CHK_Age CHECK (Age >= 18)
);

19. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
FOREIGN KEY jadvaldagi bir ustunni boshqa jadvaldagi PRIMARY KEY yoki UNIQUE ustunga bog‘laydi. Bu ma’lumotlarning yaxlitligini (referential integrity) ta’minlaydi va noto‘g‘ri ma’lumot kiritilishini oldini oladi.

20. Explain the use of COALESCE and ISNULL functions for handling NULL values.

ISNULL(expression, replacement) — agar expression NULL bo‘lsa, replacement ni qaytaradi.

COALESCE(expr1, expr2, ..., exprN) — berilgan ifodalardan NULL bo‘lmagan birinchisini qaytaradi. Ko‘p qiymatlarni tekshirish uchun qulay.

CREATE TABLE SampleTable (
  ID INT IDENTITY(100, 10) PRIMARY KEY,
  Data VARCHAR(50)
);

CREATE TABLE OrderDetails (
  OrderID INT,
  ProductID INT,
  Quantity INT,
  PRIMARY KEY (OrderID, ProductID)
);

CREATE TABLE Employees (
  EmpID INT PRIMARY KEY,
  EmpName VARCHAR(50),
  Email VARCHAR(100) UNIQUE
);

ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Orders
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
ON DELETE CASCADE
ON UPDATE CASCADE;

SELECT * FROM Products;

SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;
