/* Data Importing Process
   This file presents the data importing process
   for the new create database with snowflake schema framework
 */

-- Use the corresponding database
USE snowflake_stocks_performance_Indonesia;

-- Begin Data Importing Process
-- 1. Import data for stocks_performance_fact table
BULK INSERT stocks_performance_fact
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\stock_performance.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 2. Import data for stock_list table
BULK INSERT stock_list
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\stock_list.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 3. Import data for industry table
BULK INSERT industry
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\industry.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 4. Import data for sector table
BULK INSERT sector
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\sector.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 5. Import data for date table
BULK INSERT date
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\date.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 6. Import data for month table
BULK INSERT month
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\month.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 7. Import data for quarter table
BULK INSERT quarter
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\quarter.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 8. Import data for year table
BULK INSERT year
FROM
    'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Creating Snowflake Schema Database\Dataset\year.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );
