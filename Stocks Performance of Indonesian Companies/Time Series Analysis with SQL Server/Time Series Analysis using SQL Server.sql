/* Time Series Analysis in MS SQL Server */
/* Within this file, I demonstrate time series analysis with MS SQL Server, such as calculating moving average
and year over year (yoy) growth */

-- Let us begin by selecting appropriate database
USE stocks_performance_Indonesia;

-- No 1. Calculate short- and long-term moving averages of stocks typical price for each company
WITH company_typical_price AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS period,
        (sp.price_high + sp.price_low + sp.price_close)/3 AS typical_price
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
)
SELECT 
    ticker,
    company,
    period,
    typical_price,
    AVG(typical_price) OVER( 
        PARTITION BY company
        ORDER BY company, period
        ROWS BETWEEN 49 PRECEDING AND CURRENT ROW
    ) AS short_term_moving_average,
    AVG(typical_price) OVER(
        PARTITION BY company
        ORDER BY company, period 
        ROWS BETWEEN 199 PRECEDING AND CURRENT ROW
    ) AS long_term_moving_average
FROM
    company_typical_price
ORDER BY
    company, period;

-- No.2: Calculate the 30- and 60-day moving standard deviation of stocks' typical price for each company
WITH company_typical_price AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS period,
        (sp.price_high + sp.price_low + sp.price_close)/3 AS typical_price
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
)
SELECT 
    ticker,
    company,
    period,
    typical_price,
    CAST(STDEVP(typical_price) OVER( 
        PARTITION BY company
        ORDER BY company, period
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS NUMERIC(20, 4)) AS moving_sd_30day,
    CAST(STDEVP(typical_price) OVER(
        PARTITION BY company
        ORDER BY company, period 
        ROWS BETWEEN 59 PRECEDING AND CURRENT ROW
    ) AS NUMERIC(20,4)) AS moving_sd_60day
FROM
    company_typical_price
ORDER BY
    company, period;

-- No.3: How is the difference in stocks intraday return compared to its previous day?
-- Note: Stocks daily return is calculated by subtracting open and close price of stocks (investopedia.com)
WITH stocks_intraday_return AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS period,
        sp.price_open AS open_price,
        sp.price_close AS close_price,
        (sp.price_open - sp.price_close) AS intraday_return
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
)
SELECT 
    ticker,
    company,
    period,
    open_price,
    close_price,
    intraday_return,
    LAG(intraday_return, 1) OVER(
        PARTITION BY company
        ORDER BY company
    ) AS lag_daily_return,
    (intraday_return - LAG(intraday_return, 1) OVER(
        PARTITION BY company
        ORDER BY company
    )) AS daily_return_difference
FROM 
    stocks_intraday_return
ORDER BY
    company, ticker;

-- No.4: Calculate and Determine whether companies stock price are greater or less than annual average of close price 
WITH stock_close_price AS (
    SELECT
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        DATEPART(YEAR, sp.date) AS year,
        sp.date AS period,
        sp.price_close AS close_price
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
) -- Step I: Create CTE that reflects stocks close price only
SELECT
    ticker,
    company,
    year,
    period,
    close_price,
    AVG(close_price) OVER(
        PARTITION BY company, year
    ) AS annual_average,
    CASE 
        WHEN close_price > AVG(close_price) OVER(
        PARTITION BY company, year
    ) THEN 'Close Price is greater than annual average'
        WHEN close_price < AVG(close_price) OVER(
        PARTITION BY company, year
    ) THEN 'Close Price is less than annual average'
    END AS stock_statement -- Step II: Create a column to called statement that contains the decision
FROM 
    stock_close_price
ORDER BY 
    company, period;

-- No.5: Calculate Awesome Oscillator (AO) for Allo Bank Indonesia stock Price
-- where trading period between January 2022 and May 2023
-- and determine whether the momentum is bearish or bullish
WITH stock_median_performance AS (
    SELECT 
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS date_time,
        sp.price_high AS high_price,
        sp.price_low AS low_price
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
    WHERE
        sp.date BETWEEN '2022-01-01' AND '2023-05-31'
) -- Step I: Create CTE for calculating Median Price
SELECT
    ticker,
    company,
    date_time,
    (high_price + low_price) / 2 AS median_price, -- Step II: Calculate stocks median price
     AVG((high_price + low_price) / 2) OVER(
            PARTITION BY company, ticker
            ORDER BY company, ticker
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
     ) AS ma5_median_price, -- Step IIIa: Calculate 5-day moving average of median price
    AVG((high_price + low_price) / 2) OVER(
            PARTITION BY company, ticker
            ORDER BY company, ticker
            ROWS BETWEEN 33 PRECEDING AND CURRENT ROW
     ) AS ma34_median_price, -- Step IIIb: Calculate 34-day moving average of median price
     AVG((high_price + low_price) / 2) OVER(
            PARTITION BY company, ticker
            ORDER BY company, ticker
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
     ) - AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company, ticker
                ORDER BY company, ticker
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW
     ) AS awesome_oscillator_score, -- Step IIIc: Calculate Awesome Oscillator (AO) Score
     CASE
        WHEN 
            (AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company, ticker
                ORDER BY company, ticker
                ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) - 
            AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company, ticker
                ORDER BY company, ticker
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW)) > 0 THEN 'Bullish Momentum'
        WHEN
             (AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company, ticker
                ORDER BY company, ticker
                ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) - 
            AVG((high_price + low_price) / 2) OVER(
                PARTITION BY company, ticker
                ORDER BY company, ticker
                ROWS BETWEEN 33 PRECEDING AND CURRENT ROW)) < 0 THEN 'Bearish Momentum'
        ELSE 'No Momentum'
        END AS ao_momentum -- Step IV: Use CASE Statements to determine the AO momentum
FROM 
    stock_median_performance
WHERE
    company = 'Allo Bank Indonesia'
ORDER BY
    company ASC,
    date_time;