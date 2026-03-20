create database customer_behavior;
USE customer_behavior;
SELECT * FROM customer_data;

--- 1. what is the purchase amount generate by male vs female customer?
select gender, sum(purchase_amount_usd) as revenue from customer_data group by gender;

--- 2. Which product categories generate the highest total purchase amount?  
    SELECT
    Category,
    ROUND(SUM(`purchase_amount_usd`), 2) AS total_revenue
FROM customer_data
GROUP BY Category
ORDER BY total_revenue DESC;

--- 3. which are the top 5 product with the highest average ratings?
SELECT
    item_purchased,
    round(avg(review_rating),2) AS avg_rating
FROM customer_data
GROUP BY item_purchased
ORDER BY avg(review_rating) DESC
LIMIT 5;

--- 4. compare the average purchase amount between standsrd and express shipping?
SELECT
    shipping_type,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_purchase_amount
FROM customer_data
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type;

--- 5. do subscribe customers spend more? compare avg spend and total between sub and non-sub customers?
 SELECT
    subscription_status,
    count(customer_id) as total_customer,
    ROUND(AVG(purchase_amount_usd), 2) AS avg_spend,
    ROUND(SUM(purchase_amount_usd), 2) AS total_revenue
FROM customer_data
GROUP BY subscription_status 
order by total_revenue, avg_spend desc;

--- 6. Which 5 products have the highest percentage of purchases with discounts applied?
SELECT
item_purchased,
    ROUND(100 * 
        SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / count(*),2)
     AS discount_percentage
FROM customer_data
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

--- 7. Segment customers into New, Returning, and Loyal based on their total number of previous purchases, and show the count of each segment
WITH item_counts AS (
    SELECT category, item_purchased,
    count(customer_id) as total_orders,
    row_number() over(partition by category order by count(customer_id)desc) as item_rank
    from customer_data
    group by category, item_purchased)
    
    select item_rank, category,item_purchased,total_orders
    from item_counts
    where item_rank <=3;
    
    --- 9. Are repeat buyers (more than 5 previous purchases) more likely to subscribe?
    select subscription_status,
    count(customer_id) as repeted_buyers
    from customer_data
    where previous_purchases >5
    group by subscription_status;
    
    --- 10. what is the revenue contribution of each age group?
    select age_group,
    sum(purchase_amount_usd) as total_revenue
    from customer_data
    group by age_group
    order by total_revenue desc;
    
    select * from customer_data;
    
SELECT 
    customer_id,
    CASE
        WHEN COUNT(*) = 1 THEN 'New'
        WHEN COUNT(*) <= 4 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_segment
FROM customer_data
GROUP BY customer_id;



