# 1. Data Quality Check
--We are running an experiment at an item-level, which means all users who visit will see the same page, but the layout of different item pages may differ.
--Compare this table to the assignment events we captured for user_level_testing.
--Does this table have everything you need to compute metrics like 30-day view-binary?
--ANSWER: NO, we need event_time information such as created_at
SELECT 
  * 
FROM 
  dsv1069.final_assignments_qa
  
  # 2. Reformat the Data
  SELECT
  item_id,
  test_a AS test_assignment,
  (
    CASE
      WHEN test_a IS NOT NULL THEN 'test_a'
      ELSE NULL
    END
  ) AS test_num,
  (
    CASE
      WHEN test_a IS NOT NULL THEN '2013-01-05 00:00:00'
      ELSE NULL
    END
  ) AS test_start_date
FROM
  dsv1069.final_assignments_qa
UNION
SELECT
  item_id,
  test_b AS test_assignment,
  (
    CASE
      WHEN test_b IS NOT NULL THEN 'test_b'
      ELSE NULL
    END
  ) AS test_num,
  (
    CASE
      WHEN test_b IS NOT NULL THEN '2013-01-05 00:00:00'
      ELSE NULL
    END
  ) AS test_start_date
FROM
  dsv1069.final_assignments_qa
UNION
SELECT
  item_id,
  test_c AS test_assignment,
  (
    CASE
      WHEN test_c IS NOT NULL THEN 'test_c'
      ELSE NULL
    END
  ) AS test_num,
  (
    CASE
      WHEN test_c IS NOT NULL THEN '2013-01-05 00:00:00'
      ELSE NULL
    END
  ) AS test_start_date
FROM
  dsv1069.final_assignments_qa
UNION
SELECT
  item_id,
  test_d AS test_assignment,
  (
    CASE
      WHEN test_d IS NOT NULL THEN 'test_d'
      ELSE NULL
    END
  ) AS test_num,
  (
    CASE
      WHEN test_d IS NOT NULL THEN '2013-01-05 00:00:00'
      ELSE NULL
    END
  ) AS test_start_date
FROM
  dsv1069.final_assignments_qa
UNION
SELECT
  item_id,
  test_e AS test_assignment,
  (
    CASE
      WHEN test_e IS NOT NULL THEN 'test_e'
      ELSE NULL
    END
  ) AS test_num,
  (
    CASE
      WHEN test_e IS NOT NULL THEN '2013-01-05 00:00:00'
      ELSE NULL
    END
  ) AS test_start_date
FROM
  dsv1069.final_assignments_qa
UNION
SELECT
  item_id,
  test_f AS test_assignment,
  (
    CASE
      WHEN test_f IS NOT NULL THEN 'test_f'
      ELSE NULL
    END
  ) AS test_num,
  (
    CASE
      WHEN test_f IS NOT NULL THEN '2013-01-05 00:00:00'
      ELSE NULL
    END
  ) AS test_start_date
FROM
  dsv1069.final_assignments_qa
 
 # 3. Compute Order Binary
 
 -- Use this table to 
-- compute order_binary for the 30 day window after the test_start_date
-- for the test named item_test_2
SELECT
  t.item_id,
  t.test_assignment,
  t.test_number,
  t.test_start_date,
  date(o.created_at) AS created_at,
  MAX(
    CASE
      WHEN t.test_start_date < o.created_at
      AND DATE_PART('day', o.created_at - t.test_start_date) <= 30 THEN 1
      ELSE 0
    END
  ) AS order_30day_binary
FROM
  dsv1069.final_assignments t
  LEFT JOIN dsv1069.orders o ON t.item_id = o.item_id
WHERE
  t.test_number = 'item_test_2'
GROUP BY
  t.item_id,
  t.test_assignment,
  t.test_number,
  t.test_start_date,
  created_at
  
# 4. Compute View Item Metrics
-- Use this table to 
-- compute view_binary for the 30 day window after the test_start_date
-- for the test named item_test_2
SELECT
  t.item_id,
  t.test_assignment,
  t.test_number,
  MAX(
    CASE
      WHEN t.test_start_date < v.viewed_at
      AND DATE_PART('day', v.viewed_at - t.test_start_date) <= 30 THEN 1
      ELSE 0
    END
  ) AS view_30day_binary
FROM
  dsv1069.final_assignments t
  LEFT JOIN (
    SELECT
      date(event_time) AS viewed_at,
      cast(parameter_value AS numeric) AS item_id
    FROM
      dsv1069.events
    WHERE
      event_name = 'view_item'
      AND parameter_name = 'item_id'
  ) v ON t.item_id = v.item_id
WHERE
  t.test_number = 'item_test_2'
GROUP BY
  t.item_id,
  t.test_assignment,
  t.test_number
  
# 5. Compute lift and p-value
----Use the https://thumbtack.github.io/abba/demo/abba.html to compute the lifts in metrics and the p-values for the binary metrics ( 30 day order binary and 30 day view binary) using a interval 95% confidence. 
-----item_ordered_30day
SELECT
  test_assignment,
  num_of_item,
  SUM(item_ordered_30day) AS item_ordered_30day,
  SUM(item_viewed_30day) AS item_viewed_30day
FROM
  (
    --query 1
    SELECT
      test_assignment,
      count(DISTINCT item_id) AS num_of_item,
      sum(order_30day_binary) AS item_ordered_30day,
      0 AS item_viewed_30day
    FROM
      (
        SELECT
          t.item_id,
          t.test_assignment,
          t.test_number,
          t.test_start_date,
          date(o.created_at) AS created_at,
          MAX(
            CASE
              WHEN t.test_start_date < o.created_at
              AND DATE_PART('day', o.created_at - t.test_start_date) <= 30 THEN 1
              ELSE 0
            END
          ) AS order_30day_binary
        FROM
          dsv1069.final_assignments t
          LEFT JOIN dsv1069.orders o ON t.item_id = o.item_id
        WHERE
          t.test_number = 'item_test_2'
        GROUP BY
          t.item_id,
          t.test_assignment,
          t.test_number,
          t.test_start_date,
          created_at
      ) item_order_indicatord
    GROUP BY
      test_assignment
    UNION
    ---query 2
    SELECT
      test_assignment,
      count(DISTINCT item_id) AS num_of_item,
      0 AS item_ordered_30day,
      sum(view_30day_binary) AS item_viewed_30day
    FROM
      (
        SELECT
          t.item_id,
          t.test_assignment,
          t.test_number,
          MAX(
            CASE
              WHEN t.test_start_date < v.viewed_at
              AND DATE_PART('day', v.viewed_at - t.test_start_date) <= 30 THEN 1
              ELSE 0
            END
          ) AS view_30day_binary
        FROM
          dsv1069.final_assignments t
          LEFT JOIN (
            SELECT
              date(event_time) AS viewed_at,
              cast(parameter_value AS numeric) AS item_id
            FROM
              dsv1069.events
            WHERE
              event_name = 'view_item'
              AND parameter_name = 'item_id'
          ) v ON t.item_id = v.item_id
        WHERE
          t.test_number = 'item_test_2'
        GROUP BY
          t.item_id,
          t.test_assignment,
          t.test_number
      ) item_view_indicator
    GROUP BY
      test_assignment
  ) combined_result
GROUP BY
  test_assignment,
  num_of_item
  