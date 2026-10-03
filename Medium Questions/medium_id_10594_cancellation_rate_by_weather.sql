-- ORIGINAL CODE 
SELECT w.weather_condition,
100.0 * AVG(CASE WHEN r.outcome = 'cancelled' THEN 1 ELSE 0 END) AS cancellation_rate_pct
FROM av_rides r
JOIN av_daily_weather w
ON LOWER(r.city) = LOWER(w.city)
AND r.ride_date = w.weather_date
GROUP BY w.weather_condition

-- UPDATED CODE 

WITH distinct_daily_weather
AS ( 
SELECT DISTINCT city,
weather_date, 
weather_condition
FROM av_daily_weather
)
SELECT  w.weather_condition,
100.0 * AVG(CASE WHEN r.outcome = 'cancelled' THEN 1 ELSE 0 END) AS cancellation_rate_pct
FROM av_rides r
JOIN distinct_daily_weather w
ON LOWER(r.city) = LOWER(w.city)
AND r.ride_date = w.weather_date
GROUP BY 1
