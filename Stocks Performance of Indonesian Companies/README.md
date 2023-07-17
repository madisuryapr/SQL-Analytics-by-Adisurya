## Stocks Performance of Indonesian Companies
This project examines daily stocks performance of 30+ Indonesian companies, covering January 2020 to May 2023 period of time. Specifically, I utilize time series dataset of 30+ Indonesian companies stocks performance that which obtained from Yahoo Finance. For stock_performance table, I appended and cleanse all individual company daily stock data by performing data wrangling with Power Query. Furthermore, I also conducted data wrangling to stock_listing and company_sector where both tables data are retrieved from Indonesia Stock Exchange and Indonesia-Investments.com, respectively.

This project contains 3 tables as follows.
+ stock_performance    : This table contains 6 columns of companies' stock performance, i.e. Open, High, Low, Close, and Adjusted Close Prices and Volume
+ stock_listing         : Table in which contains list of companies' ticker, name and their first listing in Indonesia Stock Exchange (IDX)
+ company_sector        : provides the list of companies' sector for all registered companies in IDX

This project utilizes Microsoft SQL Server to devise and create various queries to answer various business-related questions regarding stock market. I employ DataGrip IDE as main driver in crafting queries.

This repository will present the fundamentals of SQL Server queries which covers following topic:
+ SELECT Statements
+ JOINs and Subqueries
+ CASE Statement
+ Common Table Expressions (CTEs)
+ Window Functions
+ Functions for Manipulating Data and Tables in MS SQL Server
+ Statistical and Mathematical Functions in MS SQL Server
+ Time Series Analysis Using MS SQL Server
+ Creating Snowflake Schema Database with MS SQL Server
