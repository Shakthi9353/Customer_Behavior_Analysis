create database customer_behavior;
use customer_behavior;
select * from customers limit 5;

# total revenue grnrated by male vs female customers?

select gender, sum(purchase_amount) as revenue
from customers 
group by gender;

# which customers used a discount but still spent more than the average purchase amount?
select customer_id, purchase_amount
from customers
where discount_applied = "Yes" and purchase_amount >= (select avg(purchase_amount) from customers);

#  top 5 products with the highest average rating 

select item_purchased, round(avg(review_rating), 2) as Average_Product_Rating 
from customers
group by item_purchased 
order by avg(review_rating) desc limit 5;
  
# compared the average purchase amount between standard and express shipping 

select shipping_type, round(avg(purchase_amount), 2) 
from customers 
where shipping_type in ("standard", "express") 
group by shipping_type;

# do subscribed customers spend more? compared avg spend and total revenue betweem subscriber and non-subscriber

select subscription_status, count(customer_id) as total_customer,
round(avg(purchase_amount),2) as average_spent, round(sum(purchase_amount), 2) as total_revenue
from customers 
group by subscription_status
order by average_spent, total_revenue desc;

# which products have the highest percentage of purchase with discounts applied 
select item_purchased, 
round(100 * sum(case when discount_applied = "Yes" then 1 else 0 end)/ count(*) , 2) as discount_rate 
from customers 
group by item_purchased 
order by discount_rate desc limit 5;

#segment customers into new, returning, and loyal based on there total number of previous purchases, and show the count of each segment?

with customer_type as (
select customer_id, previous_purchases,
case 
when previous_purchases = 1 then "New"
when previous_purchases between 2 and 10 then "Returning" 
else "Loyal" 
end as customer_segment 
from customers 
)

select customer_segment, count(*) as number_of_customers
from customer_type 
group by customer_segment;

# top 3 most purchased with in each category
with item_counts as (
select category, item_purchased, count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank 
from customers 
group by category, item_purchased 
)

select item_rank, category, item_purchased, total_orders 
from item_counts 
where item_rank <= 3;

# are customers who are repate buyers (more than 5 previous perchase) also likely to subscribe?
select subscription_status, count(customer_id) as repeat_buyers 
from customers 
where previous_purchases > 5 
group by subscription_status;

#  revenue contribution of each age group ?
select age_group, sum(purchase_amount) as total_revenue 
from customers 
group by age_group 
order by total_revenue desc;
