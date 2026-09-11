WITH cte AS 
(
SELECT 
DATE_FORMAT(customer_placed_order_datetime,'%Y-%m') order_date, 
restaurant_id, 
order_total, 
NTILE(50) OVER (ORDER BY order_total ASC, restaurant_id ASC) AS percentile
FROM doordash_delivery
WHERE DATE_FORMAT(customer_placed_order_datetime,'%Y-%m') = '2020-05'
)
SELECT 
restaurant_id,
order_total
FROM cte
WHERE percentile = 1;