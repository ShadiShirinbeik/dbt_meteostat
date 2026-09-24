WITH date_parts AS (
    SELECT 
        *,
    	timestamp::date AS date,
    	timestamp::time AS time,
    	TO_CHAR(timestamp,'HH24:MI') as hour,
    	TO_CHAR(timestamp, 'FMMonth') AS month_name,
    	TO_CHAR(timestamp, 'FMDay') AS week_day,
    	DATE_PART('day', timestamp) as date_day,
    	DATE_PART('month', timestamp) as date_month,
    	DATE_PART('year', timestamp) as date_year,
    	DATE_PART('week', timestamp) as cw
    FROM {{ref('staging_weather_hourly')}}
),
add_season AS (
    SELECT *,
        (CASE 
            WHEN month_name IN ('November', 'December', 'January', 'February')
            THEN 'winter'
            WHEN month_name IN ('March', 'April', 'May') THEN 'spring'
            WHEN month_name IN ('June', 'July', 'August') THEN 'sommer'
            WHEN month_name IN ('September', 'October') THEN 'autumn'
        END) AS season
    FROM date_parts
)
select * from add_season