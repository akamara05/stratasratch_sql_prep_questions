/*
Title: Naïve Forecasting
Instructions: 
Some forecasting methods are extremely simple and surprisingly effective. Naïve forecast is one of them; we simply 
set all forecasts to be the value of the last observation. Our goal is to develop a naïve forecast for a new metric called "distance per dollar" defined as the (distance_to_travel/monetary_cost) in our dataset and measure its accuracy.

Our dataset includes both successful and failed requests. For this task, include all rows regardless of request status when 
aggregating values.

To develop this forecast,  sum "distance to travel"  and "monetary cost" values at a monthly level before calculating 
"distance per dollar". This value becomes your actual value for the current month. The next step is to populate the 
forecasted value for each month. This can be achieved simply by getting the previous month's value in a separate column. 
Now, we have actual and forecasted values. This is your naïve forecast. Let’s evaluate our model by calculating an error 
matrix called root mean squared error (RMSE). RMSE is defined as sqrt(mean(square(actual - forecast)). Report out the RMSE 
rounded to the 2nd decimal spot.
*/


WITH MonthlyTotals AS 
(
SELECT  
MONTH(request_date) AS month,
 -- Calculation as per instructions. 
SUM(distance_to_travel)/SUM(monetary_cost) AS distance_per_dollar
FROM uber_request_logs
GROUP BY 1
),
Forecasting AS (
SELECT month, 
 distance_per_dollar AS actual,
-- use LAG function to retrieve the previous month's value and place in a separate column as forecasted value.
LAG(distance_per_dollar) OVER(order by month) AS forecast
FROM MonthlyTotals
) 
 -- Final Output
SELECT SQRT(AVG(POWER(actual - forecast, 2))) AS rmse
FROM Forecasting
