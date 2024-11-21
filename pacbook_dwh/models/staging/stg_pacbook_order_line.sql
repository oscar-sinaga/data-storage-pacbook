SELECT *
FROM {{ source('pacbook', 'order_line') }}