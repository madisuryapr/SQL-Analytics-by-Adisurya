/* JOINs and UNIONs I
   This File introduces and examines the utilization of JOINs and UNION clauses
   to answer business-related question based on available tables within
   this database
 */

 -- Question No.1: Retrieve provinces' name and their corresponding ISO code
SELECT
    DISTINCT(tval.province_isocode) AS pcode,
    pid.province_name AS name_of_province
FROM transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code;
-- This query will return 34 provinces with each corresponding ISO code

-- Question No.2: Return total transactions volume of debit and credit cards for each province
-- for Jawa region only
SELECT
    tvol.province_isocode AS pcode,
    pid.province_name AS name_of_province,
    tvol.region_isocode AS rcode,
    rid.region_name AS name_of_region,
    tvol.payment_system_name AS system_name,
    SUM(tvol.value) AS total_transactions_volume
FROM transactions_volume AS tvol
INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tvol.region_isocode = rid.region_isocode
WHERE
    tvol.payment_system_name IN ('Debit Cards', 'Credit Cards')
    AND rid.region_name = 'Jawa'
GROUP BY name_of_province, name_of_region,
         system_name, pcode, rcode
ORDER BY system_name ASC;
-- This query returns total transactions volume of debit and credit cards for Jawa region

-- Question No.3: Test the LEFT JOIN and retrieve number of provinces for each region
SELECT
    rid.region_name AS name_of_region,
    COUNT(DISTINCT(tval.province_isocode)) AS number_of_province
FROM transactions_value AS tval
LEFT JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
LEFT JOIN region_id AS rid
    ON tval.region_isocode = rid.region_isocode
GROUP BY name_of_region
ORDER  BY number_of_province DESC;
-- This query returns total number of provinces for each region,
-- where Sumatera has the most provinces (10 Provinces)

-- Question No.4: Retrieve transactions volume data for all provinces, as well as the name
-- of each province, region, and cashless payments system ID
SELECT
    tvol.province_isocode AS pcode,
    pid.province_name AS name_of_province,
    tvol.region_isocode AS rcode,
    rid.region_name AS name_of_region,
    nid.payment_system_id AS payments_id,
    tvol.payment_system_name system_name,
    tvol.time_date AS date,
    tvol.value AS volume_of_transactions
FROM transactions_volume AS tvol
INNER JOIN province_id AS pid
    ON tvol.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tvol.region_isocode = rid.region_isocode
INNER JOIN noncashps_id AS nid
    ON tvol.payment_system_name = nid.payment_system_name;
-- This query returns 4896 rows of transactions volume data of cashless payments system
-- for all provinces in Indonesia


-- Question No.5: Using prior query, retrieve transactions value data for all provinces in Indonesia,
-- alongside the name of each province, region, and cashless payments system ID
SELECT
    tval.province_isocode AS pcode,
    pid.province_name AS name_of_province,
    tval.region_isocode AS rcode,
    rid.region_name AS name_of_region,
    nid.payment_system_id AS payments_id,
    tval.payment_system_name system_name,
    tval.time_date AS date,
    tval.value AS value_of_transactions
FROM transactions_value AS tval
INNER JOIN province_id AS pid
    ON tval.province_isocode = pid.province_code
INNER JOIN region_id AS rid
    ON tval.region_isocode = rid.region_isocode
INNER JOIN noncashps_id AS nid
    ON tval.payment_system_name = nid.payment_system_name
ORDER BY name_of_province, system_name ASC, date;
-- This query returns 4896 rows of transactions value data of cashless payments system
-- for all provinces in Indonesia