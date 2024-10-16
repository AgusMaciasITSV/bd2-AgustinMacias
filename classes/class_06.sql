USE sakila;

-- 1
SELECT first_name, last_name
FROM actor a1
WHERE EXISTS(
	SELECT * FROM actor a2
    WHERE a1.last_name = a2.last_name
    AND a1.actor_id != a2.actor_id
)
ORDER BY last_name;
-- 2
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT *
    FROM film_actor fa
    WHERE fa.actor_id = a.actor_id
);
-- 3
SELECT c.customer_id,c.first_name,c.last_name
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) = 1 ;
;
-- 4
SELECT c.customer_id,c.first_name,c.last_name,COUNT(r.rental_id)
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) > 1 ;
;
-- 5
SELECT a.actor_id,a.first_name,a.last_name
FROM actor a
WHERE a.actor_id IN (
	SELECT fa.actor_id
    FROM film f
    INNER JOIN film_actor fa ON f.film_id = fa.film_id
    WHERE f.title LIKE 'BETRAYED REAR' OR f.title LIKE 'CATCH AMISTAD'
);
-- 6
SELECT a.actor_id,a.first_name,a.last_name
FROM actor a
WHERE a.actor_id IN(
	SELECT fa.actor_id
	FROM film_actor fa
	INNER JOIN film f ON f.film_id = fa.film_id
	WHERE f.title LIKE '%BETRAYED REAR%')
AND a.actor_id NOT IN(
	SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film f ON f.film_id = fa.film_id
    WHERE f.title LIKE '%CATCH AMISTAD%'
);
-- 7
SELECT a.actor_id,a.first_name,a.last_name
FROM actor a
WHERE a.actor_id IN(
	SELECT fa.actor_id
	FROM film_actor fa
	INNER JOIN film f ON f.film_id = fa.film_id
	WHERE f.title LIKE '%BETRAYED REAR%')
AND a.actor_id IN(
	SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film f ON f.film_id = fa.film_id
    WHERE f.title LIKE '%CATCH AMISTAD%'
);
-- 8
SELECT a.actor_id,a.first_name,a.last_name
FROM actor a
WHERE a.actor_id NOT IN(
	SELECT fa.actor_id
	FROM film_actor fa
	INNER JOIN film f ON f.film_id = fa.film_id
	WHERE f.title LIKE '%BETRAYED REAR%')
AND a.actor_id NOT IN(
	SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film f ON f.film_id = fa.film_id
    WHERE f.title LIKE '%CATCH AMISTAD%'
);