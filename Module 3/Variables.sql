-- Declare the variable
DECLARE @MyVariable AS INT;

-- Initialize variable using Set or Select
SET @MyVariable = 42;
-- Or
SELECT @MyVariable = 42;

-- Show value
--PRINT @MyVariable
SELECT @MyVariable

-- Combined
DECLARE @MyVariable2 INT = 45
PRINT @MyVariable2
DECLARE @MyVariable2 varchar(100) = 'MyText'
PRINT @MyVariable2
DECLARE @MyType INT = 2
Select * from Downloads Where Type = @MyType
