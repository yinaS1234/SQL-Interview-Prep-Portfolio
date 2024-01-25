# average time between 1st_2nd order per use
with cte as (
with rankorder as (
    SELECT user_id,
           invoice_id,
           paid_at,
           DENSE_RANK() OVER (PARTITION BY user_id
           ORDER BY paid_at ASC) AS order_num
    FROM dsv1069.orders
)
SELECT user_id,
       AVG(date_diff) as average_time_between_order
FROM

    (SELECT first_orders.user_id,
           DATE(first_orders.paid_at) AS first_order_date,
           DATE(second_orders.paid_at) AS second_order_date,
           DATE(second_orders.paid_at) - DATE(first_orders.paid_at) AS date_diff
    FROM
        (rankorder first_orders JOIN rankorder second_orders
      ON first_orders.user_id = second_orders.user_id)
    WHERE first_orders.order_num = 1 AND second_orders.order_num = 2
    )order_diff
group by user_id
)

select 
avg(average_time_between_order) as average_time_bt_by_user
from cte

# how many ever ordered
select count(distinct user_id) as user_o_cnt
from dsv1069.orders

# how many users
select count(id) as user_cnt
from dsv1069.users

# order per category

SELECT
item_category, 
count(distinct invoice_id) as order_per_category
from dsv1069.orders
group by rollup (item_category)
order by order_per_category desc


# order per item
SELECT
item_id,
count(distinct invoice_id) as order_per_item
from dsv1069.orders
group by rollup(item_id)
order by order_per_item DESC

# order_multiple_item_per_category_user_cnt
with cte as (
select 
user_id, 
item_category,
count(distinct item_id) as item_cnt_per_user_category
from dsv1069.orders
group by user_id, item_category
)
select item_category, avg(item_cnt_per_user_category) as avg_times_category_ordered
from cte
group by item_category

# reorder same item user-cnt
with cte as (
  select 
        user_id,
        item_id,
        count(item_id) as times_user_ordered
  from dsv1069.orders
  group by user_id, item_id
  having count(item_id)>1
)
select count(distinct user_id) as users_reordered_sameitem_cnt
from cte

# reorder_user_cnt
select count(user_id) as user_reorder_cnt
from (
select user_id, count(distinct invoice_id) as order_cnt
from dsv1069.orders
group by user_id
order by count(distinct invoice_id) desc
)user_level
where order_cnt>1







