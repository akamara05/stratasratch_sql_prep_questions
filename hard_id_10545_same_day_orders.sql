/* 
Title: Same-Day Orders

Instructions: 
Identify users who started a session and placed an order on the same day.
For these users, return the total number of orders placed on that day and the total order value for that day.
Your output should include the user_id, the session_date, the total number of orders, and the total order value for that day.
*/

WITH Base AS 
(SELECT
-- Noted repeated session rows, so used DISTINCT to deduplicate session entries. 
DISTINCT S.session_date, 
S.user_id,
O.order_date, 
O.order_id,
O.order_value
FROM sessions AS S
JOIN order_summary AS O
USING (user_id)
)
SELECT 
user_id, 
session_date, 
COUNT(order_id) AS total_orders, 
SUM(order_value) AS total_order_vlaues
FROM Base 
WHERE session_date = order_date
GROUP BY 1, 2;
