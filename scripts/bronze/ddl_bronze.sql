/*
==============================================================================
                           Loading bronze Layer
==============================================================================

purpose:
	this scrpit creates a stored procedure 'bronze.load_bronze' that will perform a full load (truncate & insert) of each file
	from crm and erp sources to the bronze layer. No transformation are applied to the data, the csv files are loaded into
	tables with the same names.

Warning:
	this script will overwrite all the existing records of tables in the bronze layer
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	BEGIN TRY
		--------------------------------------------------------------------
		-------------------------- CRM SOURCE ------------------------------
		--------------------------------------------------------------------

		DECLARE @start_time DATETIME;
		DECLARE @end_time DATETIME;
		DECLARE @global_start_time DATETIME;
		DECLARE @global_end_time DATETIME;

		SELECT @global_start_time=GETDATE();

		PRINT '===========================================================================';
		PRINT '======================== Loading Bronze Layer =============================';
		PRINT '===========================================================================';

		PRINT ''
		PRINT '---------------------------------------------------------------------------';
		PRINT '-------------------------- Loading CRM Data -------------------------------';
		PRINT '---------------------------------------------------------------------------';

		PRINT ''

		PRINT '--- Loading cust_info table from CRM source into the bronze layer ---';
		SELECT @start_time = GETDATE();

		PRINT '>> Truncate bronze.crm_cust_info...';
		-- truncate the data already loaded to avoid incremanting the table (Full Load)
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>> Inserting data into bronze.crm_cust_info...';
		-- bulk insert into crm_cust_info table from its corresponding csv file
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Projects\Datawarehouse\sql-datawarehouse\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);
		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'

		--------------------------------------------------------------------------------------------------

		PRINT '___________________________________________________________________________';
		PRINT ''
		PRINT '--- Loading prd_info table from CRM source into the bronze layer ---';
		SELECT @start_time = GETDATE();

		-- drop the data already loaded to avoid incremanting the table (Full Load)
		PRINT '>> Truncate bronze.crm_prd_info...';
		TRUNCATE TABLE bronze.crm_prd_info

		-- bulk insert into crm_prd_info table from its corresponding csv file
		PRINT '>> Inserting data into bronze.crm_prd_info...';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Projects\Datawarehouse\sql-datawarehouse\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);
		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'

		--------------------------------------------------------------------------------------------------

		PRINT '___________________________________________________________________________';
		PRINT ''
		PRINT '--- Loading sales_details table from CRM source into the bronze layer ---';
		SELECT @start_time = GETDATE();


		-- drop the data already loaded to avoid incremanting the table (Full Load)
		PRINT '>> Truncate bronze.crm_sales_details...';
		TRUNCATE TABLE bronze.crm_sales_details

		-- bulk insert into crm_sales_details table from its corresponding csv file
		PRINT '>> Inserting data into bronze.crm_sales_details...';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Projects\Datawarehouse\sql-datawarehouse\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);

		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'


		PRINT ''
		PRINT '---------------------------------------------------------------------------';
		PRINT '-------------------------- Loading CRM Data -------------------------------';
		PRINT '---------------------------------------------------------------------------';
		PRINT ''

		PRINT '--- Loading CUST_AZ12 table from ERP source into the bronze layer ---';
		SELECT @start_time = GETDATE();

		-- drop the data already loaded to avoid incremanting the table (Full Load)
		PRINT '>> Truncate bronze.erp_CUST_AZ12...';
		TRUNCATE TABLE bronze.erp_CUST_AZ12

		-- bulk insert into erp_CUST_AZ12s table from its corresponding csv file
		PRINT '>> Inserting data into bronze.erp_CUST_AZ12...';
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Projects\Datawarehouse\sql-datawarehouse\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);

		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'

		PRINT '___________________________________________________________________________';
		Print ''

		PRINT '--- Loading LOC_A101 table from ERP source into the bronze layer ---';
		SELECT @start_time = GETDATE();

		-- drop the data already loaded to avoid incremanting the table (Full Load)
		PRINT '>> Truncate bronze.erp_LOC_A101...';
		TRUNCATE TABLE bronze.erp_LOC_A101

		-- bulk insert into erp_CUST_AZ12s table from its corresponding csv file
		PRINT '>> Inserting data into bronze.erp_LOC_A101...';
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Projects\Datawarehouse\sql-datawarehouse\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);

		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'


		PRINT '___________________________________________________________________________';
		Print '';

		PRINT '--- Loading PX_CAT_G1V2 table from ERP source into the bronze layer ---';
		SELECT @start_time = GETDATE();

		-- drop the data already loaded to avoid incremanting the table (Full Load)
		PRINT '>> Truncate bronze.erp_PX_CAT_G1V2...';
		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2

		-- bulk insert into erp_CUST_AZ12s table from its corresponding csv file
		PRINT '>> Inserting data into bronze.erp_PX_CAT_G1V2...';
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Projects\Datawarehouse\sql-datawarehouse\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ','
		);

		SELECT @end_time = GETDATE();
		PRINT '';
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms';

		PRINT '___________________________________________________________________________';

		SELECT @global_end_time=GETDATE();
		PRINT '';
		PRINT 'Global execution time : '+CAST(DATEDIFF(ms,@global_start_time,@global_end_time) AS NVARCHAR)

		PRINT '___________________________________________________________________________';
	END TRY
	BEGIN CATCH
		PRINT '===========================================================';
		PRINT 'Error occured while loading the Bronze Layer';
		PRINT '===========================================================';
		PRINT 'Error Message :' + ERROR_MESSAGE();
		PRINT 'Error Number :' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END