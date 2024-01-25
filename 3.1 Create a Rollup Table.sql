# Daily Order Table
SELECT 
            date(paid_at) as day,
            count(distinct invoice_id) as order_cnt,
            count(distinct line_item_id) as lineitem_cnt
            FROM dsv1069.orders
            GROUP BY day
            order by day
limit 2000

# Query 2
SELECT 
    *
FROM
    dsv1069.dates_rollup
        LEFT JOIN
    (SELECT 
        COUNT(DISTINCT invoice_id) AS order_cnt,
            COUNT(DISTINCT line_item_id) AS lineitem_cnt,
            DATE_TRUNC('day', paid_at) AS day
    FROM
        dsv1069.orders
    GROUP BY day) daily_order ON dates_rollup.date = daily_order.day
ORDER BY date
  
# Query 3
SELECT 
    dates_rollup.date,
    COALESCE(SUM(order_cnt), 0) AS order_cnt,
    COALESCE(SUM(lineitem_cnt), 0) AS lineitem_cnt
FROM
    dsv1069.dates_rollup
        LEFT JOIN
    (SELECT 
        COUNT(DISTINCT invoice_id) AS order_cnt,
            COUNT(DISTINCT line_item_id) AS lineitem_cnt,
            DATE_TRUNC('day', paid_at) AS day
    FROM
        dsv1069.orders
    GROUP BY day) daily_order ON dates_rollup.date = daily_order.day
GROUP BY dates_rollup.date
ORDER BY dates_rollup.date
LIMIT 1000

# Query 4

SELECT 
    *
FROM
    dsv1069.dates_rollup
        LEFT JOIN
    (SELECT 
        COUNT(DISTINCT invoice_id) AS order_cnt,
            COUNT(DISTINCT line_item_id) AS lineitem_cnt,
            DATE_TRUNC('day', paid_at) AS day
    FROM
        dsv1069.orders
    GROUP BY day) daily_order ON dates_rollup.date >= daily_order.day
        AND dates_rollup.d7_ago < daily_order.day
ORDER BY date

# Query 5
SELECT 
    dates_rollup.date,
    COALESCE(SUM(order_cnt), 0) AS order_cnt,
    COALESCE(SUM(lineitem_cnt), 0) AS lineitem_cnt,
    COUNT(*) AS row
FROM
    dsv1069.dates_rollup
        LEFT JOIN
    (SELECT 
        COUNT(DISTINCT invoice_id) AS order_cnt,
            COUNT(DISTINCT line_item_id) AS lineitem_cnt,
            DATE_TRUNC('day', paid_at) AS day
    FROM
        dsv1069.orders
    GROUP BY day) daily_order ON dates_rollup.date >= daily_order.day
        AND dates_rollup.d7_ago < daily_order.day
GROUP BY dates_rollup.date
LIMIT 1000


