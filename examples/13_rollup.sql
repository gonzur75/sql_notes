SELECT *
FROM payment
LIMIT 500;

# całkowita kwota wpływów
SELECT SUM(amount)
FROM payment
LIMIT 501;


# kwota wpływów w podziale na klientów

SELECT customer_id, SUM(amount) as Amount
FROM payment
GROUP BY customer_id
ORDER BY Amount DESC
LIMIT 501;

# kwota wpływów w podziale na pracownika

SELECT staff_id, SUM(amount) as Amount
FROM payment
GROUP BY staff_id
ORDER BY Amount DESC
LIMIT 501;

# kwota wpływów w podziale na klientów i miesiące

SELECT customer_id, SUM(amount) as Amount, DATE_FORMAT(payment_date, '%Y-%m') AS PymentMonth
FROM payment
GROUP BY customer_id, PymentMonth
ORDER BY customer_id, Amount DESC
LIMIT 501;


SELECT staff_id, SUM(amount) as Amount, DATE_FORMAT(payment_date, '%Y-%m') AS PymentMonth
FROM payment
GROUP BY staff_id, PymentMonth
ORDER BY staff_id, Amount DESC
LIMIT 501;

# Przygotuj raport wpłatowy na podstawie odpowiednich tabel z bazy sakila, który wyświetli następujące informacje:
#
# imię klienta,
# nazwisko klienta,
# email klienta,
# kwotę wpłat,
# liczbę wpłat,
# średnią kwotę wpłat,
# datę ostatniej wpłaty.
# Wynik zapytania zapisz w bazie używając widoku.

CREATE OR REPLACE VIEW payment_report
AS
SELECT c.first_name,
       c.last_name,
       c.email,
       SUM(p.amount) AS Amount,
       COUNT(p.amount) AS PaymentCount,
       AVG(p.amount) AS AverageAmount,
       MAX(p.payment_date) AS LastPaymentDate
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id
LIMIT 501;

SELECT *
FROM payment_report
LIMIT 501;

#test
SELECT (SELECT SUM(Amount)FROM payment_report) = (SELECT SUM(payment.amount) FROM payment);
# Napisz kwerendę, która zwróci następujące informacje:
#
# id filmu,
# nazwę filmu,
# liczbę aktorów występujących w filmie.
# Wyniki zapisz do tabeli tymczasowej, np. tmp_film_actors.

-- Tabela tymczasowa różni się od widoku tym, że nie jest zapisywana w bazie danych, a jedynie w pamięci(sesji).
-- Widok jest zapisywany w bazie danych i można go używać w innych sesjach.
-- Tabela jest kopia danych, a widok jest zapytaniem, które można traktować jak tabelę.

CREATE TEMPORARY TABLE tmp_film_actors AS
SELECT f.film_id AS FilmID,
       f.title AS FilmTitle,
       COUNT(fa.actor_id) AS ActorCount
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
LIMIT 501;

SELECT *
FROM tmp_film_actors
LIMIT 501;

-- CTE (Common Table Expression) to tymczasowy wynik zapytania, który można używać w dalszej części zapytania.
WITH cte AS (SELECT fa.film_id, COUNT(fa.actor_id) AS ActorCount
             FROM film_actor fa
             GROUP BY 1) -- pozwala grupowanać po pierwszej kolumnie
SELECT fl.film_id,
       fl.title,
       cte.ActorCount
FROM film fl
JOIN cte ON fl.film_id = cte.film_id
LIMIT 501;

# id filmu,
# tytuł filmu,
# liczbę wypożyczeń filmu.
# Wyniki zapisz do tabeli tymczasowej, np. tmp_film_rentals.

CREATE  TEMPORARY TABLE tmp_film_rentals AS
SELECT f.film_id AS FilmID,
       f.title AS FilmTitle,
       COUNT(r.rental_id) AS RentalCount
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY RentalCount DESC
LIMIT 501;

SELECT *
FROM tmp_film_rentals
LIMIT 501;

# Napisz zapytanie, które zwróci kwotę wpłat z filmu w następującym formacie:
#
# id filmu,
# kwota wpłat z filmu.
# Wyniki zapisz do tabeli tymczasowej, np. tmp_film_payments.

CREATE TEMPORARY TABLE tmp_film_payments
AS
SELECT inv.film_id, inv.inventory_id, SUM(p.amount) AS Amount
FROM payment as p
         INNER JOIN rental as ren USING (rental_id)
         INNER JOIN inventory as inv USING (inventory_id)
GROUP BY inv.inventory_id;

DROP TEMPORARY TABLE tmp_film_payments;

SELECT *
FROM tmp_film_payments;


# Przygotuj raport, który wyświetli top 10 najchętniej wypożyczanych filmów.
# Przyjmij następujące założenia biznesowe do przygotowania raportu:
#
# nazwa filmu,
# liczba aktorów, którzy w nim grali,
# kwota przychodu filmu,
# liczba wypożyczeń filmu.

SELECT tfa.FilmTitle,
         tfa.ActorCount,
         tfp.Amount,
         tfr.RentalCount
FROM tmp_film_rentals tfr
JOIN tmp_film_actors tfa ON tfr.FilmID = tfa.FilmID
JOIN tmp_film_payments tfp ON tfr.FilmID = tfp.film_id
ORDER BY tfp.Amount
LIMIT 10;

# Napisz zapytanie, które wygeneruje raport o:
#
# sumie sprzedaży danego sklepu oraz jego pracownikach,
# całkowitej sumie sprzedaży danego sklepu (bez podziału na pracowników),
# całkowitej sumie sprzedaży.

SELECT s.store_id,
       pt.staff_id,
       SUM(pt.amount) AS Amount
FROM payment pt
JOIN sakila.staff s on s.staff_id = pt.staff_id
GROUP BY s.store_id, pt.staff_id
WITH ROLLUP -- zsumuje wszystkie wartości
ORDER BY 1, 2;

SELECT SHA1('12345') = (SELECT password FROM sakila.staff WHERE staff_id = 1);

# Na podstawie tabeli payment napisz zapytanie, które:
#
# wyznaczy sumę wpłat w podziale na klienta oraz pracownika,
# wyznaczy sumę wpłat per klient,
# wyznaczy sumę wpłat.

SELECT p.customer_id,
       p.staff_id,
       SUM(p.amount) AS Amount
FROM payment p
WHERE p.customer_id < 4
GROUP BY AMount, p.staff_id
WITH ROLLUP
HAVING Amount > 70
ORDER BY 1, 2


