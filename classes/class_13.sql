USE sakila;

-- 1
INSERT INTO customer(first_name,last_name,store_id,create_date,address_id)
VALUES(
	'Test',
    'Customer',
    1,
    NOW(),
 (select max(a.address_id)
 from address a
 inner join city c using (city_id)
 inner join country co using (country_id)
 where co.country_id = 103)
 );
-- 2
insert into rental
(rental_date,inventory_id,customer_id,staff_id)
values (
	now(),
    (
		select max(i.inventory_id)
        from inventory i
        inner join film f using (film_id)
        where f.title LIKE '%PRIDE ALAMO%'
    ),
    (
		select max(customer_id)
        from customer
    ),
    (
		select staff_id
        from staff
        where store_id = 2
    )
);
-- 3
update film
set release_year = 2001
where rating = 'G';

update film
set release_year = 2002
where rating = 'PG';

update film
set release_year = 2003
where rating = 'PG-13';

update film
set release_year = 2004
where rating = 'NC-17';

update film
set release_year = 2005
where rating = 'R';
-- 4
update rental
set return_date = NOW()
where rental_id = (select rental_id where return_date IS NULL);
-- 5
DELETE FROM film_actor
WHERE film_id = 1;
DELETE FROM film_category
WHERE film_id = 1;

DELETE FROM rental
WHERE inventory_id IN (
	SELECT inventory_id
    FROM inventory
    WHERE film_id = 1
);
DELETE FROM inventory
WHERE film_id = 1;
DELETE FROM film
WHERE film_id = 1;
select film_id, title from film order by film_id asc;
-- 6
SELECT i.inventory_id
FROM inventory i
INNER JOIN film f using (film_id)
LEFT OUTER JOIN rental r using (inventory_id)
WHERE i.inventory_id NOT IN(
	SELECT r.inventory_id WHERE r.return_date IS NULL
)
limit 1; -- inventory_id = 9

insert into rental
(rental_date,inventory_id,customer_id,staff_id)
values (
	now(),
    9,
    (select min(customer_id) from customer),
    (select min(staff_id)from staff)
);
INSERT INTO payment
(customer_id,staff_id,rental_id,amount,payment_date)
VALUES(
	(SELECT customer_id
    FROM rental
    WHERE inventory_id = 9
    AND rental_id = 16052),
    (SELECT staff_id
    FROM rental
    WHERE inventory_id = 9
    AND rental_id = 16052),
    (SELECT rental_id
    FROM rental
    WHERE inventory_id = 9
    AND rental_id = 16052),
	10,
    NOW()
);