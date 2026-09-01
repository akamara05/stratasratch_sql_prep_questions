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
from TotalProducts
ORDER BY 1; 