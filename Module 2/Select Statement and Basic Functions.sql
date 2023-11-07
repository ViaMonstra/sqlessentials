-- Select all columns
SELECT * FROM v_GS_COMPUTER_SYSTEM
SELECT * FROM v_R_System
SELECT * FROM v_R_System_Valid

-- Select one unique Columns
SELECT Distinct Client_Version0 FROM v_R_System

--Returns 10 rows
SELECT TOP(10) * FROM v_R_System_Valid

--Returns 10 percent of the rows
SELECT TOP(10) PERCENT * FROM v_R_System_Valid

-- Select specific columns
SELECT Name0, Model0, FROM v_GS_COMPUTER_SYSTEM

-- Alias Columns
SELECT Name0 AS ComputerName, Model0 AS HWModel FROM v_GS_COMPUTER_SYSTEM

-- Where
SELECT Name0 AS ComputerName, Model0 AS HWModel FROM v_GS_COMPUTER_SYSTEM Where Name0 = 'PC0001'
SELECT Name0 AS ComputerName, Model0 AS HWModel FROM v_GS_COMPUTER_SYSTEM Where Name0 like 'PC%'

-- Combining Columns
SELECT Manufacturer0 + Model0 FROM v_GS_COMPUTER_SYSTEM

-- Alias for combined columns
SELECT Manufacturer0 + ' ' + Model0 AS HWDescription FROM v_GS_COMPUTER_SYSTEM

-- String manipulation Expressions
SELECT Name0, LEFT(Name0, 3) AS ComputerNamePrefix FROM v_GS_COMPUTER_SYSTEM
SELECT Model0, UPPER(Model0) AS UpperModel FROM v_GS_COMPUTER_SYSTEM
SELECT Model0, REPLACE(Model0, 'Machine', 'PC') AS ModelAlias  FROM v_GS_COMPUTER_SYSTEM

-- Date Functions
SELECT GETDATE() AS SystemTime
SELECT GETDATE() SystemTime, DATEPART(YEAR, GETDATE()) AS SystemYear, DATEPART(MONTH, GETDATE()) AS SystemMonth;

