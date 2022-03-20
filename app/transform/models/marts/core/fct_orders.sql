with orders as (
    select *
    from {{ ref('stg_el__orders') }}
)
select * from orders