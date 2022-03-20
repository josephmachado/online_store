with source as (
    select *
    from {{ source('store', 'customer_risk_score') }}
),
ordered_customer_risk_score as (
    select customer_id,
        risk_score,
        datetime_inserted,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY datetime_inserted DESC
        ) as rw_num
    from source
)
select customer_id,
    risk_score,
    datetime_inserted
from ordered_customer_risk_score
where (customer_id, rw_num) IN (
        select customer_id,
            min(rw_num)
        from ordered_customer_risk_score
        group by customer_id
    )

    