WITH Base AS (
SELECT 
C.account_id,
A.age,
A.gender, 
COUNT(DISTINCT claim_id) AS claim_count
FROM cvs_claims AS C
LEFT JOIN cvs_accounts AS A
USING (account_id) 
WHERE YEAR(date_submitted) = '2021'
GROUP BY 1,2,3
) 
SELECT gender, 
ROUND(AVG(age)) AS avg_age
FROM Base
WHERE claim_count > 1
GROUP BY 1;