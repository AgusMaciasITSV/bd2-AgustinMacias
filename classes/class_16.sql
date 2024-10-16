USE sakila;
DROP TABLE employees;
DROP TABLE employees_audit;


-- 1)
CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);
insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 

(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),

(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),

(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');

CREATE TABLE employees_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employeeNumber INT NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    changedat DATETIME DEFAULT NULL,
    action VARCHAR(50) DEFAULT NULL
);
-- ---------------------------------------------------------------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER before_employee_update 
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    INSERT INTO employees_audit
    SET action = 'update',
     employeeNumber = OLD.employeeNumber,
        lastname = OLD.lastname,
        changedat = NOW(); 
END$$
DELIMITER ;

DROP TRIGGER before_employee_update;

-- 2)
UPDATE employees SET employeeNumber = employeeNumber - 20;
SELECT * FROM employees_audit;
SELECT * FROM employees;

-- What happened here is that the employeeNumber atribute was reduced by 20 for each instance or row in the employees table.alter

UPDATE employees SET employeeNumber = employeeNumber + 20;
SELECT * FROM employees_audit;
SELECT * FROM employees;

-- Error Code: 1062. Duplicate entry '1016' for key 'employees.PRIMARY'
-- Here it tries to reverse employeeNumber to its original number, it does so by adding 20 to each row IN THE ORDER THEY WERE DECLARED. This means
-- that it will try to add 20 to each employeeNumber, so when it tries to add 20 to 1036 it returns an error, this is because the third instance already has
-- employeeNumber as '1056' (which was second's instance original vaule) thus, this error is returned.

-- 3)
ALTER TABLE employees
ADD age INT CHECK (age BETWEEN 16 AND 70);

-- 4)
-- Referential Integrity between 'film', 'actor', and 'film_actor' tables:

-- The 'film_actor' table establishes a many-to-many relationship between 'film' and 'actor'.
-- It has foreign keys:
-- 1. 'film_id' references 'film.film_id'
-- 2. 'actor_id' references 'actor.actor_id'

-- This ensures:
-- - A record in 'film_actor' cannot exist without valid entries in both `film` and 'actor'.
-- - Deleting or updating records in 'film' or 'actor' affects the corresponding entries in 'film_actor' based on the defined foreign key constraints.

-- 5)
ALTER TABLE `employees`
ADD COLUMN `lastUpdate` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN `lastUpdateUser` VARCHAR(50) NOT NULL;


CREATE TRIGGER before_employee_insert
BEFORE INSERT ON `employees`
FOR EACH ROW
	SET NEW.lastUpdate = NOW(),
    NEW.lastUpdateUser = USER();


CREATE TRIGGER before_employee_update
BEFORE UPDATE ON `employees`
FOR EACH ROW
SET NEW.lastUpdate = NOW(),
    NEW.lastUpdateUser = USER();

DROP TRIGGER before_employee_insert;
DROP TRIGGER before_employee_update;
-- 6)
/*
film_text has 3 triggers related to loading it:

CREATE TRIGGER `ins_film` 
AFTER INSERT ON `film` 
FOR EACH ROW 
BEGIN
    INSERT INTO film_text (film_id, title, description)
	VALUES (new.film_id, new.title, new.description);
END;;
  
This trigger creates an insert into the film_text table after a film is created taking the values of the newly created
film for its fields. This means after film is inserted, the values of its film_id, title and description will also be used to create
a film_text insert. 

CREATE TRIGGER `del_film`
AFTER DELETE ON `film`
FOR EACH ROW 
BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
END;;
  
This trigger is the direct opposite of the previous one, as it ensures referential integrity by deleting the film_text row associated with the film that is being deleted.

CREATE TRIGGER `upd_film`
AFTER UPDATE ON `film`
FOR EACH ROW
BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
END;;


This trigger, very similarly to the previous two, is used to ensure data integrity, as it establishes that title, description and film_id match their respective values in the
film_text table (it keeps it up to date).

Summarizing, these triggers play an important role in keeping referential and data integrity across film and film_text.
*/