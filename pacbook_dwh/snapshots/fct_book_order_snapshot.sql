{% snapshot fct_book_order_snapshot %}
{{
    config(
        target_schema="dwh_snapshot",
        unique_key="sk_book_order_id",
        strategy="check",
        check_cols=["order_date",
                    "sk_book_id", 
                    "price",
                    "shipping_method",
                    "shipping_cost", 
                    "status",
                    "status_date",
                    "dest_address", 
                    "dest_city",
                    "dest_country"]
    )
}}

SELECT *
FROM {{ ref("fct_book_order") }}

{% endsnapshot %}
