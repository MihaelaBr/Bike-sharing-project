--Step 3. Union all 12 tables for the 12 months into 1 without nulls
CREATE OR REPLACE TABLE capstone_project_bikes.all_tripdata_1y AS
SELECT *
FROM `compact-sunset-401012.capstone_project_bikes.202*`
WHERE 
  start_station_name IS NOT NULL 
  AND start_station_id IS NOT NULL
  AND end_station_name IS NOT NULL
  AND end_station_id IS NOT NULL
  AND end_lat IS NOT NULL
  AND end_lng IS NOT NULL


-- Step 4. Add columns to calculate the ride_duration and ride_duration in secs, column for day of the week
CREATE OR REPLACE TABLE capstone_project_bikes.all_tripdata_1y_cleaned AS
SELECT *, 
  FORMAT_TIMESTAMP('%H:%M:%S', TIMESTAMP_SECONDS(TIMESTAMP_DIFF(ended_at, started_at, SECOND))) AS ride_duration,
  TIMESTAMP_DIFF(ended_at, started_at, SECOND) AS ride_duration_sec,
  CASE EXTRACT(DAYOFWEEK FROM started_at)
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
  END AS weekday

FROM `compact-sunset-401012.capstone_project_bikes.all_tripdata_1y` 


-- Step 5. Final cleaning by removing all records with ride_duration under 60 seconds, which are considered too short rides
CREATE OR REPLACE TABLE capstone_project_bikes.all_tripdata_1y_cleaned AS
SELECT 
* 
FROM `compact-sunset-401012.capstone_project_bikes.all_tripdata_1y_updated`
WHERE ride_duration_sec>60