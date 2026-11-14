-- Check grain: a single row holding the number of rows in core.dim_seller(expected: sellers 3095)
SELECT COUNT(*) AS row_count 
FROM core.dim_seller;

-- Check grain: a single row holding the row count and the number of distinct real customers in core.dim_customer(expected: row count 99441 and unique_cutomers 96096 )
SELECT COUNT(*) AS row_count,
       COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM core.dim_customer;

-- Check grain: a single row holding the rows in core.dim_product(expected: products 32951)
SELECT COUNT(*) AS row_count
FROM core.dim_product;

-- Check grain: a single row holding the number of products with a missing category name
SELECT COUNT(*) AS missing_category
FROM raw.products
WHERE product_category_name IS NULL;  

-- Check grain: a single row holding how many order_items rows belong to products with no category name
SELECT COUNT(*) AS items_without_category
FROM raw.order_items AS oi
JOIN raw.products AS p ON p.product_id = oi.product_id
WHERE product_category_name IS NULL;              