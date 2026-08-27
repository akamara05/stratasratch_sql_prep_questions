
-- Output required: year-month(date) and absolute value of the difference  bewteen the avearge for that month and the riders distance per dollar 
-- order results earliest date, DESC 
WITH cte AS 
(
SELECT 
DATE_FORMAT(request_date, '%Y-%m') AS date,
(distance_to_travel/monetary_cost) AS distance_per_dollar,
AVG(distance_to_travel/monetary_cost) OVER (PARTITION BY DATE_FORMAT(request_date, '%Y-%m') ) AS avg_per_month
FROM uber_request_logs
)
SELECT 
date, 
ROUND(ABS(distance_per_dollar-avg_per_month),2) AS difference 
FROM cte
GROUP BY 1
ORDER BY 1; 
