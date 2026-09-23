DROP TABLE IF EXISTS dim_customers;
CREATE TABLE dim_customers (
    customer_key      INT             NOT NULL,
    customer_id       VARCHAR(20),
    customer_number   VARCHAR(20),
    first_name        VARCHAR(50),
    last_name         VARCHAR(50),
    marital_status    VARCHAR(20),
    country           VARCHAR(50),
    gender            VARCHAR(10),
    birth_date        DATE,
    date_created      DATE,
    PRIMARY KEY (customer_key)
);

DROP TABLE IF EXISTS fact_sales;

CREATE TABLE fact_sales (
    order_number     VARCHAR(20)     NOT NULL,
    product_key      INT             NOT NULL,
    customer_key     INT             NOT NULL,
    order_date       DATE,
    ship_date        DATE,
    due_date         DATE,
    quantity         INT,
    price            DECIMAL(10,2),
    sales            DECIMAL(10,2),
    
    INDEX idx_customer (customer_key),
    INDEX idx_product  (product_key),
    INDEX idx_order_dt (order_date)
);
