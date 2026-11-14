-- Check grain: a single row holding the number of rows in core.dim_seller
SELECT COUNT(*) 
FROM core.dim_seller;

-- Check grain: a single row holding the row count and the number of distinct real customers in core.dim_customer
SELECT COUNT(*) AS row_count,
       COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM core.dim_customer;