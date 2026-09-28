WITH source_data AS (
    SELECT *
    FROM {{ source('northwind_data', 'orders') }}
)
SELECT *
FROM source_data