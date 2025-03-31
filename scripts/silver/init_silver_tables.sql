USE DataWarehouse;

-- drop the table 'crm_cust_info' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_cust_info' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.crm_cust_info; 
END

-- create the table 'crm_cust_info' in the bronze schema
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE,
	dwh_create_table DATETIME2 DEFAULT GETDATE()
);


-- drop the table 'crm_prd_info' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_prd_info' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.crm_prd_info; 
END

-- create the table 'crm_prd_info' in the bronze schema
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id VARCHAR(50),
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost VARCHAR(50),
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_table DATETIME2 DEFAULT GETDATE()
);


-- drop the table 'crm_prd_info' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_prd_info' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.crm_prd_info; 
END

-- create the table 'crm_prd_info' in the bronze schema
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id VARCHAR(50),
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost VARCHAR(50),
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_table DATETIME2 DEFAULT GETDATE()
);




-- drop the table 'crm_sales_details' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_sales_details' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.crm_sales_details; 
END

-- create the table 'crm_prd_info' in the bronze schema
CREATE TABLE silver.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_table DATETIME2 DEFAULT GETDATE()
);


-- drop the table 'erp_LOC_A101' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'erp_LOC_A101' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.erp_LOC_A101; 
END

-- create the table 'erp_LOC_A101' in the bronze schema
CREATE TABLE silver.erp_LOC_A101(
	CID VARCHAR(50),
	CNTRY VARCHAR(50),
	dwh_create_table DATETIME2 DEFAULT GETDATE()
);




-- drop the table 'erp_PX_CAT_G1V2' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'erp_PX_CAT_G1V2' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.erp_PX_CAT_G1V2; 
END

-- create the table 'erp_PX_CAT_G1V2' in the bronze schema
CREATE TABLE silver.erp_PX_CAT_G1V2(
	ID VARCHAR(50),
	CAT VARCHAR(50),
	SUBCAT VARCHAR(50),
	MAINTENANCE VARCHAR(50),
	dwh_create_table DATETIME2 DEFAULT GETDATE()
);



-- drop the table 'erp_CUST_AZ12' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'erp_CUST_AZ12' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.erp_CUST_AZ12; 
END

-- create the table 'erp_CUST_AZ12' in the bronze schema
CREATE TABLE silver.erp_CUST_AZ12(
	CID VARCHAR(50),
	BDATE DATE,
	GEN VARCHAR(50),
	dwh_create_table DATETIME2 DEFAULT GETDATE()
);