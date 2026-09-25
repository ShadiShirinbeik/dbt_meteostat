-- Every temperature band should have at least 100 flights,
-- otherwise the average is not reliable
SELECT temp_band, flights
FROM {{ ref('mart_delay_by_temperature') }}
WHERE flights < 100