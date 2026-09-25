-- Average delay should never be negative in any temperature band
SELECT temp_band, avg_dep_delay_min
FROM {{ ref('mart_delay_by_temperature') }}
WHERE avg_dep_delay_min < 0