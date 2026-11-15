-- reports.revenue_by_category_month grain: one row per product category per month
CREATE OR REPLACE VIEW reports.revenue_by_category_month AS
SELECT d.year,
       d.month,
       COALESCE(p.product_category_name, 'unknown') AS category,
       COUNT(*) AS items_sold,
       ROUND(SUM(f.price), 2) AS revenue
FROM core.fact_order_items AS f
JOIN core.dim_product AS p ON p.product_key = f.product_key
JOIN core.dim_date AS d ON d.date_key = f.purchase_date_key
WHERE f.order_status = 'delivered'                                               
GROUP BY d.year, d.month, COALESCE(p.product_category_name, 'unknown');

