WITH source_data AS (
    SELECT *
    FROM {{ source('northwind_data', 'order_details') }}
)
SELECT *
FROM source_data