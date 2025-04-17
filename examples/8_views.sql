SELECT *
FROM actor
LIMIT 501;

# Widoki w DB

CREATE VIEW vw_all_actor
AS
SELECT *
FROM actor;

SELECT *
FROM vw_all_actor;

-- zastosowania widoków
-- 1. uproszczenie zapytań simplified queries

CREATE VIEW customer_payment
AS
SELECT pt.payment_id, cust.first_name, cust.last_name, amount, pt.rental_id
FROM payment pt
         INNER JOIN customer cust ON pt.customer_id = cust.customer_id
WHERE pt.amount > (SELECT AVG(pt2.amount)
                   FROM payment pt2
                   WHERE pt2.customer_id = pt.customer_id);


SELECT *
FROM customer_payment
LIMIT 500;

SELECT *
FROM customer_payment
LIMIT 500;

SELECT *
FROM customer_payment cp
INNER JOIN rental ren ON ren.rental_id = cp.rental_id;

-- 2. bezpieczeństwo danych - data security

CREATE VIEW secure_data
AS
    SELECT pt.payment_id, pt.rental_id, cust.first_name, cust.last_name, amount
        FROM payment pt
                INNER JOIN customer cust ON pt.customer_id = cust.customer_id
WHERE pt.payment_id > 100;

SELECT *
FROM secure_data
LIMIT 500;

SELECT *
FROM secure_data
WHERE payment_id = 1
LIMIT 500;

SELECT payment_id, staff_id
FROM secure_data
LIMIT 500;

DROP VIEW secure_data;