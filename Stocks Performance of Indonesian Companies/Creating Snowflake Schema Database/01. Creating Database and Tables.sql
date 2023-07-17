/* Creating Database and Tables
   To create snowflake database schema,
   we begin by devising and creating a database and then
   insert several tables into new database that which have been created
 */

-- Step I: Create a database named as snowflake_stocks_performance_Indonesia
CREATE DATABASE
snowflake_stocks_performance_Indonesia;

-- Step II: Use the new database that previously created to create tables and input all data
USE snowflake_stocks_performance_Indonesia;

-- Step III: Devise several tables for both fact and dimension tables
-- A) Fact tables: This table contains stocks tickers and their historical daily prices and transactions volume
CREATE TABLE stocks_performance_fact (
    StockTicker VARCHAR(10) NOT NULL,
    Date DATE,
    OpenPrice BIGINT,
    HighPrice BIGINT,
    LowPrice BIGINT,
    ClosePrice BIGINT,
    AdjClosePrice BIGINT,
    StocksTransactionsVolume BIGINT
);

-- B) Dimension tables: These tables examine all dimensions that will be connected into the fact table
-- both direct and indirect connections
-- 1. stock_list Table
CREATE TABLE stock_list (
    Ticker VARCHAR(10) NOT NULL,
    Company VARCHAR(MAX),
    ListingDate DATE,
    IndustryID VARCHAR(20)
);

-- 2. Industry Table
CREATE TABLE industry (
    IndustryID VARCHAR(20) NOT NULL,
    Industry VARCHAR(MAX),
    SectorID VARCHAR(20)
);

-- 3. Sector Table
CREATE TABLE sector (
    SectorID VARCHAR(20) NOT NULL,
    Sector VARCHAR(MAX)
);

-- 4. Date Table
CREATE TABLE date (
    DateID BIGINT,
    Date DATE NOT NULL,
    MonthID BIGINT
);

-- 5. Month Table
CREATE TABLE month (
    MonthID BIGINT NOT NULL,
    Month VARCHAR(MAX),
    QuarterID INTEGER
);

-- 6. Quarter Table
CREATE TABLE quarter (
    QuarterID INTEGER NOT NULL,
    Quarter VARCHAR(200),
    YearID INTEGER
);

-- 7. Year Table
CREATE TABLE year (
    YearID INTEGER NOT NULL,
    Year INTEGER
);