use DataWarehouseAnalytics
-- see the design of the schema
select * 
from INFORMATION_SCHEMA.TABLES

select* 
from INFORMATION_SCHEMA.COLUMNS

select* 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME ='gold.dim.produc'
--------------------------------------------
--exploer all the categorys 
select  category,subcategory,product_name
from gold.dim_products
order by 1,2,3
----------------------------------------------
--Date exploer
--max & min year for our first order
--dateiff takes 3 paramiter (year  or months, days and max year and min )
--to calculate the total years or month or days between the 2 history we gave it
select min(order_date)as first_order_date,
max(order_date)last_order_date,
DATEDIFF(year,min(order_date),max(order_date))as total_sales_order_by_years,
DATEDIFF(month,min(order_date),max(order_date))as total_sales_order_by_months,
DATEDIFF(day,min(order_date),max(order_date))as total_sales_order_by_days
from gold.fact_sales 

----------------------------------------------

--find the youngest and the oldest customer
--getdate function its return the date of today
select min(birthdate)as oldest_customer,max(birthdate)as youngest_customer,
datediff(year,max(birthdate),GETDATE())as age_by_years
from gold.dim_customers
----------------------------------------------

--expoler measures
----------------------------------------------
--find sum sales
select sum(sales_amount) as total_sales
from gold.fact_sales          

--how many item are sold
select sum(quantity)as total_sold_item
from gold.fact_sales

--average of selling price
select AVG(sales_amount)as average_price_sales
from gold.fact_sales

--total numbers of orders
select count (DISTINCT  order_number)as total_orders
from gold.fact_sales

--total number of prodect
select COUNT(distinct product_key) as total_products
from gold.dim_products

--total number of customers
select COUNT(distinct customer_key)as total_customer
from gold.dim_customers

--total customer ordered an order
select COUNT(distinct customer_key)as active_customer
from gold.fact_sales
------------------------------------------------------------------
--generate report show all the keys mitrics of this business

select'total sold item'as measure_name, sum(sales_amount)as the_Value
from gold.fact_sales

union all

select'total_quantity', sum(quantity)
from gold.fact_sales

union all

select 'average_price_sales', AVG(sales_amount)
from gold.fact_sales

union all
select 'total_orders',count (DISTINCT  order_number)
from gold.fact_sales

union all

select 'total_products',COUNT(distinct product_key) 
from gold.dim_products

union all

select 'total_customer',COUNT(distinct customer_key)
from gold.dim_customers

union all

--total customer ordered an order
select 'active_customer',COUNT(distinct customer_key)
from gold.fact_sales
------------------------------------------------------------------
--magnitude analysis its about compare measures by categorys

--total customers by country
select country, count(distinct customer_key)as total_customer
from gold.dim_customers
group by country
order by total_customer desc


--total customers by gender
select gender, count(distinct customer_key)as total_customer
from gold.dim_customers
group by gender
order by total_customer desc


--total prodects by category

select COUNT(distinct product_name)as product_count ,category
from gold.dim_products
group by category
order by product_count desc


--average cost per category

select AVG(cost)as ave_cost,category
from gold.dim_products
group by category
order by ave_cost desc


--total profit per category

select product.category, sum(sales.sales_amount)as total_amount,
sum(product.cost)as total_cost,
sum(sales.sales_amount-product.cost) as total_profit
from gold.fact_sales as sales
join gold.dim_products as product
on sales.product_key=product.product_key
group by product.category



--total profit per customer

select sales.customer_key,sum(sales.sales_amount)as total_amount,
sum(product.cost)as total_cost,
sum(sales.sales_amount-product.cost) as total_profit
from gold.fact_sales as sales
join gold.dim_products as product
on sales.product_key=product.product_key
group by sales.customer_key
order by total_profit desc


-- distribution of sold item per countries
select customer.country as total_country,
sum(sales.quantity) as total_quantity
from gold.fact_sales as sales
join gold.dim_customers as customer
on sales.customer_key=customer.customer_key
group by customer.country
order by total_quantity desc
------------------------------------------------------------------
--ranking analysis

--top 5 prodect per profit
select top 5  product.product_name,sum(sales_amount)as total_sales
from gold.fact_sales as sales
join gold.dim_products as product
on sales.product_key=product.product_key
group by product.product_name
order by total_sales desc


--lowest 5 products per profit

select top 5  product.product_name,sum(sales_amount)as total_sales
from gold.fact_sales as sales
join gold.dim_products as product
on sales.product_key=product.product_key
group by product.product_name
order by total_sales   

------------------------------------------------------------------
--top 5 sub-category per profit

select top 5  product.subcategory,sum(sales_amount)as total_sales
from gold.fact_sales as sales
join gold.dim_products as product
on sales.product_key=product.product_key
group by product.subcategory
order by total_sales desc


--lowset 5 sub-category per profit

select top 5  product.subcategory,sum(sales_amount)as total_sales
from gold.fact_sales as sales
join gold.dim_products as product
on sales.product_key=product.product_key
group by product.subcategory
order by total_sales 





--another way to get top or lowest procdect use subquries
select * 
 from 
  (select 
   product.subcategory,sum(sales_amount)as total_sales,
   ROW_NUMBER()over(order by sum(sales_amount))as rank_p
   from gold.fact_sales as sales
   join gold.dim_products as product
   on sales.product_key=product.product_key 
   group by  product.subcategory) as lit
where rank_p<=5
------------------------------------------------------------------
--top 5 customer per buy

select top 10  customers.customer_key,customers.first_name,
sum(sales_amount)as total_sales
from gold.fact_sales as sales
join gold.dim_customers as customers
on sales.customer_key=customers.customer_key
group by customers.customer_key,customers.first_name
order by total_sales desc


--lowest 5 customer per buy

select top 10  customers.customer_key,customers.first_name,
sum(sales_amount)as total_sales
from gold.fact_sales as sales
join gold.dim_customers as customers
on sales.customer_key=customers.customer_key
group by customers.customer_key,customers.first_name
order by total_sales asc











select*
from gold.dim_products
select*
from gold.fact_sales














