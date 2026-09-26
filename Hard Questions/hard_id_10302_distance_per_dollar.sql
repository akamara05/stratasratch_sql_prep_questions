/*
Title: Distance Per Dollar
Instructions: You’re given a dataset of Uber rides with the traveling distance (distance_to_travel) and cost (monetary_cost) for each ride. First, find the difference between the distance-per-dollar for each ride and the monthly distance-per-dollar for that year-month.

Distance-per-dollar for each ride is defined as the distance traveled divided by the cost of the ride. Monthly distance-per
dollar is defined as the total distance traveled in that month divided by the total cost for that month.

Use the calculated difference on each date to calculate absolute average difference in distance-per-dollar metric on monthly 
basis (year-month).

The output should include the year-month (YYYY-MM) and the absolute average difference in distance-per-dollar (Absolute 
value to be rounded to the 2nd decimal).

You should also count both success and failed request_status as the distance and cost values are populated for all ride requests. Also, assume that all dates are unique in the dataset. Order your results by earliest request date first. 
*/

-- Output required: year-month(date) and absolute value of the difference  between the average for that month and the riders' distance per dollar.
WITH base AS 
(
SELECT 
DATE_FORMAT(request_date, '%Y-%m') AS date,
(distance_to_travel/monetary_cost) AS distance_per_dollar,
AVG(distance_to_travel/monetary_cost) OVER (PARTITION BY DATE_FORMAT(request_date, '%Y-%m')) AS avg_per_month
FROM uber_request_logs
)
-- order results by earliest date, DESC 
SELECT 
date, 
ROUND(ABS(distance_per_dollar-avg_per_month),2) AS difference 
FROM base
GROUP BY 1
ORDER BY 1; 
