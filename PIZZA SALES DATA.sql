CREATE DATABASE PIZZA_SALES_DATA;
USE PIZZA_SALES_DATA;

CREATE TABLE PIZZA_SALES (
PIZZA_ID INT,
ORDER_ID INT,
PIZZA_NAME_ID VARCHAR(100),
QUANTITY INT,
ORDER_DATE DATE,
ORDER_TIME TIME,
UNIT_PRICE DECIMAL(50,2),
TOTAL_PRICE DECIMAL(50,2),
PIZZA_SIZE VARCHAR(20) ,
PIZZA_CATEGORY VARCHAR(50) ,
PIZZA_INGREDIENTS VARCHAR(300),
PIZZA_NAME VARCHAR(200));

LOAD DATA INFILE
'E:/pizza_sales (1).csv'
into table PIZZA_SALES
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE PIZZA_SALES;
SELECT * FROM PIZZA_SALES;

#1.Total Revenue:
select sum(total_price) as TOTAL_REVENUE from pizza_sales;

#2.Average Order Value
select sum(TOTAL_PRICE) as AVERAGE_ORDER_VALUE from pizza_sales;
SELECT (SUM(total_price) /  COUNT(DISTINCT order_id)) AS Avg_order_Value FROM pizza_sales; ##MA'AM

#3.Total Pizzas Sold 
SELECT SUM(QUANTITY) FROM PIZZA_SALES;

#4.Total Orders 
SELECT COUNT(DISTINCT ORDER_ID) FROM PIZZA_SALES;
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;


#5.Average Pizza Per Order 
SELECT ORDER_ID, AVG(QUANTITY) AS AVERAGE_PIZZA_PER_ORDER FROM PIZZA_SALES GROUP BY ORDER_ID;
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM pizza_sales;

#6.Daily Trend for Total Orders(unique).
ALTER TABLE pizza_sales
ADD COLUMN day_new varchar(20) NOT NULL;
UPDATE pizza_sales SET day_new = day(ORDER_DATE);
SELECT order_date, PIZZA_CATEGORY, PIZZA_NAME, PIZZA_SIZE, COUNT(ORDER_ID) AS DAILY_TREND 
FROM PIZZA_SALES 
GROUP BY order_date, PIZZA_CATEGORY, PIZZA_SIZE, PIZZA_NAME ORDER BY DAILY_TREND;

SELECT dayname ( '2015-1-1' ) AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY dayname("2015-1-1"); ##MA'AM

#7.Monthly Trend for Orders

ALTER TABLE pizza_sales
ADD COLUMN MONTH_NEW varchar(20) NOT NULL;
UPDATE pizza_sales SET MONTH_NEW = MONTH(ORDER_DATE);
SELECT month_new, PIZZA_CATEGORY, PIZZA_NAME, PIZZA_SIZE, 
COUNT(ORDER_ID) AS DAILY_TREND 
FROM PIZZA_SALES 
GROUP BY month_new, PIZZA_CATEGORY, PIZZA_SIZE, 
PIZZA_NAME ORDER BY DAILY_TREND;


select monthname(MONTH, order_date) as Month_Name, COUNT(DISTINCT order_id) as Total_Orders
from pizza_sales
GROUP BY monthname(MONTH, order_date); ##MA'AM

#8. Percentage of Sales by Pizza Category ##right

SELECT PIZZA_CATEGORY, COUNT(TOTAL_PRICE) * 100.0/(SELECT COUNT(TOTAL_PRICE) 
FROM PIZZA_SALES) AS 'SALES PERCENTAGE'
FROM PIZZA_SALES GROUP BY PIZZA_CATEGORY;

SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category; ##MA'AM

#9. Percentage of Sales by Pizza Size 
SELECT PIZZA_SIZE, COUNT(TOTAL_PRICE)*100/(SELECT COUNT(TOTAL_PRICE) FROM PIZZA_SALES)
AS 'PERCENTAGE BY PIZZA SIZE'
FROM PIZZA_SALES GROUP BY PIZZA_SIZE;

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size; ##MA'AM

#10. Total Pizzas Sold by Pizza Category 
SELECT PIZZA_CATEGORY,COUNT(PIZZA_CATEGORY) AS 'PIZZA_SOLD_BY_CATEGORY' 
FROM PIZZA_SALES GROUP BY PIZZA_CATEGORY;

SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC; ##MA'AM

#11. Top 5 Pizzas by Revenue 
SELECT PIZZA_NAME, SUM(TOTAL_PRICE) AS REVENUE FROM PIZZA_SALES GROUP BY PIZZA_NAME 
ORDER BY REVENUE desc LIMIT 5;

SELECT pizza_name, SUM(total_price) AS Total_Revenue
from pizza_sales
group by pizza_name
order by total_revenue desc
limit 5;

#12. Bottom 5 Pizzas by Revenue 
SELECT PIZZA_NAME, SUM(TOTAL_PRICE) AS REVENUE FROM PIZZA_SALES GROUP BY PIZZA_NAME 
ORDER BY REVENUE ASC LIMIT 5; 

#13. Top 5 Pizzas by Quantity 
SELECT PIZZA_NAME, SUM(QUANTITY) AS TOTALQUANTITY FROM PIZZA_SALES GROUP BY PIZZA_NAME
ORDER BY TOTALQUANTITY desc LIMIT 5;

SELECT pizza_name, SUM(total_price) AS Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold desc
limit 5; 

#14. Bottom 5 Pizzas by Quantity 
SELECT PIZZA_NAME, SUM(QUANTITY) AS TOTALQUANTITY FROM PIZZA_SALES GROUP BY PIZZA_NAME
ORDER BY TOTALQUANTITY ASC LIMIT 5;

SELECT pizza_name, SUM(total_price) AS Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold asc
limit 5; ##MA'AM

#15. Top 5 Pizza by Total Orders 
SELECT PIZZA_NAME, COUNT(ORDER_ID) AS TOTAL_ORDERID FROM PIZZA_SALES GROUP BY PIZZA_NAME
ORDER BY TOTAL_ORDERID DESC LIMIT 5;

SELECT  pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
limit 5; 

#16. Bottom 5 Pizzas by Total Orders 
SELECT PIZZA_NAME, COUNT(ORDER_ID) AS TOTAL_ORDERID FROM PIZZA_SALES GROUP BY PIZZA_NAME
ORDER BY TOTAL_ORDERID ASC LIMIT 5;

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
limit 5; ##MA'AM
