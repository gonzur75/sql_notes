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

#przed deletem należy, sprawdzić co usuwsz selctem
#wstawiamy true, i pomimo braku dostępu do bazy, usuwamy wszystko
DELETE
FROM ActorSample
WHERE 1=1 ;

#
TRUNCATE TABLE ActorSample;

#to nie powinno dziąłać
DELETE FROM ActorSample;



DELETE FROM ActorSample
