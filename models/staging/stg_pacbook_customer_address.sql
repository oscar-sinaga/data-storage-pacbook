SELECT *
FROM {{ source('pacbook', 'customer_address') }}