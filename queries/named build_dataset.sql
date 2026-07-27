-- Step 8: The Join — Final Daily Ridership + Weather Table

WITH daily_rides AS (
  -- Step 6: Rides per day with average duration (minutes)
  SELECT
    DATE(starttime) AS ride_date,
    COUNT(*)        AS num_rides,
    AVG(tripduration / 60.0) AS avg_duration_min
  FROM
    `bigquery-public-data.new_york_citibike.citibike_trips`
  WHERE
    starttime IS NOT NULL
  GROUP BY
    ride_date
),

daily_weather AS (
  -- Step 7: Daily weather for LaGuardia station 725030 (2013–2018)
  SELECT
    PARSE_DATE('%Y-%m-%d', CONCAT(year, '-', mo, '-', da)) AS obs_date,
    temp      AS temp_f,
    `max`     AS max_temp_f,
    `min`     AS min_temp_f,
    wdsp      AS wind_speed_knots,
    prcp      AS precip_in
  FROM
    `bigquery-public-data.noaa_gsod.gsod20*`
  WHERE
    _TABLE_SUFFIX BETWEEN '13' AND '18'
    AND stn = '725030'
)

SELECT
  -- Core date and ridership metrics
  r.ride_date,
  r.num_rides,
  r.avg_duration_min,

  -- Weather metrics aligned to the same date
  w.temp_f,
  w.max_temp_f,
  w.min_temp_f,
  w.wind_speed_knots,
  w.precip_in,

  -- Extra calendar features
  FORMAT_DATE('%A', r.ride_date)          AS day_of_week,  -- e.g. 'Monday'
  EXTRACT(MONTH FROM r.ride_date)         AS month         -- 1–12
FROM
  daily_rides AS r
INNER JOIN
  daily_weather AS w
ON
  r.ride_date = w.obs_date
ORDER BY
  r.ride_date;
  -- INNER JOIN keeps only the rows where the join condition matches on both tables – everything else is discarded.