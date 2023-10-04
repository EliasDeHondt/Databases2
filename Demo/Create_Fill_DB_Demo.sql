drop table IF EXISTS emp cascade;
drop table IF EXISTS dept cascade;
drop table IF EXISTS bonus cascade;
drop table IF EXISTS salgrade cascade;
drop table IF EXISTS dummy;

CREATE TABLE EMP
       (EMPNO    NUMERIC(4) constraint pk_emp primary key,
        ENAME    VARCHAR(10) constraint ch_ename check (ename = upper(ename)),
        JOB      VARCHAR(9),
        MGR      NUMERIC(4),
        HIREDATE DATE,
        SAL      NUMERIC(7,2) constraint ch_sal check (sal between 500 and 6000), 
        COMM     NUMERIC(7,2),
        DEPTNO   NUMERIC(2) not null);

INSERT INTO EMP VALUES
        (7369,'SMITH','CLERK',7902,'17-DEC-80',800,NULL,20);
INSERT INTO EMP VALUES
        (7499,'ALLEN','SALESMAN',7698,'20-FEB-81',1600,300,30);
INSERT INTO EMP VALUES
        (7521,'WARD','SALESMAN',7698,'22-FEB-81',1250,500,30);
INSERT INTO EMP VALUES
        (7566,'JONES','MANAGER',7839,'2-APR-81',2975,NULL,20);
INSERT INTO EMP VALUES
        (7654,'MARTIN','SALESMAN',7698,'28-SEP-81',1250,1400,30);
INSERT INTO EMP VALUES
        (7698,'BLAKE','MANAGER',7839,'1-MAY-81',2850,NULL,30);
INSERT INTO EMP VALUES
        (7782,'CLARK','MANAGER',7839,'9-JUN-81',2450,NULL,10);
INSERT INTO EMP VALUES
        (7788,'SCOTT','ANALYST',7566,'09-DEC-82',3000,NULL,20);
INSERT INTO EMP VALUES
        (7839,'KING','PRESIDENT',NULL,'17-NOV-81',5000,NULL,10);
INSERT INTO EMP VALUES
        (7844,'TURNER','SALESMAN',7698,'8-SEP-81',1500,0,30);
INSERT INTO EMP VALUES
        (7876,'ADAMS','CLERK',7788,'12-JAN-83',1100,NULL,20);
INSERT INTO EMP VALUES
        (7900,'JAMES','CLERK',7698,'3-DEC-81',950,NULL,30);
INSERT INTO EMP VALUES
        (7902,'FORD','ANALYST',7566,'3-DEC-81',3000,NULL,20);
INSERT INTO EMP VALUES
        (7934,'MILLER','CLERK',7782,'23-JAN-82',1300,NULL,10);

CREATE TABLE DEPT
       (DEPTNO NUMERIC (2) constraint pk_Dept primary key,
        DNAME  VARCHAR(14),
        LOC    VARCHAR(13),
        constraint u_name unique(dname,loc));

INSERT INTO DEPT VALUES
        (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES
        (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES
        (40,'OPERATIONS','BOSTON');

alter table emp
add constraint fk_emp_dept foreign key (deptno) references dept(deptno);

CREATE TABLE BONUS
        (
        ENAME VARCHAR(10),
        JOB   VARCHAR(9),
        SAL   NUMERIC,
        COMM  NUMERIC
        );

CREATE TABLE SALGRADE
      ( GRADE NUMERIC,
        LOSAL NUMERIC,
        HISAL NUMERIC );

INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

CREATE TABLE DUMMY
      ( DUMMY NUMERIC );

INSERT INTO DUMMY VALUES (0);

COMMIT;