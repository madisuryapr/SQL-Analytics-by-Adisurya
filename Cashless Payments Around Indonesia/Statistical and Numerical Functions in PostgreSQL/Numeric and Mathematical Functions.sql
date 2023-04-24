/* NUMERIC AND MATHEMATICAL FUNCTIONS IN POSTGRESQL
   This file introduces numeric and mathematical functions usage
   within PostgreSQL environment to answer particular table-related
   questions
 */

-- Question No.1: What is the square root of transactions value of debit cards for each province?
SELECT
    province_id.province_name AS name_of_province,
    transactions_value.time_date AS date,
    transactions_value.payment_system_name AS system_name,
    transactions_value.value AS original_value,
    SQRT(transactions_value.value)::NUMERIC(20,3) AS square_root
FROM transactions_value
INNER JOIN province_id
    ON transactions_value.province_isocode = province_id.province_code
WHERE
    transactions_value.payment_system_name = 'Debit Cards'
ORDER BY
    name_of_province, date;

-- Question No.2: Using the same prior query, what is the cubic root of total transactions value
-- of Bank Indonesia Real-Time Gross Settlement System for each region?
SELECT
    region_id.region_name AS name_of_region,
    transactions_value.payment_system_name AS system_name,
    SUM(transactions_value.value) AS total_value,
    CBRT(SUM(transactions_value.value))::NUMERIC(20,3) AS cubic_root_of_sum
FROM transactions_value
INNER JOIN region_id
    ON transactions_value.region_isocode = region_id.region_isocode
WHERE
    transactions_value.payment_system_name =
    'Bank Indonesia Real-Time Gross Settlement System'
GROUP BY
    name_of_region, system_name
ORDER BY
    name_of_region;

-- Question No.3: What is the Modulo of total credit cards transactions value when divided by
-- the provincial transactions value average for each province?
SELECT
    tval.province_isocode AS pcode,
    pi.province_name AS name_of_province,
    SUM(tval.value) AS credit_cards_total,
    AVG(tval.value)::NUMERIC(22,3) AS credit_cards_average,
    MOD(SUM(tval.value), AVG(tval.value))::NUMERIC(22,3)
        AS modulo_of_sum
FROM transactions_value tval
INNER JOIN province_id pi
    ON tval.province_isocode = pi.province_code
WHERE
    tval.payment_system_name = 'Credit Cards'
GROUP BY name_of_province, pcode
ORDER BY name_of_province;

-- Question No.4: Retrieve the natural logarithm of credit cards transactions volume of DKI Jakarta
SELECT
    pi.province_name AS name_of_province,
    tvol.time_date AS period,
    CAST(tvol.value AS BIGINT) AS credit_cards_vol,
    LN(tvol.value)::NUMERIC(22,3)
        AS natural_log_credit_cards_vol
FROM transactions_volume tvol
INNER JOIN province_id pi
    ON tvol.province_isocode = pi.province_code
WHERE
    tvol.payment_system_name = 'Credit Cards'
  AND pi.province_name = 'DKI Jakarta';

-- Question No.5: Round Up all transactions value data for all provinces in Jawa region
SELECT
    province_isocode AS pcode,
    region_isocode AS rcode,
    time_date AS month_period,
    payment_system_name AS system_name,
    value AS original_value,
    CEIL(value) AS rounded_up_value
FROM transactions_value
WHERE
    region_isocode = 'JW';

-- Question No.6: Round down transactions value data for all provinces in Sumatera region
SELECT
    province_isocode AS pcode,
    region_isocode AS rcode,
    time_date AS month_period,
    payment_system_name AS system_name,
    value AS original_value,
    FLOOR(value) AS rounded_up_value
FROM transactions_value
WHERE
    region_isocode = 'SM';

-- Question No.7: What is the 10-based-logarithmic of debit cards transactions value for
-- all provinces in Jawa and Sulawesi regions?
SELECT
    province_isocode AS pcode,
    region_isocode AS rcode,
    time_date AS month_period,
    payment_system_name AS system_name,
    value AS original_value,
    LOG10(value)::NUMERIC(22,3) AS log_10_value
FROM transactions_value
WHERE payment_system_name = 'Debit Cards'
    AND region_isocode IN ('JW', 'SL');

