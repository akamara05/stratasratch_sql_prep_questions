/* 
Title: Actor Rating Difference Analysis

Question: 
You are given a dataset of actors and the films they have been involved in, including each film's release date and rating. 
For each actor, calculate the difference between the rating of their most recent film and their average rating across all 
previous films (the average rating excludes the most recent one).

Return a list of actors along with their average rating of previous films, the rating of their most recent film, and the 
difference between the two ratings. Round the difference calculation to 2 decimal places. If an actor has only one film, 
return 0 for the difference and their only film’s rating for both the average and latest rating fields.
*/

WITH release_order AS (
SELECT
actor_name, 
film_title,
release_date,
film_rating,
-- Order release dates by actor. 
row_number() over (PARTITION BY actor_name ORDER BY release_date DESC) AS release_sequence
FROM actor_rating_shift
), 
averages AS (
SELECT actor_name,
-- If an actor has only one film, return 0 for the difference and their only film’s rating for both the average 
-- and latest rating fields.
CASE WHEN COUNT(film_title) = 1 THEN film_rating
ELSE
-- The average rating excludes the most recent one
AVG(CASE WHEN release_sequence > 1 THEN film_rating END) 
END AS avg_rating,
-- Most recent film rating
CASE WHEN release_sequence = 1 THEN film_rating END AS latest_rating
FROM release_order
GROUP BY 1
)
-- Final output
SELECT
*, 
-- Round the difference calculation to 2 decimal places.
ROUND(( latest_rating-avg_rating),2) AS rating_difference
FROM averages
ORDER BY 1
