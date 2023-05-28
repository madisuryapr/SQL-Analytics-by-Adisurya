/* Create Database and Preparation */

/* This query presents the necessary preparation in creating Daily Stocks Performance of
Indonesian companies by leveraging Microsoft SQL Server
*/

-- Create database named stocks_performance_Indonesia
CREATE DATABASE stocks_performance_Indonesia;

-- Use the created Database
USE stocks_performance_Indonesia;

-- Construct Three different tables

-- 1. stock_listing: A Table in which contains data regarding initial listing information of Indonesian Companies
CREATE TABLE stock_listing (
    stock_code VARCHAR(100) PRIMARY KEY,
    company_name VARCHAR(MAX),
    initial_listing_date DATE
);

-- 2. stock_performance: A 8-column Table which encompasses daily stocks' performance of Indonesian companies
CREATE TABLE stock_performance (
    stock_ticker VARCHAR(100) FOREIGN KEY REFERENCES stock_listing(stock_code),
    date DATE,
    price_open BIGINT,
    price_high BIGINT,
    price_low BIGINT,
    price_close BIGINT,
    price_adjclose BIGINT,
    stocks_transactions_volume BIGINT
);

-- 3. company_sector: List of companies name and their corresponding sector of operation
CREATE TABLE company_sector (
    company_name VARCHAR(MAX),
    company_sector VARCHAR(MAX)
);