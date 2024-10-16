USE sakila;
-- 1)
-- Enable profiling to measure times.
SET profiling = 1;

-- Using IN operator
SELECT a.address_id, a.address, a.postal_code, c.city, co.country 
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code IN ('12345', '67890');

-- Using NOT IN operator
SELECT a.address_id, a.address, a.postal_code, c.city, co.country 
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code NOT IN ('12345', '67890');

-- Check execution profiles
SHOW PROFILES;
-- Create an index on postal_code and re-run the queries.
CREATE INDEX idx_postal_code ON address(postal_code);
-- Check execution profiles again
SHOW PROFILES;

-- Without Index: The queries will likely take longer to execute because the database has to perform a full table scan to find matching rows.
-- With Index: After creating the index on postal_code, the execution time should decrease significantly. The database can quickly locate the rows matching the specified postal codes using the index, thus improving query performance.



-- 2)

-- Search for first name
SELECT actor_id, first_name 
FROM actor 
WHERE first_name LIKE 'A%';

-- Search for last name
SELECT actor_id, last_name 
FROM actor 
WHERE last_name LIKE 'B%';

SHOW PROFILES;
-- Explain Differences:
-- When searching independently by first name or last name, you may notice different execution times or results. This can occur due to:
-- Data Distribution: If one column has more unique values than the other, it may affect the speed and efficiency of the search.
-- Indexing: If one of the columns is indexed and the other is not, queries on the indexed column will generally perform faster.
-- Data Size: If the size of the data retrieved from one column is significantly smaller than the other, it will execute faster.

-- 3)

-- Using LIKE to search description in film
SELECT film_id, description 
FROM film 
WHERE description LIKE '%action%';

-- We create the required fulltext index.
ALTER TABLE film_text
ADD FULLTEXT(description);

-- Using MATCH...AGAINST to search in film_text
SELECT film_id, description 
FROM film_text 
WHERE MATCH(description) AGAINST('action');
-- We compare
SHOW PROFILES;

-- Explanation:
-- LIKE: This method performs a pattern match but is generally slower, especially for large datasets, as it does not use full-text indexing.
-- MATCH...AGAINST: This method is faster because it utilizes full-text indexing and performs more sophisticated searching algorithms,
-- enabling better performance and relevance ranking of results.
