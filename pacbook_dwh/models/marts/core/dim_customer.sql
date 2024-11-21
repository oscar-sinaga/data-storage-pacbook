{ config(schema='pacbook_dwh') }

WITH stg_customer AS (
    SELECT customer_id AS nk_customer_id,
        first_name,
        last_name,
        CONCAT(first_name, ' ', last_name) AS full_name,
        email
    FROM { { ref("stg_pacbook_customer") } }
),
final_dim_customer AS (
    SELECT { { dbt_utils.generate_surrogate_key(["nk_customer_id"]) } } AS sk_customer_id,
        sc.nk_customer_id,
        sc.first_name,
        sc.last_name,
        sc.full_name,
        sc.email,
        { { dbt_date.now() } } AS created_at,
        { { dbt_date.now() } } AS updated_at
    FROM stg_customer sc
)
SELECT *
FROM final_dim_customer