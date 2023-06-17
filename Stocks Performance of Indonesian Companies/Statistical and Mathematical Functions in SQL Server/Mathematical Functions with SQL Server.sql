/* Mathematical Functions with  MS SQL Server
   This file demonstrates the utilization of Diverse
   Mathematical Functions within MS SQL Server to answer related questions
 */

-- Select the main Database
USE stocks_performance_Indonesia;

-- No.1: What is the square root of Unilever (UNVR) Average Stocks transactions Volume?
SELECT
    sp.stock_ticker AS ticker,
    sl.company_name AS company,
    CAST(
        SQRT(
            AVG(sp.stocks_transactions_volume)
        ) AS NUMERIC(20,3)
    ) AS square_root_transactions_volume
FROM stock_performance AS sp
INNER JOIN stock_listing sl
    ON sp.stock_ticker = sl.stock_code
WHERE
    sp.stock_ticker = 'UNVR'
GROUP BY
    sl.company_name, sp.stock_ticker;

-- No.2: Calculate natural logarithm of Bank Mandiri (BMRI) stocks median price
SELECT
    sp.stock_ticker AS ticker,
    sl.company_name AS company,
    sp.date AS date_time,
    CAST(
         ((sp.price_high + sp.price_low)/2)
        AS INTEGER
        ) AS median_price,
    CAST(
        LOG(
            ((sp.price_high + sp.price_low)/2)
            ) AS NUMERIC(15,3)
        ) AS natural_log_median_price
FROM stock_performance sp
INNER JOIN stock_listing sl
    ON sp.stock_ticker = sl.stock_code
WHERE
    sp.stock_ticker = 'BMRI'
ORDER BY date_time;

-- No.3: Who are the Top 10 Highest value of 10-base logarithm of stocks transactions value?
SELECT
    TOP 10 sp.stock_ticker ticker,
    sl.company_name company,
    CAST(
        LOG10(
            AVG(stocks_transactions_volume)
        ) AS NUMERIC(15,3)
    ) AS log10_stock_transactions_volume
FROM stock_performance sp
INNER JOIN stock_listing sl
    ON sp.stock_ticker = sl.stock_code
GROUP BY
    sl.company_name, sp.stock_ticker
ORDER BY
    log10_stock_transactions_volume DESC;