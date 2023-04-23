# Data Analytics Repository
This repository presents various projects related to Data Analytics and Business Intelligence

both PostgreSQL and Microsoft SQL Server will be utilized in conducting future project to answer various questions. Furthermore, there will be several projects which will be integrated to Tableau. Current ongoing projects are as follows:

## Cashless Payments Around Indonesia
This project will employ PostgreSQL to answer various questions regarding cashless payments in Indonesia based on montly dataset, spanning from January 20202 to December 2022 with database named as "noncash_paymentsys". The term noncash payment systems has the similiar meaning to cashless payments. This database include all cashless payments dataset for 34 provinces in Indonesia. There are 5 tables, to which be inserted in this project, namely:

+ noncashps_id         : 4-Character VARCHAR ID mame for cashless payments system. Created by writer
+ province_id          : 2-character VARCHAR ID for each provinces' name in Indonesia. This ID code is based on ISO 3166-2:ID
+ region_id            : 2-character VARCHAR ID of each region of provinces in Indonesia. The ID code is obtained from ISO 3166-2:ID
+ trasactions_value    : Total transactions value of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in Million IDR (Previously before conversion). I obtained the data from Bank Indonesia website
+ transactions_volume  : Total transactions volume of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in 000 unit of transactions (Previously before conversion). The data are retrieved from Bank Indonesia website
