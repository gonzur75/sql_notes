SELECT *
FROM language
Limit 500;


CREATE TABLE audit_language
(
    language_id TINYINT,
    name        VARCHAR(20),
    last_update TIMESTAMP,
    row_value   CHAR(20)

);
DROP TABLE IF EXISTS audit_language;

SELECT *
FROM audit_language
LIMIT 500;

DELIMITER //

CREATE TRIGGER language_after_update
    AFTER UPDATE -- po aktualizacji można jeszce przed ]
    ON language
    FOR EACH ROW -- dla każdego wiersza
-- powyżej metadane

BEGIN
    INSERT INTO audit_language (language_id, name, last_update, row_value)
    VALUES (OLD.language_id, OLD.name, OLD.last_update, 'before update');

    INSERT INTO audit_language (language_id, name, last_update, row_value)
    VALUES (NEW.language_id, NEW.name, NEW.last_update, 'after update');

END//

DELIMITER ;

SELECT *
FROM language
LIMIT 501;

INSERT INTO language (name, last_update)
VALUES ('python', '2023-10-01 12:00:00');

UPDATE language
SET name = 'SQL'
WHERE language_id = 12;

DROP TRIGGER IF EXISTS language_after_update;


INSERT INTO language (name)
VALUES ('polisH');

DELIMITER //

CREATE TRIGGER language_after_insert
    BEFORE INSERT
    ON language
    FOR EACH ROW

BEGIN

    SET NEW.name = CONCAT(UPPER(SUBSTRING(NEW.name, 1, 1)), LOWER(SUBSTRING(NEW.name FROM 2)));

END //
-- powyżej metadane

DELIMITER ;

SELECT *
FROM language
LIMIT 501;

#0.99
DELIMITER //
CREATE TRIGGER film_minimal_rate
    BEFORE UPDATE
    ON film
    FOR EACH ROW

BEGIN

    IF NEW.rental_rate < 0.99 THEN
        SET NEW.rental_rate = 0.99;
    END IF;
END //

DELIMITER ;

DROP TRIGGER IF EXISTS film_minimal_rate;

UPDATE film
SET rental_rate = 0.5
WHERE film_id = 1;

SELECT *
FROM film
LIMIT 501;

SELECT *
FROM rental
LIMIT 501;

SELECT *
FROM customer
LIMIT 501;

DELIMITER //

CREATE TRIGGER rental_after_insert
    AFTER INSERT
    ON rental
    FOR EACH ROW

BEGIN
    UPDATE customer
    SET customer.active = 1
    WHERE customer.customer_id = NEW.customer_id AND customer.active = 0;

END //

DELIMITER ;
