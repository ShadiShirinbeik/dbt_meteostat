WITH source_data AS (
    SELECT *
    FROM {{ source('northwind_data', 'orders') }}
)
SELECT *,
    order_date::DATE
    required_date::DATE
    shipped_date::DATE
FROM source_data