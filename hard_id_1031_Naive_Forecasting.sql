WITH MonthlyTotals AS 
(
SELECT  
MONTH(request_date) AS month,
SUM(distance_to_travel)/SUM(monetary_cost) AS distance_per_dollar
FROM uber_request_logs
GROUP BY 1
),
Forecasting AS (
SELECT month, 
 distance_per_dollar AS actual,
-- use LAG function to retrieve the previous month's value and place in a separate column.
LAG(distance_per_dollar) OVER(order by month) AS forecast
FROM MonthlyTotals
) 
SELECT SQRT(AVG(POWER(actual - forecast, 2))) AS rmse
FROM Forecasting
