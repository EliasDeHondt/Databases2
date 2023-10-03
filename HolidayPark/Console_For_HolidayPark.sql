SELECT * FROM clients;



CREATE USER EliasDH PASSWORD 'ROOT123456789' SUPERUSER;
GRANT ALL ON TABLE clients TO EliasDH;

SET ROLE EliasDH;

SELECT user;

SET ROLE postgres;

DROP USER EliasDH;

-- oef 1
BEGIN;

INSERT INTO clients
VALUES ('69696', 'DE HONDT', 'ELIAS', 'LACHSTRAAT', '69', '2650', 'EDEGEM', 'ANTWERPEN');
--
SAVEPOINT save_1;
--
INSERT INTO reservations (resno, tano, clientno, park_code, typeno, houseno, start_date, end_date)
VALUES (99,1,'69696',
        (SELECT code FROM parks WHERE upper(park_name)='WEERTERBERGEN'), 'FK', 225,
        to_date('28/10/2019','DD/MM/YYYY'), to_date('01/11/2019','DD/MM/YYYY'));
--
INSERT INTO reservations (resno, tano, clientno, park_code, typeno, houseno, start_date, end_date)
VALUES (100,1,'69696',
        (SELECT code FROM parks WHERE upper(park_name)='WEERTERBERGEN'), 'FV10', 515,
        to_date('23/12/2019','DD/MM/YYYY'), to_date('27/12/2019','DD/MM/YYYY'));
--
SAVEPOINT save_2;
--
INSERT INTO payments VALUES ((SELECT MAX(paymentno)+1 FROM payments), 99,1,
                             now(), 200.00, 'B');
--

ROLLBACK TO SAVEPOINT save_2;
COMMIT;

ROLLBACK;

-- oef 2

SELECT * FROM reservations WHERE clientno=(SELECT clientno FROM clients WHERE upper(last_name)='STOOT' AND upper(first_name)='PIETER');

SELECT park_code, typeno, no_bedrooms FROM cottagetypes WHERE no_bedrooms=(SELECT max(no_bedrooms) FROM cottagetypes);

DELETE FROM clients WHERE first_name='PIETER' AND last_name='STOOT';
-- Cascade Delete

BEGIN;
ALTER TABLE reservations DROP CONSTRAINT fk_res_client;
SAVEPOINT save_3;
DELETE FROM clients WHERE first_name='PIETER' AND last_name='STOOT';
SAVEPOINT save_4;
COMMIT;
ROLLBACK;

SELECT * FROM reservations WHERE typeno='FK' AND houseno=225 AND park_code=(SELECT code FROM parks WHERE upper(park_name)='WEERTERBERGEN');

DELETE FROM cottages WHERE typeno='FK' AND houseno=225 AND park_code=(SELECT code FROM parks WHERE upper(park_name)='WEERTERBERGEN');


-- oef 3


SELECT * FROM cottype_prices WHERE season_code IN (SELECT code FROM seasons where description LIKE '%summer%2020%')
                               AND park_code IN (SELECT code FROM parks JOIN countries c ON parks.country_code = c.country_code
WHERE lower(country_name) LIKE 'neth%');

UPDATE cottype_prices SET price_weekend=price_midweek*1.1, price_midweek=price_midweek*1.1
                      WHERE season_code IN (SELECT * FROM cottype_prices WHERE season_code IN (SELECT code FROM seasons where description LIKE '%summer%2020%')
                                                            AND park_code IN (SELECT code FROM parks JOIN countries c ON parks.country_code = c.country_code
                                                                              WHERE lower(country_name) LIKE 'neth%'));