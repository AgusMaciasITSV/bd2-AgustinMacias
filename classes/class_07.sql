use sakila;

-- 1
select title, rating, length
from film
where length <= ALL(
Select length from film
);
-- 2
select title, rating, length
from film
where length < ALL(
Select length from film
);
-- 3 (ALL/ANY)
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS 'Full Name',
    c.email AS 'Email',
    a.address AS 'Address',
    p.amount AS 'Lowest Payment',
    f.title AS 'Film Title'
FROM customer c
INNER JOIN address a ON a.address_id = c.address_id
INNER JOIN payment p ON p.customer_id = c.customer_id
-- Film Selection
INNER JOIN rental r ON r.rental_id = p.rental_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id

WHERE p.amount <= ALL (
    SELECT p2.amount
    FROM payment p2
    WHERE p2.customer_id = c.customer_id
)
ORDER BY p.amount DESC
LIMIT 20;
-- 3(MIN)
SELECT
	CONCAT(c.first_name,' ',c.last_name) AS 'Full Name',
    c.email AS 'Email',
    a.address AS 'Address',
    MIN(p.amount) AS 'Lowest Payment'
FROM customer c
INNER JOIN address a ON a.address_id = c.address_id
INNER JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.last_name,c.first_name,c.email,a.address;
-- 4
SELECT
	CONCAT(c.first_name,' ',c.last_name) AS 'Full Name',
    c.email AS 'Email',
    MIN(p.amount) AS 'Lowest Payment',
    MAX(p.amount) AS 'Highest Payment'
FROM customer c
INNER JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.last_name,c.first_name,c.email;
