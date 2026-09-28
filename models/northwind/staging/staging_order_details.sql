WITH source_data AS (
    SELECT *
    FROM {{ source('northwind_data', 'order_details') }}
)
SELECT *,
    unit_price::NUMERIC,
    quantity::INT,
    discount::NUMERIC
FROM source_data