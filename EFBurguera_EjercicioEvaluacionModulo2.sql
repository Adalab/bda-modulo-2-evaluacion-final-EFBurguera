/* EJERCICIOS DE EVALUACIÓN DEL MÓDULO 2*/

-- So that these exercises can be used as reference and reused, instructions have also been translated to English

-- These exercises use the Sakila Database
-- Vamos a usar la BBDD Sakila 
USE sakila;

-- 1. Select all film titles without duplicates 
-- Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
FROM film;

-- 2. Show all films with a PG-13 rating
-- Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT DISTINCT f.title
FROM film AS f
WHERE f.rating = 'PG-13';

-- 3. Find title and description of all films with the word "amazing" in their description
-- Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT f.title, f.description
FROM film AS f
WHERE f.description LIKE ('%amazing%');

-- 4. Find the title of all films longer than 120 minutes
-- Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT DISTINCT f.title
FROM film AS f
WHERE f.length > 120;

-- 5. Extract the full names of all actors
-- Recupera los nombres de todos los actores.
SELECT CONCAT(a.last_name,', ', a.first_name)
FROM actor AS a;

-- 6. Find first and last name of actors that contain "Gibson" in their last name
-- Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT CONCAT(a.last_name,', ', a.first_name)
FROM actor AS a 
WHERE a.last_name = 'Gibson';

-- 7. Find full names for actors with actor_id between 10 and 20
-- Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT DISTINCT CONCAT(a.last_name,', ', a.first_name)
FROM actor AS a 
WHERE a.actor_id BETWEEN 10 AND 20;

-- 8. Find film titles of films not pertaining to ratings 'R' and 'PG-13'
-- Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT DISTINCT f.title
FROM film AS f
WHERE f.rating NOT IN ('R', 'PG-13');

-- 9. Find total number of film in each rating group, and show the classification with the film counts
-- Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT f.rating AS rating, COUNT(DISTINCT f.film_id) AS films_per_rating_category
FROM film AS f
GROUP BY f.rating;

/* 10. Find the number of films rented by each customer and show their customer_id, first_name, last_name, 
with the number of rented films

Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto 
con la cantidad de películas alquiladas.*/
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rentals
FROM customer AS c
JOIN rental AS r
USING (customer_id)
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rentals DESC;

-- 11. Find the total amount of films rented by category and show the category name with the rented film counts
-- Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
WITH films_per_category AS (
		SELECT fc.category_id, COUNT(fc.film_id) AS FilmNumber
        FROM film_category AS fc
        GROUP BY fc.category_id)

SELECT cat.name, fpc.FilmNumber
FROM category AS cat
JOIN films_per_category AS fpc
ON fpc.category_id = cat.category_id
ORDER BY fpc.FilmNumber DESC;



/* 12. Find the average film length for films in each rating group and show the rating classification with its respective average length.
Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación 
junto con el promedio de duración.*/
SELECT f.rating, ROUND(AVG(length),1) AS AverageLength
FROM film AS f
GROUP BY f.rating;


-- 13. Find first and last name of actor acting in the film "Indian Love".
-- Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT CONCAT(a.last_name,', ', a.first_name)
FROM actor AS a
WHERE a.actor_id IN (
	SELECT fa.actor_id
    FROM film_actor AS fa
	WHERE fa.film_id IN (
		SELECT f.film_id
        FROM film AS f
        WHERE f.title = 'Indian Love'));


-- 14. Show the title of all films containing words "dog" or "cat" in their description
-- Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT f.title
FROM film AS f
WHERE f.description LIKE ('%dog%')
UNION ALL -- Using UNION you get 167 films; whereas using UNION ALL you get 169. Ergo, there are two films that contain both words
SELECT f.title
FROM film AS f
WHERE f.description LIKE ('%cat%');

-- 15. Is there any actor that does not act in any film?
-- Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT a.last_name, a.first_name
FROM actor AS a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
    FROM film_actor AS fa); -- There isn't any, all actors appear in at least one film

-- 16. Find the titles of all films released between years 2005 and 2010.
-- Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT f.title
FROM film AS f
WHERE release_year BETWEEN 2005 AND 2010; -- This extracts 1000 rows as a result. To check, we can run the following query:

SELECT release_year
FROM film; -- We check all movies were released in 2006. So the above is correct


-- 17. Find the title of all film in the "Family" category.
-- Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title
FROM film AS f
WHERE f.film_id IN (
	SELECT fc.film_id
    FROM film_category AS fc
    WHERE fc.category_id IN (
		SELECT cat.category_id
        FROM category AS cat
        WHERE cat.name = 'Family'));

-- 18. Show the full names of actors acting in more than 10 different films.
-- Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT CONCAT(a.last_name, ', ', a.first_name) AS actors_and_actresses
FROM actor AS a
JOIN film_actor AS fa
USING (actor_id)
GROUP BY fa.actor_id
HAVING COUNT(fa.film_id) > 10; -- All actors have participated in more than 10 films

SELECT actor_id, COUNT(film_id) -- This checks how many actors have acted in less than 10 films, resulting in 0 actors
from film_actor
GROUP BY actor_id
HAVING COUNT(film_id) <10;

-- 19. Find the title of all films that are rated 'R' and their lenght is longer than 2 hours, in the film table.
-- Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT f.title
FROM film AS f
WHERE f.rating = 'R' AND f.length > 120;


/* 20. Find film categories that have an average length longer than 120 minutes and show the categories names together with their average length.

Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y 
muestra el nombre de la categoría junto con el promedio de duración.*/
SELECT cat.name, ROUND(AVG(f.length)) AS average_length
FROM category AS cat
JOIN film_category AS fc
USING(category_id)
JOIN film AS f
USING(film_id)
GROUP BY cat.name
HAVING average_length > 120;


/* 21. Find actors who have acted in at least 5 films and show the actor name together with the number of films she/he has acted in.
Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la 
cantidad de películas en las que han actuado.*/

WITH Film_count AS ( -- CTE to obtain the number of films per actor/actress
	SELECT fa.actor_id, COUNT(fa.film_id) AS movies_per_actor 
    FROM film_actor AS fa
    GROUP BY fa.actor_id
    HAVING COUNT(fa.film_id) > 5)
    
SELECT a.last_name, a.first_name, fc.movies_per_actor
FROM actor AS a
JOIN Film_count AS fc
ON fc.actor_id = a.actor_id
ORDER BY fc.movies_per_actor DESC;


/* 22. Find the title for all film that were rented for longer than 5 days. Use a subquery to find the rental_ids with lengths over 5 days, then select the corresponding films 
Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días 
y luego selecciona las películas correspondientes.*/

SELECT f.title, r.rental_id
FROM film AS f
JOIN inventory AS i
USING(film_id)
JOIN rental AS r
USING(inventory_id)
WHERE r.rental_id IN (
	SELECT rental_id 
	FROM rental
	WHERE DATEDIFF(DATE(return_date), DATE(rental_date)) > 5);

/* 23. Find the names of the actors that have not acted in any film in the 'Horror' category.
Use a subquery to find the actors that have acted in any film in the 'Horror' category, then delete them from the actor list

Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" 
y luego exclúyelos de la lista de actores.*/

-- This query identifies all actors/actresses that HAVE NOT acted in movies in 'Horror' category
SELECT DISTINCT CONCAT(a.last_name,', ', a.first_name)
FROM actor AS a
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id
    FROM film_actor AS fa
    WHERE fa.film_id IN (
		SELECT fc.film_id
        FROM film_category AS fc
        LEFT JOIN category AS cat
        ON fc.category_id = cat.category_id
        WHERE cat.name = 'Horror'));



-- This query identifies all actors/actresses that HAVE acted in movies in 'Horror' category
SELECT DISTINCT CONCAT(a.last_name,', ', a.first_name)
FROM actor AS a
WHERE a.actor_id IN (
	SELECT fa.actor_id
    FROM film_actor AS fa
    WHERE fa.film_id IN (
		SELECT fc.film_id
        FROM film_category AS fc
        LEFT JOIN category AS cat
        ON fc.category_id = cat.category_id
        WHERE cat.name = 'Horror'));
    
/*Actors that acted in Horror movies plus Actors that did not act in Horror movies should sum up to 200
But instead results from both querys result in 199 actors. Something doesn't add up, but I cannot find what*/    

-- Before making a query to delete a big chunk of the actor table, lets make a copy to have a backup in case something goes wrong 
CREATE TABLE actor_backup LIKE actor;

-- * Check the structure of the table is correct
SELECT *
FROM actor_backup; -- it seems correct

-- Insert actor data into actor_backup table
INSERT INTO actor_backup SELECT * FROM actor;

-- * Check the data of the table is correct
SELECT *
FROM actor_backup; -- Again, this seems correct, so both tables are identical

-- Lets try the DELETE query in the backup table now
DELETE FROM actor_backup AS ab
WHERE ab.actor_id IN (
	SELECT fa.actor_id
    FROM film_actor AS fa
		JOIN film_category AS fc
		USING(film_id)
		WHERE fc.category_id IN ( -- This subquery identifies all actors/actresses that HAVE acted in movies in 'Horror' category
			SELECT cat.category_id
			FROM category AS cat
			WHERE name = 'Horror'));
 
-- Lets check now what actors remain in the 'Horror' category in the backup table with the query constructed above
SELECT DISTINCT CONCAT(ab.last_name,', ', ab.first_name)
FROM actor_backup AS ab
JOIN film_actor AS fa
USING(actor_id)
JOIN film_category AS fc
USING(film_id)
WHERE fc.category_id IN ( 
	SELECT cat.category_id
    FROM category AS cat
    WHERE name = 'Horror');	-- As expected this query returns 0 results

-- Lets do the same then in the actor table. But for further security, I will backup the actor table again
CREATE TABLE actor_backup_2 LIKE actor;
INSERT INTO actor_backup_2 SELECT * FROM actor;

-- Now to delete from actor
DELETE FROM actor AS a
WHERE a.actor_id IN (
	SELECT fa.actor_id
    FROM film_actor AS fa
		JOIN film_category AS fc
		USING(film_id)
		WHERE fc.category_id IN ( 
			SELECT cat.category_id
			FROM category AS cat
			WHERE name = 'Horror'));

/* Ups! This cannot be done, there is a Foreing Key restriction in this table (ON DELETE RESTRICT) that, in order to mantain referencial integrity within the database,
does not allow to delete from it 

However, the code used above in the backup table would delete that part of the table if this FK restriction did not exist */



--  BONUS --

-- 24. BONUS: Find film title of movies that are in 'Comedy' and have a length longer than 180 min from the film table
-- Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

WITH comedy AS ( -- This CTE selects the category id for comedy films
	SELECT cat.category_id
    FROM category AS cat
    WHERE cat.name = 'Comedy'),

too_long AS ( -- This CTE selects the film id and title for films that are longer than 3 hours
	SELECT f.film_id, f.title
    FROM film AS f
    WHERE f.length > 180)
    
SELECT c.category_id AS comedy_category, tl.title AS long_film_title
FROM comedy AS c
JOIN film_category AS fc
ON c.category_id = fc.category_id
JOIN too_long AS tl
ON fc.film_id = tl.film_id
ORDER BY c.category_id;


/* 25. BONUS: Find all actors that have acted together in at least one film. The query must show first and last name of the actors
 and the number of film in common.

Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.*/

WITH actor_pairs AS (
	SELECT fa1.actor_id AS actor1_id, fa2.actor_id AS actor2_id, COUNT(*) AS films_in_common
	FROM film_actor AS fa1
	JOIN film_actor AS fa2
	ON fa1.film_id = fa2.film_id
    WHERE fa1.actor_id <> fa2.actor_id
    GROUP BY actor1_id, actor2_id)


SELECT a1.last_name, a1.first_name, a2.last_name, a2.first_name, ap.films_in_common
FROM actor_pairs AS ap
LEFT JOIN actor AS a1
ON a1.actor_id = ap.actor1_id
LEFT JOIN actor AS a2
ON ap.actor2_id = a2.actor_id
WHERE films_in_common >= 1;














WITH actors_per_film AS (
	SELECT f.film_id, a.last_name, a.first_name 
    FROM actor AS a
    JOIN film_actor AS fa
    USING(actor_id)
    JOIN film AS f
    USING(film_id)
    ORDER BY film_id),
    
films_per_actor AS (
	SELECT a.last_name, a.first_name, f.film_id
    FROM actor AS a
    JOIN film_actor AS fa
    USING(actor_id)
    JOIN film AS f
    USING(film_id)
    ORDER BY actor_id);

-- Probamos otra historia

WITH actor1 AS (
	SELECT last_name, first_name, film_id, actor_id
    FROM actor AS a
    JOIN film_actor AS f
    USING(actor_id)),
    
actor2 AS (
	SELECT last_name, first_name, film_id, actor_id
    FROM actor AS a
    JOIN film_actor AS f
    USING(actor_id))
    
SELECT a1.last_name, a1.first_name, a1.film_id
FROM actor1 AS a1
JOIN actor2 AS a2
ON a1.actor_id = a2.actor_id
WHERE a1.film_id = a2.film_id AND 
		a1.actor_id <> a2.actor_id;
		


















