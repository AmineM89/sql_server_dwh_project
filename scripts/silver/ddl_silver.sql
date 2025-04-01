/*
==============================================================================
silver Layer loading stored procedure
==============================================================================

purpose:
	this scrpit creates a stored procedure 'silver.load_silver' that will perform multiple transformation (dealing
	with NULL values & duplicates, columns standardization,...) for each table from bronze layer and load them into
	silver layer with full load (truncate & insert) of each file
Warning:
	this script will overwrite all the existing records of tables in the silver layer
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME;
		DECLARE @end_time DATETIME;
		DECLARE @global_start_time DATETIME;
		DECLARE @global_end_time DATETIME;

		SELECT @global_start_time=GETDATE();
		SELECT @global_end_time=GETDATE();


		PRINT '===========================================================================';
		PRINT '======================== Loading Silver Layer =============================';
		PRINT '===========================================================================';

		PRINT ''
		PRINT '---------------------------------------------------------------------------';
		PRINT '-------------------------- Loading CRM Data -------------------------------';
		PRINT '---------------------------------------------------------------------------';

		PRINT ''
		PRINT '--- Loading cust_info table ---';
		PRINT ''
		SELECT @start_time = GETDATE();
		PRINT '>> Truncate table silver.crm_cust_info...'
		-- truncate the data already loaded to avoid incremanting the table (Full Load)
		TRUNCATE TABLE silver.crm_cust_info

		PRINT '>> Cleaning and inserting data into silver.crm_cust_info...';
		-- bulk insert into crm_cust_info table from its corresponding csv file

		WITH cust_cte AS(
			SELECT cst_id,
				cst_key,
				TRIM(cst_firstname) AS cst_firstname,
				TRIM(cst_lastname) AS cst_lastname,
				CASE
					WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single'
					WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN'Maried'
					ELSE 'n/a'
				END AS cst_marital_status,
				CASE
					WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
					WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
					ELSE 'n/a'
				END AS cst_gndr,
				CAST(cst_create_date AS DATE) AS cst_create_date,
				--cst_create_date,
				ROW_NUMBER() OVER(PARTITION BY(cst_id) ORDER BY cst_create_date DESC) as rn
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL)
		INSERT INTO silver.crm_cust_info(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
		SELECT cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		FROM cust_cte
		WHERE rn=1;

		SELECT @end_time = GETDATE();
				PRINT ''
				PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'


		--------------------------------------------------------------------------------------------------

		PRINT '___________________________________________________________________________';
		PRINT ''
		PRINT '--- Loading prd_info table ---';
		PRINT ''
		SELECT @start_time = GETDATE();

		PRINT '>> Truncate table silver.crm_prd_info...'
		-- truncate the data already loaded to avoid incremanting the table (Full Load)
		TRUNCATE TABLE silver.crm_prd_info

		PRINT '>> Cleaning and inserting data into silver.crm_prd_info...';
		-- loading data into silver.crm_prd_info table

		INSERT INTO silver.crm_prd_info(prd_id, cat_id,prd_key,prd_nm,prd_cost,prd_line, prd_start_dt, prd_end_dt)
		SELECT prd_id,
			SUBSTRING(prd_key,1,5) AS cat_id,
			SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
			prd_nm,
			ISNULL(prd_cost,0) AS prd_cost,
			CASE
				WHEN prd_line = 'M' THEN 'Mountain'
				WHEN prd_line = 'R' THEN 'Road'
				WHEN prd_line = 'T' THEN 'Touring'
				WHEN prd_line = 'S' THEN 'Sport'
				ELSE 'Other'
			END AS prd_line,
			CAST(prd_start_dt AS DATE),
			DATEADD(DAY, -1, LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
		FROM bronze.crm_prd_info;
		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'

		--------------------------------------------------------------------------------------------------

		PRINT '___________________________________________________________________________';
		PRINT ''
		PRINT '--- Loading sales_details table ---';
		PRINT ''
		SELECT @start_time = GETDATE();


		PRINT '>> Truncate table silver.crm_sales_details...'
		-- truncate the data already loaded to avoid incremanting the table (Full Load)
		TRUNCATE TABLE silver.crm_sales_details

		PRINT '>> Cleaning and inserting data into silver.crm_sales_details...';
		-- loading data into silver.crm_sales_details table

		INSERT INTO silver.crm_sales_details(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price)
		SELECT sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CAST(CASE WHEN LEN(sls_order_dt)<8 THEN NULL ELSE sls_order_dt END AS DATE) AS sls_order_dt,
			CAST(CASE WHEN LEN(sls_ship_dt)<8 THEN NULL ELSE sls_ship_dt END AS DATE) AS sls_ship_dt,
			CAST(CASE WHEN LEN(sls_due_dt)<8 THEN NULL ELSE sls_due_dt END AS DATE) AS sls_due_dt,
			CASE
				WHEN sls_sales != sls_quantity * sls_price OR sls_sales IS NULL THEN ABS(sls_quantity * sls_price)
				ELSE sls_sales
			END AS sls_sales,
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price<=0 THEN ABS(sls_sales/NULLIF(sls_quantity,0))
				ELSE sls_price
			END as sls_price
		FROM bronze.crm_sales_details;

		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'


		PRINT ''
		PRINT '---------------------------------------------------------------------------';
		PRINT '-------------------------- Loading ERP Data -------------------------------';
		PRINT '---------------------------------------------------------------------------';
		PRINT ''

		PRINT '--- Loading LOC_A101 table ---';
		PRINT ''
		SELECT @start_time = GETDATE();

		PRINT '>> Truncate table silver.erp_LOC_A101...'
		-- truncate the data already loaded to avoid incremanting the table (Full Load)
		TRUNCATE TABLE silver.erp_LOC_A101
		PRINT '>> Cleaning and inserting data into silver.erp_LOC_A101...';
		-- loading data into silver.erp_LOC_A101 table

		INSERT INTO silver.erp_LOC_A101(CID,CNTRY)
		SELECT 
			REPLACE(CID,'-','') AS CID,
			CASE
				WHEN CNTRY='DE' THEN 'Germany'
				WHEN CNTRY IN ('USA','US') THEN 'United States'
				WHEN CNTRY IS NULL OR CNTRY='' THEN 'n/a'
				ELSE CNTRY
			END AS CNTRY
		FROM bronze.erp_LOC_A101;
		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'

		PRINT '___________________________________________________________________________';
		Print ''

		PRINT '--- Loading PX_CAT_G1V2 table ---';
		PRINT ''
		SELECT @start_time = GETDATE();

		PRINT '>> Truncate table silver.erp_PX_CAT_G1V2...'
		-- truncate the data already loaded to avoid incremanting the table (Full Load)
		TRUNCATE TABLE silver.erp_PX_CAT_G1V2
		PRINT '>> Cleaning and inserting data into silver.erp_PX_CAT_G1V2...';
		-- loading data into silver.erp_PX_CAT_G1V2 table

		INSERT INTO silver.erp_PX_CAT_G1V2(ID,CAT,SUBCAT,MAINTENANCE)
		SELECT
			REPLACE(ID,'_','-') AS ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		FROM bronze.erp_PX_CAT_G1V2;

		SELECT @end_time = GETDATE();
		PRINT ''
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms'

		PRINT '___________________________________________________________________________';
		Print '';

		PRINT '--- Loading CUST_AZ12 table ---';
		PRINT ''
		SELECT @start_time = GETDATE();

		PRINT '>> Truncate table silver.erp_CUST_AZ12...'
		-- truncate the data already loaded to avoid incremanting the table (Full Load)
		TRUNCATE TABLE silver.erp_CUST_AZ12
		PRINT '>> Cleaning and inserting data into silver.erp_CUST_AZ12...';
		-- loading data into silver.erp_CUST_AZ12 table

		INSERT INTO silver.erp_CUST_AZ12(CID,BDATE,GEN)
		SELECT
			CASE
				WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
				ELSE CID
			END AS CID,
			CASE
				WHEN BDATE>'2025-01-01' THEN NULL
				ELSE CAST(BDATE AS DATE)
			END AS BDATE,
			CASE
				WHEN GEN='F' THEN 'Female'
				WHEN GEN='M' THEN 'Male'
				WHEN GEN='' OR GEN IS NULL THEN 'n/a'
				ELSE GEN
			END AS GEN
		FROM bronze.erp_CUST_AZ12;
		SELECT @end_time = GETDATE();
		PRINT '';
		PRINT '>> Excecution time : '+CAST(DATEDIFF(ms, @start_time,@end_time) AS VARCHAR)+' ms';
		
		PRINT '___________________________________________________________________________';


		SELECT @global_end_time=GETDATE();
		PRINT '';
		PRINT 'Global execution time : '+CAST(DATEDIFF(ms,@global_start_time,@global_end_time) AS NVARCHAR)+'ms'

		PRINT '___________________________________________________________________________';
	END TRY
	BEGIN CATCH
		PRINT '===========================================================';
		PRINT 'Error occured while loading the silver Layer';
		PRINT '===========================================================';
		PRINT 'Error Message :' + ERROR_MESSAGE();
		PRINT 'Error Number :' + CAST(ERROR_NUMBER() AS NVARCHAR);
	END CATCH
END