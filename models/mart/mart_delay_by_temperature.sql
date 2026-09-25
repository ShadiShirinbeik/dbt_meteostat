WITH flights_with_weather AS (
    SELECT
        f.dep_delay,
        w.temp_c
    FROM {{ ref('prep_flights') }} f
    JOIN {{ ref('prep_weather_hourly') }} w
        ON  w.airport_code = f.origin
        AND w.date = f.flight_date
        AND DATE_PART('hour', w.timestamp) = DATE_PART('hour', f.sched_dep_time)
    WHERE f.cancelled = 0
      AND f.dep_delay IS NOT NULL
      AND w.temp_c IS NOT NULL
),
banded AS (
    SELECT
        CASE
            WHEN temp_c < -10 THEN '1. below -10 C'
            WHEN temp_c <  -5 THEN '2. -10 to -5 C'
            WHEN temp_c <   0 THEN '3. -5 to 0 C'
            WHEN temp_c <   5 THEN '4. 0 to 5 C'
            ELSE                   '5. above 5 C'
        END AS temp_band,
        dep_delay
    FROM flights_with_weather
)
SELECT
    temp_band,
    COUNT(*) AS flights,
    ROUND(AVG(dep_delay)::NUMERIC, 1) AS avg_dep_delay_min,
    ROUND(100.0 * COUNT(*) FILTER (WHERE dep_delay > 15) / COUNT(*), 1) AS pct_delayed_over_15min
FROM banded
GROUP BY temp_band
ORDER BY temp_band