/* 
Question: Find the customers with the highest daily total order cost between ** 2019-02-01 and 2019-05-01**. If a customer had more than one order on a certain day, sum the order costs on a daily basis. Output each customer's first name, total cost of their items, and the date. If multiple customers tie for the highest daily total on the same date, return all of them.
*/

-- Let's take a daily summary of said customers within the instructed timeline 2019-02-01 and 2019-05-01. 
WITH customer_totals AS(
SELECT
cust_id, 
order_date,
SUM(total_order_cost) AS total_daily_cost
FROM orders 
WHERE order_date BETWEEN '2019-02-01' and '2019-05-01' 
GROUP BY 1, 2
ORDER BY 2 -- not necessary to order at this point, but easy for the analyst's readability as a first-step sanity check.
), 
-- Let's rank these total daily costs for the given order dates. 
rankings AS (
SELECT  
t.*, 
-- Used dense rank window function based on these instructions: *If multiple customers tie for the highest daily total on the same date, return all of them.*
DENSE_RANK() OVER (PARTITION BY order_date ORDER BY total_daily_cost DESC) AS ranking,
c.first_name
FROM customer_totals as t 
LEFT JOIN  (SELECT id, first_name FROM customers) as c --I only want the first name column from the customer table. 
ON t.cust_id = c.id
ORDER BY order_date, total_daily_cost DESC
) 
-- Final Output 
SELECT 
first_name, 
order_date, 
total_daily_cost AS max_cost
FROM rankings 
WHERE ranking = 1
ORDER BY 2, 1 -- Order by customer name and order date for better readability. 


