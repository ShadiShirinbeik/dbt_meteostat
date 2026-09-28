WITH source_data AS (
    SELECT *
    FROM {{ source('northwind_data', 'products') }}
)
SELECT *
FROM source_data