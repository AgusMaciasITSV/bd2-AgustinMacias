USE sakila;
-- 1
Select f.film_id,f.title
from inventory i 
right outer join film f using (film_id)
where i.inventory_id IS NULL;
-- 2
select i.inventory_id,f.title
from inventory i
inner join film f using (film_id)
left outer join rental r using (inventory_id)
where r.rental_id IS NULL;
-- 3
select 
	c.first_name as 'First Name',
    c.last_name as 'Last Name',
    i.store_id as 'Store ID',
    f.title as 'Film Title',
    r.rental_date as 'Rental Date',
    r.return_date 'Return Date'
from rental r
inner join customer c using (customer_id)
inner join inventory i using (inventory_id)
inner join film f using (film_id)
order by i.store_id,c.last_name;
-- 4
select 
	concat(c.city,',',co.country) store_location,
    concat(s.first_name,' ',s.last_name) full_name,
    sum(p.amount) total_sales
from payment p
inner join staff s using (staff_id)
inner join store st using (store_id)
inner join address a ON  a.address_id = st.address_id
inner join city c using (city_id)
inner join country co using (country_id)
group by store_location,full_name;
-- 5
select 
	a.actor_id,
    concat(a.first_name,' ',a.last_name) actor_name,
    count(fa.film_id) film_count
from film_actor fa
inner join actor a using (actor_id)
group by a.actor_id
order by film_count desc
limit 1;