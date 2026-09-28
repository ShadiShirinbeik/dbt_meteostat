WITH source_data AS (
    SELECT *
    FROM {{ source('northwind', 'categories') }}
)
SELECT *
FROM source_data