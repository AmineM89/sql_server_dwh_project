USE DataWarehouse;

-- drop the table 'crm_cust_info' if it is already created in the silver layer
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'crm_cust_info' AND schema_id = SCHEMA_ID('silver'))
BEGIN
    DROP TABLE silver.crm_cust_info; 
END


-- create the table 'crm_cust_info' in the bronze schema
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	--cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);
