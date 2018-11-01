-- 1a. Display the first and last names of all actors from the table actor.

SELECT distinct first_name,last_name FROM sakila.actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT CONCAT(upper(first_name), " ", upper(last_name)) AS "Actor Name" FROM sakila.actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM sakila.actor WHERE UPPER(first_name) = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT * FROM sakila.actor WHERE  UPPER(last_name) LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

SELECT * FROM sakila.actor WHERE UPPER(last_name) LIKE '%LI%' ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT country_id, country FROM sakila.country WHERE UPPER(country) IN ('AFGHANISTAN', 'BANGLADESH', 'CHINA');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).

ALTER TABLE sakila.actor ADD COLUMN description BLOB AFTER last_name;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE sakila.actor DROP COLUMN description ;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, count(*) FROM sakila.actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, count(*) FROM sakila.actor GROUP BY last_name HAVING count(*) >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE sakila.actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE sakila.actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE sakila.address

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,paymentpayment
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) 

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT a.first_name, a.last_name, b.address  FROM sakila.staff a, sakila.address b WHERE a.address_id = b.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT a.staff_id, SUM(b.amount)  FROM sakila.staff a, sakila.payment b WHERE a.staff_id = b.staff_id AND DATE_FORMAT(b.payment_date, '%Y-%m') = '2005-08' GROUP BY a.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT b.title, count(DISTINCT a.actor_id) "Total Actors" FROM sakila.film_actor a , sakila.film b WHERE a.film_id = b.film_id GROUP BY b.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT b.title, count(a.inventory_id)  as "Total Copies" FROM sakila.inventory a, sakila.film b WHERE a.film_id = b.film_id AND UPPER(b.title) = 'HUNCHBACK IMPOSSIBLE' GROUP BY b.title;


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

SELECT b.first_name, b.last_name, sum(amount) as "Total Amount Paid"  FROM sakila.payment a , sakila.customer b WHERE a.customer_id = b.customer_id GROUP BY b.first_name, b.last_name ORDER BY b.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
--     As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
--     Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT a.title as "Movie Title" from sakila.film a 
       WHERE a.language_id IN (SELECT b.language_id 
                               FROM sakila.language b 
							   WHERE UPPER(b.name) = 'ENGLISH')
	   AND UPPER(a.title) LIKE 'K%' OR UPPER(a.title) LIKE 'Q%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT a.first_name, a.last_name 
FROM sakila.actor a 
WHERE a.actor_id IN (SELECT b.actor_id 
					 FROM sakila.film_actor b , sakila.film c
					 WHERE b.film_id = c.film_id
					 AND UPPER(c.title) = 'ALONE TRIP');
                                                  

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.


                                           
SELECT a.first_name AS "Customer First Name", a.last_name AS "Customer Last Name", a.email "Customer email" 
FROM sakila.customer a , sakila.address b, sakila.city c, sakila.country d
WHERE a.address_id = b.address_id
AND c.country_id = d.country_id
AND b.city_id = c.city_id
AND UPPER(d.country) = 'CANADA';
 
 
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.


                     
                     
SELECT a.title AS "Family Movie Title" 
FROM sakila.film a , sakila.film_category b , sakila.category c
WHERE a.film_id = b.film_id
AND b.category_id = c.category_id 
AND UPPER(c.name) = 'FAMILY';

-- 7e. Display the most frequently rented movies in descending order.



SELECT DISTINCT d.title "Frequently Rented Movies" 
FROM (SELECT a.title, count(c.rental_id)  
FROM sakila.film a , sakila.inventory b, sakila.rental  c
WHERE a.film_id = b.film_id 
AND  b.inventory_id = c.inventory_id
GROUP BY a.title
ORDER BY count(c.rental_id) desc) AS d;


-- 7f. Write a query to display how much business, in dollars, each store brought in.


SELECT d.store_id, CONCAT('$', d.Total_Amount) AS "Total Amount" 
FROM (SELECT c.store_id, sum(a.amount) AS "Total_Amount"
FROM sakila.payment a, sakila.staff b, sakila.store c 
WHERE a.staff_id = b.staff_id
AND b.store_id = c.store_id
GROUP BY c.store_id) AS d;


-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT a.store_id AS "Store ID", c.city AS "City", d.country AS "Country"
FROM sakila.store a, sakila.address b , sakila.city c, sakila.country d
WHERE a.address_id = b.address_id
AND b.city_id = c.city_id
AND c.country_id = d.country_id;


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT a.name AS "Genre", sum(e.amount) AS "Gross Revenue"
FROM sakila.category a , sakila.film_category b, sakila.inventory c ,  sakila.rental d, sakila.payment e
WHERE a.category_id = b.category_id
AND b.film_id = c.film_id
AND c.inventory_id = d.inventory_id
AND d.rental_id = e.rental_id
GROUP BY a.name 
ORDER BY sum(e.amount) desc
LIMIT 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.


CREATE OR REPLACE VIEW top_five_genres AS 
(SELECT a.name AS "Genre", sum(e.amount) AS "Gross Revenue"
FROM sakila.category a , sakila.film_category b, sakila.inventory c ,  sakila.rental d, sakila.payment e
WHERE a.category_id = b.category_id
AND b.film_id = c.film_id
AND c.inventory_id = d.inventory_id
AND d.rental_id = e.rental_id
GROUP BY a.name 
ORDER BY sum(e.amount) desc
LIMIT 5);

-- 8b. How would you display the view that you created in 8a?

select * from sakila.top_five_genres;


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW IF EXISTS sakila.top_five_genres;
