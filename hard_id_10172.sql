WITH totals_paid AS (
SELECT month(invoicedate) AS month,
description,
SUM(unitprice*quantity) AS total_paid
FROM online_retail
-- excludes cancelled orders
WHERE invoiceno NOT LIKE 'C%'
GROUP BY 1, 2
-- excludes any returns marked by a negative vlaue 
HAVING total_paid >=0
), 
ranking AS (
SELECT month, 
description, 
total_paid, rank() over (PARTITION BY month ORDER BY total_paid DESC) as rankings
FROM totals_paid
WHERE total_paid >= 0
ORDER BY 1
) 
SELECT month, 
description, 
total_paid
FROM ranking
-- return only the highest rank for each month
WHERE rankings = 1
