/* 1. Backup SQL Code for Churn Rate by Customer Segment */

WITH months AS (
  SELECT '2017-01-01' AS first_day, '2017-01-31' AS last_day
  UNION
  SELECT '2017-02-01' AS first_day, '2017-02-28' AS last_day
  UNION
  SELECT '2017-03-01' AS first_day, '2017-03-31' AS 'last_day'
),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
), status AS (
  SELECT id, first_day AS month,
  CASE
  WHEN (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL) AND (segment = 87) THEN 1
  ELSE 0
  END AS is_active_87,
  CASE
  WHEN (subscription_end BETWEEN first_day AND last_day) AND (segment = 87) THEN 1
  ELSE 0
  END AS is_canceled_87,
  CASE
  WHEN (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL) AND (segment = 30) THEN 1
  ELSE 0
  END AS is_active_30,
  CASE
  WHEN (subscription_end BETWEEN first_day AND last_day) AND (segment = 30) THEN 1
  ELSE 0
  END AS is_canceled_30
  FROM cross_join
), summary AS (
  SELECT month, SUM(is_active_87) AS active_87, SUM(is_canceled_87) AS canceled_87,
  SUM(is_active_30) AS active_30, SUM(is_canceled_30) AS canceled_30
  FROM status
  GROUP BY month
  )
  SELECT month, (1.0 * canceled_87/active_87) AS churn_rate_87, (1.0 * canceled_30/active_30) AS churn_rate_30
  FROM summary;



/* 2. Backup SQL Code for Number of Active Versus Canceled Customers */

WITH months AS (
  SELECT '2017-01-01' AS first_day, '2017-01-31' AS last_day
  UNION
  SELECT '2017-02-01' AS first_day, '2017-02-28' AS last_day
  UNION
  SELECT '2017-03-01' AS first_day, '2017-03-31' AS last_day
),
cross_join AS (
  SELECT *
  FROM subscriptions
  CROSS JOIN months
), status AS (
  SELECT id, first_day AS month,
  CASE
  WHEN (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL) AND (segment = 87) THEN 1
  ELSE 0
  END AS is_active_87,
  CASE
  WHEN (subscription_end BETWEEN first_day AND last_day) AND (segment = 87) THEN 1
  ELSE 0
  END AS is_canceled_87,
  CASE
  WHEN (subscription_start < first_day) AND (subscription_end > first_day OR subscription_end IS NULL) AND (segment = 30) THEN 1
  ELSE 0
  END AS is_active_30,
  CASE
  WHEN (subscription_end BETWEEN first_day AND last_day) AND (segment = 30) THEN 1
  ELSE 0
  END AS is_canceled_30
  FROM cross_join
)
  SELECT month, SUM(is_active_87) AS active_87, SUM(is_canceled_87) AS canceled_87,
  SUM(is_active_30) AS active_30, SUM(is_canceled_30) AS canceled_30
  FROM status
  GROUP BY month;



/* OTHER: Min, Max "subscription start" dates */

SELECT MIN(subscription_start), MAX(subscription_start)
FROM subscriptions;
