use sakila;
-- 1)
select title,special_features from film
where rating = 'PG-13';
-- 2)
select distinct length from film
order by length desc;
-- 3)
select title, rental_rate, replacement_cost from film
where replacement_cost between 20 and 24;
-- 4)
select f.title, c.name as Category, f.rating
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on c.category_id = fc.category_id
where f.special_features like '%Behind the Scenes%';
-- 5)
select a.first_name,a.last_name from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on f.film_id = fa.film_id
where f.title = 'ZOOLANDER FICTION';
-- 6)
select s.store_id,a.address,c.city,cou.country
from store s
inner join address a on a.address_id=s.address_id
inner join city c on c.city_id = a.city_id
inner join country cou on cou.country_id = c.country_id
where s.store_id = 1;
-- 7)
select f1.title as film1, f2.title as film2, f1.rating
from film f1
inner join film f2 on f1.rating = f2.rating
where f1.film_id<f2.film_id;
-- 8)
select  s.store_id,m.name,f.title
from store s
inner join staff_list m on m.SID = s.store_id
inner join inventory i on i.store_id = s.store_id
inner join film f on f.film_id = i.film_id
where s.store_id = 2
group by f.title,s.store_id,m.name;