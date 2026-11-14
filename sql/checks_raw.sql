-- Check grain: a single row holding the number of rows in raw.orders
SELECT COUNT(*) AS row_count
FROM raw.orders;

--Check grain: one row per table in the raw schema
SELECT table_name 
FROM information_schema.tables
WHERE table_schema = 'raw'
ORDER BY table_name;

SELECT COUNT(*) AS row_count
FROM raw.customers;

-- Check grain: one row per raw table with its row count
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL SELECT 'geolocation', COUNT(*) FROM raw.geolocation
UNION ALL SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM raw.order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM raw.order_reviews
UNION ALL SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL SELECT 'products', COUNT(*) FROM raw.products
UNION ALL SELECT 'sellers', COUNT(*) FROM raw.sellers
UNION ALL SELECT 'product_category', COUNT(*) FROM raw.product_category;