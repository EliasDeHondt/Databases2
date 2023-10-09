SELECT * FROM emp;

SELECT * FROM emp WHERE deptno=30 AND comm is NULL OR comm=0;

UPDATE emp SET sal=sal*1.1, comm=0.15*emp.sal WHERE deptno=30 AND (comm IS NULL OR comm=0);

SELECT * FROM bonus;

UPDATE emp SET sal=sal*1.1 WHERE emp.ename NOT IN (SELECT ename FROM emp);

UPDATE emp SET comm=NULL WHERE upper(job)='SALESMAN';

SELECT * FROM dept;

UPDATE emp e
SET deptno=(SELECT deptno FROM dept WHERE upper(loc)='BOSTON'),
    (sal, comm)=(SELECT AVG(sal)*1.1, AVG(comm)*1.5 FROM emp WHERE deptno=e.deptno)
WHERE deptno IN (SELECT deptno FROM dept WHERE upper(loc) IN ('DALLAS', 'DETROIT'));

COMMIT;

INSERT INTO bonus
SELECT ename, job, sal, comm FROM emp WHERE upper(job) IN ('PRESIDENT', 'MANAGER') AND comm < sal*0.25;

SELECT * FROM bonus;

UPDATE dept SET deptno=50 WHERE UPPER(dname)='ACCOUNTING';
DELETE FROM dept WHERE UPPER(loc)='DALLAS';

-- VB:

-- BEGIN;
-- SQL statements to make changes to the database
-- UPDATE employees SET salary = salary * 1.1 WHERE department_id = 1;
-- Explicitly commit the transaction to save changes
-- COMMIT;

BEGIN;
-- SQL
SAVEPOINT save_1;
-- SQL
SAVEPOINT save_2;
-- SQL
ROLLBACK TO SAVEPOINT save_1;
-- SQL
COMMIT;

UPDATE emp e SET sal = sal * 1.1 WHERE sal < (SELECT AVG(sal) FROM emp WHERE deptno=e.deptno);

CREATE USER praktijk PASSWORD 'ROOT123456789' SUPERUSER;

CREATE USER theorie PASSWORD 'ROOT123456789' SUPERUSER;

-- INFO over VACUUM
CREATE TABLE testTabel( id int ) WITH (AUTOVACUUM_ENABLED = OFF); -- AUTOVACUUM_ENABLED = ON is default
INSERT INTO testTabel SELECT id FROM generate_series(1, 100000) AS id; -- 100000 rijen
SELECT * FROM testTabel;
SELECT PG_SIZE_PRETTY( PG_TOTAL_RELATION_SIZE('testTabel') ); -- Hoeveel ruimte neemt de tabel in
UPDATE testTabel SET id = id + 1;
SELECT PG_SIZE_PRETTY( PG_TOTAL_RELATION_SIZE('testTabel') );
VACUUM testTabel;
SELECT PG_SIZE_PRETTY( PG_TOTAL_RELATION_SIZE('testTabel') );
VACUUM FULL testTabel; -- Alle kolommen van de tabel worden opnieuw geschreven
VACUUM testTabel ( id ); -- Alleen de kolom id

-- INFO over TABLESPACE
CREATE TABLESPACE testTabelSpace LOCATION 'C:\Users\Gebruiker\Documents\testTabelSpace'; -- Locatie van de tabel
CREATE TABLE testTabel2 ( id int ) TABLESPACE testTabelSpace; -- Tabel in de tabelspace

-- INFO over ALTER TABLE
-- Wat kan je doen met ALTER TABLE
ALTER TABLE testTabel ADD COLUMN naam varchar(255); -- Kolom toevoegen
ALTER TABLE testTabel ALTER COLUMN naam SET NOT NULL; -- Kolom verplicht maken
ALTER TABLE testTabel ALTER COLUMN naam DROP NOT NULL; -- Kolom niet meer verplicht maken
ALTER TABLE testTabel ALTER COLUMN naam SET DEFAULT 'test'; -- Default waarde geven aan kolom
ALTER TABLE testTabel ALTER COLUMN naam DROP DEFAULT; -- Default waarde verwijderen
ALTER TABLE testTabel ALTER COLUMN naam TYPE varchar(255); -- Type van kolom veranderen
ALTER TABLE testTabel ALTER COLUMN naam SET STATISTICS 1000; -- Statistieken van kolom veranderen
ALTER TABLE testTabel ALTER COLUMN naam SET STORAGE PLAIN; -- Opslag van kolom veranderen (PLAIN, EXTERNAL, EXTENDED, MAIN)

-- Ik wil in tabel emp de kolom deptno 30 naar 35
UPDATE emp SET deptno = 35 WHERE deptno = 30;
-- Dit kan niet want er is een foreign key constraint op deptno dus
UPDATE dept SET deptno = 35 WHERE deptno = 30;
-- Dit kan ook niet want er is een foreign key constraint op deptno dus dus TRIIGER
ALTER TABLE emp DISABLE TRIGGER all; -- Alle triggers uitschakelen
UPDATE emp SET deptno = 35 WHERE deptno = 30;

ALTER TABLE dept DISABLE TRIGGER all; -- Alle triggers uitschakelen
UPDATE dept SET deptno = 35 WHERE deptno = 30;

ALTER TABLE emp ENABLE TRIGGER all; -- Alle triggers inschakelen
ALTER TABLE dept ENABLE TRIGGER all; -- Alle triggers inschakelen
SELECT * FROM emp;


UPDATE dept SET dname='sales' WHERE dname='SALES';
SELECT * FROM dept;
-- Maak hier een constraint voor aan alles moet in hoofdletters
ALTER TABLE dept ADD CONSTRAINT dname_uppercase CHECK (dname = UPPER(dname)) NOT VALID; -- NOT VALID is om de constraint niet te laten werken
UPDATE dept SET dname=UPPER(dname); -- Zet alles in hoofdletters
ALTER TABLE dept VALIDATE CONSTRAINT dname_uppercase; -- VALIDATE is om de constraint te laten werken

-- Wat is een synonym en hoe maak je die aan in PGadmin
CREATE VIEW testView AS SELECT * FROM dept; -- Maak een view aan

-- Sequence
INSERT INTO emp(empno, ename, job, sal, deptno) VALUES ((SELECT max(empno) FROM emp) + 1, 'TEST', 'TEST', 1000, 35); -- Voeg een rij toe aan de tabel
SELECT * FROM emp ORDER BY empno DESC; -- Bekijk de tabel

CREATE SEQUENCE empSequence START 7935; -- Maak een sequence aan
SELECT NEXTVAL('empSequence'); -- Geef de volgende waarde van de sequence
SELECT CURRVAL('empSequence'); -- Geef de huidige waarde van de sequence
SELECT SETVAL('empSequence', 100); -- Zet de waarde van de sequence op 100

INSERT INTO emp(empno, ename, job, sal, deptno) VALUES (NEXTVAL('empSequence'), 'TEST', 'TEST', 1000, 35);

-- Identity Column
-- CREATE TABLE students ( id int GENERATED ALWAYS AS IDENTITY ); -- Maak een tabel aan met een identity column (always)
-- of
-- CREATE TABLE students ( id int GENERATED BY DEFAULT AS IDENTITY ); -- Maak een tabel aan met een identity column (default)

CREATE TABLE students ( id int GENERATED ALWAYS AS IDENTITY CONSTRAINT students_pk PRIMARY KEY,
                        name varchar(255) NOT NULL
                      ); -- Maak een tabel aan met een identity column (always) en een primary key

INSERT INTO students (name) VALUES ('TEST'); -- Voeg een rij toe aan de tabel

DROP TABLE students; -- Verwijder de tabel

CREATE TABLE students ( id int GENERATED BY DEFAULT AS IDENTITY CONSTRAINT students_pk PRIMARY KEY,
                        name varchar(255) NOT NULL
                      ); -- Maak een tabel aan met een identity column (always) en een primary key

INSERT INTO students VALUES (DEFAULT, 'TEST'); -- Voeg een rij toe aan de tabel

SELECT * FROM students; -- Bekijk de tabel