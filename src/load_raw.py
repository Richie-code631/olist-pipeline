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

df = pd.read_csv("data/raw/olist_orders_dataset.csv")        
print(df.shape)

df.to_sql(
    "orders",                              
    engine,
    schema="raw",                      
    if_exists="replace",
    index=False,
)
print("loaded")