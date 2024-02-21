create database case3;
use case3;

##Q1
SELECT  count(DISTINCT node_id) AS unique_nodes
FROM customer_nodes;

##Q2

SELECT 
       regions.region_name,
       count(customer_nodes.node_id) AS node_count
FROM customer_nodes,regions where customer_nodes.region_id=regions.region_id 
group by regions.region_name;


##Q3
select regions.region_name,count(distinct customer_nodes.customer_id) from regions,customer_nodes
where customer_nodes.region_id=regions.region_id 
group by regions.region_name;


##Q4
select regions.region_name,sum(customer_transactions.txn_amount) from regions,customer_nodes,customer_transactions 
where regions.region_id=customer_nodes.region_id and customer_nodes.customer_id=customer_transactions.customer_id 
group by region_name;

##Q5

SELECT round(avg(datediff(end_date, start_date)), 2) AS avg_days
FROM customer_nodes
WHERE end_date!='9999-12-31';

##Q6

SELECT txn_type,
       count(*) AS unique_count,
       sum(txn_amount) AS total_amont
FROM customer_transactions
GROUP BY txn_type;

##Q7
SELECT round(count(customer_id)/
               (SELECT count(DISTINCT customer_id)
                FROM customer_transactions)) AS average_deposit_count,
       concat('$', round(avg(txn_amount), 2)) AS average_deposit_amount
FROM customer_transactions
WHERE txn_type = "deposit";

##Q8
WITH transaction_count_per_month_cte AS
  (SELECT customer_id,
          month(txn_date) AS txn_month,
          SUM(IF(txn_type="deposit", 1, 0)) AS deposit_count,
          SUM(IF(txn_type="withdrawal", 1, 0)) AS withdrawal_count,
          SUM(IF(txn_type="purchase", 1, 0)) AS purchase_count
   FROM customer_transactions
   GROUP BY customer_id,
            month(txn_date))
SELECT txn_month,
       count(DISTINCT customer_id) as customer_count
FROM transaction_count_per_month_cte
WHERE deposit_count>1
  AND (purchase_count = 1
       OR withdrawal_count = 1)
GROUP BY txn_month;

