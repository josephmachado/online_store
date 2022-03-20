with customers as (
    select *
    from {{ ref('stg_el__customers') }}
),
states as (
    select *
    from {{ source('store', 'states') }}
),
customer_risk_score as (
    select *
    from {{ ref('stg_el__customer_risk_score') }}
)
select c.*
, s.st_name
, Coalesce(r.risk_score, 0) as risk_score
from customers c
join states s
on c.state_code = s.state_code
left join customer_risk_score r
on c.customer_id = r.customer_id