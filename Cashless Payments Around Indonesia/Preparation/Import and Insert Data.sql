/* This Query Examines the process of Importing Data from .csv Files
   and Inserting Multiple Values into Tables */

-- 1. Import Data for Non-cash Payment Systems Transactions Value
COPY
    transactions_value (time_date, province_isocode,
                       region_isocode, payment_system_name,
                       category, unit, value)
FROM
    'D:\Data Analytics\PostgreSQL\Noncash Payment Systems Around Indonesia\Dataset\transactions_value.csv'
DELIMITER ';'
CSV HEADER;

-- 2. Import Data for Non-cash Payment Systems Transactions Volume
COPY
    transactions_volume (time_date, province_isocode,
                       region_isocode, payment_system_name,
                       category, unit, value)
FROM
    'D:\Data Analytics\PostgreSQL\Noncash Payment Systems Around Indonesia\Dataset\transactions_volume.csv'
DELIMITER ';'
CSV HEADER;
-- Each Tables consist of 4896 rows of data

-- 3. Import Data for province_id Table
-- This process will insert 34 Data of Indonesia's Provinces
COPY
    province_id (province_code, province_name)
FROM
    'D:\Data Analytics\PostgreSQL\Noncash Payment Systems Around Indonesia\Dataset\province_isocode.csv'
DELIMITER ';'
CSV HEADER;

-- 4. Insert Data Into noncashps_id Table
INSERT INTO
    noncashps_id (payment_system_id, payment_system_name)
VALUES ('DBTC', 'Debit Cards'),
       ('CRDC', 'Credit Cards'),
       ('ERMY', 'Electronic Money'),
       ('SCLR', 'Bank Indonesia National Clearing System'),
       ('RTGS', 'Bank Indonesia Real-Time Gross Settlement System');
-- This query will insert 5 Non-cash Payment Systems which are
-- recognized in Indonesia

-- 5. Insert Data Into region_id Table
INSERT INTO
    region_id (region_isocode, region_name)
VALUES ('NU', 'Nusa Tenggara'),
       ('JW', 'Jawa'),
       ('KA', 'Kalimantan'),
       ('PP', 'Papua'),
       ('ML', 'Maluku'),
       ('SL', 'Sulawesi'),
       ('SM', 'Sumatera');