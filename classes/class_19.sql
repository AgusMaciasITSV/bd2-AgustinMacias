-- 1)
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'bd2';

-- 2)
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';
FLUSH PRIVILEGES;

-- 3)
-- mysql -u data_analyst -p
USE sakila;
CREATE TABLE test_table (
  id INT PRIMARY KEY,
  name VARCHAR(50)
);
-- The following error is returned:
-- ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'test_table'

-- 4)
UPDATE film SET title = 'Test'
WHERE film_id = 1;

SELECT title FROM film
WHERE film_id = 1; -- We see the changes made

-- 5)
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
FLUSH PRIVILEGES;

-- 6)
-- Returned Error:
-- ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'