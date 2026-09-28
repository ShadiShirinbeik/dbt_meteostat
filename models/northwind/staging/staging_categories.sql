WITH source_data AS (
    SELECT *
    FROM {{ source('northwind_data', 'categories') }}
)
SELECT *
FROM source_data