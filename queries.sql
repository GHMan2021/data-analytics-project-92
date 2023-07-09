select count(*) as customer_count from customers c ;

with tab as (
	select	
	case 
		when age <= 25 then 1
		when age > 40 then 3
		else 2
	end as age_num,
	count(age) as count
	from customers c 
	group by age_num
)
select 
	case 
		when tab.age_num = 1 then '16-25'
		when tab.age_num = 2 then '26-40'
		else '40+'
	end as age_category,
	tab.count
from tab
order by tab.age_num;


select	
	to_char(s.sale_date, 'yyyy-mm') as date,
	count(distinct(s.customer_id)) as total_customers,
	sum(s.quantity * p.price) as income
from sales s 
inner join customers c 
on c.customer_id = s.customer_id 
inner join products p 
on p.product_id = s.product_id 
group by date
order by date;


select 
	tab_zero_price.customer,
	tab_zero_price.sale_date,
	tab_zero_price.seller
from
	(
		select
			s.customer_id,
			concat(c.first_name, ' ', c.last_name) as customer,
			s.sale_date,
			concat(e.first_name, ' ', e.last_name) as seller,			 
			row_number() over (partition by s.customer_id order by s.customer_id, sale_date) as rn 
		from sales s
		inner join products p 
		on s.product_id = p.product_id 
		inner join employees e 
		on e.employee_id = s.sales_person_id
		inner join customers c 
		on c.customer_id = s.customer_id
		where p.price = 0		
	) as tab_zero_price
where tab_zero_price.rn = 1
order by tab_zero_price.customer_id;