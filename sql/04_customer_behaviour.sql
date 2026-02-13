# 1.) How do new vs returning customers contribute to total revenue? 

-- CTE to aggregate order counts per unique customer identity
WITH CustomerStats AS (
	SELECT 
		c.customer_unique_id,
		-- Counting all orders tied to the unique ID to determine loyalty
		count(o.order_id) as total_orders
    FROM customers c
    LEFT JOIN orders o on c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
-- Categorising customers based on their historical order frequency
CustomerLabels AS(
	SELECT 
		customer_unique_id,
        -- One order is 'New' (Single-purchase); more than one is 'Returning'
        CASE WHEN total_orders = 1 THEN 'New' ELSE 'Returning' END as customer_type
	FROM CustomerStats
)

SELECT
	CustomerLabels.customer_type,
	-- Distinct count ensures we count the person, not their multiple order instances
	COUNT(DISTINCT c.customer_unique_id) as total_customers,
    -- Summing total spend to compare the financial value of each segment
    SUM(op.payment_value) as total_revenue
FROM customers c
LEFT JOIN CustomerLabels on c.customer_unique_id = CustomerLabels.customer_unique_id
LEFT JOIN orders o on c.customer_id = o.customer_id
LEFT JOIN order_payments op on o.order_id = op.order_id
GROUP BY CustomerLabels.customer_type
ORDER BY total_revenue;

# 2.) What proportion of orders comes from repeat customers?
WITH CustomerStats AS (
	SELECT 
		c.customer_unique_id,
		count(o.order_id) as total_orders
    FROM customers c
    LEFT JOIN orders o on c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
),
CustomerLabels AS(
	SELECT 
		customer_unique_id,
        CASE WHEN total_orders = 1 THEN 'New' ELSE 'Returning' END as customer_type
	FROM CustomerStats
)

SELECT 
	CustomerLabels.customer_type,
		COUNT(o.order_id) as total_orders,
		-- Using Window Function SUM(...) OVER() to calculate percentage of the grand total
		ROUND(COUNT(o.order_id) * 100.0 / SUM(COUNT(o.order_id)) OVER (), 2) as proportion_percentage
FROM customers c
LEFT JOIN CustomerLabels on c.customer_unique_id = CustomerLabels.customer_unique_id
LEFT JOIN orders o on c.customer_id = o.customer_id
GROUP BY CustomerLabels.customer_type;
