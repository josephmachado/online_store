with source as (
    select *
    from {{ source('store', 'orders') }}
),
renamed as (
    select 
        order_id,
        customer_id,
        item_id,
        item_name,
        TO_TIMESTAMP(delivered_on, 'YY-MM-DD HH24:MI:ss') as delivered_on
        from source
)
select *
from renamed