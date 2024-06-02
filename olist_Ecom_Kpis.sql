use olist;
# KPI 1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

 select 'Weekday', concat(Round(sum(payment_value)/1000000,2),'M') as Payment_Statistics from orders_data a  join
 payments_data1 b on (a.order_id = b.order_id) where weekday(order_purchase_timestamp)<5
Union all
select 'Weekend', concat(Round(sum(payment_value)/1000000,2),'M')  as Payment_Statistics from orders_data a  join 
payments_data1 b on (a.order_id = b.order_id) where weekday(order_purchase_timestamp)>=5;

# KPI 2  Number of Orders with review score 5 and payment type as credit card.

select concat(Round(count(b.order_id)/1000,2),'K') as Number_of_Orders from payments_data1 a inner join
review_data b on (a.order_id = b.order_id)
 where review_score = 5 and payment_type = 'Credit_card' ;
 
 # KPI 3 Average number of days taken for order_delivered_customer_date for pet_shop
create or replace view od as
select order_Id,Customer_id,order_status,order_purchase_timestamp,order_delivered_customer_date,datediff(order_delivered_customer_date,order_purchase_timestamp) as Shipping_days,
product_id,seller_id,price from orders_data left join sellars_data using (order_Id);
select product_category_name,round(avg(shipping_days)) from od inner join products using (product_id) where product_category_name = 'pet_shop' ;

# KPI 4 Average price and payment values from customers of sao paulo city

create or replace view od1 as 
select order_id,Customer_id,product_id,Shipping_days,order_status,payment_type,price,payment_value from od  right join payments_data1 using (order_Id);
select round(avg(price)),round(avg(payment_value)) from od1 join customers_data using (customer_id) where customer_city = 'sao paulo';

# KPI 5 Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp))), review_score from 
orders_data a join review_data b on (a.order_id=b.order_id) group by review_score order by review_score;

# total revenue
SELECT concat(round(SUM(payment_value) / 1000000, 2),'M') AS Total_revenue
FROM payments_data1;

# total Orders
select concat(round(count(order_id)/1000,2),'K') as Total_orders from payments_data1;




