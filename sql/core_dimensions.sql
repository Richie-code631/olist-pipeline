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


