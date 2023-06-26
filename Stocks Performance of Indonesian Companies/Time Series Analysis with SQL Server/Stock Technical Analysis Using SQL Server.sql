/*
   Stock Technical Analysis Using SQL Server
   In this file, I will demonstrate diverse technical analysis
   methods which are applied in evaluating companies stock performance
   within SQL Server Environment

   */

-- Execute database selection with USE statement
USE stocks_performance_Indonesia;

-- Question No.1: What is the 50-day and 200-day moving average for Bank Central Asia's
-- typical stocks price?
-- Fact: 50-day and 200-day moving averages also known as short- and long-term MAs, respectively
WITH bbca_stock AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS date_time,
        (sp.price_high + sp.price_low + sp.price_close) / 3
            AS typical_price
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    WHERE
        sl.company_name = 'Bank Central Asia'
) -- Step I: Create CTE that represents Bank Central Asia's stocks typical price
SELECT
    ticker,
    company,
    date_time,
    typical_price,
    AVG(typical_price) OVER(
        PARTITION BY company
        ORDER BY date_time
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
        ) AS ma_50day,
    AVG(typical_price) OVER(
        PARTITION BY company
        ORDER BY date_time
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
        ) AS ma_200day -- Step II: Calculate 50-day and 200-day moving average
                       -- with AVG() as Window Function
FROM bbca_stock;


-- Question No.2: Using Bollinger Bands, Determine whether upward or downward trend
-- occurs on Unilever Indonesia's stocks typical price
WITH unvr_stock AS(
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS date_time,
        sp.price_close AS close_price,
        (sp.price_high + sp.price_low + sp.price_close) / 3
                AS typical_price
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    WHERE
        sl.company_name = 'Unilever Indonesia'
) -- Step I: Create CTE for Unilever Indonesia's stocks performance
SELECT
    ticker,
    company,
    date_time,
    close_price,
    typical_price,
-- Step II: Calculate 20-day moving average of stocks close price
-- and 20-day moving standard deviation of stocks typical price
    AVG(close_price) OVER(
        PARTITION BY company
        ORDER BY company
        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) AS ma_20day,
    CAST(STDEVP(typical_price) OVER(
        PARTITION BY company
        ORDER BY company
        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) AS NUMERIC(20, 3)) AS stdev_20day,
-- Step III: Calculate Upper and Lower Bollinger Bands
    CONVERT(BIGINT, (AVG(close_price) OVER(
                        PARTITION BY company
                        ORDER BY company
                        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) + (STDEVP(typical_price) OVER(
                    PARTITION BY company
                    ORDER BY company
                    ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) * 2))) AS upper_bollinger,
    CONVERT(BIGINT, (AVG(close_price) OVER(
                        PARTITION BY company
                        ORDER BY company
                        ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) - (STDEVP(typical_price) OVER(
                    PARTITION BY company
                    ORDER BY company
                    ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) * 2))) AS lower_bollinger,
-- Step IV: Use CASE Statement to determine the trend
    CASE
        WHEN
            typical_price >
            AVG(close_price) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) AND typical_price <
              CONVERT(BIGINT, (AVG(close_price) OVER(
                                PARTITION BY company
                                ORDER BY company
                                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) + (STDEVP(typical_price) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) * 2))) THEN 'Upward Trend'
        WHEN
            typical_price <
            AVG(close_price) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) AND typical_price >
              CONVERT(BIGINT, (AVG(close_price) OVER(
                                PARTITION BY company
                                ORDER BY company
                                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) - (STDEVP(typical_price) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) * 2))) THEN 'Downward Trend'
        WHEN
            typical_price >
            CONVERT(BIGINT, (AVG(close_price) OVER(
                                PARTITION BY company
                                ORDER BY company
                                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) + (STDEVP(typical_price) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) * 2))) THEN 'Overbought'
        WHEN
            typical_price <
            CONVERT(BIGINT, (AVG(close_price) OVER(
                                PARTITION BY company
                                ORDER BY company
                                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) - (STDEVP(typical_price) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) * 2))) THEN 'Oversold'
        ELSE 'Equal to Certain Point'
    END AS price_trend
FROM
    unvr_stock;

-- Question No.3: Calculate Awesome Oscillator (AO) for Bank Jago stocks median price and
-- determine the median stocks price momentum (whether bullish, bearish, or no momentum)
WITH stocks_median_performance AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS date_time,
        sp.price_high AS high_price,
        sp.price_low AS low_price,
        ((sp.price_high + sp.price_low)/2) AS median_price
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
) -- Step I: Create CTE for median stocks price
SELECT
    ticker,
    company,
    date_time,
    high_price,
    low_price,
    median_price,
     AVG(median_price) OVER(
            PARTITION BY company, ticker
            ORDER BY date_time ASC
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
     ) AS ma5_median_price, -- Step IIa: Calculate 5-day moving average of median price
    AVG(median_price) OVER(
            PARTITION BY company, ticker
            ORDER BY date_time ASC
            ROWS BETWEEN 33 PRECEDING AND CURRENT ROW
     ) AS ma34_median_price, -- Step IIb: Calculate 34-day moving average of median price
     AVG(median_price) OVER(
            PARTITION BY company, ticker
            ORDER BY date_time ASC
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
     ) - AVG(median_price) OVER(
                PARTITION BY company, ticker
                ORDER BY company ASC
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW
     ) AS awesome_oscillator_score, -- Step IIc: Calculate Awesome Oscillator (AO) Score
     CASE
        WHEN
            (AVG(median_price) OVER(
                PARTITION BY company, ticker
                ORDER BY date_time ASC
                ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) -
             AVG(median_price) OVER(
                PARTITION BY company, ticker
                ORDER BY date_time ASC
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW)) > 0 THEN 'Bullish Momentum'
        WHEN
             (AVG(median_price) OVER(
                PARTITION BY company, ticker
                ORDER BY date_time ASC
                ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) -
              AVG(median_price) OVER(
                PARTITION BY company, ticker
                ORDER BY date_time ASC
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW)) < 0 THEN 'Bearish Momentum'
        ELSE 'No Momentum'
        END AS momentum -- Step III: Use CASE Statements to determine the AO momentum
FROM
    stocks_median_performance
WHERE
    company = 'Bank Jago'
ORDER BY
    company ASC,
    date_time;