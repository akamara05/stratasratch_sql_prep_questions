/* 
Instructions: This code doesn't return the expected result. Find what's wrong and fix it.

Title: Rank Variance Per Country

Question: Compare the total number of comments made by users in each country during December 2019 and January 2020.

For each month, rank countries by their total number of comments in descending order. Countries with the same total should  
share the same rank, and the next rank should increase by one (without skipping numbers).

Return the names of the countries whose rank improved from December to January (that is, their rank number became smaller).
*/

-- ORIGINAL SCRIPT
WITH monthly_comments AS(
SELECT 
u.country,
DATE_FORMAT(c.created_at, '%Y-%m-01') AS month_start,
SUM(c.number_of_comments) AS total_comments
FROM fb_comments_count c
JOIN fb_active_users u ON c.user_id = u.user_id
WHERE c.created_at >= '2019-12-01' AND c.created_at < '2020-02-01'
GROUP BY u.country, DATE_FORMAT(c.created_at, '%Y-%m-01')
	),
ranked_comments AS(
SELECT country,
month_start,
total_comments,
DENSE_RANK() OVER (ORDER BY total_comments DESC) AS month_rank
FROM monthly_comments),
december_rank AS (
SELECT 
country,
total_comments,
month_rank AS dec_rank
FROM ranked_comments
WHERE month_start = '2019-12-01'),
january_rank AS(
SELECT 
country,
total_comments,
month_rank AS jan_rank
FROM ranked_comments
WHERE month_start = '2020-01-01'),
rank_compare AS(
SELECT 
d.country,
d.dec_rank,
j.jan_rank
FROM december_rank d
JOIN january_rank j ON d.country = j.country
)
SELECT country
FROM rank_compare
WHERE dec_rank > jan_rank
ORDER BY dec_rank;

-------------------------------------------------------------------------
-- UPDATED SCRIPT
WITH monthly_comments AS(
SELECT 
u.country,
DATE_FORMAT(c.created_at, '%Y-%m-01') AS month_start,
SUM(c.number_of_comments) AS total_comments
FROM fb_comments_count c
LEFT JOIN fb_active_users u USING(user_id)
WHERE c.created_at BETWEEN '2019-12-01' AND '2020-02-01'
GROUP BY 1,2 ),
dec_ranked_comments AS(
SELECT DISTINCT country,
month_start,
total_comments,
DENSE_RANK() OVER (ORDER BY total_comments DESC) AS dec_rank
FROM monthly_comments
WHERE month_start = '2019-12-01'
),
jan_ranked_comments AS(
SELECT DISTINCT country,
month_start,
total_comments,
DENSE_RANK() OVER (ORDER BY total_comments DESC) AS jan_rank
FROM monthly_comments
WHERE month_start = '2020-01-01'
)
SELECT country 
FROM dec_ranked_comments
INNER JOIN jan_ranked_comments USING(country)
WHERE dec_rank > jan_rank;

