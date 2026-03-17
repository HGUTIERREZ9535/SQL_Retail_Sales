select * from PortFolioProject.dbo.Retail_Sales_Analysis

select sale_date, convert(date,sale_date ) As Sale_updated_date from PortFolioProject.dbo.Retail_Sales_Analysis

select sale_time, convert(time,sale_time ) As Sale_updated_date from PortFolioProject.dbo.Retail_Sales_Analysis

-- Star the analysis locating  NULL values 
Select * from PortFolioProject.dbo.Retail_Sales_Analysis
where transactions_id is null
or sale_date is null 
or 
sale_time is null 
or gender is null  
or category is null 
or quantiy is null  
or cogs is null 
or total_sale is null 
--Delete identified null values 
Delete from PortFolioProject.dbo.Retail_Sales_Analysis
where transactions_id is null
or sale_date is null 
or 
sale_time is null 
or gender is null  
or category is null 
or quantiy is null  
or cogs is null 
or total_sale is null 

--1
--How many sales we have 
Select * from PortFolioProject.dbo.Retail_Sales_Analysis
Select count (*) as total_sale from PortFolioProject.dbo.Retail_Sales_Analysis
--2
--How many unique customers 
Select count(distinct(customer_id)) as Unique_CustomerID from PortFolioProject.dbo.Retail_Sales_Analysis
--3
-- Sales made on '2022-11-05'
--Use Convert to update Sale_date into date format 
select Sale_date, sum (total_sale) as Total_Sales_2022_11_05, convert(date,sale_date ) As Sale_updated_date from PortFolioProject.dbo.Retail_Sales_Analysis
where sale_date = '2022-11-05'
group by sale_date
-- CTE 
--Use CTE to SELECT the new updated column 
with SalesCTE as (select Sale_date, sum (total_sale) as Total_Sales_2022_11_05, convert(date,sale_date ) As Sale_updated_date from PortFolioProject.dbo.Retail_Sales_Analysis
where sale_date = '2022-11-05'
group by sale_date
)
select Sale_updated_date, Total_Sales_2022_11_05  from SalesCTE

--4
--Transactions where the category is "Clothing" and the quantity sold is more than 4 in the month of Nov-2022

Select *  from PortFolioProject.dbo.Retail_Sales_Analysis
 where category = 'Clothing' and quantiy >= 4 and sale_date between '2022-11-01' and '2022-11-30'

 --5 
 --Write SQL query to calculate the total sales for each category 
 Select category, sum(total_sale) as Net_sale from PortFolioProject.dbo.Retail_Sales_Analysis
 group by category

 --6
 --Average age of customers who purchased items from the "beauty" category
 --Used the ROUND function since it was a big number 
 Select round (AVG(age),2)  from PortFolioProject.dbo.Retail_Sales_Analysis
 where category = 'Beauty'

 --7
 -- SQL query to find all transactions  where the total sale is greater than 1000
  Select * from PortFolioProject.dbo.Retail_Sales_Analysis
where total_sale > '1000'

--8
--Writte a SQL query to find the total number of transactions made by each gender in each category
  Select category, gender , count (transactions_id) as Number_of_people_per_Category   from PortFolioProject.dbo.Retail_Sales_Analysis
  group by category, gender 
  
--9
--Write a query to calculate the average sale for each month, find out the best selling month in each year 
  Select YEAR(sale_date) as Year,Month(sale_date) AS Month,AVG(total_sale) as Avg_Sale, 
  rank()over( partition by YEAR(sale_date) order by AVG(total_sale)desc) AS Rank_column
 from PortFolioProject.dbo.Retail_Sales_Analysis 
 group by YEAR(sale_date),Month(sale_date)
 order by YEAR(sale_date),AVG(total_sale) desc

 -- Create a CTE to select only the Rank_Column values with rank number = 1
 with Best_months_sell as ( Select YEAR(sale_date) as Year,Month(sale_date) AS Month,AVG(total_sale) as Avg_Sale, 
 rank()over( partition by YEAR(sale_date) order by AVG(total_sale)desc) AS Rank_column

  from PortFolioProject.dbo.Retail_Sales_Analysis 
 group by YEAR(sale_date),Month(sale_date)
 --order by YEAR(sale_date),AVG(total_sale) desc
 
 )
 Select * from Best_months_sell
 where Rank_column = '1'

 --10 Write a SQL query to find the top 5 customer based on the highest total sales 
   Select top 5 customer_id, sum (total_sale) as total_sale from PortFolioProject.dbo.Retail_Sales_Analysis
   group by customer_id
   order by sum (total_sale) desc 

 --11 Write a SQL query to find the number of unique customer who purchase items from each category
 --Check if there is any null value 
    Select category, count(distinct (customer_id)) as Unique_customer_per_Category from PortFolioProject.dbo.Retail_Sales_Analysis
	 group by category

-- 12  Write a SQL query to create each shift and number of orders,
--example (Morning <= 12, Afternoon between 12 and 17, evening >17)	
--Start changeing the format with CAST 
--Use CASE clause since we will be filtering the sale_time colummn, According to the sample given 
  

  Select *, case when cast (sale_time as time ) < '12:00:00' then 'Morning' 
  when cast (sale_time as time ) between '12:00:00' and '17:00:00'  then 'Afternoon' 
  else 'Night' 
  end as Shift from PortFolioProject.dbo.Retail_Sales_Analysis

  with countshift as (Select *, case when cast (sale_time as time ) < '12:00:00' then 'Morning' 
  when cast (sale_time as time ) between '12:00:00' and '17:00:00'  then 'Afternoon' 
  else 'Night' 
  end as Shift from PortFolioProject.dbo.Retail_Sales_Analysis)

  select shift,  count (*) as Total_Orders from countshift
  group by shift 
  


	   

  



















