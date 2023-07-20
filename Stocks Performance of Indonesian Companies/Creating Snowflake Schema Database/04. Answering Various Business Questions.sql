/* Answering Various Business-related Questions with Snowflake Database Schema
   After creating our database with snowflake schema,
   we are now able to answer various business-related questions
   using this database to gain various insights regarding
   Indonesian companies' stocks performance
 */

-- Begin this query be selecting the designated database
USE snowflake_stocks_performance_Indonesia;

-- Q1: How many companies do exist within the database?
SELECT
    COUNT(DISTINCT(Company)) AS number_of_companies
FROM stock_list;
-- There are 80 companies exist within the database

-- Q2: What are the averages of stocks transactions volume for all companies in Banks Industry each year?
SELECT
    i.IndustryID AS ID,
    i.Industry AS industry,
    DATEPART(YEAR, spf.Date) AS year,
    AVG(spf.StocksTransactionsVolume) AS AvgTransactionsVolume
FROM stocks_performance_fact AS spf
INNER JOIN stock_list AS sl
    ON spf.StockTicker = sl.Ticker
INNER JOIN industry AS i
    ON sl.IndustryID = i.IndustryID
WHERE
    i.IndustryID = 'G11'
GROUP BY
    i.IndustryID, i.Industry, DATEPART(YEAR, spf.Date)
ORDER BY year ASC;
-- During 2020 until 2023, average stocks transactions volume for Banks industry
-- is between 36 and 43 millions of stocks transactions

-- Q3: How many industries are contained in this database?
SELECT
    COUNT(*) AS NumberOfIndustry
FROM industry;
-- There are 34 industries are contained within this database

-- Q4: Retrieve the averages of stocks high price based on each industry
SELECT
    i.IndustryID AS ID,
    i.Industry AS IndustryName,
    spf.Date AS date,
    AVG(spf.HighPrice) AS HighPrice
FROM stocks_performance_fact AS spf
INNER JOIN stock_list AS sl
    ON spf.StockTicker = sl.Ticker
INNER JOIN industry AS i
    ON sl.IndustryID = i.IndustryID
GROUP BY
    i.Industry, spf.Date, i.IndustryID
ORDER BY
    ID ASC, date;
-- Based on this query, we obtain 28186 rows of data that represents the average of stocks high price
-- for each industry within the database

-- Q5: What is the highest stocks transactions volume for each stocks sector?
SELECT
    s.SectorID AS ID,
    s.Sector AS SectorName,
    MAX(spf.StocksTransactionsVolume) AS highest_stocks_volume
FROM stocks_performance_fact AS spf
INNER JOIN stock_list AS sl
    ON spf.StockTicker = sl.Ticker
INNER JOIN industry AS i
    ON sl.IndustryID = i.IndustryID
INNER JOIN sector AS s
    ON i.SectorID = s.SectorID
GROUP BY
    s.SectorID, s.Sector
ORDER BY
    ID ASC;
-- This query suggests that Basic Materials, Consumer Non-Cyclicals, and Consumer Cyclicals
-- become top three based on the highest stocks transactions volume

-- Q6: What are the Standard Deviations (S.D.) of stocks transactions volume for each company
-- every year within Healthcare sectors?
SELECT
    spf.StockTicker AS Ticker,
    sl.Company AS CompanyName,
    DATEPART(YEAR, spf.Date) AS Year,
    CAST(
        STDEVP(StocksTransactionsVolume)
        AS BIGINT
        ) AS SDofVolume
FROM stocks_performance_fact AS spf
INNER JOIN stock_list AS sl
    ON spf.StockTicker = sl.Ticker
INNER JOIN industry AS i
    ON sl.IndustryID = i.IndustryID
INNER JOIN sector AS s
    ON i.SectorID = s.SectorID
WHERE
    s.Sector = 'Healthcare'
GROUP BY
    sl.Company,
    spf.StockTicker,
    DATEPART(YEAR, spf.Date)
ORDER BY
    CompanyName ASC, Year;
-- This query extracts 32 rows of data for the Standard Deviations
-- of all Healthcare sector companies every year

-- Q7: Calculate the average stocks prices for all commercial services companies
SELECT
    i.IndustryID AS id,
    i.Industry AS IndustryName,
    spf.Date AS date,
    AVG(spf.OpenPrice) AS OpenPrice,
    AVG(spf.ClosePrice) AS ClosePrice,
    AVG(spf.HighPrice) AS HighPrice,
    AVG(spf.LowPrice) AS ClosePrice
FROM stocks_performance_fact AS spf
INNER JOIN stock_list AS sl
    ON spf.StockTicker = sl.Ticker
INNER JOIN industry AS i
    ON sl.IndustryID = i.IndustryID
INNER JOIN sector AS s
    ON i.SectorID = s.SectorID
WHERE
    i.Industry = 'Commercial Services'
GROUP BY
    spf.Date,
    i.Industry,
    i.IndustryID;
-- This query generates the average stocks prices for all companies in Commercial Services Industry
-- between 2020 and 2023 every day.

-- Q8: What are the total stocks transactions value for all companies based on their industries each year?
SELECT
    i.IndustryID AS id,
    i.Industry AS industryname,
    DATEPART(YEAR, spf.Date) AS year,
    CAST(
        SUM(
            (spf.ClosePrice * spf.StocksTransactionsVolume) / 1000000000
            ) AS BIGINT
        ) AS total_transactions_value_billion_idr
FROM stocks_performance_fact AS spf
INNER JOIN stock_list AS sl
    ON spf.StockTicker = sl.Ticker
INNER JOIN industry AS i
    ON sl.IndustryID = i.IndustryID
GROUP BY
    i.Industry,
    DATEPART(YEAR, spf.Date),
    i.IndustryID
ORDER BY id ASC, year;
-- This Query extracts 136 rows of data for the total stocks transactions value in Billion IDR
-- of all industries.

-- Q9: Calculate 30- and 100-day moving averages of Stocks' close price for Banks Industry
SELECT
    id,
    industryname,
    date,
    avgcloseprice,
    AVG(avgcloseprice) OVER (
        PARTITION BY industryname
        ORDER BY date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) AS ma_30day,
    AVG(avgcloseprice) OVER (
        PARTITION BY industryname
        ORDER BY date
        ROWS BETWEEN 99 PRECEDING AND CURRENT ROW
        ) AS ma_100day
FROM (
    SELECT
        i.IndustryID AS id,
        i.Industry AS industryname,
        spf.Date AS date,
        AVG(spf.ClosePrice) AS avgcloseprice
    FROM stocks_performance_fact AS spf
    INNER JOIN stock_list AS sl
        ON spf.StockTicker = sl.Ticker
    INNER JOIN industry AS i
        ON sl.IndustryID = i.IndustryID
    GROUP BY
        spf.Date,
        i.Industry,
        i.IndustryID
     ) AS subquery
WHERE
    industryname = 'Banks'
ORDER BY
    id ASC, date;
-- This query retrieves all data of Banks industry close price and its corresponding 30- dan 100-day
-- Moving Averages

-- Q10: What are the 30-day moving standard deviation and stocks return for Consumer Financing industry?
WITH stocks_close_per_industry AS (
    SELECT
        i.IndustryID AS id,
        i.Industry AS industryname,
        spf.Date AS date,
        AVG(spf.ClosePrice) AS avgcloseprice,
        STDEVP(spf.ClosePrice) AS stdevcloseprice
    FROM stocks_performance_fact AS spf
    INNER JOIN stock_list AS sl
        ON spf.StockTicker = sl.Ticker
    INNER JOIN industry AS i
        ON sl.IndustryID = i.IndustryID
    GROUP BY
        i.Industry,
        spf.Date,
        i.IndustryID
)
SELECT
    id,
    industryname,
    date,
    avgcloseprice,
    stdevcloseprice,
    CAST(
        STDEVP(avgcloseprice)
            OVER (
                PARTITION BY industryname, id
                ORDER BY date
                ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
                ) AS NUMERIC(20, 4)
        ) AS moving_stdev,
    LAG(avgcloseprice, 1)
        OVER (
            PARTITION BY industryname, id
            ORDER BY date
            ) AS price_prior_day,
        (avgcloseprice - LAG(avgcloseprice, 1) OVER(
        PARTITION BY industryname, id
        ORDER BY date
        )) AS stocks_return
FROM stocks_close_per_industry
WHERE
    industryname = 'Consumer Financing'
ORDER BY
    industryname ASC,
    date;