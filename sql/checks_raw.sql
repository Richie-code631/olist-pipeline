-- Check grain: a single row holding the number of rows in raw.orders
SELECT COUNT(*) AS row_count
FROM raw.orders;

--Check grain: one row per table in the raw schema
SELECT table_name 
FROM information_schema.tables
WHERE table_schema = 'raw'
ORDER BY table_name;
