WITH base AS (
SELECT
-- Use distinct to remove duplicates. 
DISTINCT car_part_id, 
model_year,
price
FROM car_parts
)
SELECT
car_part_id, 
model_year,
price,
-- Use LAG window function to compute difference between current row and the previous row. 
price - LAG(price) over(PARTITION BY car_part_id ORDER BY model_year) AS price_change
FROM base
ORDER BY 1, 2