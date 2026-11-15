DROP TABLE IF EXISTS core.fact_order_items CASCADE;

-- dim_seller grain: one row per seller
DROP TABLE IF EXISTS core.dim_seller;
CREATE TABLE core.dim_seller (
    seller_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id TEXT NOT NULL UNIQUE,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);

INSERT INTO core.dim_seller (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM raw.sellers;

-- dim_customer grain: one row per customer_id (one per order), with customer_unique_id identifying the real person
DROP TABLE IF EXISTS core.dim_customer;

CREATE TABLE core.dim_customer (
    customer_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id TEXT NOT NULL UNIQUE,
    customer_unique_id TEXT,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state TEXT
);

INSERT INTO core.dim_customer
    (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
SELECT
    customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
FROM raw.customers;

-- dim_product grain: one row per product
DROP TABLE IF EXISTS core.dim_product;

CREATE TABLE core.dim_product (
    product_key INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id TEXT NOT NULL UNIQUE,
    product_category_name TEXT,
	product_name_lenght DOUBLE PRECISION,
	product_description_lenght DOUBLE PRECISION,
	product_photos_qty DOUBLE PRECISION,
	product_weight_g DOUBLE PRECISION,
	product_length_cm DOUBLE PRECISION,
	product_height_cm DOUBLE PRECISION,
	product_width_cm DOUBLE PRECISION
);

INSERT INTO core.dim_product 
	( product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
SELECT  product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm
FROM raw.products;

-- dim_date grain: one row per calendar day
DROP TABLE IF EXISTS core.dim_date;

CREATE TABLE core.dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day INT,
    month INT,
    quarter INT,
    year INT
);

INSERT INTO core.dim_date (date_key, full_date, day, month, quarter, year)
SELECT
    CAST(TO_CHAR(d, 'YYYYMMDD') AS INT) AS date_key,
    CAST(d AS DATE) AS full_date,
    EXTRACT(DAY FROM d) AS day,
    EXTRACT(MONTH FROM d) AS month,
    EXTRACT(QUARTER FROM d) AS quarter,          
    EXTRACT(YEAR FROM d) AS year              
FROM generate_series(DATE '2016-01-01', DATE '2018-12-31', INTERVAL '1 day') AS d;

-- fact_order_items grain: one row per item in an order
DROP TABLE IF EXISTS core.fact_order_items;

CREATE TABLE core.fact_order_items (
    order_id TEXT NOT NULL,
    order_item_id INT NOT NULL,
    customer_key INT NOT NULL REFERENCES core.dim_customer (customer_key),
    product_key INT NOT NULL REFERENCES core.dim_product (product_key),     
    seller_key INT NOT NULL REFERENCES core.dim_seller (seller_key),        
    purchase_date_key INT NOT NULL REFERENCES core.dim_date (date_key),  
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    order_status TEXT,
    delivery_date_missing BOOLEAN,
    PRIMARY KEY (order_id, order_item_id)
);

INSERT INTO core.fact_order_items
    (order_id, order_item_id, customer_key, product_key, seller_key,
     purchase_date_key, price, freight_value, order_status, delivery_date_missing)
SELECT
    oi.order_id,
    oi.order_item_id,
    c.customer_key,
    p.product_key,
    s.seller_key,
    d.date_key,
    CAST(oi.price AS NUMERIC(10,2)),
    CAST(oi.freight_value AS NUMERIC(10,2)),
    o.order_status,
    (o.order_status = 'delivered' AND o.order_delivered_customer_date IS NULL)
FROM raw.order_items AS oi
JOIN raw.orders AS o ON o.order_id = oi.order_id
JOIN core.dim_customer AS c ON c.customer_id = o.customer_id
JOIN core.dim_product AS p ON p.product_id = oi.product_id                     
JOIN core.dim_seller AS s ON s.seller_id = oi.seller_id                     
JOIN core.dim_date AS d ON d.full_date = CAST(o.order_purchase_timestamp AS timestamp)::date;