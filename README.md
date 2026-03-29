# 🛒 Retail Sales Analysis — SQL Project


## Project Overview

This project demonstrates core SQL skills used in real-world data analysis including database setup, data cleaning, exploratory data analysis (EDA), and business-driven querying. It is built on a retail sales dataset and is designed to showcase foundational SQL competency for data analyst roles.

> **Database:** Microsoft SQL Server  
> **Dataset:** Retail transactions with customer demographics, product categories, and sales figures

---

## Objectives

1. **Database Setup**  Create and populate a retail sales database
2. **Data Cleaning**  Identify and remove records with null/missing values
3. **Exploratory Data Analysis**  Understand the dataset structure and key metrics
4. **Business Analysis**  Answer 10 real-world business questions using SQL

---

## Project Structure

```
retail-sales-sql/
│
├── SQL_Retail_Sales.sql     # Main SQL script (setup + cleaning + analysis)
└── README.md                # Project documentation
```

---

## Database Setup

### Table Schema

```sql
CREATE TABLE retails_sales (
    transactions_id  INT PRIMARY KEY,
    sale_date        DATE,
    sale_time        TIME,
    customer_id      INT,
    gender           VARCHAR(15),
    age              INT,
    category         VARCHAR(15),
    quantity         INT,
    price_per_unit   FLOAT,
    cogs             FLOAT,
    total_sale       FLOAT
);
```

### Data Import Notes

- Bulk data was imported using `BULK INSERT` from a CSV file.
- The `sale_date` column was temporarily converted to `VARCHAR(50)` to avoid format conflicts during import, then converted back to `DATE` using `TRY_CONVERT(DATE, sale_date, 105)` (format: DD-MM-YYYY).

---

## Data Cleaning

Checked for and removed records with `NULL` values across all critical columns:

```sql
-- Check for nulls
SELECT * FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL
   OR customer_id IS NULL OR gender IS NULL OR age IS NULL
   OR category IS NULL OR price_per_unit IS NULL
   OR cogs IS NULL OR total_sale IS NULL;

-- Delete nulls
DELETE FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL
   OR customer_id IS NULL OR gender IS NULL OR age IS NULL
   OR category IS NULL OR price_per_unit IS NULL
   OR cogs IS NULL OR total_sale IS NULL;
```

---

## Exploratory Data Analysis

```sql
-- Total records
SELECT COUNT(*) AS total_records FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- Unique product categories
SELECT COUNT(DISTINCT category) AS unique_categories FROM retail_sales;
```

---

## Business Questions & SQL Queries

### Q1. Sales on a Specific Date
Retrieve all transactions made on `2022-11-05`.

```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

---

### Q2. Clothing Sales in November 2022
Retrieve transactions where category is `Clothing`, quantity > 3, in November 2022.

```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND quantity > 3
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

---

### Q3. Total Sales by Category
Calculate total revenue per product category.

```sql
SELECT
    category,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;
```

---

### Q4. Average Customer Age — Beauty Category
Find the average age of customers who bought Beauty products.

```sql
SELECT
    AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;
```

---

### Q5. High-Value Transactions
Find all transactions where total sale exceeds 1000.

```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

---

### Q6. Transactions by Gender and Category
Count transactions for each gender within each product category.

```sql
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

---

### Q7. Best-Selling Month Per Year
Calculate average monthly sales and rank to find the best month each year.

```sql
SELECT *
FROM (
    SELECT
        YEAR(sale_date)            AS year,
        MONTH(sale_date)           AS month,
        ROUND(AVG(total_sale), 2)  AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        )                          AS rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) t
WHERE rank = 1;
```

---

### Q8. Top 5 Customers by Revenue
Identify the five customers who spent the most overall.

```sql
SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC;
```

---

### Q9. Unique Customers per Category
Count distinct customers who purchased from each product category.

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

---

### Q10. Orders by Time Shift
Classify transactions into Morning, Afternoon, and Evening shifts and count orders per shift.

```sql
WITH shift_data AS (
    SELECT
        CASE
            WHEN DATEPART(HOUR, sale_time) <= 12  THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS no_of_orders
FROM shift_data
GROUP BY shift
ORDER BY shift;
```

---

## Key Findings

| Area | Insight 
|
| **Customer Demographics** | Customers span a wide age range; purchases spread across Clothing, Beauty, and Electronics |
| **High-Value Sales** | Multiple transactions exceeded ₹1,000, indicating a premium customer segment |
| **Sales Trends** | Monthly analysis reveals seasonal peaks — useful for inventory planning |
| **Top Customers** | A small group of customers contributes disproportionately to total revenue |
| **Time Patterns** | Order volume varies by shift, helping optimize staffing and promotions |

---

## Tools Used

- **Microsoft SQL Server**  Database engine
- **SSMS (SQL Server Management Studio)**  Query interface
- **BULK INSERT**  Data ingestion from CSV
- **Window Functions**  `RANK() OVER (PARTITION BY ...)` for time-series ranking
- **CTEs**  Common Table Expressions for readable, modular queries

---

## 🚀 How to Run This Project

1. Install [SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) and [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
2. Create a new database in SSMS
3. Open `SQL_Retail_Sales.sql` in SSMS
4. Update the file path in the `BULK INSERT` statement to point to your local CSV file
5. Run the script top to bottom  setup, cleaning, and all analysis queries are included

---

## 👤 Author

**Yaman**  
Data Analyst | Building hands-on projects in SQL, Power BI & Excel  
📂 [GitHub Portfolio](https://github.com/Yamankumar445) • 💼 [LinkedIn](www.linkedin.com/in/yaman-kumar-7a4b67260)

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
