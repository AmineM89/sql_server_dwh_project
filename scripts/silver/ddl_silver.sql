USE DataWarehouse;

PRINT '>> Truncate table silver.crm_cust_info...'
-- truncate the data already loaded to avoid incremanting the table (Full Load)
TRUNCATE TABLE silver.crm_cust_info

PRINT '>> Inserting data into silver.crm_cust_info...';
-- bulk insert into crm_cust_info table from its corresponding csv file

WITH cte AS(
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
INSERT INTO silver.crm_cust_info
SELECT cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM cte
WHERE rn=1;


PRINT '>> Truncate table silver.crm_prd_info...'
-- truncate the data already loaded to avoid incremanting the table (Full Load)
TRUNCATE TABLE silver.crm_prd_info

PRINT '>> Inserting data into silver.crm_prd_info...';
-- loading data into silver.crm_prd_info table

INSERT INTO silver.crm_prd_info
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





PRINT '>> Truncate table silver.crm_sales_details...'
-- truncate the data already loaded to avoid incremanting the table (Full Load)
TRUNCATE TABLE silver.crm_sales_details

PRINT '>> Inserting data into silver.crm_sales_details...';
-- loading data into silver.crm_sales_details table

INSERT INTO silver.crm_sales_details
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