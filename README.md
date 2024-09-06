# Data Engineering Assignment

## Overview

This project shows how to ingest raw sales and customer data, perform data transformations, and run analytical queries using DBT and Snowflake.

## Prerequisites

Make sure the following tools are installed:
- **Python 3.6+** (for DBT)
- **pip** 
- **DBT (Data Build Tool)**
- **Snowflake account** (to store and query the data)

## Setup Instructions

### 1. Install DBT and Required Libraries

To install DBT with the Snowflake adapter, run the following command:

```bash
pip install dbt-snowflake
```

Verify the installation by running:

```bash
dbt --version
```
You should see the installed versions of DBT and the Snowflake adapter.

### 2. Configure Snowflake Connection

You need to configure your connection to Snowflake in the profiles.yml file. The file is located in the ~/.dbt/ directory. Use the following structure:

```yaml
dbt_project:
  outputs:
    dev:
      type: snowflake
      account: <your_snowflake_account>
      user: <your_snowflake_username>
      password: <your_snowflake_password>
      role: <your_snowflake_role>
      database: <your_database_name>
      schema: public
      warehouse: <your_warehouse_name>
  target: dev
```

Replace the placeholders (<your_snowflake_account>, etc.) with your actual Snowflake credentials.

### 3. Load Raw Data into Snowflake
The project includes raw sales and customer data in the seeds/ folder. To load these CSV files into Snowflake, run the following command:

```bash
dbt seed
```
This will create two tables in Snowflake: `raw_sales_data` and `raw_customer_data`.

### 4. Run Data Transformation
Run the DBT models to transform the raw sales data:

```bash
dbt run
```
This will create a new table called `transformed_sales_data`, which includes the following transformations:

- Converts `order_date`'s data type from `varchar` to `date` and extracts `year`, `month`, and `day` from it.
- Calculates `total_sales_amount` for each order.

### 5. Run SQL Queries
The project contains four key SQL queries located in the `queries/` folder. You can run these manually in Snowflake:

- Top 5 Products by Total Sales in 2023
- Top 5 Customers by Total Sales in 2023
- Average Order Value for Each Month in 2023
- Customer with the Highest Order Volume in October 2023
