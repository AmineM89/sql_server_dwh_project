/*
========================================================
         create tables in bronze layer
========================================================
purpose:
	for each table: crm_cust_info, crm_prd_info, crm_sales_details from crm source and for each table: erp_CUST_AZ12,
	erp_LOC_A101, erp_PX_CAT_G1V2 from erp sources, this script checks if the table already exists it is droped,
	then create a new one
warining:
	Carefull when executing this script, it will DELETE PERMANENTLY all the data contained in all tables
*/

USE DataWarehouse;

-- drop the table 'crm_cust_info' if it is already created
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_cust_info' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
    DROP TABLE bronze.crm_cust_info; 
END


-- create the table 'crm_cust_info' in the bronze schema
CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date VARCHAR(50)
);

-- drop the table 'crm_prd_info' if it is already created
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_prd_info' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
    DROP TABLE bronze.crm_prd_info; 
END

-- create the table 'crm_prd_info' in the bronze schema

CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost VARCHAR(50),
	prd_line VARCHAR(50),
	prd_start_dt VARCHAR(50),
	prd_end_dt VARCHAR(50)
);


-- drop the table 'crm_sales_details' if it is already created
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_sales_details' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
    DROP TABLE bronze.crm_sales_details; 
END

-- create the table 'crm_sales_details' in the bronze schema
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INT,
	sls_order_dt VARCHAR(50),
	sls_ship_dt VARCHAR(50),
	sls_due_dt VARCHAR(50),
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);


-- drop the table 'erp_CUST_AZ12' if it is already created
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'erp_CUST_AZ12' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
    DROP TABLE bronze.erp_CUST_AZ12; 
END

-- create the table 'erp_CUST_AZ12' in the bronze schema
CREATE TABLE bronze.erp_CUST_AZ12(
	CID VARCHAR(50),
	BDATE VARCHAR(50),
	GEN VARCHAR(50)
);

-- drop the table 'erp_LOC_A101' if it is already created
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'erp_LOC_A101' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
    DROP TABLE bronze.erp_LOC_A101; 
END

-- create the table 'erp_LOC_A101' in the bronze schema
CREATE TABLE bronze.erp_LOC_A101(
	CID VARCHAR(50),
	CNTRY VARCHAR(50)
);


-- drop the table 'erp_PX_CAT_G1V2' if it is already created
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'erp_PX_CAT_G1V2' AND schema_id = SCHEMA_ID('bronze'))
BEGIN
    DROP TABLE bronze.erp_PX_CAT_G1V2; 
END

CREATE TABLE bronze.erp_PX_CAT_G1V2(
	ID VARCHAR(50),
	CAT VARCHAR(50),
	SUBCAT VARCHAR(50),
	MAINTENANCE VARCHAR(50)
);