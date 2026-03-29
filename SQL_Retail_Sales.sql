--Created Database in the name of SQL_P1_RETAIL_SALES 

--Creating table 

create table retails_sales( 
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar (15),	
quantity int, 
price_per_unit float,
cogs float,
total_sale float
)

--BULK DATA IMPORTING ISSUE - 

1.	Bulk data upload failed due to a data type mismatch error in the Date column.
2.	Modified Data Type in Source File

--Converted the Date column format to VARCHAR in the CSV file to avoid format conflicts during import.

alter table retail_sales
alter column sale_date varchar(50);


-- Performed Bulk Import
-- Successfully loaded the data into the SQL table using BULK INSERT with the Date column as VARCHAR.


bulk insert retail_sales
from 'E:\data\retail_sales.csv'
with
(
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '\n',
    errorfile = 'E:\data\error_log.txt',
    maxerrors = 10
);


-- Post-Upload Data Conversion
-- After successful data upload, converted the Date column from VARCHAR back to DATE format within SQL.


-- Fix date format using SQL
UPDATE retail_sales
SET sale_date = TRY_CONVERT(DATE, sale_date, 105);

--105 = format for DD-MM-YYYY

--  Convert back to DATE

alter table retail_sales
alter column sale_date date;

-- Checking null Values in each column of the TABLE

select * from retail_sales
where transactions_id is null
	or
sale_date is null
	or 
sale_time is null 
	or 
customer_id is null 
	or 
gender is null 
	or 
age is null 
	or 
category is null 
	or 
price_per_unit is null 
	or 
cogs is null 
	or 
total_sale is null;


-- Deleting Null Values from the table 

delete from retail_sales
where transactions_id is null
	or
sale_date is null
	or 
sale_time is null 
	or 
customer_id is null 
	or 
gender is null 
	or 
age is null 
	or 
category is null 
	or 
price_per_unit is null 
	or 
cogs is null 
	or 
total_sale is null;


-- After deleting checking the total recorts 

select count(*) count from retail_sales

--How Many sales we have ? 

select count(*) as total_sales from retail_sales;

--How many unique customers we have ? 

select count(distinct customer_id) as total_customers from retail_sales

--How many unique category we have ?

select count(distinct category) AS unique_category from retail_sales 

--DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS 

--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

select * from retail_sales where sale_date = '2022-11-05'

--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 3 in the month of Nov-2022.

select * from retail_sales
where category = 'clothing' 
	And Quantity > 3
	And sale_date Between '2022-11-01' and '2022-11-30';

--Q3. Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category,
	sum(total_sale) as total_sales
from retail_sales
group by category

--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
		avg(age) as avg_Age 
from retail_sales
where category = 'Beauty'
group by category

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000

--Q6. Write a SQL query to find the total number of transactions (transaction_id)
--made by each gender in each category.

select 
	category,
	gender, 
	count(transactions_id) as total_transaction 
from retail_sales
group by category, gender
order by category

--Q7. Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year.

select  * 
from (
	select 
		year(sale_date) as year,
		month(sale_date) as month,
		round(avg(total_sale),2) as Total_Sale,
		rank() over (partition by year(sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by year(sale_date), month(sale_date)
)t
where rank = 1;

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
 
select 
	top 5 customer_id,
	sum(total_sale) as total_sales 
from retail_sales
group by customer_id 
order by sum(total_sale) desc

--Q9. Write a SQL query to find the number of unique customers
--who purchased items from each category.

select category,
	count(distinct customer_id) as unique_customers 
from retail_sales
group by category 

--Q10. Write a SQL query to create each shift and number of orders
--(Example: Morning <= 12, Afternoon between 12 & 17, Evening > 17)

With shift_data as (
select 
	case 
		when datepart(hour, sale_time) <= 12 then 'Morning'
		when datepart(hour, sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift 
from retail_sales
) 

select 
	shift, 
	count(*) as no_of_orders
from Shift_data 
group by shift 
order by shift 


 


