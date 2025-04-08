-- CREATE TABLE 
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

SELECT * FROM retail_sales
LIMIT 10

-- CHECK HOW MANY ROWS ARE IN THE DATASET
SELECT 
	COUNT(*) 
FROM retail_sales


---

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
	category is null
	OR 
	quantiy is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null

	

-- DELETE NULL VALUES


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
	category is null
	OR 
	quantiy is null
	or 
	price_per_unit is null
	or 
	cogs is null
	or 
	total_sale is null


-- DATA EXPLORATION 
-- How many sales we have?

SELECT COUNT(*) as total_sale from retail_sales

-- How many customers we have?

SELECT COUNT(DISTINCT(customer_id)) as total_sale from retail_sales

-- Which categories do we have?

select distinct category from retail_sales


-- Data analysis and business key problems

-- How many sales made on 2022-11-05
select *
from retail_sales 
where sale_date = '2022-11-05'

--All transaction where the category is clothing and quantity sold is more than 10 in the month of Nov-2022
select *
from retail_sales
where category = 'Clothing' and to_char(sale_date,'YYYY-MM')='2022-11' and quantity>=4


--Total sales per category
select category, sum(total_sale) as net_sale, count(*) as total_sale
from retail_sales
group by 1


--The average age of customers who purchased items from the beauty category
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- All transactions where total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000


-- Total number of transactions made by each gender in each category
select category, gender, count(*) as total_trans
from retail_sales
group by category, gender
order by 1


-- Average sale for each month and the best sale month for each year
select year , month , avg_sale
from
(
select extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
order by 1, 3 desc 
) as t1
where rank =1


--Find the top 5 customer based on the highest total sales

select customer_id,
		sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
LIMIT 5

-- Find the number of unique customers who purchased items from each category
select category , count(distinct(customer_id)) as cnt_uniq
from retail_Sales
group by 1

-- Find the number of orders per shift (for example morning <12 , afternoon 12&17, evening >17)
with hourly_sale
as
(
select *,
	case 
		when extract (hour from sale_time )<12 then 'morning'
		when extract (hour from sale_time ) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_order
from hourly_sale
group by shift
