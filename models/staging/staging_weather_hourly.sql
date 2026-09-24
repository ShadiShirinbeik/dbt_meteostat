WITH hourly_raw AS (
    SELECT 
        airport_code,
        station_id,
        JSON_ARRAY_ELEMENTS(extracted_data -> 'data') AS json_data
    FROM {{source('weather_data', 'weather_hourly_raw')}}
),
hourly_flattened AS (
    SELECT  
        airport_code,
        station_id,
        (json_data ->> 'timestamp')::TIMESTAMP  AS timestamp,
        (json_data ->> 'temp_c')::NUMERIC AS temp_c,
        (json_data ->> 'dewpoint_c')::NUMERIC AS dewpoint_c,
        (json_data ->> 'humidity_perc')::NUMERIC AS humidity_perc,
        (json_data ->> 'precipitation_mm')::NUMERIC AS precipitation_mm,
        (json_data ->> 'snow_mm')::INT AS snow_mm,
        (json_data ->> 'wind_direction')::INT AS wind_direction,
        (json_data ->> 'wind_speed_kmh')::  NUMERIC AS wind_speed_kmh,
        (json_data ->> 'wind_peakgust_kmh')::NUMERIC AS wind_peakgust_kmh,
        (json_data ->> 'pressure_hpa')::NUMERIC AS pressure_hpa,
        (json_data ->> 'sun_minutes')::INT AS sun_minutes,
        (json_data ->> 'condition_code')::INT AS condition_code
    FROM hourly_raw
)
SELECT *
FROM hourly_flattened