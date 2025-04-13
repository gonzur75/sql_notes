-- DML Operations on views

SELECT *
FROM language;

CREATE VIEW dml_operations
AS
SELECT *
FROM language;

#READ
SELECT *
FROM dml_operations
LIMIT 500;

# CREATE
INSERT INTO dml_operations(name, last_update)
VALUES ('Hindi' , '2025-04-13 00:00:00');

# UPDATE

UPDATE dml_operations
SET name = 'Polish'
WHERE language_id = 7;

# DELETE
DELETE FROM dml_operations
WHERE language_id = 7;

SHOW CREATE TABLE language;

CREATE VIEW dml_operations2
AS
SELECT language_id,last_update
FROM language;

SELECT *
FROM dml_operations2
LIMIT 501;

SHOW CREATE VIEW dml_operations2;

INSERT INTO dml_operations2
SET last_update = '2025-04-13 00:00:00'
WHERE language_id = 6;

CREATE VIEW dml_operations_3
AS
SELECT *
FROM language;

UPDATE dml_operations_3
SET last_update = '2025-04-13 00:00:00'
WHERE language_id = 6;

SELECT *
FROM dml_operations_4 LIMIT 501;

CREATE VIEW dml_operations_4
AS
SELECT *
FROM language
WHERE YEAR(last_update) < 2010
WITH CHECK OPTION;

UPDATE dml_operations_4
SET last_update = '2007-04-13 00:00:00'
WHERE language_id = 5;

UPDATE dml_operations_4
SET last_update = '2011-04-13 00:00:00'
WHERE language_id = 5;


