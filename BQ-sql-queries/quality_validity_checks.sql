-- Step 1. Checking for null values in 1 month sample table from raw data
SELECT
  SUM(IF(ride_id IS NULL, 1, 0)) AS ride_id_nulls,
  SUM(IF(rideable_type IS NULL, 1, 0)) AS ride_type_nulls,
  SUM(IF(started_at IS NULL, 1, 0)) AS starttime_nulls,
  SUM(IF(ended_at IS NULL, 1, 0)) AS endtime_nulls,
  SUM(IF(start_station_name IS NULL, 1, 0)) AS startst_name_nulls,  
  SUM(IF(start_station_id IS NULL, 1, 0)) AS startst_ids_nulls,
  SUM(IF(end_station_name IS NULL, 1, 0)) AS endst_name_nulls,  
  SUM(IF(end_station_id IS NULL, 1, 0)) AS endst_ids_nulls,
  SUM(IF(start_lat IS NULL, 1, 0)) AS startlat_nulls,  
  SUM(IF(start_lng IS NULL, 1, 0)) AS startlng_nulls,
  SUM(IF(end_lat IS NULL, 1, 0)) AS endlat_nulls,  
  SUM(IF(end_lng IS NULL, 1, 0)) AS endlng_nulls,
  SUM(IF(member_casual IS NULL, 1, 0)) AS member_type_nulls,
FROM
    `compact-sunset-401012.capstone_project_bikes.202305-tripdata`

-- Step 2. Quality checks and summary for all columns in 1 month sample table from raw data
SELECT
  -- Check if ride_id contains only unique values
  COUNT(ride_id) as total_rides,
  COUNT(DISTINCT(ride_id)) as total_unique_rides,

  -- There should be 3 types of rideable options: electric_bike, classic_bike, docked_bike
  COUNT(DISTINCT(rideable_type)) as total_rideable_types,
  STRING_AGG(DISTINCT(rideable_type), ", ") as rideable_types_names,

  -- Total number of station names should be the same as station ids 
  COUNT(DISTINCT(TRIM(LOWER(start_station_name)))) AS total_start_stations,
  COUNT(DISTINCT(TRIM(LOWER(end_station_name)))) AS total_end_stations,
  COUNT(DISTINCT(TRIM(LOWER(start_station_id)))) AS total_start_stations_ids,
  COUNT(DISTINCT(TRIM(LOWER(end_station_id)))) AS total_end_stations_ids,

  -- There should be 2 types of users: member and casual
  STRING_AGG(DISTINCT(member_casual), ", ") as member_casual_types,

  -- Lat, long should be at least 5 characters, if not there could be problems with plotting on a map
  MIN(LENGTH(CAST(start_lat AS STRING))) as len_start_lat,
  MIN(LENGTH(CAST(start_lng AS STRING))) as len_start_lng,
  MIN(LENGTH(CAST(end_lat AS STRING))) as len_end_lat,
  MIN(LENGTH(CAST(end_lng AS STRING))) as len_end_lng 
FROM
  `compact-sunset-401012.capstone_project_bikes.202305-tripdata` 
WHERE
  start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
  AND start_station_id IS NOT NULL
  AND end_station_id IS NOT NULL