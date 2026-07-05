-- SQL Retail Sales Analysis - Project 1
CREATE DATABASE sql_project_p1;


-- Creating the table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
			transactions_id INT PRIMARY KEY,	
			sale_date DATE,
			sale_time TIME,
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR (15),
			quantiy	INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
		);

	
	SELECT * FROM retail_sales
	limit 10;

SELECT 
	COUNT (*)
FROM retail_sales;

-- Data Cleaning

Select * FROM retail_sales
WHERE transactions_id IS NULL



SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR 
	total_sale IS NULL
	;


DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	;

SELECT
	count(*)
FROM retail_sales
;

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	;



--- Data Exploration

-- How many sales did we complete?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique (not duplicate) customers did we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales

-- How many and what are the categorys that we have that are unique?
SELECT COUNT(DISTINCT category) FROM retail_sales
SELECT DISTINCT category FROM retail_sales



-- Data Analysis, Business Key Problems, and Business Answers

-- What sales were made on November 5th, 2022?
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'
;

-- What are the sales for Clothing that were sold more than or 4 times in the month of November 2022?
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND quantiy >= 4
	AND sale_date >= DATE '2022-11-01'
	AND sale_date < DATE '2022-12-1'
;

-- What is the total sales for each category?
SELECT 
	category,
	SUM(total_sale) as net_sales,
	COUNT (*) as total_orders
FROM retail_sales
GROUP BY 1
	;

-- What is the average age of people who purchase from the beauty category?
SELECT 
	ROUND(AVG(age),2)
FROM retail_sales
WHERE category = 'Beauty'
;

-- What is the average age of all the purchases from the categorys?
SELECT category,
	ROUND(AVG(AGE),2) as average_age
FROM retail_sales
GROUP BY 1
;

-- What are the transactions ID's where the total_sales is greater than 1000?
SELECT transactions_id
FROM retail_sales
	WHERE total_sale > 1000
;

-- What are the transactions where the total_sales is greater than 500?
SELECT * FROM retail_sales
WHERE total_sale > 500
;

-- What is the total number of transactions (transaction_id) made by each gender in each category?
SELECT 
	category, 
	gender,
COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1

-- What is the average sale for each month and what is the best selling month in each year?

SELECT * FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_total_sale,
		RANK() OVER(PARTITION BY EXTRACT (YEAR FROM Sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
) as table1
WHERE rank =1
;

-- What is the top 5 customers based on the highest total sales?
SELECT 
	customer_id,
	SUM (total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;

-- What is the number of unique customers who purchased items from each category?


SELECT 
	category,
	COUNT(DISTINCT customer_id) as count_unique_customers
FROM retail_sales
GROUP BY category
;

-- Write a query to create each shift and number of orders (Example: Morning < 12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12  THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)

SELECT
	shift,
	COUNT(*) as total_orders 
FROM hourly_sale
GROUP BY shift
;

-- End of my project!