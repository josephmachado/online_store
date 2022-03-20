with source as (
    select *
    from {{ source('store', 'customers') }}
),
ordered_customer as (
    select customer_id,
        first_name,
        last_name,
        state_code,
        TO_TIMESTAMP(datetime_created, 'YY-MM-DD HH24:MI:ss') as datetime_created,
        TO_TIMESTAMP(datetime_updated, 'YY-MM-DD HH24:MI:ss') as datetime_updated,
        datetime_inserted,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY datetime_inserted DESC
        ) as rw_num
    from source
)
select customer_id,
    first_name,
    last_name,
    state_code,
    datetime_created,
    datetime_updated,
    datetime_inserted
from ordered_customer
where (customer_id, rw_num) IN (
        select customer_id,
            min(rw_num)
        from ordered_customer
        group by customer_id
    )