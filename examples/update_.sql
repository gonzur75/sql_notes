# TINYINT - 8bit from -2**8 to 2**8
# SMALLINT - 16bit from -2**16 to 2**16
# MEDIUMINT - 24bit from -2**24 to 2**24
# BIGINT - 64bit from -2**64 to 2**64
# INT - 32bit from -2**32 to 2**32

CREATE TABLE ActorSample
(
    actor_id SMALLINT unsigned NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL, # tu by pasowało ustalić najdłuższe imię na świecie,
    last_name VARCHAR(25) NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (actor_id)
);

SELECT *
FROM ActorSample
LIMIT 501;

INSERT INTO ActorSample (first_name, last_name, last_update)
VALUES ("Janusz", "Kowalski", "2025-10-04");
;

INSERT INTO ActorSample
VALUES (DEFAULT, "Janusz","Kowalski", "2025-10-05");
;

INSERT INTO ActorSample (first_name)
VALUES ("Kowalski");
;

INSERT INTO ActorSample (first_name, last_name, last_update)
VALUES ("JAnusz", NULL,DEFAULT);
;

INSERT INTO ActorSample (first_name, last_name)
VALUES ("Janusz", "Kowalski"),
       ("Jaro", "K"),
       ("Jacek", "S"),
       ("Janusz", "Kowalski"),
       ("Janusz", "Kowalski"),
       ("Janusz", "Kowalski");

INSERT INTO ActorSample (first_name, last_name, last_update)
SELECT first_name, last_name, last_update
FROM actor
WHERE first_name = "KENNETH"
LIMIT 501;

DROP TABLE ActorSample;

CREATE TABLE ActorSample
(
    actor_id SMALLINT unsigned NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL, # tu by pasowało ustalić najdłuższe imię na świecie,
    last_name VARCHAR(25) NULL,
    last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (actor_id)
);

SELECT *
FROM ActorSample
LIMIT 501;

INSERT INTO ActorSample (first_name, last_name, last_update)
SELECT first_name, last_name, last_update
FROM actor
LIMIT 501;

UPDATE ActorSample
SET first_name = "Janusz"
WHERE actor_id = 1;

UPDATE ActorSample
SET first_name = "Jarosław"
WHERE actor_id IN (1,5, 10);


UPDATE ActorSample
SET first_name = "Jacek", last_name = "Gacek"
WHERE actor_id IN (3, 7, 10);

# ERD diagram
# tabela wiele do wielu jest redundantna co oznacza że duża ilość danych się powtarza
# dlatego stosuje się tabele pośrednie

SELECT *
FROM film_actor
WHERE film_id = 1
LIMIT 501;

UPDATE ActorSample
SET first_name = "Janusz"
WHERE actor_id in (SELECT actor_id
                      FROM film_actor
                      WHERE film_id = 1);

DROP TABLE ActorSample;

