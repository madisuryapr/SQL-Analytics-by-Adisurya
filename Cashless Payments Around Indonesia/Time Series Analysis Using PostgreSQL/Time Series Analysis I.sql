-- TIME SERIES ANALYSIS I
-- This file examines and explores PostgreSQL utilization in analyzing time series data

-- 1. Calculate quarterly average of transactions value for Debit cards in all provinces of Jawa Region
-- retrieve all data in Billions of Rupiah
SELECT
    rid.region_name,
    pid.province_name,
    DATE_PART('year', tsval.time_date) AS year,
    DATE_PART('quarter', tsval.time_date) AS quarter,
    tsval.payment_system_name AS pstype,
    CAST(AVG(value) AS BIGINT)/1000 AS debit_cards_average_billion_idr
FROM transactions_value AS tsval
INNER JOIN province_id AS pid
    ON tsval.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    USING(region_isocode)
WHERE
    tsval.payment_system_name = 'Debit Cards'
    AND rid.region_name = 'Jawa'
GROUP BY
    rid.region_name, year, quarter,
    pid.province_name, tsval.payment_system_name
ORDER BY
    pid.province_name ASC;
-- Based on the query, we obtain 72 rows of data containing quarterly average of Debit Cards
-- transactions value around Jawa region in Billions of Rupiah

-- 2. Calculate the spread between provinces' maximum volume and monthly transactions volume of credit cards
-- for each province
SELECT
    tvol.province_isocode AS province_code,
    rid.region_name AS region,
    pid.province_name AS province,
    tvol.time_date AS date,
    tvol.value AS credit_cards_volume,
    MAX(value) OVER(PARTITION BY tvol.province_isocode) AS region_maximum_volume,
    MAX(value) OVER(PARTITION BY tvol.province_isocode)- tvol.value AS volume_spread
FROM transactions_volume AS tvol
INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tvol.region_isocode = rid.region_isocode
WHERE
    tvol.payment_system_name = 'Credit Cards'
GROUP BY
    tvol.province_isocode, region, province, date, value
ORDER BY pid.province_name ASC, date ASC;
-- Hence, we obtain the spread between provinces' maximum and individual transactions volume
-- of credit cards for each province


-- 3. Retrieve the 95th and 75th percentiles, as well as median (also knows as 50th percentile)
-- of transactions value for all payment systems of each province
SELECT
    ROW_NUMBER() OVER() AS row_number,
    pid.province_name AS province,
    tsval.payment_system_name AS payment_system,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY tsval.value) AS percentile_95,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY tsval.value) AS percentile_75,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY tsval.value) AS median
FROM transactions_value AS tsval
INNER JOIN province_id AS pid
    ON tsval.province_isocode = pid.province_code
GROUP BY province, payment_system
ORDER BY province ASC;
-- Thus, we obtain 136 rows of data of 95th and 75th percentiles, as well as the median
-- of each province

-- 4. Calculate both transactions value and volume standard deviation for all cashless payments system
-- for each provinces
-- Step I: Construct Common Table Expression (CTE) for all data that combines
-- both transactions value and volume data
WITH cashless_payments AS (
SELECT
        tval.time_date AS date,
        tval.province_isocode AS pcode,
        pid.province_name AS province_name,
        tval.region_isocode AS rcode,
        rid.region_name AS region_name,
        ncid.payment_system_id AS payments_id,
        tval.payment_system_name AS system_name,
        tval.category AS category,
        tval.value AS value
    FROM transactions_value AS tval
    INNER JOIN province_id AS pid
        ON tval.province_isocode = pid.province_code
    INNER JOIN region_id AS rid
        ON tval.region_isocode = rid.region_isocode
    INNER JOIN noncashps_id AS ncid
        USING(payment_system_name)
    UNION ALL
    SELECT
        tvol.time_date AS date,
        tvol.province_isocode AS pcode,
        pid.province_name AS province_name,
        tvol.region_isocode AS rcode,
        rid.region_name AS region_name,
        ncid.payment_system_id AS payments_id,
        tvol.payment_system_name AS system_name,
        tvol.category AS category,
        tvol.value AS value
    FROM transactions_volume AS tvol
    INNER JOIN province_id AS pid
        ON tvol.province_isocode = pid.province_code
    INNER JOIN region_id AS rid
        ON tvol.region_isocode = rid.region_isocode
    INNER JOIN noncashps_id AS ncid
        USING(payment_system_name)
ORDER BY province_name, system_name ASC, category, date
)
-- Step II: Use all properties of CTE and extract the standard deviation of
-- transactions value and volume for each province, round data into 3 decimals.
SELECT
    pcode, province_name,
    rcode, region_name,
    system_name, category,
    ROUND(STDDEV(value), 3) AS standard_devation
FROM cashless_payments
GROUP BY province_name, region_name, pcode,
         rcode, system_name, category
ORDER BY province_name ASC, category ASC;
-- This query will extract 272 rows of data which contains the standard deviation for both
-- transactions value and volume of cashless payments system of each province

   
-- 5. By applying CTE, calculate 3-month and 6-month moving average of debit and credit cards transactions
-- value for each province in Sumatera and Jawa regions (round the results to 3 decimals)
WITH smjw_debit_credit_tval AS (
    SELECT
        tval.time_date AS date,
        tval.province_isocode AS pcode,
        pid.province_name AS province_name,
        tval.region_isocode AS rcode,
        rid.region_name AS region_name,
        ncid.payment_system_id AS payments_id,
        tval.payment_system_name AS system_name,
        tval.category AS category,
        tval.value AS value
    FROM transactions_value AS tval
    INNER JOIN province_id AS pid
        ON tval.province_isocode = pid.province_code
    INNER JOIN region_id AS rid
        ON tval.region_isocode = rid.region_isocode
    INNER JOIN noncashps_id AS ncid
        USING(payment_system_name)
    WHERE tval.payment_system_name IN ('Credit Cards', 'Debit Cards')
        AND rid.region_name IN ('Sumatera', 'Jawa')
    ORDER BY province_name, system_name ASC, category, date
)
SELECT
    date, pcode, province_name,
    rcode, region_name, payments_id,
    system_name, category,
    value,
    ROUND(AVG(value) OVER( PARTITION BY province_name
                    ORDER BY province_name, system_name ASC, category, date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 3) AS ma_3month,
    ROUND(AVG(value) OVER( PARTITION BY province_name
                    ORDER BY province_name, system_name ASC, category, date
        ROWS BETWEEN 5 PRECEDING AND CURRENT ROW), 3) AS ma_6month
FROM
    smjw_debit_credit_tval;
-- Hence, we obtain 3-month and 6-month moving average of debit and credit cards transactions value
-- for each province in Sumatera and Jawa Region.
