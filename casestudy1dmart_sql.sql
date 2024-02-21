## Data Cleansing
drop table clean_weekly_sales;
CREATE TABLE clean_weekly_sales AS
select week_date,
week(week_date) as week_number,
month(week_date) as month_number,
year(week_date)as calemder_year,
region,platform,
case 
when segment = null then 'Unknown'
else segment 
end as segment,
case
when right(segment,1)='1' then 'Young Adults'
when right(segment,1)='2' then 'Middle Aged'
when right(segment,1) in('3','4') then 'Retirees'
else 'Unknown'
end as age_band,
case 
when left(segment,1)='C' then 'Couples'
when left(segment,1)='F' then 'Families'
else 'Unknown'
end as demographic,customer_type,transactions,sales,
round(sales/transactions,2) as 'avg_transaction'
from weekly_sales;

use case1;
select * from clean_weekly_sales;

## Data Exploration

## 1.Which week numbers are missing from the dataset?
drop table seq52;
create table seq52(x int not null auto_increment primary key);
insert into seq52 values (),(),(),(),(),(),(),(),(),();
insert into seq52 values (),(),(),(),(),(),(),(),(),();
insert into seq52 values (),(),(),(),(),(),(),(),(),();
insert into seq52 values (),(),(),(),(),(),(),(),(),();
insert into seq52 values (),(),(),(),(),(),(),(),(),();
insert into seq52 values (),();
select * from seq52;

select distinct week_number from clean_weekly_sales;
select distinct x as week_day from seq52 where x not in(select distinct week_number from clean_weekly_sales); 

## 2.How many total transactions were there for each year in the dataset?
SELECT
  calemder_year,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales group by calemder_year;

## 3.What are the total sales for each region for each month?

SELECT month_number,region,sum(sales) from clean_weekly_sales group by region,month_number order by region,month_number;
 
## 4.What is the total count of transactions for each platform

SELECT
  platform,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform;

## 5.What is the percentage of sales for Retail vs Shopify for each month?

WITH cte_monthly_platform_sales AS (
  SELECT
    month_number,calemder_year,
    platform,
    SUM(sales) AS monthly_sales
  FROM clean_weekly_sales 
  GROUP BY month_number,calemder_year, platform 
)
SELECT
  month_number,calemder_year,
  ROUND(
    100 * max(CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS retail_percentage,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number,calemder_year
ORDER BY month_number,calemder_year;

## 6.What is the percentage of sales by demographic for each year in the dataset?

SELECT
  calendar_year,
  demographic,
  SUM(SALES) AS yearly_sales,
  ROUND((100 * SUM(sales)/SUM(SUM(SALES)) OVER (PARTITION BY demographic)),2) AS percentage
FROM clean_weekly_sales
GROUP BY
  calendar_year,demographic
ORDER BY calendar_year,demographic;
  
## 7.Which age_band and demographic values contribute the most to Retail sales?

SELECT age_band,demographic,sum(sales) from clean_weekly_sales where platform='Retail'
  group by age_band,demographic order by sum(sales) desc;


