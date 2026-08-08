/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================

Script Purpose:
    This script creates the business-ready views for the Gold layer of the
    data warehouse.

    The Gold layer follows a Star Schema design and consists of dimension
    and fact views built from the Silver layer. These views provide clean,
    integrated, and analytics-ready data for reporting and business intelligence.

Views Created:
    • gold.dim_customers
        Customer dimension containing enriched customer information.

    • gold.dim_products
        Product dimension containing active products with categories,
        subcategories, and product attributes.

    • gold.fact_sales
        Sales fact view containing transactional sales data linked to
        customers and products.

Usage:
    - Query these views directly for dashboards, reporting, and analytics.
    - Join fact_sales with the dimension views using Customer_key and
      Product_key for complete business analysis.

===============================================================================
*/



-- ===============================================================================
-- Create dimenstion: gold.dim_customers
-- ===============================================================================
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS Customer_key,
	ci.cst_key AS Customer_number,
	ci.cst_id AS Customer_id,
	ci.cst_firstname AS First_name,
	ci.cst_lastname AS Last_name,
	lo.cntry AS Country,
	ci.cst_marital_status AS Marriage_statues,
	CASE WHEN ci.cst_gndr != 'NaN' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen, 'NaN')
	END AS Gender,
	ca.bdate AS Birthdate,
	ci.cst_create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 lo
ON ci.cst_key = lo.cid


-- ===============================================================================
-- Create dimenstion: gold.dim_products
-- ===============================================================================
CREATE VIEW gold.dim_products AS 
SELECT
	ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt) AS Product_key,
	prd_id AS Product_id,
	prd_key AS Product_number,
	prd_nm AS Product_name,
	px.id AS Category_id,
	px.cat AS Category,
	px.subcat AS Subcategory,
	prd_cost AS Product_cost,
	prd_line AS Product_line,
	px.maintenance,
	prd_start_dt AS Start_date
FROM silver.crm_prd_info pd
LEFT JOIN silver.erp_px_cat_g1v2 px
ON pd.cat_id = px.id
WHERE pd.prd_end_dt IS NULL


-- ===============================================================================
-- Create fact: gold.fact_sales
-- ===============================================================================
CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS Order_number,
	dc.Customer_key,
	dp.Product_key,
	sd.sls_order_dt AS Order_date,
	sd.sls_ship_dt AS Shippment_date,
	sd.sls_due_dt AS Due_date,
	sd.sls_sales AS Sales_amount,
	sd.sls_quantity AS Quantity,
	sd.sls_price AS Price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id = dc.Customer_id
LEFT JOIN gold.dim_products dp
ON sd.sls_prd_key = dp.Product_number
