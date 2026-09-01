/* 
Title: New Products 

Instructions: Calculate the net change in the number of products launched by companies in 2020 compared to 2019. 
Your output should include the company names and the net difference.
(Net difference = Number of products launched in 2020 - The number launched in 2019.)
*/

WITH TotalProducts AS (
SELECT company_name, 
COUNT(DISTINCT CASE WHEN year = 2019 THEN product_name END) AS products_2019,
COUNT(DISTINCT CASE WHEN year = 2020 THEN product_name END) AS products_2020
FROM car_launches
GROUP BY 1
)
SELECT 
company_name, 
(products_2020 - products_2019) AS total_launch 
FROM TotalProducts
ORDER BY 1; 
