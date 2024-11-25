{{ config(schema='pacbook_dwh') }}

stg_address AS (
    SELECT *
    FROM {{ ref("stg_pacbook_address") }}
),

stg_country AS (
    SELECT *
    FROM {{ ref("stg_pacbook_country") }}
),

WITH stg_cust_order AS (
    SELECT
        order_id AS nk_order_id,
        order_date::date AS order_date,
        customer_id AS nk_customer_id,
        shipping_method_id,
        dest_address_id
    FROM {{ ref("stg_pacbook_cust_order") }}
),

stg_order_history AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY status_date DESC) AS row_num
    FROM {{ ref("stg_pacbook_order_history") }}
),

last_order_history AS (
    SELECT
        order_id,
        status_id,
        status_date
    FROM stg_order_history
    WHERE row_num = 1
),

stg_order_line AS (
    SELECT *
    FROM {{ ref("stg_pacbook_order_line") }}
),

stg_shipping_method AS (
    SELECT *
    FROM {{ ref("stg_pacbook_shipping_method") }}
),

stg_order_status AS (
    SELECT *
    FROM {{ ref("stg_pacbook_order_status") }}
),

dim_book AS (
    SELECT *
    FROM {{ ref("dim_book") }}
),

dim_customer AS (
    SELECT *
    FROM {{ ref("dim_customer") }}
),

dim_date AS (
    SELECT *
    FROM {{ ref("dim_date") }}
),

final_fct_book_order AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["nk_order_id"]) }} AS sk_book_order_id,
        sco.nk_order_id,
        dd.date_day AS order_date,
        dc.sk_customer_id,
        db.sk_book_id,
        sol.price,
        ssm.method_name AS shipping_method,
        ssm.cost AS shipping_cost,
        sos.status_value AS status,
        soh.status_date,
        CONCAT(sa.street_name, ' ', sa.street_number) AS dest_address,
        sa.city AS dest_city,
        sc.country_name AS dest_country,
        {{ dbt_date.now() }} AS created_at,
        {{ dbt_date.now() }} AS updated_at
    FROM stg_cust_order sco
    INNER JOIN dim_date dd
        ON sco.order_date = dd.date_day
    INNER JOIN dim_customer dc
        ON sco.nk_customer_id = dc.nk_customer_id
    INNER JOIN stg_order_line sol
        ON sco.nk_order_id = sol.order_id
    INNER JOIN dim_book db
        ON sol.book_id = db.nk_book_id
    INNER JOIN stg_shipping_method ssm
        ON sco.shipping_method_id = ssm.method_id
    INNER JOIN last_order_history soh
        ON sco.nk_order_id = soh.order_id
    INNER JOIN stg_order_status sos
        ON soh.status_id = sos.status_id
    INNER JOIN stg_address sa
        ON sco.dest_address_id = sa.address_id
    INNER JOIN stg_country sc
        ON sa.country_id = sc.country_id
)

SELECT * FROM final_fct_book_order