# Data Analytics Repository
This repository presents various projects related to Data Analytics and Business Intelligence

both PostgreSQL and Microsoft SQL Server will be utilized in conducting future project to answer various questions. Furthermore, there will be several projects which will be integrated to Tableau Desktop. Current projects are as follows:

## Cashless Payments Around Indonesia
This project will employ PostgreSQL to answer various questions regarding cashless payments in Indonesia based on montly dataset, spanning from January 20202 to December 2022 with database named as "noncash_paymentsys". The term noncash payment systems has the similiar meaning to cashless payments. This database include all cashless payments dataset for 34 provinces in Indonesia. There are 5 tables, to which be inserted in this project, namely:

+ noncashps_id         : 4-Character VARCHAR ID mame for cashless payments system. Created by writer
+ province_id          : 2-character VARCHAR ID for each provinces' name in Indonesia. This ID code is based on ISO 3166-2:ID
+ region_id            : 2-character VARCHAR ID of each region of provinces in Indonesia. The ID code is obtained from ISO 3166-2:ID
+ trasactions_value    : Total transactions value of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in Billion IDR. The data were from Bank Indonesia website
+ transactions_volume  : Total transactions volume of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in unit of transactions. The data are retrieved from Bank Indonesia website

### Live Dashboard
This dashboard is available on both Desktop and mobile versions. Click link below to observe the dashboard
+ [View Live Dashboard for Cashless Payments Around Indonesia on Tableau Public](https://public.tableau.com/app/profile/madisuryapr/viz/CashlessPaymentsSystemAroundIndonesia/CashlessPayments)

![Tableau Dashboard](https://github.com/madisuryapr/Data-Analytics-by-Adisurya/assets/91768688/f33806a9-232a-472e-803e-fab393e8aa13)

## Stocks' Performance of Indonesian Firms During COVID-19 Pandemic
This project presents another SQL project regarding stocks' performance for 30+ Indonesian firms during COVID-19 pandemic, in which encompasses daily dataset over the period January 2020 to April 2023. Microsoft SQL Server Express will be utilized as primary database engine and query language. The project database is expected to contain 3 tabless as follows.
+ stocks_performance    : This table contains 6 columns of firm's stock performance, i.e. Open, High, Low, Close, Adj Close, and Volume
+ stock_listing         : Table in which contains list of stock firms and their first listing in Indonesia Stock Exchange (IDX)
+ stock_firm_sector     : The table provides the list of firm's sector for all registered firms in IDX
