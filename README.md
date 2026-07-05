# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis
**Level**: Beginner
**Database**: `sql_project_p1`
**Table**: `retail_sales`

This project is a beginner SQL project where I created a retail sales database, cleaned the data, explored the dataset, and answered business questions using SQL.

The goal of this project was to practice real data analyst work, including database setup, checking for missing values, deleting incomplete records, exploring the data, and writing SQL queries that answer business questions about sales, customers, product categories, and order times.

## Objectives

1. **Create the database and table**
   Set up a PostgreSQL database called `sql_project_p1` and create a table called `retail_sales`.

2. **Clean the data**
   Check for null values in important columns and remove records with missing data.

3. **Explore the data**
   Count total records, unique customers, and unique product categories.

4. **Answer business questions**
   Use SQL queries to find sales trends, top customers, category performance, customer demographics, and order shifts.

## Database Setup

The project starts by creating the database and the `retail_sales` table.

```sql
CREATE DATABASE sql_project_p1;

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantiy INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

## Table Columns

The `retail_sales` table includes the following columns:

| Column Name       | Description                    |
| ----------------- | ------------------------------ |
| `transactions_id` | Unique ID for each transaction |
| `sale_date`       | Date of the sale               |
| `sale_time`       | Time of the sale               |
| `customer_id`     | Unique ID for each customer    |
| `gender`          | Gender of the customer         |
| `age`             | Age of the customer            |
| `category`        | Product category               |
| `quantiy`         | Number of items sold           |
| `price_per_unit`  | Price for one unit             |
| `cogs`            | Cost of goods sold             |
| `total_sale`      | Total sale amount              |

## Data Preview

To view the first 10 records:

```sql
SELECT *
FROM retail_sales
LIMIT 10;
```

To count the total number of records:

```sql
SELECT COUNT(*)
FROM retail_sales;
```

## Data Cleaning

The first step was to check for null values in the table.

```sql
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;
```

Then I checked all important columns for missing values.

```sql
SELECT *
FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

After finding records with missing values, I deleted them.

```sql
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

Then I checked the table again to make sure the null records were removed.

```sql
SELECT *
FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantiy IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
```

## Data Exploration

### How many sales did we complete?

```sql
SELECT COUNT(*) AS total_sales
FROM retail_sales;
```

### How many unique customers did we have?

```sql
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales;
```

### How many unique categories do we have?

```sql
SELECT COUNT(DISTINCT category) AS unique_categories
FROM retail_sales;
```

### What are the unique categories?

```sql
SELECT DISTINCT category
FROM retail_sales;
```

## Business Questions and SQL Queries

### 1. What sales were made on November 5th, 2022?

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### 2. What Clothing sales had a quantity of 4 or more in November 2022?

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
    AND quantiy >= 4
    AND sale_date >= DATE '2022-11-01'
    AND sale_date < DATE '2022-12-01';
```

### 3. What are the total sales for each category?

```sql
SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

### 4. What is the average age of customers who purchased from the Beauty category?

```sql
SELECT
    ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';
```

### 5. What is the average age of customers for each category?

```sql
SELECT
    category,
    ROUND(AVG(age), 2) AS average_age
FROM retail_sales
GROUP BY category;
```

### 6. Which transaction IDs had total sales greater than 1000?

```sql
SELECT transactions_id
FROM retail_sales
WHERE total_sale > 1000;
```

### 7. Which transactions had total sales greater than 500?

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 500;
```

### 8. What is the total number of transactions made by each gender in each category?

```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY
    category,
    gender
ORDER BY category;
```

### 9. What is the average sale for each month, and what was the best selling month in each year?

```sql
SELECT *
FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_total_sale,
        RANK() OVER(
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) AS table1
WHERE rank = 1;
```

### 10. Who are the top 5 customers based on total sales?

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### 11. How many unique customers purchased from each category?

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS count_unique_customers
FROM retail_sales
GROUP BY category;
```

### 12. How many orders happened during each shift?

The shifts are grouped as:

| Shift     | Time          |
| --------- | ------------- |
| Morning   | Before 12 PM  |
| Afternoon | 12 PM to 5 PM |
| Evening   | After 5 PM    |

```sql
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

## Skills Used

* Creating a database
* Creating a table
* Using `SELECT`
* Using `WHERE`
* Checking for null values
* Deleting records
* Using `COUNT`
* Using `COUNT(DISTINCT)`
* Using `SUM`
* Using `AVG`
* Using `ROUND`
* Using `GROUP BY`
* Using `ORDER BY`
* Using `LIMIT`
* Using date filters
* Using `EXTRACT`
* Using `CASE`
* Using common table expressions
* Using window functions with `RANK()`

## Project Summary

In this project, I used SQL to clean and analyze a retail sales dataset. I started by creating a database and table, then checked the data for missing values. After cleaning the dataset, I explored the data by counting sales, customers, and product categories.

I also wrote business-focused SQL queries to answer questions about sales by date, category performance, customer age, high-value transactions, top customers, monthly sales trends, and order shifts.

This project helped me practice the SQL skills that are commonly used in data analyst work.


## End of Project

This is the end of my Retail Sales Analysis SQL project.


## Author - David Ghukasyan

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
