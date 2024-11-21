{% snapshot fct_order_repeat_time_snapshot %}
{{
    config(
        target_schema="dwh_snapshot",
        unique_key="sk_order_repeat_time_id",
        strategy="check",
        check_cols=["sk_customer_id",
                    "nk_customer_id", 
                    "nk_order_id",
                    "order_date",
                    "previous_order_date",
                    "order_interval"]
    )
}}

SELECT *
FROM {{ ref("fct_order_repeat_time") }}

{% endsnapshot %}
