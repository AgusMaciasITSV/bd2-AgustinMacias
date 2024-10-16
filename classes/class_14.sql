USE sakila;

-- 1)
SELECT CONCAT(c.first_name,' ',c.last_name) full_name,a.address address,ci.city city
FROM customer c
INNER JOIN address a USING (address_id)
INNER JOIN city ci USING (city_id)
INNER JOIN country co USING (country_id)
WHERE co.country = 'Argentina';

-- 2)
SELECT f.title Title,l.name Language,
	CASE
		WHEN f.rating = 'G' THEN 'G (General Audiences) – All ages admitted.'
        WHEN f.rating = 'PG' THEN 'PG (Parental Guidance Suggested) – Some material may not be suitable for children.'
        WHEN f.rating = 'PG-13' THEN 'PG-13 (Parents Strongly Cautioned) – Some material may be inappropriate for children under 13.'
        WHEN f.rating = 'R' THEN 'R (Restricted) – Under 17 requires accompanying parent or adult guardian.'
        WHEN f.rating = 'NC-17' THEN 'NC-17 (Adults Only) – No one 17 and under admitted.'
        ELSE 'None'
	END AS Rating
FROM film f
INNER JOIN language l USING (language_id);

-- 3)
SELECT CONCAT(a.first_name,' ',a.last_name) Fullname,GROUP_CONCAT(f.title, ' ', f.release_year) AS 'Film'
FROM film f
INNER JOIN film_actor fa USING (film_id)
INNER JOIN actor a USING (actor_id)
WHERE CONCAT(a.first_name,' ',a.last_name) LIKE '%%' -- <---- Write name between the '%%'
GROUP BY actor_id;

-- 4)
SELECT f.title Film,CONCAT(c.first_name,' ',c.last_name) Customer,
	CASE 
		WHEN r.return_date IS NULL THEN 'No'
        ELSE 'Yes'
	END Returned
FROM rental r
INNER JOIN customer c USING (customer_id)
INNER JOIN inventory i USING (inventory_id)
INNER JOIN film f using (film_id);

-- 5) CAST and CONVERT functions

-- CAST: Converts a value to a specified data type (standard SQL).
SELECT payment_id, amount, CAST(amount AS SIGNED) AS amount_int FROM payment;

-- CONVERT: Also converts a value to a specified data type (MySQL-specific syntax).
SELECT payment_id, amount, CONVERT(amount, SIGNED) AS amount_int FROM payment;


-- 6) NVL, ISNULL, IFNULL, COALESCE functions

-- NVL: Oracle only. Replaces NULL with a specified value.
-- NVL(expression, replacement_value) -- Oracle

-- ISNULL: Replaces NULL with a specified value (MySQL, SQL Server).
SELECT ISNULL(manager_id, 'No Manager') FROM employees;

-- IFNULL: MySQL-specific. Replaces NULL with a specified value.
SELECT IFNULL(return_date, 'Not Returned') FROM rental;

-- COALESCE: Returns the first non-NULL value from a list (available in most DBs).
SELECT COALESCE(return_date, rental_date, 'No Date') FROM rental;
