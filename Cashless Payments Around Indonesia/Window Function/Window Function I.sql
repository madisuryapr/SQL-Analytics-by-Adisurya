/* WINDOW Function I
   In this file, writer will introduce the application of WINDOW function
   to answer any business-related questions based on regional cashless payments
   system around Indonesia database */

-- 1. Obtain the row number of transactions_volume table, join with province_id table
-- to include province name
SELECT
    ROW_NUMBER() OVER(ORDER BY pid.province_name,
        tvol.payment_system_name ASC, tvol.time_date) AS row_number,
    tvol.province_isocode AS pcode,
    pid.province_name AS name_of_province,
    tvol.time_date AS date,
    tvol.payment_system_name AS system_name,
    tvol.value AS value
FROM transactions_volume AS tvol
INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
ORDER BY name_of_province, system_name ASC, date;

-- 2. Retrieve the rank of debit cards transactions value for all provinces
SELECT
    tval.province_isocode AS pcode,
    pid.province_name name_of_province,
    tval.time_date AS date,
    RANK() OVER(ORDER BY tval.value DESC),
    (tval.value/1000)::NUMERIC(25,2) AS value_billon
FROM transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
WHERE tval.payment_system_name = 'Debit Cards';
-- The result of this query suggests that DKI Jakarta has the highest debit cards transactions value
-- among all provinces, around IDR 200-300 Billion in monthly terms

-- 3. To Avert any skipped rank, we are able to utilize DENSE_RANK() in prior query
SELECT
    tval.province_isocode AS pcode,
    pid.province_name name_of_province,
    tval.time_date AS date,
    DENSE_RANK() OVER(ORDER BY tval.value DESC),
    (tval.value/1000)::NUMERIC(25,2) AS value_billon
FROM transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
WHERE tval.payment_system_name = 'Debit Cards';
-- This query maintains the results of prior query

-- 4. Retrieve row number of provinces in transactions value table, where row numbering
-- is based on provinces' region, extract Jawa Region only
SELECT
    ROW_NUMBER() OVER(PARTITION BY rid.region_name
        ORDER BY pid.province_name, tval.payment_system_name ASC,
            tval.time_date) AS row_number_per_region,
    tval.province_isocode AS pcode,
    pid.province_name AS name_of_province,
    tval.region_isocode AS rcode,
    rid.region_name AS name_of_region,
    tval.time_date AS date,
    tval.payment_system_name AS system_name,
    tval.value AS value
FROM transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tval.region_isocode = rid.region_isocode
WHERE region_name = 'Jawa'
ORDER BY name_of_province, system_name ASC, date;
-- We obtain 864 rows of transactions value for Jawa region only

-- 5. Provide equal page distribution for transactions value table based on province
SELECT
    tval.province_isocode AS pcode,
    pid.province_name AS name_of_province,
    tval.time_date AS date,
    tval.payment_system_name AS system_name,
    tval.value AS value,
    NTILE(34) OVER(ORDER BY pid.province_name,
        tval.payment_system_name ASC,
            tval.time_date)
FROM transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
ORDER BY  name_of_province, system_name ASC, date;
-- This query generates 34 pages with equal distribution where each page represents one province
