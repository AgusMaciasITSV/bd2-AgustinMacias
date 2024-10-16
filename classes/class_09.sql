use sakila;

-- 1
select co.country_id,co.country,COUNT(ci.city_id)
from country co
inner join city ci using (country_id)
group by country_id
order by co.country,co.country_id;

-- 2
select co.country_id,co.country,count(ci.city_id) AS cityAmount
from country co
inner join city ci using (country_id)
group by co.country,co.country_id
having cityAmount >= 10
order by cityAmount desc;
-- 3
select cu.first_name,cu.last_name,a.address,count(r.rental_id),sum(p.amount) as TotalSpent
from customer cu
inner join address a using(address_id)
inner join payment p using(customer_id)
inner join rental r using (rental_id)
group by cu.customer_id
order by TotalSpent desc;
-- 4
select c.name,avg(f.length)
from category c
inner join film_category fc using (category_id)
inner join film f using (film_id)
group by c.name
order by avg(f.length) desc;
-- 5
select f.rating as Rating,sum(p.amount) as VentasTotales 
from rental r
inner join inventory i using (inventory_id)
inner join film f using (film_id)
inner join payment p using (rental_id)
group by Rating
order by VentasTotales desc;