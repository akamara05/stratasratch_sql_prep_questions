-- Join tables.
WITH Base AS (
SELECT
P.plan_id,
P.billing_cycle_in_months,
P.plan_rate, 
S.signup_id,
S.started_at,
T.refunded_at,
T.settled_at,
T.transaction_id,
T.usd_gross
FROM noom_plans AS P
LEFT JOIN noom_signups AS S
USING (plan_id)
LEFT JOIN noom_transactions AS T
USING (signup_id)
),
Refunds AS (
SELECT billing_cycle_in_months, 
TIMESTAMPDIFF(DAY,settled_at,refunded_at) AS refund_timeframe
FROM Base 
WHERE started_at >= '2019-01-01'
) 
SELECT billing_cycle_in_months, 
MIN(refund_timeframe) AS min_day,
AVG(refund_timeframe) AS avg_day,
MAX(refund_timeframe) AS max_days
FROM Refunds
GROUP BY 1;