SELECT *
FROM {{ source('pacbook', 'order_history') }}