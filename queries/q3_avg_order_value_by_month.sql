-- What is the average order value for each month in the year 2023?
SELECT 
    ORDER_MONTH, 
    ROUND(AVG(TOTAL_SALES_AMOUNT), 2) AS AVG_ORDER_VALUE
FROM 
    TRANSFORMED_SALES_DATA
WHERE 
    ORDER_YEAR = 2023
GROUP BY 
    ORDER_MONTH
ORDER BY 
    ORDER_MONTH;