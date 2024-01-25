# Query 1-binary
with test_a as (
SELECT 
    event_id,
    date(event_time) as day,
    user_id,
    max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
    max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
from dsv1069.events
where event_name='test_assignment'
group by 
      event_id,
      day,
      user_id
)
select 
    t.test_id,
    t.test_assignment,
    t.user_id,
    MAX(case when t.day<o.created_at then 1 else 0 end) as orders_after_assignment_binary
    
from test_a t left join dsv1069.orders  o on t.user_id=o.user_id
group by  
    t.test_id,
    t.test_assignment,
    t.user_id
    
# Query 2-order metric
with test_a as (
SELECT 
    event_id,
    date(event_time) as day,
    user_id,
    max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
    max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
from dsv1069.events
where event_name='test_assignment'
group by 
      event_id,
      day,
      user_id
)
select 
    t.test_id,
    t.test_assignment,
    t.user_id,
    count (distinct (case when t.day<o.created_at then o.invoice_id else null end)) as orders_cnt_after_assignment,
    count (distinct (case when t.day<o.created_at then o.line_item_id else null end)) as item_cnt_after_assignment,
    sum (case when t.day<o.created_at then o.price else null end) as total_revenue_after_assignment
from test_a t left join dsv1069.orders  o on t.user_id=o.user_id
group by  
    t.test_id,
    t.test_assignment,
    t.user_id
