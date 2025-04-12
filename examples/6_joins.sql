-- Students
CREATE TABLE Students
(
    StudentId   INT,
    StudentName VARCHAR(10)
);
INSERT INTO Students (StudentId, StudentName)
SELECT 1, 'John'
UNION ALL
SELECT 2, 'Matt'
UNION ALL
SELECT 3, 'James';

-- Classes
CREATE TABLE Classes
(
    ClassId   INT,
    ClassName VARCHAR(10)
);
INSERT INTO Classes (ClassId, ClassName)
SELECT 1, 'Maths'
UNION ALL
SELECT 2, 'Arts'
UNION ALL
SELECT 3, 'History';

-- StudentClass
CREATE TABLE StudentClass
(
    StudentId INT,
    ClassId   INT
);
INSERT INTO StudentClass (StudentId, ClassId)
SELECT 1, 1
UNION ALL
SELECT 1, 2
UNION ALL
SELECT 3, 1
UNION ALL
SELECT 3, 2
UNION ALL
SELECT 3, 3;


SELECT *
FROM Students;

SELECT *
FROM Classes;

SELECT *
FROM StudentClass;

SELECT s1.StudentName, c1.ClassName
FROM Students AS s1
         INNER JOIN StudentClass AS SC ON s1.StudentId = SC.StudentId
         INNER JOIN Classes AS c1 ON SC.ClassId = c1.ClassId;

SELECT *
FROM Students AS st
WHERE st.StudentId IN (SELECT DISTINCT st.StudentId
                       FROM StudentClass AS sc)
LIMIT 501;


SELECT (SELECT st.StudentName FROM Students st WHERE sc.StudentId = st.StudentId) AS StudentName,
       (SELECT cl.ClassName cl FROM Classes cl WHERE sc.ClassId = cl.ClassId) AS ClassName
FROM StudentClass sc
LIMIT 501;


SELECT DISTINCT st.StudentName
FROM Students st
JOIN StudentClass sc ON st.StudentId = sc.StudentId;

SELECT
    DISTINCT (SELECT st.StudentName FROM Students st WHERE st.StudentId = st.StudentId) AS StudentName
FROM StudentClass sc;

SELECT DISTINCT st.StudentName
FROM Students st
LEFT JOIN StudentClass sc on st.StudentId = sc.StudentId
WHERE sc.ClassId IS NULL;

# distinct algorytm z hashowaniem który wyrzuci powtórki
SELECT st.StudentName
FROM Students st
WHERE st.StudentId NOT IN (SELECT DISTINCT sc.StudentId FROM StudentClass sc);

# lista klientów którzy, kochają dramy, id, imie, nazwisko, id dramy

SELECT *
FROM category
WHERE name LIKE '%dr%'
LIMIT 501;

#film z kategorii drama
SELECT ct.name, fl.*
FROM film AS fl
INNER JOIN film_category AS fc ON fl.film_id = fc.film_id
INNER JOIN sakila.category ct on fc.category_id = ct.category_id
WHERE ct.name = 'Drama';

SELECT fl.*
FROM film as fl
WHERE fl.film_id IN (SELECT fc.film_id
                         FROM film_category fc
                         WHERE fc.category_id IN (SELECT ct.category_id
                                                  FROM category AS ct
                                                    WHERE ct.name = 'Drama'
                                      ));

SELECT DISTINCT ct.customer_id, ct.first_name, ct.last_name, COUNT(*) AS rental_drama_count
FROM customer as ct
    INNER JOIN sakila.rental AS ren ON ct.customer_id = ren.customer_id
    INNER JOIN sakila.inventory AS inv ON ren.inventory_id = inv.inventory_id
    INNER JOIN sakila.film_category fc ON fc.film_id = inv.film_id
    INNER JOIN sakila.category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Drama'
GROUP BY ct.customer_id
ORDER BY rental_drama_count DESC
LIMIT 501
;

SELECT ct.customer_id, ct.first_name, ct.last_name
FROM customer as ct
WHERE ct.customer_id IN (SELECT ren.customer_id
                         FROM rental ren
                         WHERE ren.inventory_id IN (SELECT inv.inventory_id
                                                    FROM inventory inv
                                                    WHERE inv.film_id IN (SELECT ct.film_id
                                                                          FROM film_category ct
                                                                          WHERE ct.category_id IN (SELECT c.category_id
                                                                                                   FROM category AS c
                                                                                                   WHERE c.name = 'Drama'))))
ORDER BY ct.customer_id ASC;

SELECT ct.customer_id,
       ct.first_name,
       ct.last_name,
       ( SELECT COUNT(*)
         FROM rental ren
         WHERE ren.customer_id = ct.customer_id) AS rental_count
FROM customer as ct
WHERE ct.customer_id IN (SELECT ren.customer_id
                         FROM rental ren);S

