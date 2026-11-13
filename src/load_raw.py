import os
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

load_dotenv()

url = URL.create(
    "postgresql+psycopg2",
    username=os.getenv("PGUSER"),
    password=os.getenv("PGPASSWORD"),
    host=os.getenv("PGHOST"),
    port=os.getenv("PGPORT"),
    database=os.getenv("PGDATABASE"),
)
engine = create_engine(url)

FILES = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",            
    "olist_order_items_dataset.csv": "order_items",            
    "olist_order_payments_dataset.csv": "order_payments",         
    "olist_order_reviews_dataset.csv": "order_reviews",          
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",               
    "olist_sellers_dataset.csv": "sellers",                
    "product_category_name_translation.csv": "product_category",   
}

for filename, table in FILES.items():
    df = pd.read_csv(f"data/raw/{filename}")
    df.to_sql(
        table,
        engine,
        schema="raw",
        if_exists="replace",
        index=False,
        chunksize=10000,
    )
    print(f"{table}: {len(df)} rows loaded")