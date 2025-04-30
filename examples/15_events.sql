-- EVENTS
-- TRIGERY Działają w oparciu o DML(update, insert, delete)
-- EVENTS Działają w oparciu o czas

SHOW VARIABLES LIKE 'event_scheduler';
SELECT @@GLOBAL.event_scheduler;

CREATE TABLE event_audit
(
    id          INT NOT NULL AUTO_INCREMENT,
    last_update TIMESTAMP,
    PRIMARY KEY (id)
);


SELECT *
FROM event_audit
LIMIT 501;


DELIMITER //

CREATE EVENT one_time_event
    ON SCHEDULE AT NOW() + INTERVAL 1 MINUTE
    DO
    BEGIN
        INSERT INTO event_audit (last_update)
        VALUES (NOW());

    END //

DELIMITER ;

SELECT *
FROM event_audit
LIMIT 501;

DELIMITER //

CREATE EVENT recurring_event
    ON SCHEDULE EVERY 10 SECOND
    DO
    BEGIN
        INSERT INTO event_audit (last_update)
        VALUES (NOW());

    END //

DELIMITER ;

DROP EVENT recurring_event;

-- zmien status wszystkim nieaktywnym użytkownikom (nic nie wypożyczyli od 20 lat)

DELIMITER //

CREATE EVENT deactivate_inactive_users
    ON SCHEDULE AT NOW() + INTERVAL 8 HOUR
    DO
    BEGIN
        UPDATE customer
        SET active = 0
        WHERE customer_id IN (SELECT cust.customer_id
                              FROM customer cust
                              LEFT JOIN rental r ON cust.customer_id = r.customer_id
                              WHERE r.return_date IS NULL  or r.rental_date < DATE_SUB(NOW(), INTERVAL 20 YEAR));

    END //

DELIMITER ;

-- codzienna archiwizacja starych płatności

SELECT *
FROM payment
LIMIT 501;

-- potrzebuje tabeli payment_archive wysztarczy skopiować i zmienic nazwe

CREATE TABLE payment_archive LIKE payment;

SELECT *
FROM payment_archive
LIMIT 501;


DELIMITER //

CREATE EVENT archive_old_payments
    ON SCHEDULE EVERY 1 DAY
    DO
    BEGIN
        INSERT INTO payment_archive (payment_id, customer_id, staff_id, rental_id, amount, payment_date)
        SELECT p.payment_id, p.customer_id, p.staff_id, p.rental_id, p.amount, p.payment_date
        FROM payment p
        WHERE p.payment_date < DATE_SUB(NOW(), INTERVAL 1 YEAR);


    END //

DELIMITER ;

