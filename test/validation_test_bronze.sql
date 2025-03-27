/*
================================================
 Validation test for bronze layer
================================================

purpose:
	for each loaded table check if there is no shift in the columns compared to the csv file, it checks as well the number
	of rows loaded compared with the number of rows the in csv file
*/

USE DataWarehouse;
-------------------------------------------
--------------- CRM SOURCE ----------------
-------------------------------------------


-- validation test for loading crm_cust_info table
-----------------------------------------------------

-- Expectation: No shift in columns
SELECT TOP 10 *
FROM bronze.crm_cust_info;

--Expectation: 18494 rows
SELECT COUNT(*) AS nb_rows FROM bronze.crm_cust_info;


-- validation test for loading crm_prd_info table
----------------------------------------------------

-- Expectation: No shift in columns
SELECT TOP 10 *
FROM bronze.crm_prd_info;

--Expectation: 397 rows
SELECT COUNT(*) AS nb_rows FROM bronze.crm_prd_info;


-- validation test for loading crm_sales_details table
----------------------------------------------------

-- Expectation: No shift in columns
SELECT TOP 10 *
FROM bronze.crm_sales_details;

--Expectation: 60398 rows
SELECT COUNT(*) AS nb_rows FROM bronze.crm_sales_details;

-------------------------------------------
--------------- ERP SOURCE ----------------
-------------------------------------------

-- validation test for loading erp_CUST_AZ12 table
----------------------------------------------------

-- Expectation: No shift in columns
SELECT TOP 10 *
FROM bronze.erp_CUST_AZ12;

--Expectation: 18484 rows
SELECT COUNT(*) AS nb_rows FROM bronze.erp_CUST_AZ12;


-- validation test for loading erp_LOC_A101 table
----------------------------------------------------

-- Expectation: No shift in columns
SELECT TOP 10 *
FROM bronze.erp_LOC_A101;

--Expectation: 18484 rows
SELECT COUNT(*) AS nb_rows FROM bronze.erp_LOC_A101;


-- validation test for loading erp_PX_CAT_G1V2 table
----------------------------------------------------

-- Expectation: No shift in columns
SELECT TOP 10 *
FROM bronze.erp_PX_CAT_G1V2;

--Expectation: 37 rows
SELECT COUNT(*) AS nb_rows FROM bronze.erp_PX_CAT_G1V2;