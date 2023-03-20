/* SELECT Statement Part I */
/* The objective of this file is to introduce how to utilize
   SELECT Statement in terms of answering several questions
   within this file
 */

-- 1. Retrieve All columns in transactions_value table
SELECT *
FROM transactions_value;

-- 2. Retrieve All columns in transactions_volume table
SELECT *
FROM transactions_volume;

-- 3. How many rows contain in transactions_value table?
SELECT
    COUNT(*) AS rows_number
FROM
    transactions_value;
-- Based on this query, there are 4896 rows of data within transactions_value table
-- This query can also be applied to transactions_volume table

-- 4a. Retrieve number of payment systems contained within noncashps_id table
SELECT
    COUNT(*) AS number_of_payment_system
FROM
    noncashps_id;
-- There are 5 payment systems contained within the table

-- 4b. Ensure that number of payment systems contained in transactions_value table
-- are similar to prior query
SELECT
    COUNT(DISTINCT(payment_system_name))
    AS number_of_payment_system
FROM
    transactions_value;
-- This query suggests that there are only 4 payment systems within transactions_value table

-- 5. What is the overall average of payment systems
-- transactions value in Indonesia?
SELECT
    AVG(value) AS total_average
FROM
    transactions_value;
-- The overall average of payment systems transactions value in Indonesia is around 27000 Billion IDR

-- 6. We are also able to convert prior results to obtain the Trillion value
-- by dividing the result by 1000000 and assigning number of decimal
SELECT
    ROUND(AVG(value)/1000000, 3)
        AS average_trillion_idr
FROM
    transactions_value;

-- 7. Prior queries are also capable to extract the overall average
-- of payment systems transactions volume in Indonesia
SELECT
    AVG(value) AS total_average
FROM
    transactions_volume;
-- We obtain around 4 million number of transactions for all payment systems in Indonesia

-- 8. To convert the number, we can employ query no.6, with denominator modification
SELECT
    ROUND(AVG(value)/1000, 3)
    AS average_million_of_transactions
FROM
    transactions_volume;
-- Based on query above, there are 4.35 million transactions volume in average of
-- payment system transactions volume occurred in Indonesia

-- 9. How many provinces are included in province_id table?
SELECT
    COUNT(*) AS number_of_province
FROM
    province_id;
-- As of 2021, there are 34 provinces registered in Indonesia

-- 10. How many regions are exist in region_id table
SELECT
    COUNT(*) AS number_of_region
FROM
    region_id;
-- Based on ISO 3166-2:ID, there are 7 regions exist in Indonesia