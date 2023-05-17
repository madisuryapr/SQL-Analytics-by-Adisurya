/* Window Functions I */
/* In this file, I demonstrate and introduce the utilization of Window Functions
   withini SQL Server environment
*/

-- Use stocks_performance_Indonesia database
USE stocks_performance_Indonesia;

-- 1. Retrieve row number for stock_performance table
SELECT
    ROW_NUMBER() OVER(
        ORDER BY stock_ticker
        ) AS row_number,
    stock_ticker AS ticker,
    date AS period,
    open_price,
    high_price,
    low_price,
    close_price
FROM stock_performance;

-- 2. Obtain row number for stock_performance table for each stock ticker
SELECT 
    ROW_NUMBER() OVER(
        PARTITION BY stock_ticker
        ORDER BY stock_ticker
    ) AS row_number_partitioned,
    stock_ticker AS ticker,
    date AS period,
    open_price,
    low_price,
    high_price,
    close_price
FROM stock_performance;

-- 3. Extract previous 30 days stocks typical price for each stock ticker
SELECT
    stock_ticker AS ticker,
    date AS period,
    ((high_price + low_price + close_price)/3) AS typical_price,
    LAG((high_price + low_price + close_price)/3, 30) 
    OVER ( 
        PARTITION BY stock_ticker
        ORDER BY stock_ticker
    ) AS typical_price_lag30
FROM stock_performance;

-- 4. Calculate the next 60 days of stocks high, low, and close prices
SELECT
    sp.stock_ticker AS ticker,
    sl.company_name AS company_name,
    sp.date AS period,
    high_price,
    low_price,
    close_price,
    LEAD(high_price, 60) OVER(
        PARTITION BY stock_ticker
            ORDER BY stock_ticker
    ) AS high_price_lead60,
    LEAD(low_price, 60) OVER(
        PARTITION BY stock_ticker
            ORDER BY stock_ticker
    ) AS high_price_lead60,
    LEAD(close_price, 60) OVER(
        PARTITION BY stock_ticker
            ORDER BY stock_ticker
    ) AS close_price_lead60
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl 
    ON sp.stock_ticker = sl.stock_code;

-- 5. Determine the culumative distribution of stock's monthly average typical price for each company
SELECT
    sp.stock_ticker AS ticker,
    sl.company_name AS company,
    DATEPART(year, sp.date) AS year,
    DATEPART(month, sp.date) AS month,
    AVG((high_price + low_price + close_price)/3) AS monthly_typical_price,
    CAST(CUME_DIST() OVER(
        PARTITION BY DATEPART(year, sp.date)
        ORDER BY stock_ticker
    ) AS NUMERIC(25, 6)) AS cumulative_distribution
FROM stock_performance AS sp 
INNER JOIN stock_listing AS sl 
    ON sp.stock_ticker = sl.stock_code
GROUP BY 
    sp.stock_ticker, 
    sl.company_name,
    DATEPART(year, sp.date),
    DATEPART(month, sp.date)
ORDER BY company ASC, year, month;
