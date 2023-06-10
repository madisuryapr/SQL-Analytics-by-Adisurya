/* Preparation in Creating Star Schema with PostgreSQL

   This file presents several steps to creating
   and designing database based on star schema methods
 */

 -- Create new database called cashless_system_star
CREATE DATABASE cashless_system_star;

-- Create fact table named cashless_fact_star
CREATE TABLE cashless_fact_star (
    province_isocode VARCHAR(25),
    region_isocode VARCHAR(25),
    cashless_id VARCHAR(25),
    date_id INTEGER,
    transactions_value NUMERIC(25,3),
    transactions_volume BIGINT
);

-- Create dimension table in which contains information regarding Province ISO Code
-- and its corresponding province name. This table named province_code_dimension_star
CREATE TABLE province_code_dimension_star (
    province_isocode VARCHAR(25),
    province TEXT
);

-- Create dimension table that encompasses Region ISO Code and the name of region.
-- Named this table as region_code_dimension_star
CREATE TABLE region_code_dimension_star (
    region_isocode VARCHAR(25),
    region TEXT
);

-- Create dimension table for cashless payments system id and cashless payments' name.
-- This table is called cashless_payments_id_dimension_star
CREATE TABLE cashless_payments_id_dimension_star (
    cashless_id VARCHAR(25),
    cashless_system_name TEXT
);

-- Create dimension table that constitutes the date information and id. Name this
-- table as date_dimension_star
CREATE TABLE date_dimension_star (
    date_id SERIAL,
    date DATE
);