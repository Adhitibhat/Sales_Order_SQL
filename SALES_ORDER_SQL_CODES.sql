--Retreiving the data from the tables --
select * from Sales_order;
select * from Customers;
select * from Products;

--1) Fetch all the small shipped ORDERS from August 2003 till the end of year 2003.
select *
from sales_order
where deal_size = 'Small'
and status = 'Shipped'
and order_date between to_date('01-08-2003', 'dd-mm-yyyy') and to_date('31-12-2003', 'dd-mm-yyyy');

select *
from sales_order
where deal_size = 'Small'
and status = 'Shipped'
and year_id=2003 
and month_id >= 8;

--2) Find all the orders which do not belong to customers from USA and are still in process.
--fetch data from  orders table
--exclude USA customers
--fetch orders which are in process

select s.*
from sales_order s
join customers c on c.customer_id = s.customer
where c.country <> 'USA'
and s.status = 'In Process';

--3) Find all orders for Planes, Ships and Trains which are neither Shipped nor In Process nor Resolved.
        select *
        from Sales_order s
        join products p on p.product_code=s.product
        where p.product_line in ('Planes', 'Ships', 'Trains')
        and s.deal_size not in ('Shipped', 'In Process', 'Resolved');

--4) Find customers whose phone number has either parenthesis "()" or a plus sign "+".
        select *
        from Customers
        where phone like '%+%' or phone like '%(%' or phone like '%)%';


--5) Find customers whose phone number does not have any space.
        select *
        from Customers
        where phone not like '% %';

--6) Fetch all the orders between Feb 2003 and May 2003 where the quantity ordered was an even number.
        select *
        from Sales_order
        where order_date between to_date('01-02-2003', 'dd-mm-yyyy') and to_date('31-05-2003', 'dd-mm-yyyy')
        and quantity_ordered % 2 = 0;

--7) Find orders which sold the product for price higher than its original price.
        select s.order_number, s.price_each, p.price, p.product_line, p.product_code
        from Sales_order s
        join products p on p.product_code=s.product
        where s.price_each > p.price;

--8) Find the average sales order price
        select round(avg(sales)::decimal,2) as avg_sales
        from Sales_order;

--9) Count total no of orders.
        select count(1) as total_orders from Sales_order;

--10) Find the total quantity sold.
        select sum(quantity_ordered) as total_items_sold from Sales_order;

--11) Fetch the first order date and the last order date.
        select min(order_date) first_order_date, max(order_date) last_order_date
        from sales_order;

--12) Find the average sales order price based on deal size

select deal_size , avg(sales) as avg_sales
from sales_order 
group by deal_size; 

--13) Find total no of orders per each day. Sort data based on highest orders.

select order_date, count(1) as no_of_orders
from sales_order
group by order_date
order by no_of_orders desc;

--14) Display the total sales figure for each quarter. Represent each quarter with their respective period.
select qtr_id
, case when qtr_id = 1 then 'JAN-MAR'
	   when qtr_id = 2 then 'APR-JUN'
	   when qtr_id = 3 then 'JUL-SEP'
	   --ELSE 'OCT-DEC'
  END QUARTER
, sum(sales) as total_sales
from Sales_order group by qtr_id

--15) Identify how many cars, Motorcycles, trains and ships are available in the inventory.
--Treat all type of cars as just "Cars".

-- Solution 1:
SELECT case when product_line in ('Classic Cars', 'Vintage Cars') 
				then 'Cars' 
			else product_line 
	   end vehicles
, count(1)
FROM products
where product_line in ('Classic Cars', 'Vintage Cars', 'Motorcycles', 'Trains', 'Ships')
group by case when product_line in ('Classic Cars', 'Vintage Cars') 
					then 'Cars' 
				else product_line 
		   end;

-- solution 2
select product_line, count(1) as no_of_vehicles
FROM products
where product_line in ('Motorcycles', 'Trains', 'Ships')
group by product_line
union
select 'Cars', count(1) as no_of_vehicles
FROM products
where product_line like '%Cars%';

--16) Identify the vehicles in the inventory which are short in number.
--Shortage of vehicle is considered when there are less than 10 vehicles.

select product_line, count(1)
from products
group by product_line
having count(1) < 10;

--17) Find the countries which have purchased more than 10 motorcycles.

    select p.product_line, c.country, count(1)
    from Sales_order s
    join products p on p.product_code = s.product
    join customers c on c.customer_id = s.customer
    where p.product_line = 'Motorcycles'
    group by p.product_line, c.country
    having count(1) > 10
    order by 3 desc;

--18) Find the orders where the sales amount is incorrect.
SELECT order_number
, round(sales::decimal,2) as sales
, round((quantity_ordered * price_each)::decimal, 2) as calc_amt
FROM sales_order 
where round(sales::decimal,2) <> round((quantity_ordered * price_each)::decimal, 2);

--19) Fetch the total sales done for each day.
    select order_date, sum(sales)::decimal as sales
    from Sales_order
    group by order_date
    order by 2 desc;

--20) Fetch the top 3 months which have been doing the lowest sales.
    select to_char(order_date, 'Mon'), sum(sales)::decimal as sales
    from Sales_order
    group by to_char(order_date, 'Mon')
    order by 2
    limit 3;

--21) Find total no of orders per each day of the week (monday to sunday). Sort data based on highest orders.
	select extract (isodow from order_date), count(1) as no_of_orders
	from sales_order
	group by extract (isodow from order_date)
	order by 1,2 ;

--22) Find out the vehicles which was sold the most and which was sold the least. Output should be a single record which 2 columns. One column for most sold vehicle and other for least sold vehicle.

select 	most_sold_vehicle, least_sold_vehicle
from (select p.product_line ||' ('|| sum(quantity_ordered)  ||')' as most_sold_vehicle
	from Sales_order so
	join products p on p.product_code=so.product
	group by p.product_line	
	order by sum(quantity_ordered) desc
	limit 1) a,
	(select p.product_line ||' ('|| sum(quantity_ordered)  ||')' as least_sold_vehicle
	from Sales_order so
	join products p on p.product_code=so.product
	group by p.product_line	
	order by sum(quantity_ordered) 
	limit 1) b

--23) Display the total sales figure for each quarter. Represent each quarter with their respective period.

select sum(sales) as total_sales
, case when qtr_id = 1 then 'JAN-MAR'
	   when qtr_id = 2 then 'APR-JUN'
	   when qtr_id = 3 then 'JUL-SEP'
	   when qtr_id = 4 then 'OCT-DEC'
  end period
from sales_order 
group by qtr_id; 
--(when the quater_id is not given)
select sum(sales) as total_sales
, case when extract(month from s.order_date) between 1 and 3 then 'JAN-MAR'
	   when extract(month from s.order_date) between 4 and 6 then 'APR-JUN'
	   when extract(month from s.order_date) between 7 and 9 then 'JUL-SEP'
	   when extract(month from s.order_date) between 10 and 12 then 'OCT-DEC'
  end as qtr
from sales_order s
group by case when extract(month from s.order_date) between 1 and 3 then 'JAN-MAR'
			   when extract(month from s.order_date) between 4 and 6 then 'APR-JUN'
			   when extract(month from s.order_date) between 7 and 9 then 'JUL-SEP'
			   when extract(month from s.order_date) between 10 and 12 then 'OCT-DEC'
		  end;

--24)Find the most profitable orders. most profiatle orders are those whose sale price exceeded the
--average sale price fro each city and whose deal size is not small

with cte as 
(select c.city ,avg(s.sales) as average --Average sales of each city
from sales_order s 
join customers c on c.customer_id=s.customer
group by c.city)

select s.order_number,s.sales,ct.*
from sales_order s
join customers c on s.customer=c.customer_id
join cte ct  on ct.city=c.city
where s.sales>ct.average
and s.deal_size!='Small';

--25) Find the difference in average sales for each month of 2003 and 2004.
--SOLUTION_1 (Has problem with Redundancy as you are executing two simialr queries)
WITH cte_2003 as
(select to_char(order_date,'MON') as months,avg(sales) as AVERAGE03 --2003
from sales_order s
where year_id=2003
group by TO_CHAR(order_date,'MON')),
cte_2004 as 
(select to_char(order_date,'MON') as months,avg(sales) AS AVERAGE04 --2004
from sales_order s
where year_id=2004
group by TO_CHAR(order_date,'MON'))

select y03.months, abs(y03.AVERAGE03-y04.AVERAGE04)
from cte_2003 y03
join cte_2004 y04 on y03.months=y04.months

--SOLUTION 
WITH CTE AS
(select year_id,to_char(order_date,'MON') as months,avg(sales) AS AVERAGE04 --2003,2004
from sales_order s
where s.year_id IN (2003,2004)
group by year_id,TO_CHAR(order_date,'MON'))
select y03.months, abs(y03.AVERAGE04-y04.AVERAGE04)--SELF_JOIN
from CTE y03
join CTE y04 on y03.months=y04.months
 WHERE y03.year_id=2003 and
 y04.year_id=2004
