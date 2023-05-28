/* SELECT Statement II
   This file continues to examine the utilization of SELECT Statement
   within MS SQL Server environment
   */

-- Select designated database
USE stocks_performance_Indonesia;

-- No. 1: How many companies are listed in IDX based on their sector? Extract only top 5 sectors
SELECT
    TOP 5 cs.company_sector AS sector,
    COUNT(*) AS number_of_companies
FROM
    stock_listing AS sl
INNER JOIN company_sector AS cs
    ON sl.company_name = cs.company_name
GROUP BY
    cs.company_sector
ORDER BY
    number_of_companies DESC;

-- No.2: What company is the top 7 highest average close stock price that exceeds 5000 in 2022?
SELECT
    TOP 7 sl.company_name AS company,
    AVG(sp.price_close) AS closeprice
FROM
    stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
WHERE
    DATEPART(YEAR, sp.date) = 2022
GROUP BY
    sl.company_name
HAVING AVG(sp.price_close) > 5000
ORDER BY
    AVG(sp.price_close) DESC;

-- No.3: how many stocks transactions volume is the lowest that had been purchased in 2023?
-- Return only 25 companies
SELECT
    TOP 25 sp.stock_ticker AS ticker,
    sl.company_name AS company,
    MIN(stocks_transactions_volume) AS min_stocks_tv
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
WHERE
    DATEPART(YEAR, sp.date) = 2023
GROUP BY
    sl.company_name,
    sp.stock_ticker
ORDER BY
    company;

-- No.4: What is the top companies that have average stocks high price exceeds 7000?
-- Return only 1 company
SELECT
    TOP 1 sl.company_name AS company,
    sp.stock_ticker AS ticker,
    AVG(sp.price_high) AS avg_highprice
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
GROUP BY
    sl.company_name,
    sp.stock_ticker
HAVING AVG(sp.price_high) > 7000
ORDER BY
    AVG(sp.price_high) DESC;

-- No.5: How many companies that have average adjusted close stocks price that
-- are greater than its aggregate average?
SELECT
    COUNT(*) AS number_of_companies
FROM (
      SELECT
         sl.company_name AS company,
         AVG(sp.price_adjclose) AS avg_adjclose
      FROM stock_performance AS sp
      INNER JOIN stock_listing AS sl
         ON sp.stock_ticker = sl.stock_code
      GROUP BY
         sl.company_name
      HAVING AVG(sp.price_adjclose) > (
            SELECT
                AVG(price_adjclose)
                AS agg_avg_adjclose
            FROM
                stock_performance
    )
) AS subquery;