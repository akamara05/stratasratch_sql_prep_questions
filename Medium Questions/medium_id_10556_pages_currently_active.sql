/* 
Title: Pages Currently Active

Instructions: You are monitoring a system where pages can be turned on or off at different times. The page status log records 
every state change event for each page. Find the number of pages that are currently active based on their most recent status 
change. Return the count of currently active pages.
*/

WITH base AS ( 
SELECT
page_id, 
status,
ROW_NUMBER() OVER(PARTITION BY page_id ORDER BY changed_at DESC) AS row_order
FROM page_status_log
ORDER BY 1, 3
)
SELECT 
COUNT(DISTINCT page_id) as active_pages_count
FROM base
WHERE row_order = 1
AND status = 'on';
