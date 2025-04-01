/*
=================================================
Gold layer views creation
=================================================
script purpose:
	Instead of loading the gold layer, this script generates a schema model using views: dim_customers, dim_products,
	and fact_sales. It integrates data from multiple tables across different source systems (CRM & ERP).
	Additionally, the script creates surrogate keys to facilitate joins and renames columns for better readability
*/


USE DataWarehouse
GO
CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_create_date) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	CASE
		WHEN ci.cst_gndr='n/a'THEN COALESCE(ca.GEN,'n/a') -- crm is master
		ELSE ci.cst_gndr
	END AS gender,
	ci.cst_marital_status AS marital_status,
	ci.cst_create_date AS create_date,
	ca.BDATE AS birthdate
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_LOC_A101 loc
ON		loc.CID=ci.cst_key
LEFT JOIN silver.erp_CUST_AZ12 ca
ON		ca.CID=ci.cst_key

GO


CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY prd_id) AS product_key,
	p.prd_id AS product_id,
	p.prd_key AS product_number,
	p.cat_id AS category_id,
	p.prd_nm AS product_name,
	cat.CAT AS category,
	cat.SUBCAT subcategory,
	p.prd_line AS product_line,
	cat.MAINTENANCE maintenance,
	p.prd_cost AS cost,
	p.prd_start_dt AS product_start_date
FROM silver.crm_prd_info AS p
LEFT JOIN silver.erp_PX_CAT_G1V2 cat
ON		  cat.ID=p.cat_id
WHERE p.prd_end_dt IS NULL

GO

CREATE VIEW gold.fact_sales AS
SELECT
	sls_ord_num AS order_id,
	customer_key,
	product_key,
	sls_order_dt AS order_date,
	sls_ship_dt AS ship_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_value,
	sls_quantity AS quality,
	sls_price AS unit_price
FROM silver.crm_sales_details s
LEFT JOIN gold.dim_customers c
ON c.customer_id = s.sls_cust_id
LEFT JOIN gold.dim_products p
ON p.product_number=s.sls_prd_key
