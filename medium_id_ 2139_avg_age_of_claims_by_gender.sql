/*
Title: Average Age of Claims by Gender

Instructions: You have been asked to calculate the average age by gender of people who filed more than 1 claim in 2021.
The output should include the gender and average age rounded to the nearest whole number.
*/

WITH Base AS (
SELECT 
C.account_id,
A.age,
A.gender, 
COUNT(DISTINCT C.claim_id) AS claim_count
FROM cvs_claims AS C
LEFT JOIN cvs_accounts AS A
USING (account_id) 
WHERE YEAR(date_submitted) = '2021'
GROUP BY 1,2,3
) 
SELECT gender, 
-- Average age rounded to the nearest whole number
ROUND(AVG(age)) AS avg_age
FROM Base
-- Filed more than 1 claim
WHERE claim_count > 1
GROUP BY 1;
