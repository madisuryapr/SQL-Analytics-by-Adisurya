/* Data Import */
/* This file demonstrates the import process in MS SQL Server Database Engine using particular query,
   namely BULK INSERT */

-- Start the process by selecting designated database
USE stocks_performance_Indonesia;

-- Begin the Import process
-- 1. Data import for company_sector table
BULK INSERT company_sector
FROM 'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Dataset\CSV Data\company_sector.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 2. Data import for stock_listing table
BULK INSERT stock_listing
FROM 'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Dataset\CSV Data\stock_listing.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );

-- 3. Data import for stock_performance table
BULK INSERT stock_performance
FROM 'D:\Data Analytics\Project\Stocks Performance of Indonesian Companies\Dataset\CSV Data\stock_performance.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
    );