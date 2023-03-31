/* SELECT Statement Part II */
/* This file examines the utilization of
   SELECT Statement even further to answer
   Specific questions
 */

-- Question No.1: Retrieve the average of transactions value for each payment systems
SELECT
    payment_system_name AS "Payment System Name",
    AVG(value) AS "Average of Transactions Value"
FROM
    transactions_value
GROUP BY payment_system_name
ORDER BY payment_system_name ASC;

-- Question No.2: The number of decimal seems cluttered, employ ROUND clause to obtain
-- the specific number of values
SELECT
    payment_system_name AS "Payment System Name",
    ROUND(AVG(value), 3) AS "Average of Transactions Value"
FROM
    transactions_value
GROUP BY payment_system_name
ORDER BY payment_system_name ASC;

-- Question No.3: Retrieve the total of transactions value, grouped by region_id and
-- and payment_system_name
SELECT
    region_isocode AS "Region",
    payment_system_name AS "Payment System",
    SUM(value) AS "Total Transactions Volume"
FROM
    transactions_volume
GROUP BY
    region_isocode,
    payment_system_name
ORDER BY region_isocode ASC,
         payment_system_name;

-- Question No.4: Retrieve the Standard Deviation of transactions value for all payment systems, grouped by provinces
SELECT
    province_isocode AS "Province",
    STDDEV(value) AS "Standard Deviation"
FROM
    transactions_value
GROUP BY
    province_isocode
ORDER BY province_isocode;

-- Question No.5: Previous results quite confusing, since we do not know the name of provinces.
-- Therefore, employ JOIN Clause to obtain province's name from other table
SELECT
    tval.province_isocode AS "Province Code",
    pid.province_name AS "Province Name",
    STDDEV(tval.value) AS "Standard Deviation"
FROM
    transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
GROUP BY
    tval.province_isocode, pid.province_name
ORDER BY tval.province_isocode ASC;

-- Question No.6: Retrieve Provinces Name, Province ISO Code, and the total transactions volume
-- Of each payment systems
SELECT
    tvol.province_isocode AS "Province Code",
    pid.province_name AS "Province Name",
    tvol.payment_system_name,
    SUM(tvol.value) AS "Average"
FROM
    transactions_volume AS tvol
INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
GROUP BY
    tvol.province_isocode,
    pid.province_name,
    tvol.payment_system_name
ORDER BY
    pid.province_name ASC;

-- Question No.7: Retrieve Debit Cards transactions volume more than 10000 for each provinces
SELECT
    tvol.time_date AS date,
    tvol.province_isocode AS "Province Code",
    pid.province_name AS "Province Name",
    tvol.payment_system_name AS "Payment System Name",
    tvol.value AS "Transactions Volume"
FROM
    transactions_volume AS tvol
INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
WHERE
    payment_system_name = 'Debit Cards'
GROUP BY tvol.time_date, tvol.province_isocode,
         pid.province_name, tvol.payment_system_name,
         tvol.value
HAVING tvol.value > 10000
ORDER BY pid.province_name ASC;
-- This query generated 400 rows of data for each provinces where transactions volume is more than 10000

-- Question No.8: Select Debit Cards Transactions Volume for Jawa Region Only
SELECT
    tval.time_date AS date,
    tval.province_isocode AS "Province Code",
    pid.province_name AS "Province Name",
    tval.payment_system_name AS "Payment System Name",
    tval.value AS "Transactions Value"
FROM
    transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
WHERE tval.region_isocode = 'JW'
    AND tval.payment_system_name = 'Debit Cards';
-- This code therefore generated 216 rows of data for debit cards transactions value in Jawa Region
