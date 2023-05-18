/* Window Functions II */
/* In this file, I present the utilization of aggregate and statistical functions within Window Functions perspective */

-- Begin the execution by selecting stocks_performance_Indonesia database
USE stocks_performance_Indonesia;

-- 1. What is the total stocks transactions volume for each company?
SELECT 
    sp.stock_ticker AS ticker,
    sl.company_name AS company,
    sp.date AS period_date,
    sp.stocks_transactions_volume AS stocks_volume,
    SUM(sp.stocks_transactions_volume) OVER(
        PARTITION BY stock_ticker
    ) AS total_volume_per_company
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl 
    ON sp.stock_ticker = sl.stock_code
ORDER BY company, period_date;

-- 2. Retrieve the annual average of company's stocks typical price for each company
WITH company_stock AS (
    SELECT 
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS period,
        DATEPART(year, sp.date) AS year_period,
        (sp.high_price + sp.low_price + sp.close_price)/3 AS typical_price 
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
)
SELECT
    ticker,
    company,
    period,
    year_period,
    typical_price,
    AVG(typical_price) OVER(
        PARTITION BY company, 
        year_period
    ) AS average_typical_price_per_company 
FROM 
    company_stock
ORDER BY company, period;

-- 3. What is the annual maximum stocks high price for each company?
WITH company_high_price AS (
    SELECT 
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS period,
        DATEPART(year, sp.date) AS year_period,
        sp.high_price AS high_price 
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
)
SELECT 
    ticker,
    company,
    period,
    year_period,
    high_price,
    MAX(high_price) OVER(
        PARTITION BY company,
        year_period
    ) AS annual_maximum_high_price
FROM 
    company_high_price
ORDER BY company, period;

-- 4. Calculate the aggregate variance of companies' stocks typical price for each company
WITH company_typical_price AS (
    SELECT 
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        sp.date AS period,
        (sp.high_price + sp.low_price + sp.close_price)/3 AS typical_price
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
)
SELECT 
    ticker,
    company,
    period,
    typical_price,
    CAST(VARP(typical_price) OVER(
        PARTITION BY company
    ) AS NUMERIC(25,4)) AS variance_typical_price_per_company
FROM 
    company_typical_price 
ORDER BY company, period;

-- 5. What is the standard deviation of companies' stocks monthly average of typical price for each company?
WITH monthly_company_typical_price AS (
        SELECT 
        sp.stock_ticker AS ticker,
        sl.company_name AS company,
        DATEPART(YEAR, sp.date) AS year,
        DATEPART(MONTH, sp.date) AS month,
        AVG((sp.high_price + sp.low_price + sp.close_price)/3) AS monthly_average_typical_price
    FROM stock_performance AS sp 
    INNER JOIN stock_listing AS sl 
        ON sp.stock_ticker = sl.stock_code
    GROUP BY 
        sl.company_name,
        DATEPART(YEAR, sp.date),
        DATEPART(MONTH, sp.date),
        sp.stock_ticker
)
SELECT 
    ticker,
    company,
    year,
    month,
    CONCAT_WS('.', year, month) AS monthly_period,
    monthly_average_typical_price,
    CAST(STDEVP(monthly_average_typical_price) OVER (
        PARTITION BY company
    ) AS NUMERIC(25, 4)) AS standard_deviation
FROM monthly_company_typical_price
ORDER BY company, year, month;