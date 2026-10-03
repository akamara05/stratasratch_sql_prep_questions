
/*
Debug. This code doesn't return the expected result. Find what's wrong and fix it.

The Product Data Science team wants to see whether weather conditions affect how often rides get canceled. Join each ride 
to the weather recorded for its city on its ride date, then calculate the cancellation rate for each weather condition (the 
percentage of rides with outcome canceled).

The weather table contains some exact duplicate rows from a repeated data load, which must not make a ride count twice. Exclude rides with no matching weather record.

Output the weather condition and the cancellation rate.
*/



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
