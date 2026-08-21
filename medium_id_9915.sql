WITH customer_totals AS 
(
SELECT
cust_id, 
order_date,
SUM(total_order_cost) AS total_daily_cost
FROM orders 
WHERE order_date BETWEEN '2019-02-01' and '2019-05-01' 
GROUP BY 1, 2
ORDER BY 3
), 
rankings AS (
SELECT  
t.*, 
-- Used dense rank window function based on these instructions,  If multiple customers tie for the highest daily total on the same date, return all of them.
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY total_daily_cost DESC) AS ranking,
c.first_name
FROM customer_totals as t 
LEFT JOIN  (SELECT id, first_name FROM customers) as c
ON t.cust_id = c.id
ORDER BY order_date, total_daily_cost DESC
) 
SELECT 
first_name, 
order_date, 
total_daily_cost as max_cost
FROM rankings 
WHERE ranking = 1
ORDER BY 2, 1


