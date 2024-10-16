USE sakila;

-- 1)

DROP FUNCTION IF EXISTS film_copies_by_store;
DELIMITER $$

CREATE FUNCTION film_copies_by_store(
	store_id_input INT,
    film_name_input VARCHAR(50)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE films_amount INT;

    SELECT COUNT(f.film_id) INTO films_amount
    FROM film f
    JOIN inventory i USING (film_id)
    WHERE i.store_id = store_id_input
    AND f.title LIKE 'ACADEMY DINOSAUR';

    RETURN films_amount;
END$$

DELIMITER ;

SELECT film_copies_by_store(1,'ACADEMY') AS 'Film amount';

-- 2)
DROP PROCEDURE IF EXISTS customersByCountry;
DELIMITER $$
CREATE PROCEDURE customersByCountry(
	IN country_input VARCHAR(20),
    OUT customer_list TEXT
)
BEGIN
	DECLARE cur_finished INT DEFAULT 0;
    DECLARE customerText TEXT DEFAULT '';
    DECLARE current_customer VARCHAR(50);
    
    DECLARE customer_cursor CURSOR 
    FOR 
		SELECT CONCAT(c.first_name,' ',c.last_name)
        FROM customer c
        JOIN address USING (address_id)
        JOIN city USING (city_id)
        JOIN country co USING (country_id)
        WHERE co.country LIKE country_input;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET cur_finished = 1;
    
	OPEN customer_cursor;
	
    get_customer_name: LOOP
        FETCH customer_cursor INTO current_customer;
        
        IF cur_finished = 1
			THEN LEAVE get_customer_name;
		END IF;
        
		IF customerText = '' THEN
            SET customerText = current_customer;
        ELSE
            SET customerText = CONCAT(customerText, ';', current_customer);
        END IF;
        
	END LOOP get_customer_name;
	CLOSE customer_cursor;
    
    SET customer_list = customerText;
    
END $$
DELIMITER ;

CALL customersByCountry('Argentina',@customers);
SELECT @customers AS 'Argentina';

-- 3)
/*
The function inventory_in_stock is used to determine if a specific item in the store's inventory is available (in stock). 
The process works like this: the function takes an inventory_id as a parameter. First, it checks whether any rentals exist for that item by counting the rows in the rental table 
that match the given inventory_id. If no rentals are found, the function returns TRUE, indicating that the item is in stock (meaning it was never rented, thus it is in stock).
If there are rentals, the function moves on to the next step. In this step, it checks whether any of the rental records for that item have a return_date
that is still NULL, indicating that the item hasn't been returned yet. If no such rentals are found (all rentals have been returned), 
the function returns TRUE, as the item is back in stock. If at least one rental still has a NULL return_date, the function returns FALSE, meaning the item is still rented out.

The procedure film_in_stock serves a similar purpose but on a larger scale, determining how many copies of a specific film are available in a particular store. 
It takes two input parameters: p_film_id and p_store_id. The procedure operates in two steps: First, it retrieves the inventory_id for all items in the inventory table 
that match the provided film_id and store_id. Availability is then checked using the inventory_in_stock function described earlier. 
Next, it counts how many of those film copies are available (those that passed the inventory_in_stock check) and stores this count in the p_film_count variable, 
which is returned to show how many copies of the film are available for rent in the specified store.
*/

