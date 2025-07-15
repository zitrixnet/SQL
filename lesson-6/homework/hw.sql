-- Puzzle 1: Finding Distinct Values (2 usul)
CREATE TABLE InputTbl (
    col1 VARCHAR(10),
    col2 VARCHAR(10)
);
INSERT INTO InputTbl (col1, col2) VALUES 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');

-- Usul 1: DISTINCT bilan
SELECT DISTINCT col1, col2
FROM InputTbl
WHERE col1 <= col2
UNION
SELECT DISTINCT col2 AS col1, col1 AS col2
FROM InputTbl
WHERE col1 > col2
ORDER BY col1, col2;

-- Usul 2: MIN va MAX funksiyalari bilan guruhlash
SELECT MIN(col1) AS col1, MAX(col2) AS col2
FROM InputTbl
GROUP BY CASE WHEN col1 < col2 THEN col1 ELSE col2 END,
         CASE WHEN col1 > col2 THEN col1 ELSE col2 END
ORDER BY col1, col2;

-- Puzzle 2: Removing Rows with All Zeroes
CREATE TABLE TestMultipleZero (
    A INT NULL,
    B INT NULL,
    C INT NULL,
    D INT NULL
);

INSERT INTO TestMultipleZero(A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT * 
FROM TestMultipleZero
WHERE NOT (ISNULL(A,0) = 0 AND ISNULL(B,0) = 0 AND ISNULL(C,0) = 0 AND ISNULL(D,0) = 0);

-- Puzzle 3: Find those with odd ids
CREATE TABLE section1(id INT, name VARCHAR(20));

INSERT INTO section1 VALUES 
(1, 'Been'),
(2, 'Roma'),
(3, 'Steven'),
(4, 'Paulo'),
(5, 'Genryh'),
(6, 'Bruno'),
(7, 'Fred'),
(8, 'Andro');

SELECT * FROM section1 WHERE id % 2 = 1;

-- Puzzle 4: Person with the smallest id
SELECT TOP 1 * FROM section1 ORDER BY id ASC;

-- Puzzle 5: Person with the highest id
SELECT TOP 1 * FROM section1 ORDER BY id DESC;

-- Puzzle 6: People whose name starts with b (case-insensitive)
SELECT * FROM section1 WHERE LOWER(name) LIKE 'b%';

-- Puzzle 7: Rows where code contains literal underscore '_'
CREATE TABLE ProductCodes (
    Code VARCHAR(20)
);

INSERT INTO ProductCodes (Code) VALUES
('X-123'),
('X_456'),
('X#789'),
('X-001'),
('X%202'),
('X_ABC'),
('X#DEF'),
('X-999');

SELECT * 
FROM ProductCodes
WHERE Code LIKE '%[_]%';
