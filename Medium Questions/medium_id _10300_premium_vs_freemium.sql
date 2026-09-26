/*
Title: Premium vs Freemium

Question: 
Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers 
have more downloads than paying customers. The output should be sorted by earliest date first and contain 3 columns date, 
non-paying downloads, paying downloads. Hint: In Oracle you should use "date" when referring to date column (reserved 
keyword).

Instructions: Debug Code. This code doesn't return the expected result. Find what's wrong and fix it.
*/


-- ORIGINAL CODE
WITH download_totals AS (
    SELECT c.date AS download_date,
-- Based on a preview of the ms_download_facts table, it makes more sense to use the SUM function instead of COUNT, as each customer may have multiple downloads per day. 
	COUNT(CASE WHEN paying_customer = 'yes' THEN downloads END) AS paying,
	COUNT(CASE WHEN paying_customer = 'no' THEN downloads END) AS non_paying
    FROM ms_user_dimension a
	-- Use USING rather than ON to join tables. 
    INNER JOIN ms_acc_dimension b ON a.acc_id = b.acc_id
    INNER JOIN ms_download_facts c ON a.user_id = c.user_id
    GROUP BY c.date
)
SELECT 
download_date,
non_paying,
paying
FROM download_totals
-- Wrong filter criteria.
WHERE (non_paying - paying) > 0
-- ASC is not necessary; it's assumed as the default.
ORDER BY download_date ASC;


-- UPDATED CODE
WITH download_totals AS (
    SELECT c.date AS download_date,
	SUM(CASE WHEN paying_customer = 'yes' THEN downloads END) AS paying,
	SUM(CASE WHEN paying_customer = 'no' THEN downloads END) AS non_paying
    FROM ms_user_dimension a
    LEFT JOIN ms_download_facts c USING(user_id)
    LEFT JOIN ms_acc_dimension b USING(acc_id)
    GROUP BY 1
	--  Include only records where non-paying customers have more downloads than paying customers.
    HAVING non_paying > paying
)
SELECT 
download_date,
non_paying,
paying
FROM download_totals
ORDER BY 1


