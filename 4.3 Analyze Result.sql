# Query 1-binary-porpotion
select 
    test_assignment,
    count(user_id) as num_of_user,
    sum(orders_after_assignment_binary) as num_user_with_orders
FROM
(
    with test_a as (
    SELECT 
        event_id,
        event_time,
        user_id,
        max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
        max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
    from dsv1069.events
    where event_name='test_assignment'
    group by 
          event_id,
          event_time,
          user_id
    )
    select 
        t.test_id,
        t.test_assignment,
        t.user_id,
        MAX(case when t.event_time<o.created_at then 1 else 0 end) as orders_after_assignment_binary
        
    from test_a t left join dsv1069.orders  o on t.user_id=o.user_id
    group by  
        t.test_id,
        t.test_assignment,
        t.user_id
)order_indicator
where test_id=7 
group by test_assignment

# Query 2-binary-proportion
select 
    test_assignment,
    count(user_id) as num_of_user,
    sum(views_after_assignment_binary) as num_user_with_views
FROM
(
   with test_a as (
SELECT 
    event_id,
    event_time,
    user_id,
    max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
    max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
from dsv1069.events
where event_name='test_assignment'
group by 
      event_id,
      event_time,
      user_id
)
select 
    t.test_id,
    t.test_assignment,
    t.user_id,
    MAX(case when t.event_time<v.event_time then 1 else 0 end) as views_after_assignment_binary
    
from test_a t left join 
(select * from dsv1069.events
where event_name='view_item') v  on t.user_id=v.user_id
group by  
    t.test_id,
    t.test_assignment,
    t.user_id
)view_indicator
where test_id=7 
group by test_assignment

# Query 3
select 
    test_assignment,
    count(user_id)                             as num_of_user,
    sum(views_after_assignment_binary)         as num_users_viewed,
    sum(views_within_30D_A_binary)             as num_user_viewed_within_30event_time
FROM
(
   with test_a as (
SELECT 
    event_id,
    event_time,
    user_id,
    max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
    max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
from dsv1069.events
where event_name='test_assignment'
group by 
      event_id,
      event_time,
      user_id
)
select 
    t.test_id,
    t.test_assignment,
    t.user_id,
    MAX(case when t.event_time<v.event_time then 1 else 0 end) as views_after_assignment_binary,
    MAX(case when (t.event_time<v.event_time) and date_part('day',v.event_time - t.event_time)<=30 then 1 else 0 end) as views_within_30D_A_binary
    
from test_a t left join 
(select * from dsv1069.events
where event_name='view_item') v  on t.user_id=v.user_id
group by  
    t.test_id,
    t.test_assignment,
    t.user_id
)view_indicator
where test_id=7 
group by test_assignment

# Query 4 Mean metrics

SELECT 
    test_id,
    test_assignment,
    count(user_id)                             as num_of_user,
    avg(orders_cnt_after_assignment)           as avg_invoices_after_assignment,
    stddev(orders_cnt_after_assignment)       as stddev_invoices
FROM
(  with test_a as (
        SELECT 
            event_id,
            event_time,
            user_id,
            max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
            max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
        from dsv1069.events
        where event_name='test_assignment'
        group by 
              event_id,
              event_time,
              user_id
                  )
    select 
        t.test_id,
        t.test_assignment,
        t.user_id,
        count (distinct (case when t.event_time<o.created_at then o.invoice_id else null end)) as orders_cnt_after_assignment,
        count (distinct (case when t.event_time<o.created_at then o.line_item_id else null end)) as item_cnt_after_assignment,
        sum (case when t.event_time<o.created_at then o.price else null end) as total_revenue_after_assignment
    from test_a t left join dsv1069.orders  o on t.user_id=o.user_id
    group by  
        t.test_id,
        t.test_assignment,
        t.user_id
) order_af_assigntment
group by test_id, 
         test_assignment
order by test_id



