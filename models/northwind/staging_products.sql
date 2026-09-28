WITH source_data AS (
    SELECT *
    FROM {{ source('northwind', 'products') }}
)
SELECT *,
    unit_price::NUMERIC,
	units_in_stock::INT, 
	units_on_order::INT
FROM source_data