/* JOINs in SQL Server
   This file presents JOINs statement
   usage to answer diverse business-related questions
   */

-- Use stocks_performance_Indonesia database
USE stocks_performance_Indonesia;

-- No.1: What is the overall average of stocks typical price for each company? Use INNER JOIN
SELECT
    sp.stock_ticker AS ticker,
    sl.company_name AS company,
    AVG(
        (sp.price_high + sp.price_low + sp.price_close)/3
        ) AS average_typical_price
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
GROUP BY
    sl.company_name, sp.stock_ticker
ORDER BY
    company ASC;

-- No.2: Retrieve all companies ticker, name, initial stocks listing, alongside their sectors. Use LEFT JOIN
SELECT
    sl.stock_code AS code,
    sl.company_name AS company,
    sl.initial_listing_date AS listing_date,
    cs.company_sector AS sector
FROM stock_listing AS sl
LEFT JOIN company_sector AS cs
    ON sl.company_name = cs.company_name
ORDER BY
    company ASC;

-- No.3: Recall the prior query, calculate how many nulls in sector column
WITH listing AS(
    SELECT
    sl.stock_code AS code,
    sl.company_name AS company,
    sl.initial_listing_date AS listing_date,
    cs.company_sector AS sector
FROM stock_listing AS sl
LEFT JOIN company_sector AS cs
    ON sl.company_name = cs.company_name
)
SELECT
    COUNT(*) AS null_rows
FROM listing
WHERE
    sector IS NULL;

-- No.4: Extract stock ticker, company name and their corresponding sector. Employ RIGHT JOIN
SELECT
    sl.stock_code AS code,
    cs.company_name AS company,
    cs.company_sector AS sector
FROM stock_listing AS sl
RIGHT JOIN company_sector AS cs
    ON sl.company_name = cs.company_name
ORDER BY
    company ASC;

-- No.5: Again, recalling from prior query, calculate how many rows that are not null for stock code
WITH company_list AS(
    SELECT
    sl.stock_code AS code,
    cs.company_name AS company,
    cs.company_sector AS sector
FROM stock_listing AS sl
RIGHT JOIN company_sector AS cs
    ON sl.company_name = cs.company_name
)
SELECT
    COUNT(*) AS non_null_rows
FROM
    company_list
WHERE
    code IS NOT NULL;

-- No.6: By employing multiple joins, calculate overall average of stocks transactions volume for
-- Each company that exists with INNER JOIN
SELECT
    sl.company_name AS company,
    cs.company_sector AS sector,
    AVG(sp.stocks_transactions_volume) AS average_transactions
FROM stock_performance AS sp
INNER JOIN stock_listing AS sl
    ON sp.stock_ticker = sl.stock_code
INNER JOIN company_sector AS cs
    ON sl.company_name = cs.company_name
GROUP BY
    sl.company_name, cs.company_sector
ORDER BY
    company ASC;