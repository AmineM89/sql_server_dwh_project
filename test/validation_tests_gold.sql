/*
============================================
Unit tests on gold layer
============================================
script purpose:
	Generate queries to validate data integration within the star schema.
*/
USE DataWarehouse;

-- Expectation : 'Male', 'Female' or 'n/a'
SELECT DISTINCT
	gender
FROM gold.dim_customers


-------------------------------------------
-- check surrogate key uniqueness
-------------------------------------------

-- expectation : empty query
SELECT customer_number
FROM gold.dim_customers
GROUP BY customer_number
HAVING COUNT(*)>1

-- expectation : empty query
SELECT customer_id
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*)>1

-- expectation : empty query
SELECT product_number
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*)>1

-- expectation : empty query
SELECT product_id
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*)>1

-----------------------------------------------------------
-- check join using surrogate keys
-----------------------------------------------------------

-- expectation : empty query
SELECT order_id
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key=s.product_key
LEFT JOIN gold.dim_customers c
ON c.customer_key=s.customer_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL
