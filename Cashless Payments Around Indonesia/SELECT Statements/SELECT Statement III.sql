/* SELECT Statement Part III */
/* This file explores the usages of
   SELECT statement to answer the business questions
 */

-- 1A. What is the average of debit and credit cards transactions value
-- per year for each provinces?
SELECT
    province_isocode AS "province",
    EXTRACT(YEAR FROM time_date) AS year,
    payment_system_name AS "Payment System Name",
    AVG(value) AS average
FROM
    transactions_value
WHERE
    payment_system_name IN ('Debit Cards', 'Credit Cards')
GROUP BY
    province_isocode,
    payment_system_name, EXTRACT(YEAR FROM time_date)
ORDER BY province_isocode ASC, EXTRACT(YEAR FROM time_date) ASC;
-- This query will generate 204 rows of data

-- 1B. Since we would like to focus in integer results, use CAST function
SELECT
    province_isocode AS "province",
    EXTRACT(YEAR FROM time_date) AS year,
    payment_system_name AS "Payment System Name",
    CAST(AVG(value) AS INT) AS average
FROM
    transactions_value
WHERE
    payment_system_name IN ('Debit Cards', 'Credit Cards')
GROUP BY
    province_isocode,
    payment_system_name, EXTRACT(YEAR FROM time_date)
ORDER BY province_isocode ASC, EXTRACT(YEAR FROM time_date) ASC;

-- 1C. It seems the province_isocode is not sufficient to represent the provinces in Indonesia.
-- Hence, to extract the province's name, Join transactions_value and province_id tables
SELECT
    tval.province_isocode AS "Province_code",
    pid.province_name AS "Province Name",
    EXTRACT(YEAR FROM tval.time_date) AS year,
    tval.payment_system_name AS "Payment System Name",
    CAST(AVG(value) AS INT) AS average
FROM
    transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
WHERE
    payment_system_name IN ('Debit Cards', 'Credit Cards')
GROUP BY
    tval.province_isocode, pid.province_name,
    tval.payment_system_name, EXTRACT(YEAR FROM tval.time_date)
ORDER BY province_isocode ASC,
         tval.payment_system_name ASC;

-- 2A. Now Let us retrieve the total of all payment systems transactions volume
-- based on region each year
SELECT
    tvol.region_isocode AS region_code,
    rid.region_name AS region_name,
    EXTRACT(YEAR FROM tvol.time_date) AS year,
    tvol.payment_system_name AS payments_name,
    SUM(tvol.value) AS total_transaction_volume
FROM
    transactions_volume AS tvol
INNER JOIN region_id AS rid
    ON tvol.region_isocode = rid.region_isocode
GROUP BY
    tvol.region_isocode, rid.region_name,
    EXTRACT(YEAR FROM tvol.time_date), tvol.payment_system_name
ORDER BY rid.region_name ASC,
         tvol.payment_system_name ASC;
-- Based on this query, we obtain 84 rows of data in which represents total transactions volume
-- for all regions each year.

-- 2B. We are also capable to obtain the detailed number of results from prior query
-- by applying CAST clause to total_transactions_volume
SELECT
    tvol.region_isocode AS region_code,
    rid.region_name AS region_name,
    EXTRACT(YEAR FROM tvol.time_date) AS year,
    tvol.payment_system_name AS payments_name,
    CAST(SUM(tvol.value) AS NUMERIC(12,3)) AS total_transaction_volume
FROM
    transactions_volume AS tvol
INNER JOIN region_id AS rid
    ON tvol.region_isocode = rid.region_isocode
GROUP BY
    tvol.region_isocode, rid.region_name,
    EXTRACT(YEAR FROM tvol.time_date), tvol.payment_system_name
ORDER BY rid.region_name ASC,
         tvol.payment_system_name ASC;
-- The results remain consistent to previous query, within addition of 3 decimal numbers