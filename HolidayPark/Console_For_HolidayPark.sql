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

/* Start transactie */
BEGIN;
ALTER TABLE reservations DROP CONSTRAINT fk_res_client;
SAVEPOINT save_3;
DELETE FROM clients WHERE first_name='PIETER' AND last_name='STOOT';
SAVEPOINT save_4;
COMMIT;
ROLLBACK;
/* End transactie */

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


-- Vraag 1: Maak in de tabel cottagetypes een beperking op het kenmerk no_persons. no_persons mag alleen waarden hebben tussen 4 en 24.
ALTER TABLE cottagetypes ADD CONSTRAINT no_persons_check CHECK (no_persons BETWEEN 4 AND 24) NOT VALID;

-- Wijzig het type huisjes dat niet aan die constraint voldoet.
UPDATE cottagetypes SET no_persons=4 WHERE no_persons<2;

-- Voer de volgende update uit:
UPDATE cottagetypes SET no_persons = 3 WHERE park_code = 'WB' AND typeNo= 'BC';

-- Activeer nu de bovenstaande constraint opnieuw zonder de in c. uitgevoerde update ongedaan te maken of iets aan de constraint zelf te veranderen!
ALTER TABLE cottagetypes VALIDATE CONSTRAINT no_persons_check;

-- Controleer na succesvolle activering de status van de constraint in de Data Dictionary. Doe dit met de volgende query:
SELECT con.* FROM pg_catalog.pg_constraint con
    INNER JOIN pg_catalog.pg_class rel ON rel.oid = con.conrelid
    INNER JOIN pg_catalog.pg_namespace nsp ON nsp.oid = connamespace
             WHERE rel.relname = 'cottagetypes';

-- Vraag 2: Een beperking kan ook op een andere manier tijdelijk buiten werking worden gesteld. Merk op dat dit niet kan met een CHECK constraint. Pas die andere methode toe op de FOREIGN KEY constraint van de tabel cottagetypes. Probeer dan de volgende UPDATE hieronder:
-- Dus dit kan niet:
UPDATE cottagetypes SET park_code = 'FS' WHERE park_code = 'SF' AND typeNo = '14';
-- Dus
ALTER TABLE cottagetypes ALTER CONSTRAINT fk_cottype_park DEFERRABLE; -- Betekent dat de constraint pas gecontroleerd wordt bij het einde van de transactie
SET CONSTRAINTS fk_cottype_park DEFERRED; -- Betekent dat de constraint pas gecontroleerd wordt bij het einde van de transactie
ALTER TABLE cottagetypes ALTER CONSTRAINT fk_cottype_park NOT DEFERRABLE; -- Betekent dat de constraint direct gecontroleerd wordt

-- En ook nog ERROR [23514] ERROR: new row for relation "cottagetypes" violates check constraint "no_persons_check" Detail: Failing row contains (FS, 14, 1, 2, 1, N, null, Y, 63).
SELECT * FROM cottagetypes WHERE park_code IN ('FS', 'SF');

-- Vraag 3: In de tabel klanten moet het kenmerk e-mail (VARCHAR(30)) worden toegevoegd. Een nieuw toegevoegd attribuut is altijd de laatste kolom in de tabel. We willen het attribuut net na het NAME attribuut plaatsen. Hoe realiseer je dit?
-- In postgres AFTER bestaanden:
ALTER TABLE clients ADD COLUMN email VARCHAR(30);
-- En nu verplaatsen: (maak een duplicate van de tabel in de in goeden volgorde)
CREATE TABLE clients_new AS SELECT clientno, last_name, first_name, email, street, houseno, postcode, city, status FROM clients;

SELECT * FROM clients_new;

DROP TABLE clients;
DROP TABLE clients CASCADE;

ALTER TABLE clients_new RENAME TO clients;

-- Moet nu in clients (clients_new):
ALTER TABLE clients ADD last_name VARCHAR(25) CONSTRAINT lastnm_caps CHECK(last_name = UPPER(last_name));
ALTER TABLE clients ADD first_name VARCHAR(25) CONSTRAINT firstnm_caps CHECK(first_name= UPPER(first_name));
ALTER TABLE clients ADD street VARCHAR(40) CONSTRAINT clientstreet_caps CHECK(street = UPPER(street));
ALTER TABLE clients ADD city VARCHAR(20) CONSTRAINT city_caps CHECK(city = UPPER(city));
ALTER TABLE clients ADD CONSTRAINT pk_client PRIMARY KEY (clientNo);

ALTER TABLE reservations ADD CONSTRAINT fk_res_client FOREIGN KEY (clientNo) REFERENCES clients(clientNo);


-- Vraag 4: De tabel reserveringen heeft een samengestelde primaire sleutel. Stel dat u de structuur van die tabel wilt wijzigen. Elke reservering krijgt een uniek nummer resID via een identiteitskolom.
-- We moeten een duplicaat van de tabel maken met de nieuwe structuur en ook resID
CREATE TABLE reservations_new AS SELECT * FROM reservations;
-- New column & identiteitskolom
ALTER TABLE reservations_new ADD COLUMN resID int GENERATED ALWAYS AS IDENTITY;
-- Primary key
ALTER TABLE reservations_new ADD CONSTRAINT pk_res_new PRIMARY KEY (resID);
-- Foreign key in de anderen tabellen
ALTER TABLE payments DROP CONSTRAINT fk_payment_reserv; -- Eerst de foreign key verwijderen
ALTER TABLE payments ADD resID int; -- Nieuwe kolom toevoegen

UPDATE payments p SET resID = (SELECT resID FROM reservations_new r WHERE p.resno=r.resno AND p.tano=r.tano);


-- Vraag 5: De reservatietabel heeft een samengestelde primaire sleutel. Stel dat u de structuur van die tabel wilt wijzigen.
-- Elke reservering krijgt een uniek nummer RES_ID via een sequentie SEQ_RESERVATIES.
-- Hoe gaat u dit aanpakken? Beschrijf de verschillende stappen en geef ook de verklaringen.
CREATE SEQUENCE seq_reservaties;
ALTER TABLE reservations ADD COLUMN res_id int DEFAULT nextval('seq_reservaties');
SELECT * FROM reservations;
-- ...

ALTER TABLE reservations DROP COLUMN res_id;

-- Vraag 6 Probeer de volgende update uit te voeren:
UPDATE cottages SET houseno = 52 WHERE park_code = 'SF' AND typeNo = '12' AND houseNo = 50;
-- Dit lukt niet omdat er een foreign key op staat (houseno, typeno, park_code) in reservations

-- Start een sessie. Zet de primaire sleutel op de cottages tabel tijdelijk buiten werking.
-- Tip 1: Dit kan door de triggers uit te schakelen.
-- Tip 2: Alleen de triggers van primaire sleutels die uitstelbaar zijn kunnen worden uitgeschakeld.

BEGIN; -- Dit werkt niet
ALTER TABLE cottages DISABLE TRIGGER ALL;
SAVEPOINT save_1;
UPDATE cottages SET houseno = 52 WHERE park_code = 'SF' AND typeNo = '12' AND houseNo = 50;
ROLLBACK;

BEGIN; -- Dit werkt wel
ALTER TABLE cottages DROP CONSTRAINT pk_cottage CASCADE;
ALTER TABLE cottages ADD CONSTRAINT pk_cottage PRIMARY KEY (park_code, typeNo, houseNo) DEFERRABLE;
ALTER TABLE cottages DISABLE TRIGGER ALL;
UPDATE cottages SET houseno = 52 WHERE park_code = 'SF' AND typeNo = '12' AND houseNo = 50;
SAVEPOINT save_1;
ALTER TABLE cottages ENABLE TRIGGER ALL;
ROLLBACK;




