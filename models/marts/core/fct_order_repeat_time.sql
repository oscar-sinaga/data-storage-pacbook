WITH stg_cust_order AS (
    SELECT
        order_id AS nk_order_id,
        customer_id AS nk_customer_id,
        cast(order_date as TIMESTAMP),
        cast(lag(order_date) over (PARTITION by customer_id order by order_date ASC) as TIMESTAMP) as previous_order_date
    FROM {{ ref("stg_pacbook_cust_order") }}
),

WITH stg_repeat_order as (
    SELECT
        nk_customer_id,
        nk_order_id,
        order_date,
        previous_order_date,
        (order_date - previous_order_date) as order_interval
    FROM stg_cust_order
)

with dim_customer as (
    SELECT *
    FROM {{ref("dim_customer")}}
)

final_fct_order_repeat_time as (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["nk_order_id"]) }} AS sk_order_repeat_time_id,
        dc.sk_customer_id,
        sro.nk_customer_id,
        sro.nk_order_id,
        sro.order_date,
        sro.previous_order_date,
        sro.order_interval
    FROM stg_repeat_order as sro
    INNER JOIN dim_customer as dc
        using(nk_customer_id)
)

SELECT * from final_fct_order_repeat_time;