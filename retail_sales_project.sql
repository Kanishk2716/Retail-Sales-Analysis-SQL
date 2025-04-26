select * from retail_sales ;

Select count(*)
	from retail_sales ;

-- Checking NULL Values	

SELECT *
FROM retail_sales
where transactions_id is NULL ;

SELECT *
FROM retail_sales
where sale_date is NULL ;

Select *
froM retail_sales
where sale_time is NULL ;

Select * from retail_sales
where  
		transactions_id is NULL
		OR
		sale_date is NULL
		OR 
		sale_time is NULL
		OR
		customer_id is NULL
		OR 
		gender is NULL
		OR 
		category is NULL
		OR
		quantiy is NULL
		OR
		cogs is NULL
		OR
		total_sale is NULL ;

-- DATA CLEANING
-- Delete Rows with NULL Values

DELETE from retail_sales
where
		transactions_id is NULL
		OR
		sale_date is NULL
		OR 
		sale_time is NULL
		OR
		customer_id is NULL
		OR 
		gender is NULL
		OR 
		category is NULL
		OR
		quantiy is NULL
		OR
		cogs is NULL
		OR
		total_sale is NULL ;


-- DATA EXPLORATION

-- How many sales we have ?
select count(*)
AS total_sales 
from retail_sales ;

-- How many unique customers we have ?

Select count(distinct(customer_id))
from retail_sales ;

-- How many unique categories ?
Select distinct(category)
from retail_sales ;

-- Data Analysis & Key Business  Problems & Answers

-- Q1. Write a SQL query to retrieve all the columns for sales made on '2022-11-05'


Select *
from retail_sales 
where sale_date = '2022-11-05' ;

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

Select *
from retail_sales
where Category = 'Clothing'
and to_char(sale_date, 'YYYY-MM') = '2022-11'
and quantiy >= 4;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category

Select category , sum(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
Group by category ;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select category , avg(age) as avg_Age
from retail_sales
group by  category
having  category = 'Beauty' ;

Select round(avg(age) , 2) as avg_Age
from retail_sales
where category = 'Beauty' ;

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select *
from retail_sales
where total_sale > 1000 ;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select  category ,  gender ,count(transactions_id)  
from retail_sales
group by gender , category 
order by 1 ;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:


Select 
	year,
	month,
	avg_total_sales
	from(
Select 
	EXTRACT(YEAR FROM sale_date) as year ,
	EXTRACT(Month From sale_date) as month ,
    AVG(total_sale) as  avg_total_sales ,
	Rank() Over(Partition by Extract(year from sale_date) order by avg(total_sale) desc) as Rank
from retail_sales
group by 1,2) as t1
where rank = 1 ;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales:


Select customer_id , sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5 ;


-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

Select category ,count(distinct(customer_id)) as cnt_unique_cs
from retail_sales
group by category ;

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

With hourly_sale
AS
(
Select * , 
		CASE 
			WHEN EXTRACT(HOUR FROM SALE_TIME)<12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM SALE_TIME) BETWEEN 12 AND 17  THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
from retail_sales
)
Select shift ,  count(total_sale)
from hourly_sale
group by shift ;





