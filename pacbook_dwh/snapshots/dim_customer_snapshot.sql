{% snapshot dim_customer_snapshot %}
{{
    config(
        target_schema="dwh_snapshot",
        unique_key="sk_customer_id",
        strategy="check",
        check_cols=["first_name",
                    "last_name", 
                    "full_name",
                    "email"]
    )
}}

SELECT *
FROM {{ ref("dim_customer") }}

{% endsnapshot %}
