## Cashless Payments System Around Indonesia
This project examines cashless payments system around Indonesia. Specifically, I utilize time series dataset of recognized cashless payment systems in Indonesia, namely debit cards, credit cards, Bank Indonesia National Clearing System (in Indonesia officially called as Sistem Kliring Nasional Bank Indonesia), and Bank Indonesia Real-Time Gross Settlement System, ranging from January 2020 to December 2022 for 34 Provinces. I retrieved all data from The Central Bank of Indonesia.

There are 5 tables, to which be inserted in this project, namely:

+ noncashps_id         : 4-Character VARCHAR ID mame for cashless payments system. Created by writer
+ province_id          : 2-character VARCHAR ID for each provinces' name in Indonesia. This ID code is based on ISO 3166-2:ID
+ region_id            : 2-character VARCHAR ID of each region of provinces in Indonesia. The ID code is obtained from ISO 3166-2:ID
+ trasactions_value    : Total transactions value of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in Billion IDR.
+ transactions_volume  : Total transactions volume of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in unit of transactions.

Furthermore, this project also explores the utilization of Structured Query Language (SQL) syntaxes to answer any business questions related to the data. There are two main softwares that will be employed within this project, namely PostgreSQL for SQL database and Tableau Desktop to visualize our data. Nevertheless, this folder will only examine PostgreSQL queries in details. Please kindly check my Tableau Public account for the result of Data Visualization.

This repository will present the fundamentals of PostgreSQL Queries and answer all relevant business-related questions, including:
+ SELECT Statements
+ JOINs and UNIONs
+ CASE Statement
+ Subqueries
+ Common Table Expressions (CTEs)
+ Window Functions
+ Functions for Manipulating Data and Tables in PostgreSQL
+ Statistical and Numeric Functions in PostgreSQL
+ Time Series Analysis Using PostgreSQL
+ Database Design with Star Schema in PostgreSQL
