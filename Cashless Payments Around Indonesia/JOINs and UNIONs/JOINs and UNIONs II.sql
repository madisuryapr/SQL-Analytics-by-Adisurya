/* JOINs AND UNIONs II
   The objective of this file is to examine JOINs and UNIONs even further,
   including the concept of FULL JOIN, UNION, as well as UNION ALL
 */

-- Question No.1: By Using FULL JOIN, Retrieve cashless payments systems' name
-- and their corresponding transactions value accross provinces in Indonesia
SELECT
    tval.time_date AS date,
    tval.province_isocode AS prov_code,
    pid.province_name AS name_of_province,
    nid.payment_system_id AS system_id,
    nid.payment_system_name AS system_name,
    tval.category AS category,
    tval.value AS value
FROM transactions_value tval
FULL JOIN province_id pid
    ON tval.province_isocode = pid.province_code
FULL JOIN noncashps_id nid
    ON tval.payment_system_name = nid.payment_system_name
ORDER BY name_of_province, system_name, date;
-- This query returns 4897 rows of data. Did you notice something different?
-- correct, we are unable to obtain the transactions value of electronic money, since
-- both transactions value and volume tables do not provide any data for corresponding cashless systems' name

-- Question No.2: Using UNION clause, Append both transactions value and volume tables that
-- comprises debit and credit cards data for all provinces in Jawa Region
SELECT
    tval.time_date AS date,
    tval.province_isocode AS prov_code,
    pid.province_name AS name_of_province,
    tval.region_isocode AS reg_code,
    rid.region_name AS reg_name,
    nid.payment_system_id AS system_id,
    tval.payment_system_name AS system_name,
    tval.category AS category,
    tval.value AS value
FROM transactions_value tval
INNER JOIN province_id pid
    ON tval.province_isocode = pid.province_code
INNER JOIN region_id rid
    ON tval.region_isocode = rid.region_isocode
INNER JOIN noncashps_id nid
    ON tval.payment_system_name = nid.payment_system_name
WHERE
    rid.region_name = 'Jawa' AND
    nid.payment_system_name IN ('Debit Cards', 'Credit Cards')
UNION
SELECT
    tvol.time_date AS date,
    tvol.province_isocode AS prov_code,
    pid.province_name AS name_of_province,
    tvol.region_isocode AS reg_code,
    rid.region_name AS reg_name,
    nid.payment_system_id AS system_id,
    tvol.payment_system_name AS system_name,
    tvol.category AS category,
    tvol.value AS value
FROM transactions_volume tvol
INNER JOIN province_id pid
    ON tvol.province_isocode = pid.province_code
INNER JOIN region_id rid
    ON tvol.region_isocode = rid.region_isocode
INNER JOIN noncashps_id nid
    ON tvol.payment_system_name = nid.payment_system_name
WHERE
    rid.region_name = 'Jawa' AND
    nid.payment_system_name IN ('Debit Cards', 'Credit Cards')
ORDER BY name_of_province, system_name, category, date;
-- This query returns 864 rows of appended transactions value and volume tables of
-- debit and credit cards for all provinces within Jawa region

-- Question No.3: Suppose that the manager wanted to obtain both transactions value and volume
-- tables for all provinces and cashless payments system. We are able to perform this data
-- extraction by utilizing UNION ALL clause
SELECT
    tval.time_date AS date,
    tval.province_isocode AS pro_code,
    pid.province_name AS name_of_province,
    tval.region_isocode AS reg_code,
    rid.region_name AS name_of_region,
    nid.payment_system_id AS system_id,
    tval.payment_system_name AS system_name,
    tval.category AS category,
    tval.value AS value
FROM transactions_value tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tval.region_isocode = rid.region_isocode
INNER JOIN noncashps_id AS nid
    ON tval.payment_system_name = nid.payment_system_name
UNION ALL
SELECT
    tvol.time_date AS date,
    tvol.province_isocode AS pro_code,
    pid.province_name AS name_of_province,
    tvol.region_isocode AS reg_code,
    rid.region_name AS name_of_region,
    nid.payment_system_id AS system_id,
    tvol.payment_system_name AS system_name,
    tvol.category AS category,
    tvol.value AS value
FROM transactions_volume tvol
INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tvol.region_isocode = rid.region_isocode
INNER JOIN noncashps_id AS nid
    ON tvol.payment_system_name = nid.payment_system_name
ORDER BY name_of_province, system_name, category, date;
-- In return, this query will present 9792 rows of data regarding transactions
-- value and volume for all cashless payments system for each province and region