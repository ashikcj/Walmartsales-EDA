USE sql_practice;

CREATE TABLE walmart_sales
(InvoiceID VARCHAR(30) NOT NULL PRIMARY KEY, 
branch VARCHAR(5), City VARCHAR(30) NOT NULL, 
customer_type VARCHAR(30) NOT NULL, 
gender VARCHAR(10) NOT NULL, product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL, 
quantity INT NOT NULL, VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL, 
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT(2, 1)
);


-- Data wrangling

-- feature engineering This helps to add column based on the existing column
-- ---------------------------------------------------------------------------------------------
----------------------------------------- Feature Engineering-----------------------------------

-- time_of_day

SELECT 
  time,
  (CASE
  WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
  WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
  ELSE "Evening"  
  END) AS time_of_date
FROM walmart_sales;

ALTER TABLE walmart_sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE walmart_sales
SET time_of_day = (
  CASE
       WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
       WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
       ELSE "Evening"  
  END
  );

-- day_name
-- add a new column day_name that contain extracted date

SELECT date, DAYNAME(date) 
FROM walmart_sales;

ALTER TABLE walmart_sales ADD COLUMN day_name VARCHAR(20);

UPDATE walmart_sales
SET day_name = (DAYNAME(date));

-- month name
-- add a new column month name

SELECT date, MONTHNAME(date)
FROM walmart_sales;

ALTER TABLE walmart_sales ADD COLUMN month_name VARCHAR(20);

UPDATE walmart_sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------------------------------------
-- ---------------------------------Generic questions-----------------------------------------------

-- how many unique cities does the data have
SELECT DISTINCT city
FROM walmart_sales;

-- in which city is each branch located
SELECT 
 DISTINCT branch
 FROM walmart_sales;
 
 SELECT DISTINCT city, branch 
 FROM walmart_sales;
 
 -- ---------------------------------------------------------------------------------------------
 -- -----------------------------------------------Product Questions-----------------------------
 
 -- How many unique product line does the data have?
 SELECT DISTINCT product_line
 FROM walmart_sales;
 
 SELECT COUNT(DISTINCT product_line)
 FROM walmart_sales;
 
 -- what is most common payment method
 
 SELECT payment_method, COUNT(payment_method) AS count_of_method
 FROM walmart_sales
 GROUP BY payment_method
 ORDER BY COUNT(payment_method) DESC
 LIMIT 1;
 
 -- whatis the most selling product
 
 SELECT product_line, SUM(quantity) AS qsum
 FROM walmart_sales
 GROUP BY product_line
 ORDER BY qsum DESC
 LIMIT 1;
 
 -- What is the total revenue by month
 SELECT month_name, SUM(total) AS total_revenue
 FROM walmart_sales
 GROUP BY month_name
 ORDER BY total_revenue DESC;
 
 -- what month had largest cogs?
 SELECT month_name AS month, SUM(cogs) AS scog
 FROM walmart_sales
 GROUP BY month
 ORDER BY scog DESC;
 
 -- what product line had largest revenue
 
 SELECT product_line, SUM(total) AS revenue
 FROM walmart_sales
 GROUP BY product_line
 ORDER BY revenue DESC;
 
 -- What is the city with largest revenue
 
SELECT city, SUM(total) AS revenue
 FROM walmart_sales
 GROUP BY city
 ORDER BY revenue DESC;
 
 -- product line with highest vat
 SELECT product_line, SUM(VAT) AS high_vat
 FROM walmart_sales
 GROUP BY product_line
 ORDER BY high_vat DESC;
 

  -- which branch sold more products than average products sold?
 SELECT branch, SUM(quantity) AS qty
 FROM walmart_sales
 GROUP BY branch
 HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmart_sales);
 
 -- what is the most commom product line by gender
 SELECT product_line, gender, COUNT(gender) AS total_count
 FROM walmart_sales
 GROUP BY gender, product_line
 ORDER BY total_count;
 
 -- what is the average rating of each product line?
 SELECT AVG(rating) AS avg_rating, product_line
 FROM walmart_sales
 GROUP BY product_line
 ORDER BY avg_rating DESC;
 

USE sql_practice;

-- -------------------------------------------------------------------------------------------------
-- ------------------------------------------Sales--------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT time_of_day,
COUNT(*) AS total_sales
FROM walmart_sales
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day,
COUNT(*) AS total_sales
FROM walmart_sales
WHERE day_name ='Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- which type of customer bring most revenue
SELECT customer_type, SUM(total) AS total_revenue
FROM walmart_sales
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

-- which city has the largest tax percent or vat
SELECT city, AVG(VAT) as avat
FROM walmart_sales
GROUP BY city
ORDER BY avat DESC
LIMIT 1;

-- what type of customer pays most vat
SELECT customer_type, AVG(VAT) AS svat
FROM walmart_sales
GROUP BY customer_type
ORDER BY svat DESC;


-- -------------------------------------------------------------------------------------------
-- ---------------------------------------- Customer Information------------------------------

-- how many unique customer type does the data have
SELECT DISTINCT customer_type
FROM walmart_sales;

-- how many unique payment method does the data have
SELECT DISTINCT payment_method
FROM walmart_sales;

-- what is the most common customer type


-- which customer type buys the most
SELECT customer_type, COUNT(*) AS cust_cnt
FROM walmart_sales
GROUP BY customer_type;

-- what is the gender of most of the customers
SELECT gender, COUNT(*) AS gender_count
FROM walmart_sales
GROUP BY gender 
ORDER BY gender_count DESC; 

-- what is the gender distribution per branch
SELECT gender, COUNT(*) AS gender_count
FROM walmart_sales
WHERE branch ='B'
GROUP BY gender 
ORDER BY gender_count DESC; 

-- what time of the day do customer give most rating
SELECT time_of_day, AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- which time of te day do customer give most ratings per branch, a b c
SELECT time_of_day, AVG(rating) AS avg_rating
FROM walmart_sales
WHERE branch='C'
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- which day of the week has more avg rating
SELECT day_name, AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- which day of the week has best avg rating by branch
SELECT branch, day_name, AVG(rating) AS avg_rating
FROM walmart_sales
GROUP BY day_name, branch
ORDER BY branch;


 