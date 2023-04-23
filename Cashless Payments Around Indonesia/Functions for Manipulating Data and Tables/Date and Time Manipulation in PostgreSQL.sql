/* DATE AND TIME MANIPULATION IN POSTGRESQL
   This file introduces various functions for manipulating date and time
   within PostgreSQL environment
 */

-- Prologue No.1: Show world time zones
SELECT * FROM pg_timezone_names;

-- Prologue No.2: Show time zones for Asia region only
SELECT * FROM pg_timezone_names
WHERE name LIKE '%Asia%';

-- Question No.1: What date is it for today?
SELECT NOW() AS today;
-- This Query returns 2023-04-23

-- Question No.2: What date is it for today? (Alternative query)
SELECT CURRENT_TIMESTAMP AS today;
-- This Query returns the same result as prior one

-- Question No.3: What date is it today?
SELECT CURRENT_DATE AS today_date;
-- Today is 2023-04-23

-- Question No.4: What time is it?
SELECT CURRENT_TIME AS time;
-- Currently It's 06:34 in the morning

-- Question No.5: Retrieve year and month of date from transactions_value table
SELECT
    DISTINCT(time_date) AS date,
    EXTRACT(YEAR FROM time_date) AS year,
    EXTRACT(MONTH FROM time_date) AS month
FROM transactions_value
ORDER BY date;
-- This query returns all year and month of time_date column from transactions_value table

-- Question No.6: Return year, quarter, and month of date from transactions_value table (alternative)
SELECT
    DISTINCT(time_date) AS date,
    DATE_PART('year', time_date) AS year,
    DATE_PART('quarter', time_date) AS quarter,
    DATE_PART('month', time_date) AS month
FROM transactions_value
ORDER BY date;
-- This query will return the year, quarter and month of the date

-- Question No.7: How many days are the difference between today and all dates from
-- transactions_volume data?
SELECT
    DISTINCT(time_date) AS date,
    (CAST(NOW() AS date) - time_date) AS date_difference_day
FROM transactions_volume
ORDER BY date;
-- This query returns the difference between current date and all dates from the tables in days period

-- Question No.8: Retrieve today's date based on All Indonesia Time Zone
SELECT
    NOW() AT TIME ZONE 'Asia/Jakarta'          AS western_Indonesia_time,
    NOW() AT TIME ZONE 'Asia/Ujung_Pandang'    AS central_Indonesia_time,
    NOW() AT TIME ZONE 'Asia/Jayapura'         AS eastern_Indonesia_time;
-- This query return three different times based on each Indonesia time zone

-- Question No.9: How long has time passed for each date within time_date column of
-- transactions_value table?
SELECT
    DISTINCT(time_date) AS date,
    AGE(NOW()::DATE, time_date) AS time_age
FROM transactions_value
ORDER BY date ASC;
-- This query extracts the age of each date compared to current date (2023-04-23)

-- Question No.10: Calculate Future dates by adding one and a half year
-- to all dates in transactions_volume table
SELECT
    DISTINCT(time_date) AS date,
    (time_date + INTERVAL '1 year 6 months')::DATE
        AS one_half_year_later
FROM transactions_volume
ORDER BY date ASC;
-- This query will extract future dates after one and a half year later