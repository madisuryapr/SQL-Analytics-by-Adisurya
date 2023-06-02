/* CASE Statement with SQL Server
   In this file, I demonstrate the usage of CASE statement
   to answer any business-related questions regarding
   stocks performance of Indonesian companies
 */

 -- As in line with the routine, use stocks_performance_Indonesia database
USE stocks_performance_Indonesia;

-- No.1: Determine whether Bank Mandiri typical stocks price is lower or higher than its average
SELECT
    sp.stock_ticker AS ticker,
    sl.company_name AS company,
    sp.date AS date_time,
    (sp.price_high + sp.price_low + sp.price_close)/3
        AS typical_price,
    AVG((sp.price_high + sp.price_low + sp.price_close)/3) OVER(
                PARTITION BY sl.company_name
                ) AS avg_typical_price,
    CASE
        WHEN
            (sp.price_high + sp.price_low + sp.price_close)/3 >
            AVG((sp.price_high + sp.price_low + sp.price_close)/3) OVER(
                PARTITION BY sl.company_name
                ) THEN 'Higher than Average'
        WHEN
            (sp.price_high + sp.price_low + sp.price_close)/3 <
            AVG((sp.price_high + sp.price_low + sp.price_close)/3) OVER(
                PARTITION BY sl.company_name
                ) THEN 'Lower than Average'
        ELSE 'Equal to Average'
        END AS condition
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
WHERE
    company_name = 'Bank Mandiri'
ORDER BY
    sp.date ASC;

-- No.2: Determine the Auto Rejection (AR) threshold for Astra International high stocks price
SELECT
    sp.stock_ticker AS ticker,
    sl.company_name AS company,
    sp.date AS period_time,
    sp.price_high AS highprice,
    CASE
        WHEN sp.price_high > 50 AND sp.price_high < 200
            THEN '+- 35% AR Threshold'
        WHEN sp.price_high >= 200 AND sp.price_high < 5000
            THEN '+- 25% AR Threshold'
        WHEN sp.price_high >= 5000
            THEN '+- 20% AR Threshold'
        END AS auto_rejection_threshold
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
WHERE
    sp.stock_ticker = 'ASII'
ORDER BY
    sp.date ASC;

-- No.3: What is the annual total stocks transactions volume of Bank Mandiri
-- with open price higher than 3600?
SELECT
    DATEPART(YEAR, sp.date) AS year,
    CAST
        (SUM(CASE
                WHEN
                    sp.price_open > 3600
                THEN
                    sp.stocks_transactions_volume
             END)/1000000 AS BIGINT)
    AS stocks_total_tvol_million
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
WHERE
    sp.stock_ticker = 'BMRI'
GROUP BY
    DATEPART(YEAR, sp.date)
ORDER BY year ASC;

-- No.4: How many days that XL Axiata (EXCL) stocks close price that more or less than 2300 each year?
SELECT
    DATEPART(YEAR, date) AS year,
    COUNT(CASE
              WHEN
                  stock_ticker = 'EXCL' AND
                  price_close > 2300
              THEN stock_ticker
              END) AS number_of_days_more,
    COUNT(CASE
              WHEN
                  stock_ticker = 'EXCL' AND
                  price_close < 2300
              THEN stock_ticker
              END) AS number_of_days_less
FROM stock_performance
WHERE
    stock_ticker = 'EXCL'
GROUP BY
    DATEPART(YEAR, date)
ORDER BY
    year ASC;
