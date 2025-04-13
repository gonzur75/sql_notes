DELIMITER //

CREATE FUNCTION get_language(lang_id INT)
    RETURNS VARCHAR(20)
    DETERMINISTIC
    READS SQL DATA
    # MODIFIES SQL DATA modyfikuje dane
BEGIN
    DECLARE lang_name VARCHAR(20);
    # tworzy zmienną lokalną,
    # SET przypisuje wartość, może być lokalny lub w ramach sesji
    SELECT name
    INTO lang_name
    FROM language lan # to jest dobrym zwyczajem, ze względu na kolizje nazw
    WHERE lan.language_id = lang_id
    LIMIT 1;

    RETURN lang_name;

end //

DELIMITER ;

SELECT *
FROM language
LIMIT 501;

SELECT title, get_language(language_id) AS lang
FROM film
LIMIT 501;

SELECT *
FROM film
WHERE language_id <> 1
LIMIT 501;

# ile wypożyczeń ma dany klient
DELIMITER $$

CREATE FUNCTION count_rentals(customer_id INT)
    RETURNS SMALLINT UNSIGNED
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE rental_count SMALLINT UNSIGNED;

    SELECT COUNT(*)
    INTO rental_count
    FROM rental r
    WHERE r.customer_id = customer_id;

    RETURN rental_count;

END $$

DELIMITER ;


SELECT cust.first_name, cust.last_name, count_rentals(cust.customer_id) AS rental_count
FROM customer cust
ORDER BY rental_count DESC
LIMIT 501;


SHOW CREATE TABLE language;
SELECT get_language(12);

# get film title with category name(Dinosaur Acadamy (Drama))

DELIMITER //

CREATE FUNCTION title_with_category(film_id INT)
    RETURNS VARCHAR(255)
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE film_title VARCHAR(50);

    SELECT CONCAT(f.title, ' (', c.name, ')') AS title
    INTO film_title
    FROM film f
             INNER JOIN film_category fc ON f.film_id = fc.film_id
             INNER JOIN category c ON c.category_id = fc.category_id
    WHERE f.film_id = film_id;


    RETURN film_title;

END //

DELIMITER ;

SELECT title_with_category(f.film_id) AS title
FROM film f
LIMIT 501;

SELECT first_name, last_name, title_with_category(film_id) AS title
FROM actor
         INNER JOIN film_actor fa ON actor.actor_id = fa.actor_id
LIMIT 501;

# customer full name


DELIMITER //

CREATE FUNCTION get_full_name(customer_id INT)
    RETURNS VARCHAR(50)
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE full_name VARCHAR(50);
    SELECT CONCAT(cust.first_name, ' ', cust.last_name) AS full_name
    INTO full_name
    FROM customer cust
    WHERE cust.customer_id = customer_id
    LIMIT 501;


    RETURN full_name;

END //

DELIMITER ;

SELECT get_full_name(customer_id) AS full_name
FROM customer
LIMIT 501;

SELECT rental_date, get_full_name(customer_id) AS full_name
FROM rental
LIMIT 501;

SELECT DATEDIFF(return_date, rental_date), rental_id
FROM rental
WHERE rental_id = 1
LIMIT 501;

# get renatal_days

DELIMITER //

CREATE FUNCTION calc_rental_days(rental_id INT)
    RETURNS SMALLINT UNSIGNED
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE days SMALLINT UNSIGNED;
    SELECT DATEDIFF(return_date, rental_date)
    INTO days
    FROM rental ren
    WHERE ren.rental_id = rental_id
    LIMIT 1;


    RETURN days;

END //

DELIMITER ;

SELECT calc_rental_days(5)

# avg payment per customer

SELECT *
FROM payment
LIMIT 501;

DELIMITER //

CREATE FUNCTION avg_payment_for_customer(customer_id INT)
    RETURNS DECIMAL(6, 2)
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE avg_payment DECIMAL(6, 2);

    SELECT IFNULL(AVG(pay.amount), 0)
    INTO avg_payment
    FROM payment pay
    WHERE pay.customer_id = customer_id
    LIMIT 501;

    RETURN avg_payment;

END //

DELIMITER ;

SELECT first_name, last_name, avg_payment_for_customer(customer_id) AS avg_payment
FROM customer
LIMIT 501;

DELIMITER //

CREATE FUNCTION stddev_payment_for_customer(customer_id INT)
    RETURNS DECIMAL(6, 2)
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE stddev_payment DECIMAL(6, 2);

    SELECT IFNULL(STDDEV(pay.amount), 0)
    INTO stddev_payment
    FROM payment pay
    WHERE pay.customer_id = customer_id
    LIMIT 501;

    RETURN stddev_payment;

END //

DELIMITER ;

SELECT first_name,
       last_name,
       avg_payment_for_customer(customer_id)    AS avg_payment,
       stddev_payment_for_customer(customer_id) AS stddev_payment
FROM customer
LIMIT 501;

# median

DELIMITER //

CREATE FUNCTION median_payment_for_customer(customer_id INT)
    RETURNS DECIMAL(6, 2)
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE count_payments SMALLINT UNSIGNED;
    DECLARE median_value DECIMAL(6, 2);
    DECLARE offset_value SMALLINT UNSIGNED;

    SELECT COUNT(*)
    INTO count_payments
    FROM payment pay
    WHERE pay.customer_id = customer_id
    LIMIT 1;

    IF count_payments = 0 THEN
        RETURN NULL;
    END IF;

    IF MOD(count_payments, 2) = 1 THEN
        SET offset_value = FLOOR(count_payments / 2);

        SELECT pay.amount
        INTO median_value
        FROM payment pay
        WHERE pay.customer_id = customer_id
        ORDER BY pay.amount
        LIMIT 1 OFFSET offset_value;
    ELSE
        SET offset_value = FLOOR(count_payments / 2) - 1;

        SELECT AVG(mid_values.amount)
        INTO median_value
        FROM (SELECT pay.amount
              FROM payment pay
              WHERE pay.customer_id = customer_id
              ORDER BY pay.amount
              LIMIT 2 OFFSET offset_value) AS mid_values;
    END IF;

    RETURN median_value;

END //

DELIMITER ;

DROP FUNCTION median_payment_for_customer;
SELECT median_payment_for_customer(1)
