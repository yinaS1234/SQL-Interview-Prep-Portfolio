# Query 1
select 
user_id,
item_id,
event_time,
rank() over(partition by user_id order by event_time desc) as rk
from dsv1069.view_item_events

# Query 2
select *
from (
      select 
      user_id,
      item_id,
      event_time,
      rank() over(partition by user_id order by event_time desc) as rk
      from dsv1069.view_item_events
) view_rank
JOIN dsv1069.users on view_rank.user_id=users.id
JOIN dsv1069.items on view_rank.item_id=items.id

# Include Edge
SELECT
  COALESCE(users.parent_user_id, users.id) AS user_id,
  users.email_address,
  items.id AS item_id,
  items.name AS item_name,
  items.category AS item_category
from (
      select 
          user_id,
          item_id,
          event_time,
          rank() over(partition by user_id order by event_time desc) as rk
      from dsv1069.view_item_events
      where event_time >'2017-01-01'
) view_rank
JOIN dsv1069.users on view_rank.user_id=users.id
JOIN dsv1069.items on view_rank.item_id=items.id
LEFT JOIN dsv1069.orders on view_rank.user_id=orders.user_id and view_rank.item_id=orders.item_id
where rk=1 
and users.deleted_at is null 
and orders.item_id is null

# Standard Query
SELECT
  users.id AS user_id,
  users.email_address,
  items.id AS item_id,
  items.name AS item_name,
  items.category AS item_category,
  view_rank.rk
from (
      select 
      user_id,
      item_id,
      event_time,
      rank() over(partition by user_id order by event_time desc) as rk
      from dsv1069.view_item_events
) view_rank
JOIN dsv1069.users on view_rank.user_id=users.id
JOIN dsv1069.items on view_rank.item_id=items.id
where rk=1

# Query 5
select *
from dsv1069.users
where id=192206







