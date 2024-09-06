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
        -- Converting order_date from VARCHAR to DATE
        TRY_CAST(order_date AS DATE) AS order_date,  
        -- Extracting year, month, and day from the order_date
        YEAR(TRY_CAST(order_date AS DATE)) AS order_year,
        MONTH(TRY_CAST(order_date AS DATE)) AS order_month,
        DAY(TRY_CAST(order_date AS DATE)) AS order_day,
        -- Calculating the total sales amount (quantity * price)
        (quantity * price) AS total_sales_amount
    FROM {{ ref('sales') }}
)

SELECT * FROM sales_transformed
