SELECT *
FROM {{ source('pacbook', 'cust_order') }}