
import duckdb
import os

# Define database and CSV paths
DB_PATH = "netflix.duckdb"
CSV_PATH = "data/netflix_titles.csv"

# Check whether CSV exists
if not os.path.exists(CSV_PATH):
    raise FileNotFoundError(f"Dataset not found: {CSV_PATH}")

# Connect to DuckDB
con = duckdb.connect(DB_PATH)

# Create raw table directly from CSV
con.execute("""
    CREATE OR REPLACE TABLE raw_netflix_titles AS
    SELECT *
    FROM read_csv_auto('data/netflix_titles.csv');
""")

# Verify row count
row_count = con.execute("""
    SELECT COUNT(*) FROM raw_netflix_titles
""").fetchone()[0]

# Display table schema
schema = con.execute("""
    DESCRIBE raw_netflix_titles
""").fetchdf()

# Display sample records
sample = con.execute("""
    SELECT * FROM raw_netflix_titles LIMIT 5
""").fetchdf()

print("Database created successfully!")
print(f"Database: {DB_PATH}")
print(f"Table: raw_netflix_titles")
print(f"Total records: {row_count}")

print("\nTable Schema:")
print(schema)

print("\nSample Records:")
print(sample)

con.close()
