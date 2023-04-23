/* TABLE MANIPULATION USING POSTGRESQL
   This fill will examine diverse functions to manipulate table,
   including altering column name, updating data, as well as dropping
   particular columns within a table
 */
-- Case No.1: There is a mistyping from Yogyakarta province in province_id table
-- update the data into 'Yogyakarta' by removing the 'DI'
UPDATE province_id
    SET province_name = 'Yogyakarta'
WHERE
    province_name = 'DI Yogyakarta';
-- Check the execution of prior query
SELECT *
FROM province_id;
-- DI Yogyakarta has been altered into Yogyakarta

-- Case No.2: transactions_value table has million idr unit. However, It seems difficult to read the data
-- within table, hence you wanted to create a new column to represent all data into Billion IDR unit

-- Step I: Add new column called as value_billion
ALTER TABLE transactions_value
ADD COLUMN value_billion NUMERIC(25,3);
-- Check transactions_value table to confirm the result of prior query
SELECT *
FROM transactions_value;
-- value_billion column has been created successfully

-- Step II: Convert value data into Billion IDR and insert all converted data to the new column
INSERT INTO
    transactions_value AS t1(time_date, province_isocode, region_isocode,
                             payment_system_name, category, unit,
                             value, value_billion)
SELECT time_date,
       province_isocode,
       region_isocode,
       payment_system_name,
       category,
       unit,
       value,
       value/1000
FROM transactions_value AS t2;
-- Use SELECT * to check the execution of previous query
SELECT *
FROM transactions_value;

-- Step III: It seems previous query execution generated duplicates, remove all duplicates
DELETE FROM transactions_value
WHERE value_billion IS NULL;

-- Step IV: Drop value column, alter value_billion name and unit
ALTER TABLE transactions_value
DROP COLUMN value; -- Drop value Column

ALTER TABLE transactions_value
RENAME COLUMN value_billion to value; -- Rename value_billion column

UPDATE transactions_value
SET
    unit = 'Billion IDR'
WHERE
    unit = 'Million IDR'; -- Update unit into Billion IDR

-- Step V: Re-check all prior queries result
SELECT *
FROM
    transactions_value
ORDER BY
    province_isocode, payment_system_name ASC, time_date;
-- Therefore, we have the cleaned table in billion IDR unit of data and ready to be analyzed


-- Case No.3: After altering transactions_value table into designated criteria, you realize
-- that transactions_volume table also need to be altered in order to support the analysis
-- process. We are able to apply an equal approach to Case No.2

-- Step I: Add new column called as value_billion
ALTER TABLE transactions_volume
ADD COLUMN value_full_unit NUMERIC(25,3);
-- Check transactions_volume table to confirm the result of prior query
SELECT *
FROM transactions_value;
-- value_full_unit column has been created successfully

-- Step II: Convert value data into unit of transactions and insert all converted data to the new column
INSERT INTO
    transactions_volume AS t1(time_date, province_isocode, region_isocode,
                             payment_system_name, category, unit,
                             value, value_full_unit)
SELECT time_date,
       province_isocode,
       region_isocode,
       payment_system_name,
       category,
       unit,
       value,
       value * 1000
FROM transactions_volume AS t2;
-- Use SELECT * to check the execution of previous query
SELECT *
FROM transactions_volume;

-- Step III: It seems previous query execution generated duplicates, remove all duplicates
DELETE FROM transactions_volume
WHERE value_full_unit IS NULL;

-- Step IV: Drop value column, alter value_billion name and unit
ALTER TABLE transactions_volume
DROP COLUMN value; -- Drop value Column

ALTER TABLE transactions_volume
RENAME COLUMN value_full_unit to value; -- Rename value_full_unit column

UPDATE transactions_volume
SET
    unit = 'Unit of Transactions'
WHERE
    unit = '000 Unit of Transactions'; -- Update unit into Unit of transactions

-- Step V: Re-check all prior queries result
SELECT *
FROM
    transactions_volume
ORDER BY
    province_isocode, payment_system_name ASC, time_date;
-- Therefore, we have the cleaned table in Unit of Transactions of data and ready to be analyzed