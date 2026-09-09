/* 
Title: User Flag Performance Analysis

Instructions: A video platform's trust and safety team wants to measure how effective each user's flags are at surfacing content that 
actually gets moderated. For each user who has had at least one flag reviewed by YouTube, determine the number of distinct 
videos they flagged that had at least one YouTube-reviewed flag, and how many of those videos were ultimately removed.

Output the user's first name, last name, the number of distinct flagged videos with at least one YouTube-reviewed flag, the 
number of those videos that were ultimately removed, and the most recent review date among their reviewed flags.
*/

WITH Base AS ( 
SELECT
U.*, 
R.reviewed_by_yt,
R.reviewed_date,
R.reviewed_outcome
FROM user_flags AS U 
LEFT JOIN flag_review AS R 
USING(flag_id)
-- For each user who has had at least one flag reviewed by YouTube.
WHERE reviewed_by_yt >=1 
), 
VideoCounts AS ( 
SELECT 
user_firstname,
user_lastname, 
-- Most recent review date
MAX(reviewed_date) AS latest_review_date,
COUNT(DISTINCT CASE WHEN flag_id IS NOT NULL THEN video_id END) AS videos_flagged, 
COUNT(reviewed_by_yt) AS videos_reviewed, 
COUNT(DISTINCT CASE WHEN reviewed_outcome = 'APPROVED' THEN video_id END ) AS videos_approved,
COUNT(DISTINCT CASE WHEN reviewed_outcome = 'REMOVED' THEN video_id END ) AS videos_removed
FROM Base 
GROUP BY 1, 2
) 
SELECT 
user_firstname,
user_lastname,
videos_flagged,
videos_removed,
latest_review_date
FROM VideoCounts 
ORDER BY 1;
