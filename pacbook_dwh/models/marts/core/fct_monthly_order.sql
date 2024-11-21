{ config(schema='pacbook_dwh') }


WITH stg_monthly_order AS (
    SELECT
        EXTRACT(MONTH FROM order_date::date) AS month,
        EXTRACT(YEAR FROM order_date::date) AS year,
        order_id as nk_order_id
    FROM {{ ref("stg_pacbook_cust_order") }}
),

stg_order_line AS (
    SELECT *
    FROM {{ ref("stg_pacbook_order_line") }}
),

dim_book AS (
    SELECT *
    FROM {{ ref("dim_book") }}
),

final_monthly_order AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(["month", "year", "sk_book_id"]) }} AS sk_monthly_order_id,
        smo.month,
        smo.year,
        db.sk_book_id,
        COUNT(smo.nk_order_id) AS total_order,
        SUM(sol.price) AS total_sale_amount,
        {{ dbt_date.now() }} AS created_at,
        {{ dbt_date.now() }} AS updated_at
    FROM
        stg_monthly_order smo
    INNER JOIN stg_order_line sol
        ON smo.nk_order_id = sol.order_id
    INNER JOIN dim_book db
        ON sol.book_id = db.nk_book_id
    GROUP BY
        smo.month, smo.year, db.sk_book_id
    ORDER BY
        smo.year DESC,
        smo.month ASC
)

SELECT * FROM final_monthly_order