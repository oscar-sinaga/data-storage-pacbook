{{ config(schema='pacbook_dwh') }}

WITH stg_author AS (
    SELECT *
    FROM { { ref("stg_pacbook_author") } }
),
stg_book AS (
    SELECT book_id AS nk_book_id,
        title,
        isbn13,
        num_pages,
        publication_date,
        language_id,
        publisher_id
    FROM { { ref("stg_pacbook_book") } }
),
stg_book_author AS (
    SELECT *
    FROM { { ref("stg_pacbook_book_author") } }
),
stg_book_language AS (
    SELECT *
    FROM { { ref("stg_pacbook_book_language") } }
),
stg_publisher AS (
    SELECT *
    FROM { { ref("stg_pacbook_publisher") } }
),
final_dim_book AS (
    SELECT { { dbt_utils.generate_surrogate_key(['nk_book_id']) } } AS sk_book_id,
        sb.nk_book_id,
        sb.title,
        sb.isbn13,
        sb.num_pages,
        sb.publication_date,
        sa.author_name AS author,
        sbl.language_name AS language,
        sp.publisher_name AS publisher,
        { { dbt_date.now() } } AS created_at,
        { { dbt_date.now() } } AS updated_at
    FROM stg_book sb
        INNER JOIN stg_book_language sbl ON sb.language_id = sbl.language_id
        INNER JOIN stg_publisher sp ON sb.publisher_id = sp.publisher_id
        INNER JOIN stg_book_author sba ON sb.nk_book_id = sba.book_id
        INNER JOIN stg_author sa ON sba.author_id = sa.author_id
)
SELECT *
FROM final_dim_book;