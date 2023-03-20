# Data-Analytics-by-Adisurya
In this repository, I will be preserving various projects related to Data Analytics and Business Intelligence

I will utilize both PostgreSQL and Microsoft SQL Server in conducting my future project. Currently, I am going to execute a project as following:

## Cashless Payments Around Indonesia
In this project, I employ PostgreSQL to answer various questions regarding cashless payments in Indonesia based on montly dataset, spanning from January 20202 to December 2022 with database named as "noncash_paymentsys". The term noncash payment systems has the similiar meaning to cashless payments. This database include all cashless payments dataset for 34 provinces in Indonesia. There are 5 tables, to which be inserted in this project, namely:

1. #### noncashps_id         : 4-Character VARCHAR ID mame for cashless payments system. Created by writer
2. #### province_id          : 2-character VARCHAR ID for each provinces' name in Indonesia. This ID code is based on ISO 3166-2:ID
3. #### region_id            : 2-character VARCHAR ID of each region of provinces in Indonesia. The ID code is obtained from ISO 3166-2:ID
4. #### trasactions_value    : Total transactions value of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in Million IDR
5. #### transactions_volume  : Total transactions volume of each recognized cashless payments system by official authority for each Indonesia provinces. All values are in 000 unit of transactions
