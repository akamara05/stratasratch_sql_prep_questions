/*
Question: 
Find the total number of downloads for paying and non-paying users by date. 
Include only records where non-paying customers have more downloads than paying customers. 
The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.

My Response: 
Each table seems to hold just a few columns of required information, so my first 
step is to join the tables and create a CTE 'Base' table to then query from. 
*/
WITH base AS (
    SELECT
        udim.user_id,
        acc.*,
        facts.date,
        facts. downloads
    FROM ms_acc_dimension AS acc -- Include aliases to improve readability.
    LEFT JOIN ms_user_dimension AS udim USING(acc_id)
    LEFT JOIN ms_download_facts AS facts USING (user_id)
),
-- Sum the number of downloads for paying vs non-paying customers.
downloads AS (
    SELECT
        date,
        SUM(case when paying_customer = 'yes' then downloads END) AS paying_downloads,
        SUM(case when paying_customer = 'no' then downloads END) AS non_paying_downloads
    FROM base
    GROUP BY 1
)
-- Final output
SELECT
    *
FROM downloads
-- Per instructions: Include only records where non-paying customers have more downloads than paying customers
WHERE
    non_paying_downloads > paying_downloads
-- Per instructions: The output should be sorted by earliest date first.
ORDER BY date
