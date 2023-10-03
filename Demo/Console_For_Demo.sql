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