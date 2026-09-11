/* 
Title: Lowest Revenue Generated Restaurants

Instructions: Write a query that returns a list of the bottom 2% revenue generating restaurants. Return a list of restaurant IDs and their total revenue from when customers placed orders in May 2020.

You can calculate the total revenue by summing the order_total column. And you should calculate the bottom 2% by partitioning 
the total revenue into evenly distributed buckets.
*/

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
