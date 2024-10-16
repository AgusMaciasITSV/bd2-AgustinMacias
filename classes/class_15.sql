USE sakila;

-- 1)
CREATE OR REPLACE VIEW list_of_customers AS
SELECT c.customer_id id, 
CONCAT(c.first_name,' ',c.last_name) full_name,
a.address,
a.postal_code,
a.phone,
ci.city,
co.country,
CASE
	WHEN c.active = 1 THEN 'Active'
	ELSE 'Inactive'
END status,
c.store_id
FROM customer c
INNER JOIN address a USING (address_id)
INNER JOIN city ci USING (city_id)
INNER JOIN country co USING (country_id);

SELECT * FROM list_of_customers;

-- 2)
CREATE OR REPLACE VIEW film_details AS
SELECT f.film_id id,
f.title,
f.description,
c.name category,
f.rental_rate rental_price,
f.length,
f.rating,
GROUP_CONCAT(CONCAT(a.first_name,' ',a.last_name) SEPARATOR ',') actors
FROM film f
JOIN film_category fc USING (film_id)
JOIN category c USING (category_id)
JOIN film_actor fa USING (film_id)
JOIN actor a USING (actor_id)
GROUP BY f.film_id,category;

SELECT * FROM film_details;

-- 3)
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT c.name category, 
SUM(p.amount) total_rental
FROM payment p
JOIN rental r USING (rental_id)
JOIN inventory i USING (inventory_id)
JOIN film f USING (film_id)
JOIN film_category ca USING (film_id)
JOIN category c USING (category_id)
GROUP BY c.category_id;

SELECT * FROM sales_by_film_category;

-- 4)
CREATE OR REPLACE VIEW actor_information AS
SELECT 
	a.actor_id,
	a.first_name,
	a.last_name,
	COUNT(f.film_id) amount_films
FROM actor a
JOIN film_actor fa USING (actor_id)
JOIN film f USING (film_id)
GROUP BY a.actor_id;

SELECT * FROM actor_information;

-- 5) Analysis of the actor_info view from Sakila DB
/*
View Explanation:
The actor_info view provides a detailed listing of actors along with the films they have appeared in, categorized by film genres.

Query breakdown:

1. SELECT a.actor_id, a.first_name, a.last_name: 
Retrieves the actor's ID, first name, and last name from the actor table.

2. GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ', (...) ) ORDER BY c.name SEPARATOR '; ') AS film_info: 
This is the key part of the query:
GROUP_CONCAT: Concatenates film information for each actor.
DISTINCT: Ensures unique combinations of category and film titles.
CONCAT(c.name, ': ', ...): Concatenates the category name followed by film titles.

3. Subquery (inside CONCAT):
   (SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
    FROM sakila.film f
    INNER JOIN sakila.film_category fc ON f.film_id = fc.film_id
    INNER JOIN sakila.film_actor fa ON f.film_id = fa.film_id
    WHERE fc.category_id = c.category_id
    AND fa.actor_id = a.actor_id)
*/

-- 6) Materialized Views
/*
Materialized views are database objects that store the result of a query physically, like a table. 
They are used to improve performance, especially when dealing with complex queries on large datasets.
Unlike regular views, materialized views store the actual data, so they don't need to re-execute the query each time.

Why they are used:
- Improves query performance.
- Reduces the load on frequently queried large datasets.

Alternatives:
- Regular views (but they don't store data).
- Temporary tables or caching layers.
- DBMS where materialized views exist: Oracle, PostgreSQL, SQL Server (called indexed views), DB2.

Note: MySQL does not support materialized views directly, but you can simulate them by manually creating tables and refreshing them with data.
*/
