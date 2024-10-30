SELECT *
FROM {{ source('pacbook', 'order_status') }}