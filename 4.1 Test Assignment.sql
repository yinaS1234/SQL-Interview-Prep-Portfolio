# 1 how many test running
--- parameter_name has test_assignment test_id
SELECT distinct parameter_value as test_id
from dsv1069.events
where event_name='test_assignment' and parameter_name='test_id'

# Assignment Event Table
SELECT 
    event_id,
    date(event_time) as day,
    user_id,
    platform,
    max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
    max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
from dsv1069.events
where event_name='test_assignment'
group by 
      event_id,
      day,
      user_id,
      platform
order by event_id

# Sanity Check-Assignment
with test_a as (
SELECT 
    event_id,
    date(event_time) as day,
    user_id,
    platform,
    max(case when parameter_name='test_id' then cast(parameter_value AS INT) else null  end) as test_id,
    max(case when parameter_name='test_assignment' then parameter_value else null end) as test_assignment
from dsv1069.events
where event_name='test_assignment'
group by 
      event_id,
      day,
      user_id,
      platform
order by event_id
)

select user_id, test_id, count(distinct test_assignment)
from test_a
group by user_id, test_id
order by count(distinct test_assignment) desc

# Sanity Check-Missing Data
SELECT 
date(event_time) as day,
parameter_value as test_id,
count(*) as event_rows
FROM dsv1069.events
WHERE event_name='test_assignment' and parameter_name='test_id'
group by test_id, day


