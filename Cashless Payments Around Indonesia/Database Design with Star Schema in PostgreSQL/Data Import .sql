/* Data Import to New Database
   This file shows how to import datasets to the new designated database
 */

 -- Import data for cashless_fact_star table
COPY cashless_fact_star
FROM 'D:/Data Analytics/Project/Cashless Payments Around Indonesia/Database Design with Star Schema in PostgreSQL/Dataset/cashless_fact_star.csv'
DELIMITER ';'
CSV HEADER;

-- Import data for cashless_payments_id_dimension_star
COPY cashless_payments_id_dimension_star
FROM 'D:/Data Analytics/Project/Cashless Payments Around Indonesia/Database Design with Star Schema in PostgreSQL/Dataset/cashless_payments_id_dimension_star.csv'
DELIMITER ';'
CSV HEADER;

-- Import data for date_dimension_star
COPY date_dimension_star
FROM 'D:/Data Analytics/Project/Cashless Payments Around Indonesia/Database Design with Star Schema in PostgreSQL/Dataset/date_dimension_star.csv'
DELIMITER ';'
CSV HEADER;

-- Import data for province_code_dimension_star
COPY province_code_dimension_star
FROM 'D:/Data Analytics/Project/Cashless Payments Around Indonesia/Database Design with Star Schema in PostgreSQL/Dataset/province_code_dimension_star.csv'
DELIMITER ';'
CSV HEADER;

-- Import data for region_code_dimension_star
COPY region_code_dimension_star
FROM 'D:/Data Analytics/Project/Cashless Payments Around Indonesia/Database Design with Star Schema in PostgreSQL/Dataset/region_code_dimension_star.csv'
DELIMITER ';'
CSV HEADER;

