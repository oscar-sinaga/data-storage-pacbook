{% snapshot fct_monthly_order_snapshot %}
{{
    config(
        target_schema="dwh_snapshot",
        unique_key="sk_monthly_order_id",
        strategy="check",
        check_cols=["month",
                    "year", 
                    "sk_book_id",
                    "total_order",
                    "total_sale_amount"]
    )
}}

SELECT *
FROM {{ ref("fct_monthly_order") }}

{% endsnapshot %}
