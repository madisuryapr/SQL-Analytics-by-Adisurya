/* WINDOW Function II
   This file is going to be examining the utilization of Window Function
   even further by applying aggregate and distribution functions
*/

-- Question No.1: Utilizing the combination of aggregate and window functions, what is the
-- total transactions value of debit and credit cards for each province?
SELECT
    tvalue.province_isocode AS pro_code,
    pid.province_name AS name_of_province,
    tvalue.region_isocode AS reg_code,
    rid.region_name AS name_of_region,
    nid.payment_system_id AS system_id,
    tvalue.payment_system_name AS system_name,
    tvalue.time_date AS date_period,
    ROUND((tvalue.value/1000), 3) AS transactions_value_billion,
    SUM(ROUND((tvalue.value/1000), 3))
        OVER(PARTITION BY pid.province_name, tvalue.payment_system_name)
    AS total_transactions_value_billion_per_province
FROM transactions_value AS tvalue
INNER JOIN province_id AS pid
    ON tvalue.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tvalue.region_isocode = rid.region_isocode
INNER JOIN noncashps_id AS nid
    ON tvalue.payment_system_name = nid.payment_system_name
WHERE
    tvalue.payment_system_name IN ('Debit Cards', 'Credit Cards')
ORDER BY name_of_province, system_name ASC, date_period;

-- Question No.2: Returns the cumulative sum of quarterly total of debit cards transactions value
-- for each province and year
SELECT
    pcode,
    name_of_province,
    year,
    quarter,
    billion_transactions_value,
    SUM(billion_transactions_value)
        OVER(PARTITION BY name_of_province, year
             ORDER BY year, quarter) AS cumulative_sum
FROM (SELECT
        tval.province_isocode AS pcode,
        pid.province_name AS name_of_province,
        DATE_PART('Year', tval.time_date) AS year,
        DATE_PART('Quarter', tval.time_date) AS quarter,
        ROUND((SUM(tval.value)/1000) , 3) AS billion_transactions_value
      FROM transactions_value AS tval
      INNER JOIN province_id AS pid
        ON tval.province_isocode = pid.province_code
      WHERE
        tval.payment_system_name = 'Debit Cards'
      GROUP BY name_of_province, quarter, year, pcode
      ORDER BY name_of_province, year, quarter) AS quarterly_table;
-- This query returns 408 rows of quarterly-cumulative-sum of debit cards
-- transactions value for each province in Indonesia

-- Question No.3: Using prior subquery with additional modification,
-- calculate one-year moving average of all cashless payments system for each province
SELECT
    pcode,
    name_of_province,
    year,
    quarter,
    system_name,
    billion_transactions_value,
    ROUND(AVG(billion_transactions_value)
        OVER(PARTITION BY system_name, name_of_province
            ORDER BY name_of_province, system_name ASC, year, quarter
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), 3) AS one_year_ma
FROM (SELECT
        tval.province_isocode AS pcode,
        pid.province_name AS name_of_province,
        DATE_PART('Year', tval.time_date) AS year,
        DATE_PART('Quarter', tval.time_date) AS quarter,
        tval.payment_system_name AS system_name,
        ROUND((SUM(tval.value)/1000) , 3) AS billion_transactions_value
      FROM transactions_value AS tval
      INNER JOIN province_id AS pid
        ON tval.province_isocode = pid.province_code
      GROUP BY name_of_province, system_name, quarter, year, pcode
      ORDER BY name_of_province, system_name ASC, year, quarter) AS quarterly_table
ORDER BY name_of_province, system_name ASC, year, quarter;
-- This query returns one-year moving average of quarterly total transactions value
-- of cashless payments system for each province in Indonesia

-- Question No.4: Calculate cumulative distribution of cashless payments system
-- transactions volume for each province in Jawa Region
WITH jawa_cashless AS (
    SELECT
        province_isocode AS pcode,
        region_isocode AS rcode,
        time_date AS date,
        payment_system_name AS system_name,
        unit,
        value
    FROM
        transactions_volume
    WHERE
        region_isocode = 'JW'
)
SELECT
    pcode,
    pid.province_name AS name_of_province,
    rcode,
    rid.region_name AS region_name,
    date,
    system_name,
    unit,
    value,
    (CUME_DIST() OVER(PARTITION BY pid.province_name, system_name
                     ORDER BY value ASC))::
        NUMERIC(25,4) AS cumulative_distribution
FROM
    jawa_cashless AS jcs
INNER JOIN region_id AS rid
    ON jcs.rcode = rid.region_isocode
INNER JOIN province_id AS pid
    ON jcs.pcode = pid.province_code
ORDER BY name_of_province, system_name ASC;
-- This query returns the cumulative distribution of cashless payments system
-- of each province in Jawa region

-- Question No.5: Calculate percentile ranking of cashless payments system
-- transactions value for each province in Kalimantan and Sulawesi Region
WITH kalimantan_sulawesi_cashless AS (
    SELECT
        province_isocode AS pcode,
        region_isocode AS rcode,
        time_date AS date,
        payment_system_name AS system_name,
        unit,
        value
    FROM
        transactions_value
    WHERE
        region_isocode IN ('KA', 'SL')
)
SELECT
    pcode,
    pid.province_name AS name_of_province,
    rcode,
    rid.region_name AS region_name,
    date,
    system_name,
    unit,
    value,
    (PERCENT_RANK() OVER(PARTITION BY pid.province_name, system_name
                     ORDER BY value ASC))::
        NUMERIC(25,4) AS percentile_ranking
FROM
    kalimantan_sulawesi_cashless AS kscs
INNER JOIN region_id AS rid
    ON kscs.rcode = rid.region_isocode
INNER JOIN province_id AS pid
    ON kscs.pcode = pid.province_code
ORDER BY name_of_province, system_name ASC;
-- This query returns the percentile ranking of cashless payments system
-- of each province in Kalimantan and Sulawesi 