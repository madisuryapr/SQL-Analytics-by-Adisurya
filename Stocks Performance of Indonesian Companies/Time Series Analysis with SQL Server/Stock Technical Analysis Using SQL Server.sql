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
        (sp.high_price + sp.low_price + sp.close_price) / 3
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
        ORDER BY company
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
        ) AS ma_50day,
    AVG(typical_price) OVER(
        PARTITION BY company
        ORDER BY company
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
        ) AS ma_200day -- Step II: Calculate 50-day and 200-day moving average
                       -- with AVG() as Window Function
FROM bbca_stock;


-- Question No.2: Using Bollinger Bands, Determine whether upward or downward trend
-- occurs on Bank Negara Indonesia's stock typical price
WITH bbni_stock AS(
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS date_time,
        sp.close_price AS close_price,
        (sp.high_price + sp.low_price + sp.close_price) / 3
                AS typical_price
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    WHERE
        sl.company_name = 'Bank Negara Indonesia'
) -- Step I: Create CTE for Bank Negara Indonesia's stocks performance
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
    END AS price_trend
FROM
    bbni_stock;

-- Question No.3: Calculate Awesome Oscillator (AO) for Bank Jago stocks median price and
-- determine the median stocks price momentum (whether bullish, bearish, or no momentum)
WITH bank_jago_median AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS date_time,
        sp.high_price AS high_price,
        sp.low_price AS low_price
    FROM stock_performance AS sp
    INNER JOIN stock_listing AS sl
        ON sp.stock_ticker = sl.stock_code
    WHERE
    sl.company_name = 'Bank Jago'
) -- Step I: Create CTE for calculating Median Price
SELECT
    ticker,
    company,
    date_time,
    (high_price + low_price) / 2 AS median_price, -- Step II: Calculate stocks median price
     AVG((high_price + low_price) / 2) OVER(
            PARTITION BY company
            ORDER BY company
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
     ) AS ma5_median_price, -- Step IIIa: Calculate 5-day moving average of median price
    AVG((high_price + low_price) / 2) OVER(
            PARTITION BY company
            ORDER BY company
            ROWS BETWEEN 33 PRECEDING AND CURRENT ROW
     ) AS ma34_median_price, -- Step IIIb: Calculate 34-day moving average of median price
     AVG((high_price + low_price) / 2) OVER(
            PARTITION BY company
            ORDER BY company
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
     ) - AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW
     ) AS awesome_oscillator_score, -- Step IIIc: Calculate Awesome Oscillator (AO) Score
     CASE
        WHEN
            (AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) -
             AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW)) > 0 THEN 'Bullish Momentum'
        WHEN
             (AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) -
              AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company
                ORDER BY company
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW)) < 0 THEN 'Bearish Momentum'
        ELSE 'No Momentum'
        END AS momentum -- Step IV: Use CASE Statements to determine the AO momentum
FROM
    bank_jago_median
ORDER BY
    company,
    date_time,
    ticker;