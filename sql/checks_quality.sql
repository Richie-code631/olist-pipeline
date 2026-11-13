-- Check grain: A single row holding how many order_id values appear more than once in raw.orders
SELECT COUNT(*) AS duplicate_order_ids
FROM (
	SELECT order_id
	FROM raw.orders
	GROUP BY order_id
	HAVING COUNT(*) > 1
)
 AS d;

-- Check grain: one row per order-status with how many orders are missing a delivered date
SELECT order_status,
		COUNT(*) AS orders,
		SUM(CASE 
		WHEN order_delivered_customer_date IS NULL 
		THEN 1 ELSE 0 END) AS missing_delivered_date
FROM raw.orders
GROUP BY order_status
ORDER BY orders DESC;

-- Check grain: a single row holding how many order_items rows have an order_id missing from raw.orders
SELECT COUNT(*) AS orphan_items
FROM raw.order_items AS oi
LEFT JOIN raw.orders AS o ON o.order_id = oi.order_id
WHERE o.order_id IS NULL;                 

-- Check grain: a single row holding how many orders have a delivered date earlier than the purchase date
SELECT COUNT(*) AS delivered_before_purchase
FROM raw.orders
WHERE CAST(order_delivered_customer_date AS timestamp)
      < CAST(order_purchase_timestamp AS timestamp);                    