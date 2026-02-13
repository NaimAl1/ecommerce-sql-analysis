CREATE DATABASE olist_database;
USE olist_database;

SET sql_mode = '';

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS order_reviews;
DROP TABLE IF EXISTS category_translations;
DROP TABLE IF EXISTS geolocation;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS closed_deals;
DROP TABLE IF EXISTS marketing_qualified_leads;

CREATE TABLE customers (
	customer_id VARCHAR(255) PRIMARY KEY,
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10) 
);

CREATE TABLE products (
    product_id VARCHAR(255) PRIMARY KEY,
    product_category_name VARCHAR(255) NULL,
    product_name_lenght INT NULL,
    product_description_lenght INT NULL,
    product_photos_qty INT NULL,
    product_weight_g INT NULL,
    product_length_cm INT NULL,
    product_height_cm INT NULL, 
    product_width_cm INT NULL
);

CREATE TABLE sellers (
	seller_id VARCHAR(255) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE orders (
	order_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255),
    order_status VARCHAR(100),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME, 
    order_delivered_carrier_date DATETIME, 
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id VARCHAR(255),
    order_item_id INT,
    product_id VARCHAR(255),
    seller_id VARCHAR(255), 
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE order_payments (
	order_id VARCHAR(255),
    payment_sequential INT,
    payment_type VARCHAR(100),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE order_reviews (
	review_id VARCHAR(255) ,
    order_id VARCHAR(255),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,
    PRIMARY KEY (order_id, review_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE category_translations(
	product_category_name VARCHAR(255),
    product_category_name_english VARCHAR(255)
);

CREATE TABLE geolocation (
	geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(30,10),
    geolocation_lng DECIMAL(30,10),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

CREATE TABLE marketing_qualified_leads (
	mql_id VARCHAR(50) PRIMARY KEY,      
	first_contact_date DATE,            
	landing_page_id VARCHAR(50),        
	origin VARCHAR(50)                  
);

CREATE TABLE closed_deals (
    mql_id VARCHAR(50) PRIMARY KEY,     
    seller_id VARCHAR(50),               
    sdr_id VARCHAR(50),                  
    sr_id VARCHAR(50),                   
    won_date DATETIME,                   
    business_segment VARCHAR(100),       
    lead_type VARCHAR(50),               
    lead_behaviour_profile VARCHAR(50),  
    has_company BOOLEAN ,                
    has_gtin BOOLEAN ,                    
    average_stock VARCHAR(50),           
    business_type VARCHAR(50),           
    declared_product_catalog_size INT,   
    declared_monthly_revenue DECIMAL(15,2),
    CONSTRAINT fk_mql FOREIGN KEY (mql_id) 
        REFERENCES marketing_qualified_leads(mql_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/product_category_name_translation.csv'
INTO TABLE category_translations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_marketing_qualified_leads_dataset.csv'
INTO TABLE marketing_qualified_leads
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.5/Uploads/olist_closed_deals_dataset.csv'
INTO TABLE closed_deals
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(mql_id, seller_id, sdr_id, sr_id, @var_won_date, business_segment, lead_type, 
 lead_behaviour_profile, @var_has_company, @var_has_gtin, average_stock, business_type, 
 @var_catalog_size, @var_monthly_revenue)
SET 
    -- 1. Date Handling
    won_date = NULLIF(@var_won_date, ''),
    
    -- 2. Boolean Conversion (Word to Number)
    has_company = CASE 
        WHEN @var_has_company = 'true' THEN 1 
        WHEN @var_has_company = 'false' THEN 0 
        ELSE NULL END,
    has_gtin = CASE 
        WHEN @var_has_gtin = 'true' THEN 1 
        WHEN @var_has_gtin = 'false' THEN 0 
        ELSE NULL END,
        
    -- 3. Numeric Handling
    declared_product_catalog_size = NULLIF(@var_catalog_size, ''),
    declared_monthly_revenue = NULLIF(@var_monthly_revenue, '');
