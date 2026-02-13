# 1.) Which state generates the most orders and revenue?

SELECT 
    -- Grouping by state to identify key geographical markets
	c.customer_state,
    -- Using DISTINCT to avoid over-counting orders with split payments
	COUNT(DISTINCT o.order_id) as total_orders,
    -- Aggregating total spend to determine the highest value regions
    SUM(op.payment_value) as total_revenue
FROM customers c
-- Linking customers to their specific orders
LEFT JOIN orders o on c.customer_id = o.customer_id
-- Joining payment data to calculate actual cash flow per state
LEFT JOIN order_payments op on o.order_id = op.order_id 
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;
