/* Table Modification
   This file demonstrates the modification for the latest tables
   that inserted into a new database called snowflake_stocks_performance_Indonesia
   by designating both primary and foreign keys on all tables
 */

-- First, we select our new database to alter all tables
USE snowflake_stocks_performance_Indonesia;

-- A) Direct connections between fact and dimension tables

-- 1. Create a connection between stocks_performance_fact and stock_list tables
ALTER TABLE stock_list
ADD PRIMARY KEY (Ticker);

ALTER TABLE stocks_performance_fact
ADD FOREIGN KEY (StockTicker) REFERENCES stock_list(Ticker);

-- 2. Create a connection between stocks_performance_fact and date tables
ALTER TABLE date
ADD PRIMARY KEY (Date);

ALTER TABLE stocks_performance_fact
ADD FOREIGN KEY (Date) REFERENCES date(Date);

-- B) Indirect connections between fact and dimension tables

-- 1. Create a connection between stock_list and industry tables
ALTER TABLE industry
ADD PRIMARY KEY (IndustryID);

ALTER TABLE stock_list
ADD FOREIGN KEY (IndustryID) REFERENCES industry(IndustryID);

-- 2. Create a connection between industry and sector tables
ALTER TABLE sector
ADD PRIMARY KEY (SectorID);

ALTER TABLE industry
ADD FOREIGN KEY (SectorID) REFERENCES sector(SectorID);

-- 3. Establish a connection between date and month tables
ALTER TABLE month
ADD PRIMARY KEY (MonthID);

ALTER TABLE date
ADD FOREIGN KEY (MonthID) REFERENCES month(MonthID);

-- 4. Create a connection between month and quarter tables
ALTER TABLE quarter
ADD PRIMARY KEY (QuarterID);

ALTER TABLE month
ADD FOREIGN KEY (QuarterID) REFERENCES quarter(QuarterID);

-- 5. Establish a connection between quarter and year tables
ALTER TABLE year
ADD PRIMARY KEY (YearID);

ALTER TABLE quarter
ADD FOREIGN KEY (YearID) REFERENCES year(YearID);