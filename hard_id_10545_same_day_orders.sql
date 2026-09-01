WITH Base AS 
(SELECT
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