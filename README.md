# Airbnb End-to-End Data Engineering Pipeline

**AWS · Snowflake · dbt · SQL · Data Modeling**

A data engineering project by **Duc Anh Nguyen** that transforms Airbnb listings, hosts, and bookings data into structured datasets for analytics using **Snowflake and dbt**.

The repository contains a dbt project organized into **Bronze, Silver, and Gold** layers, with incremental transformations, reusable Jinja macros, dimensional modeling, and snapshots for historical tracking.

## Project overview

The goal is to build a maintainable analytics pipeline that separates raw source data from cleaned, transformed, and analytics-ready datasets.

The implementation in this repository focuses on the **Snowflake/dbt transformation layer**. AWS is part of the broader project architecture, but the repository does **not currently include deployable AWS ingestion infrastructure or automation scripts**.

### Data flow

```text
Airbnb source data (listings, hosts, bookings)
             |
             v
Snowflake AIRBNB.STAGING
             |
             v
dbt Bronze models
  - bronze_listings
  - bronze_hosts
  - bronze_bookings
             |
             v
dbt Silver models
  - silver_listings
  - silver_hosts
  - silver_bookings
             |
             v
dbt Gold models
  - obt (joined analytics table)
  - fact (fact-style analytical model)
  - ephemeral dimension queries
  - dimension snapshots
             |
             v
Analytics and reporting
```

## Technology stack

| Area | Tools |
| --- | --- |
| Data warehouse | Snowflake |
| Data transformation | dbt, SQL, Jinja |
| Pipeline architecture | Bronze / Silver / Gold (Medallion-style) |
| Data modeling | Fact-style tables, denormalized analytics tables, dimension views |
| Incremental processing | dbt incremental materializations |
| Historical tracking | dbt snapshots |
| Source data | Airbnb listings, hosts, and bookings CSV files |
| Broader cloud architecture | AWS |

## How the pipeline works

### 1. Source and Bronze layers

The dbt project defines source tables for `listings`, `hosts`, and `bookings` in **`AIRBNB.STAGING`**.

The Bronze models read from these staging tables. Each model is explicitly configured for **incremental materialization**, filtering incoming rows using a `created_at` watermark.

### 2. Silver layer

The Silver models prepare more useful analytical attributes:

- **Bookings:** selects booking fields and calculates `total_amount` using a reusable macro.
- **Hosts:** standardizes host names and categorizes host response rates.
- **Listings:** selects property and location fields and assigns price categories.

Silver models are configured as **incremental models with unique keys**.

### 3. Gold layer

The Gold models combine the transformed data into analytics-ready structures:

- **`obt.sql`** joins bookings, listings, and hosts into a denormalized **one-big-table (OBT)** representation.
- **`fact.sql`** builds a fact-style query that joins the Gold OBT with dimension snapshots.
- **Ephemeral models** expose selected booking, host, and listing fields without creating standalone physical tables.

### 4. Historical data and reusable SQL

- **dbt snapshots:** `dim_bookings`, `dim_hosts`, and `dim_listings` use timestamp-based configurations for historical tracking.
- **Jinja macros:** examples include `multiply`, `tag`, `trimmer`, and a custom schema-naming macro.
- **SQL tests:** a custom test in `tests/source_tests.sql` checks a booking-amount condition and is configured with warning severity.

## Repository structure

```text
Airbnb-end-to-end-data-pipeline/
├── README.md
├── dbt-snowflake/
│   ├── source/
│   │   ├── bookings.csv
│   │   ├── hosts.csv
│   │   └── listings.csv
│   └── aws_dbt_snowflake_project/
│       ├── dbt_project.yml
│       ├── models/
│       │   ├── sources/
│       │   ├── bronze/
│       │   ├── silver/
│       │   └── gold/
│       │       └── ephemeral/
│       ├── macros/
│       ├── snapshots/
│       ├── tests/
│       ├── analyses/
│       └── seeds/
└── Airbnb End-To-End Data Engineering Project/
    └── aws_dbt_snowflake/
```

The main dbt project is located in [`dbt-snowflake/aws_dbt_snowflake_project/`](dbt-snowflake/aws_dbt_snowflake_project).

## Getting started

**Prerequisites**

- Access to a Snowflake account and warehouse
- Python and `dbt-snowflake`
- Source tables available in `AIRBNB.STAGING` with the expected columns
- A **local, securely configured** dbt profile for your Snowflake connection

The repository includes example CSV input files under [`dbt-snowflake/source/`](dbt-snowflake/source/), but loading them into Snowflake staging is a separate setup step.

**Run the dbt project**

```bash
cd dbt-snowflake/aws_dbt_snowflake_project

# Check local dbt/Snowflake connection
dbt debug

# Build the Bronze, Silver, and Gold models
dbt run

# Execute configured tests
dbt test

# Run timestamp-based historical snapshots
dbt snapshot
```

The project assumes the configured Snowflake databases, schemas, roles, and tables exist. You may need to adapt connection settings and Snowflake object names to your environment. **Do not commit passwords, tokens, or other credentials**; use environment variables or an ignored local profile.

## Skills demonstrated

- Designing a layered analytical data architecture
- Building **incremental ELT transformations**
- Modeling facts, dimensions, and denormalized analytical tables
- Using **dbt snapshots** for historical tracking
- Writing reusable SQL transformations with **Jinja macros**
- Organizing transformations into a modular dbt project

## Notes and future improvements

This is a portfolio project illustrating data transformation and modeling patterns. The repository primarily contains dbt source code and example data; it is **not a turnkey, fully deployed AWS-to-Snowflake pipeline**.

Potential next steps include adding documented ingestion scripts, automated data-quality checks, CI/CD, and a reproducible environment setup.

---

**Author:** Duc Anh Nguyen  
**GitHub:** [ducanhng85](https://github.com/ducanhng85)
