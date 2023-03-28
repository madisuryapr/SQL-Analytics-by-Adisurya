/* TIME SERIES ANALYSIS II
    This file examines even further PostgreSQL application in answering time-series-related questions
    Furthermore, this file encompasses WINDOW functions and CTE utilization to obtain
    the answer */


-- 1. Calculate 6-month and 12-month moving averages of transactions value of
-- all cashless payments system for each region

-- Step I: Create Common Table Expression named as region_transactions_value
WITH region_transactions_value AS (
SELECT
        tval.region_isocode AS region_code,
        rid.region_name AS region,
        tval.time_date AS date,
        tval.payment_system_name AS system_name,
        tval.category AS category,
        ROUND(SUM(tval.value)/1000, 3) AS transactions_value_billion
    FROM transactions_value AS tval
    INNER JOIN region_id AS rid
    ON tval.region_isocode = rid.region_isocode
    INNER JOIN noncashps_id AS ncsid
    USING(payment_system_name)
    GROUP BY region, date, system_name, category, region_code
    ORDER BY region, system_name ASC, category, date
)
-- Step II: Employ AVG() and Window functions to retrieve designated moving average
SELECT
    region_code, region,
    DATE_PART('year', date) || '-' ||
       TO_CHAR(date, 'Month') AS monthly_time,
    system_name,
    category,
    transactions_value_billion,
    AVG(transactions_value_billion) OVER (
        PARTITION BY region, system_name
        ORDER BY region, system_name ASC, category, date
        ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
        )::NUMERIC(35,3) AS moving_average_6month,
    AVG(transactions_value_billion) OVER (
        PARTITION BY region, system_name
        ORDER BY region, system_name ASC, category, date
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
        )::NUMERIC(35,3) AS moving_average_12month
FROM region_transactions_value;
-- This query returns both 6-month and 12-month moving averages of transactions value for
-- all cashless payments system for each region in Indonesia


-- 2. Calculate month-to-month (mtm) and year-over-year (yoy) growth of
-- credit & debit cards transactions value and volume for each province
-- (round the results into 3 decimals behind comma

-- Step I: Create CTE to which appends both transactions_value and transactions_volume tables
WITH debit_credit_transactions AS (
    SELECT
        tval.province_isocode AS pcode,
        pid.province_name AS name_of_province,
        tval.time_date AS date,
        tval.payment_system_name AS system_name,
        tval.category AS category,
        tval.value AS value
    FROM transactions_value AS tval
    INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
    WHERE tval.payment_system_name IN ('Credit Cards', 'Debit Cards')
    UNION ALL
    SELECT
        tvol.province_isocode AS pcode,
        pid.province_name AS name_of_province,
        tvol.time_date AS date,
        tvol.payment_system_name AS system_name,
        tvol.category AS category,
        tvol.value AS value
    FROM transactions_volume AS tvol
    INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
    WHERE tvol.payment_system_name IN ('Credit Cards', 'Debit Cards')
    ORDER BY name_of_province, system_name ASC, category, date
)
-- Step II: Select All required fields and calculate both month-to-month and year-over-year growth
SELECT
    pcode,
    name_of_province,
    DATE_PART('year', date) || '-' ||
        TO_CHAR(date, 'Month') AS monthly_date,
    system_name,
    category,
    value,
-- Step III: Retrieve previous month and year transactions and by utilizing window functions,
-- calculate month-to-month and year-over-year growth of debit and credit cards transactions
-- for each province
    LAG(value, 1) OVER (PARTITION BY name_of_province, system_name, category
        ORDER BY name_of_province, system_name ASC,
            category, date) AS previous_month_transactions,
    LAG(value, 12) OVER (PARTITION BY  name_of_province, system_name, category
        ORDER BY name_of_province, system_name ASC,
            category, date) AS previous_year_transactions,
    ROUND(((value - LAG(value, 1) OVER (PARTITION BY name_of_province, system_name, category
        ORDER BY name_of_province, system_name ASC,
            category, date))/(LAG(value, 1) OVER (PARTITION BY name_of_province, system_name, category
        ORDER BY name_of_province, system_name ASC,
            category, date))) * 100, 3) AS mtm_growth,
    ROUND(((value - LAG(value, 12) OVER (PARTITION BY name_of_province, system_name, category
        ORDER BY name_of_province, system_name ASC,
            category, date))/LAG(value, 12) OVER (PARTITION BY name_of_province, system_name, category
        ORDER BY name_of_province, system_name ASC,
            category, date)) * 100, 3) AS yoy_growth
FROM debit_credit_transactions;
-- Therefore, we obtain all designated fields which includes both month-to-month and year-over-year growth
-- of debit and credit cards transactions for each province in Indonesia
