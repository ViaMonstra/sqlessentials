USE master;
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = tempdev, FILENAME = 'E:\SQLTMP\tempdb.mdf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = temp2, FILENAME = 'E:\SQLTMP\tempdb_mssql_2.ndf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = temp3, FILENAME = 'E:\SQLTMP\tempdb_mssql_3.ndf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = temp4, FILENAME = 'E:\SQLTMP\tempdb_mssql_4.ndf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = temp5, FILENAME = 'E:\SQLTMP\tempdb_mssql_5.ndf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = temp6, FILENAME = 'E:\SQLTMP\tempdb_mssql_6.ndf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = temp7, FILENAME = 'E:\SQLTMP\tempdb_mssql_7.ndf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = temp8, FILENAME = 'E:\SQLTMP\tempdb_mssql_8.ndf');
GO

ALTER DATABASE tempdb 
MODIFY FILE (NAME = templog, FILENAME = 'E:\SQLTMP\templog.ldf');
GO