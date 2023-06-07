/* Common Table Expressions (CTEs) Using SQL Server
   In this file, I demonstrate how to utilize CTEs
   when it comes to answering various business-related questions
 */

-- Before begin the demonstration, use corresponding database
USE stocks_performance_Indonesia;

-- No.1: What are the 10 companies with highest average stocks lower price?
WITH stocks_lower_average AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        AVG(sp.price_low) AS average_low_price
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    GROUP BY
        sl.company_name,
        sp.stock_ticker
)
SELECT
    TOP 10 ticker,
    company,
    average_low_price
FROM
    stocks_lower_average
ORDER BY
    average_low_price DESC;

-- No.2: What are 5 companies that have the lowest maximum stocks median price in 2022?
WITH stocks_median_price_2022 AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        DATEPART(YEAR, sp.date) AS year,
        sp.date AS date_time,
        ((sp.price_high + sp.price_low)/2) AS median_price
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    WHERE
        DATEPART(YEAR, sp.date) = 2022
)
SELECT
    TOP 5 ticker,
    company,
    MAX(median_price) AS max_median_price
FROM
    stocks_median_price_2022
GROUP BY
    company, ticker
ORDER BY
    max_median_price ASC;

-- No.3: What is the total stocks transactions volume for each company sector? Extract 10 highest only
WITH stocks_volume_company AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        cs.company_sector AS sector,
        sp.date AS date_time,
        sp.stocks_transactions_volume AS stocks_tvolume
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    INNER JOIN company_sector AS cs
        ON sl.company_name = cs.company_name
)
SELECT
    TOP 10 sector,
    (SUM(stocks_tvolume)/1000000)AS total_volume_million
FROM
    stocks_volume_company
GROUP BY sector
ORDER BY total_volume_million DESC;

-- No.4: What is the total stocks transactions volume for Unilever Indonesia (UNVR) in 2023 each month?
WITH unvr_2023 AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        DATEPART(YEAR, sp.date) AS year,
        DATEPART(MONTH, sp.date) AS month,
        sp.date AS date_time,
        sp.stocks_transactions_volume AS volume
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    WHERE
        sp.stock_ticker = 'UNVR'
        AND
        DATEPART(YEAR, sp.date) = 2023
)
SELECT
    year,
    month,
    UPPER(DATENAME(MONTH, date_time))
        AS month_name,
    SUM(volume) AS total_volume
FROM
    unvr_2023
GROUP BY
    DATENAME(MONTH, date_time),
    month, year;