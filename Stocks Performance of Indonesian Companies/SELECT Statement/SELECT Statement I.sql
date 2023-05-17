/* SELECT Statement I */
/* This query introduces the usage of SELECT Statement within SQL Server Environment */

-- Begin the query by employing related database
USE stocks_performance_Indonesia;

-- 1. Retrieve all columns from company_sector table
SELECT * FROM company_sector;

-- 2. Retrieve all columns from stock_listing table
SELECT * FROM stock_listing;

-- 3. Retrieve all columns from stock_performance table
SELECT * FROM stock_performance;

-- 4. How many rows are contained within company_sector table?
SELECT COUNT(*) AS number_of_rows
FROM company_sector;

-- 5. How many rows are contained within stock_listing table?
SELECT COUNT(*) AS number_of_rows
FROM stock_listing;

-- 6. How many stock tickers are including in stock_performance table?
SELECT COUNT(DISTINCT(stock_ticker)) AS number_of_ticker
FROM stock_performance;

-- 7. How many companies' sector are exist in company_sector table?
SELECT COUNT(DISTINCT(company_sector)) AS number_of_sector
FROM company_sector;

-- 8. Retrieve the top 5 number of companies, group them by company_sector
SELECT
    TOP 5 company_sector AS sector,
    COUNT(*) AS number_of_companies
FROM company_sector
GROUP BY company_sector
ORDER BY number_of_companies DESC;

-- 9. What's the highest stock open price for each stock ticker?
SELECT
    stock_ticker AS ticker,
    MAX(open_price) AS max_open_price
FROM stock_performance
GROUP BY stock_ticker;

-- 10. What's the average of typical price for each stock ticker?
-- typical stock's price is obtained by dividing the total of low, high, and close prices by 3
SELECT
    stock_ticker AS ticker,
    AVG((open_price + low_price + high_price)/3) AS average_typical_price
FROM stock_performance
GROUP BY stock_ticker;