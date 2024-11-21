{% snapshot dim_book_snapshot %}
{{
    config(
        target_schema="dwh_snapshot",
        unique_key="sk_book_id",
        strategy="check",
        check_cols=["title",
                    "author", 
                    "isbn13",
                    "num_pages",
                    "publication_date",
                    "language",
                    "publisher"]
    )
}}

SELECT *
FROM {{ ref("dim_book") }}

{% endsnapshot %}
