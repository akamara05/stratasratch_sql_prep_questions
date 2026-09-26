/*
Question: Find the best-selling item for each month (no need to separate months by year). 
The best-selling item is determined by the highest total sales amount, calculated as: total_paid = unitprice * quantity. 
A negative quantity indicates a return or cancellation (the invoice number begins with 'C'. To calculate sales, 
ignore returns and cancellations. Output the month, description of the item, and the total amount paid
*/

WITH totals_paid AS (
-- Per instructions, no need to separate months by year.
SELECT month(invoicedate) AS month,
description,
SUM(unitprice*quantity) AS total_paid
FROM online_retail
-- Excludes canceled orders
WHERE invoiceno NOT LIKE 'C%'
GROUP BY 1, 2
-- Excludes any returns marked by a negative value 
HAVING total_paid >=0
), 
ranking AS (
SELECT 
month, 
description, 
total_paid, 
rank() over (PARTITION BY month ORDER BY total_paid DESC) as rankings
FROM totals_paid
WHERE total_paid >= 0
ORDER BY 1
) 
SELECT 
month, 
description, 
total_paid
FROM ranking
-- return only the highest rank for each month
WHERE rankings = 1
