/* The Objective of this Queries is to create corresponding tables
   regarding Non-cash Payment Systems Around Indonesia
 */

-- 1. Create Table for Transactions Value of Non-cash Payment Systems
CREATE TABLE transactions_value (
    time_date DATE,
    province_isocode VARCHAR(25),
    region_isocode VARCHAR(25),
    payment_system_name TEXT,
    category VARCHAR(150),
    unit TEXT,
    value NUMERIC(35, 3)
);

-- 2. Create Table for Transactions Volume of Non-cash Payment Systems
CREATE TABLE transactions_volume (
    time_date DATE,
    province_isocode VARCHAR(25),
    region_isocode VARCHAR(25),
    payment_system_name TEXT,
    category VARCHAR(150),
    unit TEXT,
    value NUMERIC(35, 3)
);

-- 3. Create Table for Non-cash Payment Systems IDs
-- This table consists of IDs for Non-cash Payment Systems created by Author
CREATE TABLE noncashps_id (
    payment_system_id VARCHAR(20),
    payment_system_name TEXT
);

-- 4. Create Region's IDs Table
-- This table encompasses Regional ISO-Code for Indonesia based on ISO 3166-2:ID
CREATE TABLE region_id (
    region_isocode VARCHAR(20),
    region_name VARCHAR(100)
);

-- 5. Create Province's IDs Table
-- This table encompasses ISO-Code for Indonesia's 34 Provinces based on ISO 3166-2:ID
CREATE TABLE province_id (
    province_code VARCHAR(20),
    province_name TEXT
);