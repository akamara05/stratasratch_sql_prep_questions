/* 
Title: Distances Traveled

Instructions: Find the top 10 users that have traveled the greatest distance. Output their id, name and a total distance traveled.
*/

-- Consolidate necessary fields from both tables.
WITH base AS ( 
SELECT 
rides.user_id, 
rides.id,
rides.distance,
users.name
FROM lyft_rides_log AS rides
LEFT JOIN lyft_users AS users
ON users.id = rides.user_id
) 
SELECT
user_id,
name, 
SUM(distance) AS traveled_distance
FROM base
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;
