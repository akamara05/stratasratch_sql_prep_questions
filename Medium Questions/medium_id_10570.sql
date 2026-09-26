/*
Title: Car Part Price

Question: An automotive parts supplier maintains a database of car part prices across different model years. As parts are 
redesigned or manufacturing costs change, prices fluctuate from year to year. The procurement team needs to analyze these 
price trends to identify which parts have seen the most significant price increases or decreases.

Calculate the price change for each car part compared to its previous model year. The price change should show the 
difference in dollars (current price minus previous price). For the first occurrence of each part, the price change should 
be NULL since there's no prior data to compare against. Return all columns from the original table plus a column showing the 
change from the previous model year.

If the dataset contains duplicates, remove them before calculating price changes, keeping only one entry per unique 
car_part_id, model_year combination. Note that some parts may have gaps in their model year sequences. In these cases, 
calculate the price change against whichever entry comes immediately before in the dataset, regardless of how many years 
have passed.
*/


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
