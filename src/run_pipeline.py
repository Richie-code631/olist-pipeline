import os
import subprocess
import sys
from pathlib import Path

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

SQL_STEPS = [
    "sql/core_dimensions.sql",
    "sql/reports.sql",                     
]

print("Step 1: loading raw data")
subprocess.run([sys.executable, "src/load_raw.py"], check=True)

for path in SQL_STEPS:
    print(f"Running {path}")
    sql = Path(path).read_text(encoding="utf-8")
    with engine.begin() as conn:
        conn.exec_driver_sql(sql)

print("Pipeline finished")