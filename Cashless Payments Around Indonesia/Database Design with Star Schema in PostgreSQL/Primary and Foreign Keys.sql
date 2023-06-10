


/* Step I: Alter all dimension table by adding primary keys */

-- Adding Primary Key to date_dimension_star table
ALTER TABLE date_dimension_star
ADD PRIMARY KEY (date_id);

-- Adding Primary Key to province_code_dimension_star table
ALTER TABLE province_code_dimension_star
ADD PRIMARY KEY (province_isocode);

-- Adding Primary Key to region_code_dimension_star table
ALTER TABLE region_code_dimension_star
ADD PRIMARY KEY (region_isocode);

-- Adding Primary Key to cashless_payments_id_dimension_star table
ALTER TABLE cashless_payments_id_dimension_star
ADD PRIMARY KEY (cashless_id);

/* Step II: Insert all designated foreign keys to cashless_fact_star table
 */

-- Alter table and use province_isocode as foreign key
ALTER TABLE cashless_fact_star
ADD FOREIGN KEY (province_isocode) REFERENCES province_code_dimension_star(province_isocode);

-- Alter table and use region_isocode as foreign key
ALTER TABLE cashless_fact_star
ADD FOREIGN KEY (region_isocode) REFERENCES region_code_dimension_star(region_isocode);

-- Alter table and use date_id as foreign key
ALTER TABLE cashless_fact_star
ADD FOREIGN KEY (date_id) REFERENCES date_dimension_star(date_id);

-- Alter table and use cashless_id as foreign key
ALTER TABLE cashless_fact_star
ADD FOREIGN KEY (cashless_id) REFERENCES cashless_payments_id_dimension_star(cashless_id);