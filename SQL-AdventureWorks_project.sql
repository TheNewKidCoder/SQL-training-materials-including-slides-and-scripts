/*
This SQL script demonstrates a comprehensive project using the DimCustomer and FactInternetSales tables from the AdventureWorksDW database.  
It showcases multiple SQL concepts, including column renaming, alias usage, sorting (ASC/DESC), filtering with WHERE, joining tables (INNER JOIN),  
creating and saving filtered results into a temporary table, and dropping objects when no longer needed. The ERD (Entity Relationship Diagram)  
is referenced to illustrate how FactInternetSales (fact table) connects to DimCustomer (dimension table) through the CustomerKey primary–foreign key relationship.  
The purpose of this script is to serve as a learning and reference tool for writing efficient, well-structured SQL queries while maintaining clarity  
for team members and collaborators.
*/

-- 1️. Use the AdventureWorks database
USE AdventureWorksDW2019;  
GO

-- 2️. View structure of tables
SELECT TOP 5 * FROM DimCustomer;
SELECT TOP 5 * FROM FactInternetSales;

-- 3️. Select specific columns with alias
SELECT 
    CustomerKey AS Customer_ID,
    FirstName + ' ' + LastName AS Full_Name,
    BirthDate,
    Gender
FROM DimCustomer;

-- 4️. Sorting
-- Oldest customers first
SELECT CustomerKey, FirstName, LastName, BirthDate
FROM DimCustomer
ORDER BY BirthDate ASC;

-- Youngest customers first
SELECT CustomerKey, FirstName, LastName, BirthDate
FROM DimCustomer
ORDER BY BirthDate DESC;

-- 5️. Filtering with WHERE and LIKE
SELECT *
FROM DimCustomer
WHERE Gender = 'M'
  AND FirstName LIKE 'A%';  -- Names starting with A

-- 6️. CASE statement for custom category
SELECT 
    CustomerKey,
    FirstName,
    LastName,
    YearlyIncome,
    CASE 
        WHEN YearlyIncome >= 80000 THEN 'High Income'
        WHEN YearlyIncome BETWEEN 40000 AND 79999 THEN 'Middle Income'
        ELSE 'Low Income'
    END AS IncomeCategory
FROM DimCustomer;


/* For checking column names in the table-

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DimCustomer' AND TABLE_SCHEMA = 'dbo';

*/

-- 7️. INNER JOIN to combine sales with customer info
SELECT 
    c.CustomerKey,
    c.FirstName + ' ' + c.LastName AS Full_Name,
    s.SalesOrderNumber,
    s.OrderDate,
    s.SalesAmount
FROM FactInternetSales s
INNER JOIN DimCustomer c
    ON s.CustomerKey = c.CustomerKey;

-- 8️. LEFT JOIN to find customers with or without sales
SELECT 
    c.CustomerKey,
    c.FirstName + ' ' + c.LastName AS Full_Name,
    s.SalesOrderNumber
FROM DimCustomer c
LEFT JOIN FactInternetSales s
    ON s.CustomerKey = c.CustomerKey;

-- 9️. Aggregation: Total sales per customer
SELECT 
    c.CustomerKey,
    c.FirstName + ' ' + c.LastName AS Full_Name,
    SUM(s.SalesAmount) AS TotalSales
FROM FactInternetSales s
INNER JOIN DimCustomer c
    ON s.CustomerKey = c.CustomerKey
GROUP BY c.CustomerKey, c.FirstName, c.LastName
HAVING SUM(s.SalesAmount) > 1000; -- Only big customers

-- You can change a column name like this to e.g. in DimCustomer
EXEC sp_rename 'dbo.DimCustomer.YearlyIncome', 'AnnualIncome', 'COLUMN';

-- 1️0. Save filtered sales into a temp table
SELECT 
    s.*,
    c.FirstName,
    c.LastName
INTO #HighValueSales
FROM FactInternetSales s
INNER JOIN DimCustomer c
    ON s.CustomerKey = c.CustomerKey
WHERE s.SalesAmount > 500;

-- View temp table
SELECT * FROM #HighValueSales;

-- When you disconnect, the temp table is dropped automatically. But you can also drop it 
-- Drop temp table
DROP TABLE #HighValueSales;

-- Bonus: Get top 10 highest sales orders
SELECT TOP 10 *
FROM FactInternetSales
ORDER BY SalesAmount DESC;
