USE master;

-- drop the database if already created
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    DROP DATABASE DataWarehouse;
END
GO

-- create database
CREATE DATABASE DataWarehouse;
GO
--select the created database
USE DataWarehouse;
GO
-- create schema for medallion data architecture
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;