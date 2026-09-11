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
AND status= 'on';