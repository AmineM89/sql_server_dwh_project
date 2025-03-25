/*
============================================================================================
Create database and schemas
============================================================================================

Script purpose:
	this scipt will create a database named 'DataWarehouse' alter checking if it already exists, after that we create
	in this data base three schemas: 'bronze', 'silver' and 'gold'
Warning:
	if the database 'DataWarehouse' exists already, ALL THE DATA WILL BE DELETED when executing this script
*/

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