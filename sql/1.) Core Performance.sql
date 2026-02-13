-- 1.) What is the YoY overall revenue, number of orders, and average order value?

SELECT 
	-- Gathers all the timestamps and takes the 'year' of purchase (e.g. 03/03/2016 (2016))
	YEAR(o.order_purchase_timestamp) as order_year,
	-- Counts all the unique Order IDs labelled as total orders
    COUNT(DISTINCT o.order_id) as total_orders, 
    -- Adds all the payments together to get the total revenue
	SUM(op.payment_value) as total_revenue, 
    -- Total Revenue / Unique Order IDs (avoids over-counting orders which may have used different payment methods) = Average Order Value (AOV)
	ROUND(SUM(op.payment_value) / COUNT(DISTINCT o.order_id), 2) as average_order_value
FROM orders o
-- Linking payment details to orders using the unique Order ID
LEFT JOIN order_payments op on o.order_id = op.order_id
-- Not including orders which have been canceled or are unavailable 
WHERE order_status NOT IN ('canceled', 'unavailable')
-- Aggregates metrics by calendar year
GROUP BY YEAR(o.order_purchase_timestamp)
-- Ordering the table from earliest to latest to see if there has been growth YoY
ORDER BY order_year ASC;