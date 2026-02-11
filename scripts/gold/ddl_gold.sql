/*
=====================================================================================================================================
DDL Script: Create Gold Views
=====================================================================================================================================
Script purpose:
    This script create views for Gold layer in the Data Warehouse.
    The Gold layer represents the final dimention and fact tables (Star schema)
    Each view performs transformations and combines data from Silver layer to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
=====================================================================================================================================
*/


-- ==========================================
-- Create Dimension: gold.dim_customers
-- ==========================================

IF OBJECT_ID('gold.dim_customers', 'v') IS NOT NULL
	DROP VIEW gold.dim_customers;

GO

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	CI.cst_id AS customer_id,
	CI.cst_key AS customer_number,
	CI.cst_firstname AS first_name,
	CI.cst_lastname AS last_name,
	LO.cntry AS country,
	CASE WHEN CI.cst_gndr != 'N/A' THEN CI.cst_gndr
		 ELSE COALESCE(CA.gen,'N/A')
	END AS gender,
	CI.cst_marital_status AS marital_status,
	CA.bdate AS birth_date,
	CI.cst_create_date AS create_date
FROM silver.crm_cust_info CI
LEFT JOIN silver.erp_cust_az12 CA ON CI.cst_key = CA.cid
LEFT JOIN silver.erp_loc_a101 LO ON CI.cst_key = LO.cid

GO

-- ==========================================
-- Create Dimension: gold.dim_products
-- ==========================================

IF OBJECT_ID('gold.dim_products', 'v') IS NOT NULL
	DROP VIEW gold.dim_products;

GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY PN.prd_start_dt, PN.prd_key) AS product_key,
	PN.prd_id AS product_id,
	PN.prd_key AS product_number,
	PN.prd_nm AS product_name,
	PN.cat_id AS category_id,
	PC.cat AS category,
	PC.subcat AS subcategory,
	PC.maintenance,
	PN.prd_cost AS cost,
	PN.prd_line AS product_line,
	PN.prd_start_dt AS start_date
FROM silver.crm_prd_info PN
LEFT JOIN silver.erp_px_cat_g1v2 PC ON PN.cat_id = PC.id
WHERE prd_end_dt IS NULL	---> Filter out all Historical Data

GO

-- ==========================================
-- Create Fact: gold.fact_sales
-- ==========================================

IF OBJECT_ID('gold.fact_sales', 'v') IS NOT NULL
	DROP VIEW gold.fact_sales;

GO

CREATE VIEW gold.fact_sales AS
SELECT
	SD.sls_ord_num AS order_number,
	PR.product_key,
	CU.customer_key,
	SD.sls_order_dt AS order_date,
	SD.sls_ship_dt AS shipping_date,
	SD.sls_due_dt AS due_date,
	SD.sls_sales AS sales_amount,
	SD.sls_quantity AS quantity,
	SD.sls_price AS price
FROM silver.crm_sales_details SD
LEFT JOIN gold.dim_products AS PR ON SD.sls_prd_key = PR.product_number
LEFT JOIN gold.dim_customers AS CU ON SD.sls_cust_id = CU.customer_id
