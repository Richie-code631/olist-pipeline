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

-- reports.revenue_by_sellers_month grain: one row per seller in a given month
DROP VIEW IF EXISTS reports.revenue_by_sellers_month;

CREATE OR REPLACE VIEW reports.revenue_by_sellers_month AS
SELECT s.seller_id,
	   s.seller_city,
	   s.seller_state,
	   d.year,
	   d.month,
	   COUNT(*) AS items_sold,
       ROUND(SUM(f.price), 2) AS revenue
FROM core.fact_order_items AS f
JOIN core.dim_seller AS s ON s.seller_key = f.seller_key
JOIN core.dim_date AS d ON d.date_key = f.purchase_date_key
WHERE f.order_status = 'delivered'                                               
GROUP BY s.seller_id, s.seller_city, s.seller_state, d.year, d.month;