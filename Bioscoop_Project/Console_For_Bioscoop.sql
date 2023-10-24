/***************************************
 *                                     *
 *   Created by Elias & Kobe           *
 *   Visit https://eliasdh.com         *
 *                                     *
 ***************************************/


-- **************************************** --
-- SELECT Tables                            --
-- **************************************** --
SELECT * FROM cinema_complex;
SELECT * FROM hall;
SELECT * FROM movie;
SELECT * FROM ensemble;
SELECT * FROM director;
SELECT * FROM ensemble_or_director;
SELECT * FROM customer;
SELECT * FROM oscars;
SELECT * FROM movie;
SELECT * FROM reduced_rate;
SELECT * FROM scheduling;
SELECT * FROM ticket_reservation;
SELECT * FROM ticket;
SELECT * FROM seat_reservation;
SELECT * FROM version;

-- **************************************** --
-- SELECT Views                             --
-- **************************************** --
SELECT * FROM programming_managers_view;
SELECT * FROM webapplication_mobileapp_view;
SELECT * FROM sales_terminal_cp;
SELECT * FROM hall_attendant_view;
SELECT * FROM content_managers_view;

-- **************************************** --
-- SELECT Extra                             --
-- **************************************** --

-- Alle Oscars-categorieën en winnaars ophalen:
SELECT oscar_category, nominee FROM oscars WHERE winner = true;

-- Films met hun bijbehorende regisseurs en ensembleleden ophalen:
SELECT m.title, d.first_name AS director_first_name, d.last_name AS director_last_name, e.first_name AS ensemble_first_name, e.last_name AS ensemble_last_name
FROM movie m
         LEFT JOIN ensemble_or_director ed ON m.ensemble_or_directorid = ed.ensemble_or_directorid
         LEFT JOIN director d ON ed.directorid = d.directorid
         LEFT JOIN ensemble e ON ed.ensembleid = e.ensembleid;

-- Sessies voor een bepaald complex en film ophalen:
SELECT s.start_date, s.start_time, s.end_date, s.end_time
FROM scheduling s
WHERE s.complexid = 1 AND s.movieid = 1;

-- Films die in een bepaald genre vallen ophalen:
SELECT * FROM movie WHERE genre = 'drama';

-- Klanten die met een specifieke betalingsmethode hebben gereserveerd ophalen:
SELECT * FROM customer c
                  JOIN ticket_reservation tr ON c.customerid = tr.customerid
WHERE tr.payment_method = 'visa';

-- Alle films en hun regisseurs ophalen:
SELECT m.title AS movie_title, d.first_name AS director_first_name, d.last_name AS director_last_name
FROM movie m
         JOIN ensemble_or_director eod ON m.ensemble_or_directorid = eod.ensemble_or_directorid
         JOIN director d ON eod.directorid = d.directorid;

-- Alle klanten met hun bijbehorende ticketreserveringen en de geassocieerde filminformatie ophalen:
SELECT c.first_name AS customer_first_name, c.last_name AS customer_last_name, tr.confirmation_email_sent, tr.payment_method, m.title AS movie_title
FROM customer c
         LEFT JOIN ticket_reservation tr ON c.customerid = tr.customerid
         LEFT JOIN scheduling s ON tr.schedulingid = s.schedulingid
         LEFT JOIN movie m ON s.movieid = m.movieid;

-- Alle filmvertoningen voor een specifiek complex met de bijbehorende film- en hallinformatie ophalen:
SELECT cc.name AS cinema_complex_name, s.start_date, s.start_time, s.end_date, s.end_time, m.title AS movie_title, h.capacity AS hall_capacity
FROM scheduling s
         JOIN cinema_complex cc ON s.complexid = cc.complexid
         JOIN movie m ON s.movieid = m.movieid
         JOIN hall h ON m.movieid = h.complexid;

-- Ophaal alle informatie over filmvertoningen in een specifiek complex, inclusief klantgegevens, filmtitels, regisseurs en hallen:
SELECT
    cc.name AS cinema_complex_name,
    s.start_date,
    s.start_time,
    s.end_date,
    s.end_time,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name,
    tr.confirmation_email_sent,
    tr.payment_method,
    m.title AS movie_title,
    d.first_name AS director_first_name,
    d.last_name AS director_last_name,
    h.capacity AS hall_capacity
FROM scheduling s
         JOIN cinema_complex cc ON s.complexid = cc.complexid
         JOIN movie m ON s.movieid = m.movieid
         JOIN hall h ON m.movieid = h.complexid
         LEFT JOIN ticket_reservation tr ON s.schedulingid = tr.schedulingid
         LEFT JOIN customer c ON tr.customerid = c.customerid
         LEFT JOIN ensemble_or_director eod ON m.ensemble_or_directorid = eod.ensemble_or_directorid
         LEFT JOIN director d ON eod.directorid = d.directorid;

