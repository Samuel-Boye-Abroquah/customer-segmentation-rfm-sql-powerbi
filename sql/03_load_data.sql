/* =====================================================================
   File:        03_load_data.sql
   Purpose:     Load source CSVs into MySQL tables using LOAD DATA INFILE
   Database:    customer_rfm
   Prerequisite: 02_create_tables.sql must have been run first
   
   Data Source: CSVs must be in MySQL's secure upload folder
                (usually C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/)
   
   Note:        TRUNCATE is used instead of DROP to preserve table
                structure, indexes, and constraints between reloads.
   ===================================================================== */

USE customer_rfm;


/* ---------------------------------------------------------------------
   1. dim_customers — Customer dimension
   ---------------------------------------------------------------------
   Grain:  One row per customer
   Source: dim_customers.csv
   Load:   Full replace (TRUNCATE + LOAD)
   
   Columns loaded (in CSV order):
     customer_key, customer_id, customer_number, first_name, last_name,
     marital_status, country, gender, birth_date, date_created
   --------------------------------------------------------------------- */

TRUNCATE TABLE dim_customers;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dim_customers.csv'
INTO TABLE dim_customers
FIELDS TERMINATED BY ',' 
       OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


/* ---------------------------------------------------------------------
   2. fact_sales — Sales fact table
   ---------------------------------------------------------------------
   Grain:  One row per order line
   Source: fact_sales.csv
   Load:   Full replace (TRUNCATE + LOAD)
   
   Columns loaded (explicitly mapped to match CSV order):
     order_number, product_key, customer_key, order_date,
     ship_date, due_date, quantity, price, sales
   
   Why explicit columns?
     Ensures the load works even if the table has extra columns
     (e.g., auto-increment IDs added later). Also protects against
     silently mismatched CSV column order.
   --------------------------------------------------------------------- */

TRUNCATE TABLE fact_sales;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_sales.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ',' 
       OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_number, product_key, customer_key, order_date, ship_date, due_date,
 quantity, price, sales);

/* =====================================================================
   End of file: 03_load_data.sql
   ===================================================================== */
