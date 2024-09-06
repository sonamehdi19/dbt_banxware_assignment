# DECISIONS.md

## 1. Environment Setup

### 1.1 Snowflake Setup
A new database is created in Snowflake named `home_assignment` to store the data for this project. The following SQL command was used to create the database:

```sql
CREATE DATABASE home_assignment;
```
A warehouse named `compute_wh` was also created to handle query execution.

### 1.2 DBT Installation and Configuration
DBT is installed using:

```bash 
pip install dbt-snowflake
```
Configured the `profiles.yml` to connect DBT with Snowflake and ran `dbt debug` to verify the connection.

### 1.3 DBT Project Configuration
Aliases are set for the seed tables to ensure that the sales.csv and customers.csv files are loaded as raw_sales_data and raw_customer_data respectively.

```yaml
seeds:
  dbt_banxware_assignment:
    sales:
      alias: raw_sales_data
    customers:
      alias: raw_customer_data
```

## 2. Data Ingestion

The `dbt seed` command was used to load the `sales.csv` and `customers.csv` files into Snowflake. This created the `raw_sales_data` and `raw_customer_data` tables.

```bash 
dbt seed
```
## 3. Data Transformation

A DBT model `transformed_sales_data` was created with the following SQL logic to structure the sales data:

```sql
{{ config(
    materialized='table'
) }}

WITH sales_transformed AS (
    SELECT
        order_id,
        customer_id,
        product_id,
        quantity,
        price,
        order_status,
        TRY_CAST(order_date AS DATE) AS order_date,  
        YEAR(TRY_CAST(order_date AS DATE)) AS order_year,
        MONTH(TRY_CAST(order_date AS DATE)) AS order_month,
        DAY(TRY_CAST(order_date AS DATE)) AS order_day,
        (quantity * price) AS total_sales_amount
    FROM {{ ref('sales') }}
)

SELECT * FROM sales_transformed
```

This configuration materializes the DBT model as a physical table in Snowflake. This means that the result of the transformation is stored as a persistent table, rather than being created as a view, to improve query performance for repeated analyses.

The SQL performed the following transformations:

- Converted order_date from `VARCHAR` to `DATE`.
- Extracted `year`, `month`, and `day` from `order_date`.
- Calculated `total_sales_amount` by multiplying `quantity` by `price`.

The following command was used to run the transformation:

```bash 
dbt run
```

## 4. Analytical Queries
The following SQL queries were created and saved in the queries/ folder:

- Top 5 Products by Total Sales in 2023 (q1_top_5_products.sql)
- Top 5 Customers by Total Sales in 2023 (q2_top_5_customers.sql)
- Average Order Value for Each Month in 2023 (q3_avg_order_value_by_month.sql)
- Customer with the Highest Order Volume in October 2023 (q4_customer_highest_volume.sql)
