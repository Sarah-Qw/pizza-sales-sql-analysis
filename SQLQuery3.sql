USE DataBase_Pizza_Sales;

SELECT * FROM Pizza_Table;

-- KPIs

-- Total Revenue
SELECT 
    ROUND(SUM(total_price),2) AS 'Total Revenue'
FROM Pizza_Table;


-- Total Orders
SELECT
    COUNT( DISTINCT (order_id)) AS 'Total Orders'
FROM Pizza_Table;


-- Total Pizzas Sold ( Quantity Sold )
SELECT 
    SUM(quantity) AS 'Total Pizzas Sold'
FROM Pizza_Table;



-- Questions to Answer


-- 1. What is the total revenue from all sales?
SELECT 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table;


-- 2. What are the best-selling pizza types by total orders?
SELECT TOP 5
    pizza_name,
    COUNT(DISTINCT order_id) AS 'Total_Orders'
FROM Pizza_Table
GROUP BY 
    pizza_name
ORDER BY 
    COUNT(DISTINCT order_id) DESC;


-- 3. What are the worst-selling pizza types by total orders?
SELECT  TOP 5
    pizza_name, 
    COUNT(DISTINCT order_id) AS 'Total Orders'
FROM Pizza_Table
GROUP BY pizza_name
ORDER BY COUNT(DISTINCT order_id) ASC;


-- 4. Which pizza category generated the highest revenue?
SELECT TOP 1 
    pizza_category, 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table
GROUP BY pizza_category
ORDER BY SUM(total_price) DESC;



-- 5. What is the most ordered pizza size (by total quantity)?
SELECT 
    pizza_size, 
    SUM(quantity) AS 'Total Quantity'
FROM Pizza_Table
GROUP BY pizza_size
ORDER BY SUM(quantity) DESC;



-- 6. Which pizza size generated the highest revenue?
SELECT TOP 1 
    pizza_size, 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table
GROUP BY pizza_size
ORDER BY SUM(total_price) DESC;


-- 7. Average Order Value
SELECT
    ROUND(SUM(total_price)/COUNT(DISTINCT order_id),2) AS 'avg order value'
FROM Pizza_Table;


-- 8. Which days of the week has the highest sales revenue?
SELECT 
    DATENAME(WEEKDAY, order_date) AS 'Week Day', 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY SUM(total_price) DESC;


-- 9. Which days of the week has the lowest sales revenue?
SELECT 
    DATENAME(WEEKDAY, order_date) AS 'Week Day', 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY SUM(total_price) ASC;


/*
-- 10. What are the peak hours of the day for pizza orders?
(Hourly trend for total Orders)
*/
SELECT 
    DATEPART(HOUR,order_time) AS 'Hour of Day',
    COUNT(DISTINCT(Order_id)) AS 'Total Orders'
FROM Pizza_Table
GROUP BY DATEPART(HOUR,order_time)
ORDER BY DATEPART(HOUR,order_time) ASC;



-- 11. Which pizza types are priced above the average price?
SELECT DISTINCT 
    pizza_name, 
    pizza_category,
    unit_price
FROM Pizza_Table
WHERE unit_price > (SELECT AVG(unit_price) FROM Pizza_Table)
ORDER BY unit_price DESC;


-- 12. Which orders exceeded the average order value?
SELECT 
    order_id, 
    SUM(total_price) AS 'Order Total Value'
FROM Pizza_Table
GROUP BY order_id
HAVING SUM(total_price) > (
    SELECT SUM(total_price) / COUNT(DISTINCT order_id) 
    FROM Pizza_Table
)
ORDER BY SUM(total_price) DESC;


-- 13. Which pizza categories exceeded 5000 in total sales?
SELECT 
    pizza_category, 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table
GROUP BY pizza_category
HAVING SUM(total_price) > 5000
ORDER BY SUM(total_price) DESC;



/*
14. What are the total monthly sales? (Monthly Sales Trend)
Note: Results are ordered chronologically by the Month of the year
(jan to Dec) using DATEPART*/
SELECT 
    DATENAME(MONTH, order_date) AS 'month',
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM 
    Pizza_Table
GROUP BY 
    DATENAME(MONTH, order_date),
    DATEPART(MONTH, order_date)  
ORDER BY 
    DATEPART(MONTH, order_date);



-- 15. What is the revenue contribution percentage of each category?
SELECT 
    pizza_category, 
    ROUND(SUM(total_price) * 100.0 /
    (SELECT SUM(total_price) FROM Pizza_Table), 2) AS 'Revenue Percentage (%)'
FROM Pizza_Table
GROUP BY pizza_category
ORDER BY 'Revenue Percentage (%)' DESC;



-- 16. What are the most ordered pizza types in the 'Chicken' category?
SELECT 
    pizza_category, 
    pizza_name, 
    SUM(quantity) AS 'Total Quantity Ordered'
FROM Pizza_Table
WHERE pizza_category = 'Chicken'
GROUP BY 
    pizza_category, 
    pizza_name
ORDER BY SUM(quantity) DESC;



-- 17. Average Pizzas per Order
CREATE VIEW AVG_Pizzas_per_order AS
SELECT 
    CAST(
        (CAST(SUM(quantity) AS decimal(10,2)) / 
        CAST(COUNT(DISTINCT order_id) AS decimal(10,2))) 
    AS decimal(10,2)) AS 'avg pizza per order'
FROM Pizza_Table;


/* 
18) How many orders are there for each day of the week?
(Daily Trend For Toatl Orders)
*/
SELECT 
    DATENAME(WEEKDAY,order_date) AS 'week day',
    COUNT(DISTINCT(order_id)) AS 'total orders'
FROM pizza_table
GROUP BY DATENAME(WEEKDAY,order_date);



/* 
18.b) Daily Trend For Total Orders 
Note: Results are ordered chronologically by the day of the week 
(Sunday to Saturday) using DATEPART.
*/
SELECT 
    DATENAME(WEEKDAY,order_date) AS 'week day',
    COUNT(DISTINCT(order_id)) AS 'total orders'
FROM Pizza_Table
GROUP BY 
    DATENAME(WEEKDAY, order_date), 
    DATEPART(WEEKDAY, order_date) -- أضفنا رقم اليوم في التجميع
ORDER BY 
    DATEPART(WEEKDAY, order_date) ASC; -- رتبنا النتيجة بناءً على رقم اليوم



-- 19. What are the top 5 pizza types by revenue?
SELECT TOP 5 
    pizza_name, 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table
GROUP BY pizza_name
ORDER BY SUM(total_price) DESC;



-- 20. What are the bottom 5 pizza types by revenue?
SELECT TOP 5 
    pizza_name, 
    ROUND(SUM(total_price), 2) AS 'Total Revenue'
FROM Pizza_Table
GROUP BY pizza_name
ORDER BY SUM(total_price) ASC;




----------------------------------------------------------------------------------
-- FINAL STEP: CREATING OPTIMIZED VIEWS FOR DASHBOARD REPORTING
-- These views aggregate the answers to the previous 20 business questions 
-- into 4 logical tables to ensure high performance and data consistency.
----------------------------------------------------------------------------------


-- 1. View for General KPIs and Time Trends
-- This view supports overall revenue, total orders, and sales trends by Month, Day, and Hour.
ALTER VIEW View_General_Dashboard_Data AS
SELECT 
    order_id,
    order_date,
    order_time,
    pizza_id,
    quantity,
    unit_price,
    total_price,
    FORMAT(order_date, 'MMM') AS Month_Name,
    DATEPART(MONTH, order_date) AS Month_No,
    FORMAT(order_date, 'ddd') AS Day_Name,
    DATEPART(WEEKDAY, order_date) AS Day_No,
    DATEPART(HOUR, order_time) AS Order_Hour,
    -- تصنيف الساعات إلى مجموعات (Groups)
    CASE 
        WHEN DATEPART(HOUR, order_time) BETWEEN 9 AND 11 THEN '09 AM - 12 PM'
        WHEN DATEPART(HOUR, order_time) BETWEEN 12 AND 14 THEN '12 PM - 03 PM'
        WHEN DATEPART(HOUR, order_time) BETWEEN 15 AND 17 THEN '03 PM - 06 PM'
        WHEN DATEPART(HOUR, order_time) BETWEEN 18 AND 20 THEN '06 PM - 09 PM'
        WHEN DATEPART(HOUR, order_time) BETWEEN 21 AND 23 THEN '09 PM - 12 AM'
        ELSE 'Other'
    END AS Time_Range,
    -- عمود ترتيب عشان الترتيب في الباور بي آي ما يخرب
    CASE 
        WHEN DATEPART(HOUR, order_time) BETWEEN 9 AND 11 THEN 1
        WHEN DATEPART(HOUR, order_time) BETWEEN 12 AND 14 THEN 2
        WHEN DATEPART(HOUR, order_time) BETWEEN 15 AND 17 THEN 3
        WHEN DATEPART(HOUR, order_time) BETWEEN 18 AND 20 THEN 4
        WHEN DATEPART(HOUR, order_time) BETWEEN 21 AND 23 THEN 5
        ELSE 6
    END AS Time_Range_Order
FROM Pizza_Table;


-- 2. View for Category and Size Insights
ALTER VIEW View_Category_Analysis AS
SELECT 
    pizza_category,
    pizza_name,
    pizza_size,
    SUM(total_price) AS Total_Revenue,
    SUM(quantity) AS Total_Quantity,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM Pizza_Table
GROUP BY pizza_category, pizza_name,pizza_size;



-- 3. View for Product Performance and Ranking
-- This view ranks pizza types based on revenue and quantity to identify top and bottom sellers.
CREATE VIEW View_Pizza_Inventory_Performance AS
SELECT 
    pizza_name,
    pizza_category,
    SUM(total_price) AS Pizza_Revenue,
    SUM(quantity) AS Pizza_Qty,
    COUNT(DISTINCT order_id) AS Pizza_Orders
FROM Pizza_Table
GROUP BY pizza_name, pizza_category;



-- 4. View for Detailed Pricing Analysis
-- This view provides granular data for comparing individual unit prices and order totals.
CREATE VIEW View_Pricing_Analysis AS
SELECT 
    order_id,
    pizza_name,
    unit_price,
    total_price
FROM Pizza_Table;


