--===================================================================
--================ cst_cust_info val tests ==========================
--===================================================================

--------------------------------------------------
----- Validation test for cst_id duplicated ------
--------------------------------------------------

-- expected empty query
SELECT cst_id
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1;

-----------------------------------------------------
----- validation test for cst_id NULL values --------
-----------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;

-----------------------------------------------------------
------ validation test for cst_gndr standardization -------
-----------------------------------------------------------

-- create a temporatry table from bronze.crm_cust_info with all the duplicate and NULL values cleared
IF OBJECT_ID('tempdb..#temp') IS NOT NULL
BEGIN
    DROP TABLE #temp; 
END

CREATE TABLE #temp (
    cst_id INT,
	cst_marital_status VARCHAR(50),
	cst_gndr VARcHAR(50),
	cst_create_date DATE
);

TRUNCATE TABLE #temp

WITH cte AS(
	SELECT cst_id,
		cst_marital_status,
		cst_gndr,
		CAST(cst_create_date AS DATE) AS cst_create_date,
		--cst_create_date,
		ROW_NUMBER() OVER(PARTITION BY(cst_id) ORDER BY cst_create_date DESC) as rn
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL)
INSERT INTO #temp
SELECT cst_id,
	cst_marital_status,
	cst_gndr,
	cst_create_date
FROM cte
WHERE rn=1;


--- expectation: sames number of row ('F'<->'Female','M'<->'Male', NULL<->'n/a') from both queries
SELECT
	cst_gndr,
	COUNT(*) AS silver_count
FROM silver.crm_cust_info
GROUP BY cst_gndr;

SELECT
	cst_gndr,
	COUNT(*) AS bronze_count
FROM #temp
GROUP BY cst_gndr;

---------------------------------------------------------------------
------ validation test for cst_marital_status standardization -------
---------------------------------------------------------------------

--- expectation: sames number of row ('S'<->'Single','M'<->'Maried', NULL<->'n/a') from both queries
SELECT
	cst_marital_status,
	COUNT(*) AS silver_count
FROM silver.crm_cust_info
GROUP BY cst_marital_status;

SELECT
	cst_marital_status,
	COUNT(*) AS bronze_count
FROM #temp
GROUP BY cst_marital_status;


---------------------------------------------------------------------
---------- validation test for cst_firstname normalizarion ----------
---------------------------------------------------------------------

-- expectation : emply query
SELECT TRIM(cst_firstname) AS trimed_fn, cst_firstname
FROM silver.crm_cust_info
WHERE TRIM(cst_firstname) != cst_firstname




---------------------------------------------------------------------
---------- validation test for cst_lastname normalizarion -----------
---------------------------------------------------------------------

-- expectation : emply query
SELECT TRIM(cst_lastname) AS trimed_fn, cst_lastname
FROM silver.crm_cust_info
WHERE TRIM(cst_lastname) != cst_lastname


------------------------------------------------------------------------------------------------------
--------- validation test for cst_id compativility with customer id in crm_sales_details table -------
------------------------------------------------------------------------------------------------------

-- expectation : empty query
SELECT cst_id
FROM silver.crm_cust_info
WHERE cst_id NOT IN (SELECT sls_cust_id FROM bronze.crm_sales_details)


--======================================================================
--================== cst_prd_info_validation_tests =====================
--======================================================================

------------------------------------------------------
---- validation test for prd_cost negative values ----
------------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;


--------------------------------------------------
---- validation test for prd_cost NULL values ----
--------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL


----------------------------------------------------------
------ validation test for prd_line standardization ------
----------------------------------------------------------

-- expectation : same count for both queries
SELECT prd_line,
	COUNT(*) AS silver_count
FROM silver.crm_prd_info
GROUP BY prd_line;

SELECT prd_line,
	COUNT(*) AS bronze_count
FROM bronze.crm_prd_info
GROUP BY prd_line;

----------------------------------------------------------
-------------- validation test prd_end_dt ----------------
----------------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt


-----------------------------------------------------------------------
---------- validation test for prd_key & prd_nm extra spaces ----------
-----------------------------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_prd_info
WHERE TRIM(prd_key) != prd_key

-- expectation : empty query
SELECT *
FROM silver.crm_prd_info
WHERE TRIM(prd_nm) != prd_nm

--------------------------------------------------------------------------------------------------------------
---------- validation test for prd_key compatibility with prd_key in crm_sales_details ----------
--------------------------------------------------------------------------------------------------------------

-- expectation: empty query (or few records returned)
SELECT DISTINCT sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT DISTINCT prd_key FROM silver.crm_prd_info)

--===========================================================================
--================== crm_sales_details validation tests =====================
--===========================================================================

------------------------------------------------------------------------
---------- validation test for cst_id and prd_key NULL values ----------
------------------------------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id IS NULL

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key IS NULL


--------------------------------------------------------------------------
---------- validation test for sales values (qte, price, sales) ----------
--------------------------------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_price IS NULL OR sls_price<=0

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity IS NULL OR sls_quantity<=0

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_price IS NULL OR sls_price<=0

---------------------------------------------------------------------------
---------- validation test for dates (order, ship and due dates) ----------
---------------------------------------------------------------------------

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > GETDATE() OR sls_ship_dt > GETDATE()

-- expectation : empty query
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt < '1900-01-01' OR sls_ship_dt < '1900-01-01' OR sls_due_dt < '1900-01-01'


--======================================================================
--================== erp_LOC_A101 validation tests =====================
--======================================================================

--------------------------------------------------------
---------- validation test for Country Column ----------
--------------------------------------------------------

-- expectation: match in the count of both queries (United States)
SELECT COUNT(*) AS silver_count
FROM silver.erp_LOC_A101
WHERE CNTRY = 'United States'

SELECT COUNT(*) AS bronze_count
FROM bronze.erp_LOC_A101
WHERE CNTRY = 'United States' OR CNTRY = 'US' OR CNTRY = 'USA'

-- expectation: match in the count of both queries (Germany)
SELECT COUNT(*) AS silver_count
FROM silver.erp_LOC_A101
WHERE CNTRY = 'Germany'

SELECT COUNT(*) AS bronze_count
FROM bronze.erp_LOC_A101
WHERE CNTRY = 'Germany' OR CNTRY = 'DE'

-- expectation: match in the count of both queries (NULL)
SELECT COUNT(*) AS silver_count
FROM silver.erp_LOC_A101
WHERE CNTRY = 'n/a'

SELECT COUNT(*) AS bronze_count
FROM bronze.erp_LOC_A101
WHERE CNTRY = '' OR CNTRY IS NULL


------------------------------------------------------------------------------------
---------- validation test for CID Duplicates & Compatibility with cst_key ---------
------------------------------------------------------------------------------------

-- expectation: empty query
SELECT
	CID,
	COUNT(*)
FROM silver.erp_LOC_A101
GROUP BY CID
HAVING COUNT(*)>1

-- expectation: empty query
SELECT *
FROM silver.erp_LOC_A101
WHERE CID NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)


--=========================================================================
--================== erp_PX_CAT_G1V2 validation tests =====================
--=========================================================================

------------------------------------------------------------------------------------
---------- validation test for ID Duplicates & Compatibility with prd_key ---------
------------------------------------------------------------------------------------


-- expectation: empty query
SELECT ID,
	COUNT(*)
FROM silver.erp_PX_CAT_G1V2
GROUP BY ID
HAVING COUNT(*)>1

-- expectation : empty query of few records returned
SELECT * 
FROM silver.erp_PX_CAT_G1V2
WHERE ID NOT IN (SELECT DISTINCT cat_id FROM silver.crm_prd_info)


--=======================================================================
--================== erp_CUST_AZ12 validation tests =====================
--=======================================================================

----------------------------------------------------------------
---------- validation test for Birthdays out of range ----------
----------------------------------------------------------------

-- expectation: empty query
SELECT *
FROM silver.erp_CUST_AZ12
WHERE BDATE > '2025-01-01'


----------------------------------------------------------------
---------- validation test for gender standardization ----------
----------------------------------------------------------------

-- expectation: sames count of both queries (count 'M' + 'Male' <-> 'Male, 'F' + 'Female' <-> 'Female'
SELECT
	GEN,
	COUNT(*) AS count_silver
FROM silver.erp_CUST_AZ12
GROUP BY GEN

SELECT
	GEN,
	COUNT(*) AS count_bronze
FROM bronze.erp_CUST_AZ12
GROUP BY GEN

--------------------------------------------------------------------------------------
---------- validation test for CID uniqueness and compatibility with cst_id ----------
--------------------------------------------------------------------------------------

-- expectation: empty query
SELECT
	CID,
	COUNT(*)
FROM silver.erp_CUST_AZ12
GROUP BY CID
HAVING COUNT(*)>1

-- expectation: empty query
SELECT *
FROM silver.erp_CUST_AZ12
WHERE CID NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

--=========================================================================
--================== cst_gndr update validation tests =====================
--=========================================================================

-- expectation: reduced count of 'n/a'
SELECT COUNT(*) AS after_update_count
FROM silver.crm_cust_info
WHERE cst_gndr='n/a'

SELECT COUNT(*) AS before_update_count
FROM bronze.crm_cust_info
WHERE cst_gndr IS NULL