WITH flights_one_month AS (
    SELECT * 
    FROM {{ref('staging_flights_one_month')}}
    ),
flights_cleaned AS(
	SELECT flight_date::DATE,
			make_time( dep_time / 100, dep_time % 100, 0) as dep_time,
			make_time( sched_dep_time / 100, sched_dep_time % 100, 0) as sched_dep_time,
			dep_delay::INT,
			make_interval(mins => dep_delay) as dep_delay_interval,
			arr_time::INT,
			make_time( sched_arr_time / 100, sched_arr_time % 100, 0) as sched_arr_time,
			arr_delay::INT,
			make_interval(mins => arr_delay) as arr_delay_interval,
			airline::VARCHAR,
			tail_number::VARCHAR,
			flight_number::INT,
			origin::VARCHAR,
			dest::VARCHAR,
			air_time::INT,
			make_interval(mins => air_time) as air_time_interval,
			actual_elapsed_time::INT,
			make_interval(mins=> actual_elapsed_time) as actual_elapsed_time_interval,
			(distance * 1.60934)::NUMERIC as distance_km,
			cancelled::INT,
			diverted::INT
	FROM flights_one_month
)
SELECT * FROM flights_cleaned