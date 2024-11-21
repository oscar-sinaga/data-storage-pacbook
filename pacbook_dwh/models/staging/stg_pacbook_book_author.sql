SELECT *
FROM {{ source('pacbook', 'book_author') }}