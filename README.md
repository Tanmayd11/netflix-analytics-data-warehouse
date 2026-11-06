# Netflix Analytics Data Warehouse
### A Local Data Engineering Project Using dbt Core and DuckDB

An end-to-end analytics engineering project that transforms Netflix movies and TV shows catalogue data into clean, tested, and business-ready analytical models using **dbt Core, DuckDB, Python, and SQL**.

The project implements a modular data transformation workflow inspired by the Medallion Architecture, with staging, intermediate, and mart layers.

## Project Overview

| Detail | Value |
|---|---|
| Project type | Data Engineering / Analytics Engineering |
| Dataset | Netflix Movies and TV Shows |
| Source records | 8,807 |
| Source columns | 12 |
| Transformation tool | dbt Core |
| Database | DuckDB |
| Query language | SQL |
| Supporting language | Python |
| Data modelling | Staging, Intermediate, Marts |
| Data quality | 15 dbt tests |

## Architecture

```text
Netflix CSV Dataset
        |
        v
Python Ingestion (load_data.py)
        |
        v
DuckDB - raw_netflix_titles
        |
        v
STAGING LAYER
stg_netflix_titles
        |
        v
INTERMEDIATE LAYER
int_netflix_content
        |
        +--------------------------+
        |            |             |
        v            v             v
   FACT MODEL   DIMENSION      INCREMENTAL
                MODELS          MODEL
        |            |             |
        v            v             v
fct_content_   dim_content_   int_incremental_
summary        type           netflix
               dim_release_
               year
        |
        v
Business-ready analytics
```

## Technology Stack

- **Python:** Data ingestion and database loading.
- **DuckDB:** Local analytical database.
- **dbt Core:** SQL transformations, model dependencies, testing, and documentation.
- **SQL:** Data cleaning, transformation, and aggregation.
- **Git:** Version control.

## Data Pipeline

### 1. Data Ingestion

The original Netflix CSV dataset is loaded into DuckDB using Python.

- Source table: `raw_netflix_titles`
- Records loaded: 8,807
- Original CSV preserved separately.

### 2. Staging Layer

Model: `stg_netflix_titles`

- Standardizes the source structure.
- Parses `date_added` into a date field.
- Renames the `cast` column to `cast_members`.
- Preserves the original business attributes.

### 3. Intermediate Layer

Model: `int_netflix_content`

- Standardizes missing director and country values as `Unknown`.
- Uses a reusable dbt macro for string cleaning.
- Derives a standardized `content_type` classification.
- Maintains the record-level dataset for downstream models.

### 4. Mart Layer

| Model | Purpose |
|---|---|
| `fct_content_summary` | Overall catalogue KPIs and data quality metrics |
| `dim_content_type` | Aggregations by Movie and TV Show |
| `dim_release_year` | Release-year analysis |
| `int_incremental_netflix` | Demonstrates incremental loading using `show_id` as the unique key |

### 5. Incremental Processing

The incremental model uses:

- `materialized='incremental'`
- `unique_key='show_id'`
- `is_incremental()` to filter records already present in the target table.

This demonstrates how new records can be processed without rebuilding the complete target table on every run.

## Data Quality and Testing

The project includes **15 dbt data tests** covering:

- Not-null constraints.
- Unique identifiers.
- Accepted content-type values.
- Valid release years.
- Record-count reconciliation between staging and intermediate layers.
- Reconciliation of total titles against movies and TV shows.

The final `dbt build` completed successfully:

| Metric | Result |
|---|---:|
| Models | 6 |
| Data tests | 15 |
| Total operations | 21 |
| Passed | 21 |
| Failed | 0 |
| Warnings | 0 |

## Business Insights

Analysis of the 8,807 catalogue records:

| KPI | Result |
|---|---:|
| Total titles | 8,807 |
| Movies | 6,131 |
| TV Shows | 2,676 |
| Distinct release years | 74 |
| Missing director records | 2,634 |

Additional observations:

- Movies represent approximately 69.6% of the catalogue.
- TV Shows represent approximately 30.4%.
- 2018 has the highest number of titles in the dataset, with 1,147.
- The United States is the most frequent country value, with 2,818 titles.

*Note: Country analysis groups the original country field as stored, including multi-country combinations.*

## Project Structure

```text
Netflix Analytics Data Warehouse/
│
├── data/
│   └── netflix_titles.csv
│
├── load_data.py
├── netflix.duckdb
├── .gitignore
├── README.md
│
└── netflix_analytics/
    ├── dbt_project.yml
    ├── models/
    │   ├── staging/
    │   │   ├── sources.yml
    │   │   └── stg_netflix_titles.sql
    │   │
    │   ├── intermediate/
    │   │   └── int_netflix_content.sql
    │   │
    │   ├── marts/
    │   │   ├── fct_content_summary.sql
    │   │   ├── dim_content_type.sql
    │   │   ├── dim_release_year.sql
    │   │   └── int_incremental_netflix.sql
    │   │
    │   └── schema.yml
    │
    ├── macros/
    │   └── clean_string.sql
    │
    └── tests/
        ├── assert_valid_release_year.sql
        ├── assert_record_count.sql
        └── assert_content_type_reconciliation.sql
```

## Setup and Execution

### Prerequisites

- Python
- Git
- dbt Core
- dbt-duckdb adapter

### 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd <YOUR_PROJECT_FOLDER>
```

### 2. Create and activate a virtual environment

Windows PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```bash
pip install dbt-core dbt-duckdb duckdb pandas
```

### 4. Download the dataset

Download the Netflix Movies and TV Shows dataset from Kaggle and place the CSV at:

```text
data/netflix_titles.csv
```

The raw dataset is excluded from this repository. Check the dataset's licence and attribution requirements before redistributing it.

### 5. Load data into DuckDB

Run from the project root:

```bash
python load_data.py
```

### 6. Configure the dbt profile

Configure `~/.dbt/profiles.yml` with the DuckDB adapter and point its database path to your project's `netflix.duckdb` file.

Example:

```yaml
netflix_analytics:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "YOUR_ABSOLUTE_PROJECT_PATH/netflix.duckdb"
      threads: 4
```

### 7. Run dbt

Move into the dbt project directory:

```bash
cd netflix_analytics
```

Validate the connection:

```bash
dbt debug
```

Build models and run tests:

```bash
dbt build
```

Generate project documentation:

```bash
dbt docs generate
dbt docs serve
```

## Key Learning Outcomes

- Building an end-to-end local data pipeline.
- Implementing modular SQL transformations with dbt.
- Working with staging, intermediate, and mart layers.
- Creating reusable dbt macros.
- Implementing incremental materialization.
- Writing schema and custom SQL data tests.
- Managing model dependencies and lineage.
- Generating dbt project documentation.
- Performing business-oriented SQL analysis.

---

**Project:** Netflix Analytics Data Warehouse  
**Tools:** Python | SQL | dbt Core | DuckDB | Git
