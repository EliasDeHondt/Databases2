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


-- Voorbeeld van: [READ COMMITTED STATEMENT LEVEL]
-- User 1 doet en COMMIT; en dan pas ziet User 2 de veranderingen

BEGIN; -- User 1
SELECT last_name FROM clients WHERE clientNo = 1;

SELECT last_name FROM clients WHERE clientNo = 1;
COMMIT;

BEGIN; -- User 2

UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 1;

COMMIT;

-- Voorbeeld van: [READ COMMITTED STATEMENT LEVEL]
-- User 1 doet en COMMIT; en dan pas ziet User 2 de veranderingen

BEGIN; -- User 1
SELECT last_name FROM clients WHERE clientNo = 1; -- last_name = X

SELECT last_name FROM clients WHERE clientNo = 1; -- last_name = Y
COMMIT;

BEGIN; -- User 2

UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 1;  -- X = Y

COMMIT;

-- Voorbeeld van: [SET TRANSACTION READ ONLY]
-- User 2 doet een COMMIT; en User 1 ziet geen veranderingen

SET TRANSACTION READ ONLY;
BEGIN; -- User 1
SELECT last_name FROM clients WHERE clientNo = 1; -- last_name = X

SELECT last_name FROM clients WHERE clientNo = 1; -- last_name = X
COMMIT;

BEGIN; -- User 2

UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 1;  -- X = Y
COMMIT;


-- Voorbeeld van: [SET TRANSACTION ISOLATION LEVEL SERIALIZABLE]
-- User 2 doet een COMMIT; en User 1 ziet geen veranderingen (User 2 kan wel een UPDATE)

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN; -- User 1
SELECT last_name FROM clients WHERE clientNo = 1; -- last_name = X

SELECT last_name FROM clients WHERE clientNo = 1; -- last_name = X
UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 2; -- User 1 kan ook een UPDATE doen zolang het geen conflict geeft met User 2
COMMIT;

BEGIN; -- User 2

UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 1;  -- X = Y
COMMIT;


-- Voorbeeld van: [DEADLOCK]
-- User 1 moet en COMMIT; doen maar User 2 moet ook en COMMIT; deon dus RIP

BEGIN; -- User 1
UPDATE clients SET last_name = 'X' WHERE clientNo = 1;

UPDATE clients SET last_name = 'Y' WHERE clientNo = 2;
COMMIT;

BEGIN; -- User 2
UPDATE clients SET last_name = 'X' WHERE clientNo = 2;

UPDATE clients SET last_name = 'Y' WHERE clientNo = 1;
COMMIT;


-- Voorbeeld van: [LOCK]
-- User 1 moet en COMMIT; doen voor dat User 2 een UPDATE kan doen

BEGIN; -- User 1
UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 1;  -- X = Y

COMMIT;

BEGIN; -- User 2

UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 1;  -- X = Y
COMMIT;


-- Voorbeeld van: [LOCK & UPDATE NOWAIT]
-- Het verschil met de gewonen DEADLOCK is dat met UPDATE NOWAIT de transactie niet wordt uitgevoerd en een ERROR geeft (dus niet moet wachten op de andere transactie)

BEGIN; -- User 1
SELECT last_name FROM clients WHERE clientNo = 1 FOR UPDATE NOWAIT; -- last_name = X

UPDATE clients SET last_name = 'DE HONDT' WHERE clientNo = 1;  -- X = Y
COMMIT;

BEGIN; -- User 2

SELECT last_name FROM clients WHERE clientNo = 1 FOR UPDATE NOWAIT; -- last_name = X

SELECT last_name FROM clients WHERE clientNo = 1 FOR UPDATE NOWAIT; -- last_name = X
COMMIT;


-- W5P1
SELECT * FROM pg_indexes WHERE schemaname = 'public';
SELECT * FROM pg_indexes WHERE tablename = 'cottype_prices';
ALTER TABLE cottype_prices DROP CONSTRAINT pk_cottype_prices;
ALTER TABLE cottype_prices ADD CONSTRAINT pk_cottype_prices PRIMARY KEY (park_code, typeno, season_code);
DROP INDEX IF EXISTS pk_cottype_prices; -- Dit kan niet omdat het een primary key is
SELECT spcname AS "Tablespace Name", pg_tablespace_location(oid) AS "Location" FROM pg_tablespace;
CREATE TABLESPACE testTabelSpace LOCATION 'C:\Program Files\PostgreSQL\15\data\testTabelSpace';

CREATE TABLE clients_copy AS TABLE clients;
SELECT indexname, tablename FROM pg_indexes WHERE tablename = 'clients';
SELECT indexname, tablename FROM pg_indexes WHERE tablename = 'clients_copy';
SELECT * FROM clients_copy;
CREATE INDEX idx_client_name_copy ON clients_copy (clientno);
SELECT * FROM pg_tablespace;
CREATE TABLESPACE testTabelSpace LOCATION 'C:\Program Files\PostgreSQL\15\data\testTabelSpace';
ALTER TABLE clients_copy SET TABLESPACE testTabelSpace;
SELECT * FROM pg_tables WHERE tablename = 'clients_copy';
SELECT indexname, tablespace FROM pg_indexes WHERE tablename = 'clients_copy';
EXPLAIN SELECT * FROM clients WHERE clientNo = '77777';
CREATE INDEX ind_fname_client ON clients (first_name);
EXPLAIN SELECT clientNo,first_name,last_name FROM clients WHERE first_name IS NULL;
EXPLAIN SELECT * FROM clients WHERE first_name='WILLY';
EXPLAIN SELECT clientNo, first_name,last_name FROM clients WHERE UPPER(first_name) = 'WILLY';
EXPLAIN SELECT * FROM clients WHERE first_name LIKE '%TH%';
SET enable_seqscan = off;
EXPLAIN SELECT clientNo,first_name,last_name FROM clients WHERE first_name IS NULL;
EXPLAIN SELECT * FROM clients WHERE first_name='WILLY';
EXPLAIN SELECT clientNo, first_name,last_name FROM clients WHERE UPPER(first_name) = 'WILLY';
EXPLAIN SELECT * FROM clients WHERE first_name LIKE '%TH%';
EXPLAIN SELECT * FROM cottages WHERE houseNo = 10;
EXPLAIN SELECT * FROM cottages WHERE houseNo = 10 AND typeNo= '62';
EXPLAIN SELECT park_code,typeNo, houseNo FROM cottages WHERE park_code='EP';
CREATE INDEX ind_lname_client ON clients (last_name);
EXPLAIN SELECT * FROM clients WHERE last_name ='STOOT';
EXPLAIN SELECT * FROM clients WHERE UPPER(last_name)='STOOT';
CREATE INDEX ind_upper_last_name_client ON clients (UPPER(last_name));
SET enable_seqscan = on;
SELECT indexname FROM pg_indexes WHERE tablename = 'reservations' AND indexname = 'ind_client_res';
CREATE INDEX ind_client_res ON reservations (clientNo);
EXPLAIN SELECT clientNo, COUNT(*) AS aantal_reservaties FROM reservations GROUP BY clientNo ORDER BY clientNo;
DROP INDEX ind_fname_client;
DROP INDEX ind_lname_client;
DROP INDEX ind_client_res;
EXPLAIN SELECT c.clientNo, c.first_name,c.last_name FROM clients c JOIN reservations r ON r.clientNo = c.clientNo;
EXPLAIN SELECT c.clientNo, c.first_name,c.last_name FROM reservations r JOIN clients c ON c.clientNo = r.clientNo;
EXPLAIN SELECT c.last_name, c.first_name,p.sport, p.park_name, r.typeNo, r.houseNo FROM reservations r JOIN clients c ON c.clientNo = r.clientNo JOIN parks p ON p.code = r.park_code WHERE p.country_code = '1';
EXPLAIN SELECT pa.park_code,pa.attraction_code,pat.description FROM parkattractions pa JOIN parkattractiontypes pat ON pa.attraction_code = pat.attraction_code;
EXPLAIN SELECT t.park_code,t.typeNo, no_persons, houseNo,central FROM cottagetypes t JOIN cottages c ON c.park_code=t.park_code AND c.typeNo=t.typeNo;
EXPLAIN SELECT * FROM travelagencies WHERE taNo NOT IN (SELECT taNo FROM reservations);
EXPLAIN SELECT * FROM travelagencies t WHERE NOT EXISTS (SELECT 'x' FROM reservations WHERE t.taNo = taNo);
EXPLAIN SELECT t.taNo FROM travelagencies t EXCEPT (SELECT r.taNo FROM reservations r);

-- W6P1
SELECT table_name FROM information_schema.columns;
SELECT tablename FROM pg_tables;
SELECT table_name FROM information_schema.columns INTERSECT SELECT tablename FROM pg_tables;
CREATE SEQUENCE test_sequentie START 1 INCREMENT 1;
SELECT currval('test_sequentie');
SELECT last_value FROM test_sequentie;
SELECT currval('test_sequentie');
SELECT last_value FROM pg_sequences WHERE sequencename = 'test_sequentie';
UPDATE pg_sequences SET increment_by = 5 WHERE sequencename = 'test_sequentie';
SELECT * FROM pg_sequences;
SELECT * FROM pg_sequence;
SELECT table_name, table_type FROM information_schema.tables WHERE table_type= 'VIEW' AND table_catalog = 'HolidayPark';
SELECT * FROM pg_locks;
SELECT * FROM pg_class;
SELECT oid, relname FROM pg_class WHERE oid IN (SELECT relation FROM pg_locks);
BEGIN;
SELECT * FROM countries;
UPDATE countries SET country_name = 'Nederland' WHERE country_code = '2';
ROLLBACK;