create database employee;
use employee;

CREATE TABLE dept (
deptno decimal(2,0) primary key,
dname varchar(14) default NULL,
dloc varchar(13) default NULL
);

INSERT INTO dept VALUES (10,"ACCOUNTING","MUMBAI"),
(20,"RESEARCH","BENGALURU"),
(30,"SALES","DELHI"),
(40,"OPERATIONS","CHENNAI"),
(50,"Marketing","CHENNAI");

select * from dept;

CREATE TABLE emp (
empno decimal(4,0) primary key,
ename varchar(10) default NULL,
mgr_no decimal(4,0) default NULL,
hiredate date default NULL,
sal decimal(7,2) default NULL,
deptno decimal(2,0) references dept(deptno) on delete cascade on update cascade
);

INSERT INTO emp VALUES (7369,"Adarsh",7839,"2012-12-17","80000.00","20"),
(7499,"Shruthi",7654,"2013-02-20","16000.00","30"),
(7521,"Anvitha",7654,"2015-02-22","12500.00","30"),
(7566,"Tanvir",7839,"2008-04-02","29750.00","20"),
(7654,"Ramesh",7839,"2014-09-28","12500.00","30"),
(7839,"King",NULL,"2010-12-09","28500.00","20");

select * from emp;

create table incentives (
empno decimal(4,0) references emp(empno) on delete cascade on update cascade,
incentive_date date,
incentive_amount decimal(10,2),
primary key(empno,incentive_date)
);

INSERT INTO incentives VALUES(7499,"2019-02-01",5000.00);
INSERT INTO incentives VALUES(7521,"2019-03-01",2500.00);
INSERT INTO incentives VALUES(7566,"2022-02-01",5070.00);
INSERT INTO incentives VALUES(7654,"2020-02-01",2000.00);
INSERT INTO incentives VALUES(7654,"2022-04-01",879.00);

select * from incentives;

Create table project (
pno int primary key,
pname varchar(30) not null,
ploc varchar(30)
);

INSERT INTO project VALUES(101,"AI Project","BENGALURU");
INSERT INTO project VALUES(102,"IOT","HYDERABAD");
INSERT INTO project VALUES(103,"BLOCKCHAIN","BENGALURU");
INSERT INTO project VALUES(104,"DATA SCIENCE","MYSURU");
INSERT INTO project VALUES(105,"AUTONOMUS SYSTEMS","PUNE");

select * from project;


Create table assigned_to (
empno decimal(4,0) references emp(empno) on delete cascade on update cascade,
pno int references project(pno) on delete cascade on update cascade,
job_role varchar(30),
primary key(empno,pno)
);

INSERT INTO assigned_to VALUES(7499,101,"Software Engineer");
INSERT INTO assigned_to VALUES(7521,101,"Software Architect");
INSERT INTO assigned_to VALUES(7566,101,"Project Manager");
INSERT INTO assigned_to VALUES(7654,102,"Sales");
INSERT INTO assigned_to VALUES(7521,102,"Software Engineer");

select * from assigned_to;

select empno from emp
where empno not in (select empno from incentives);


SELECT m.ename, count(*)
FROM emp e,emp m
WHERE e.mgr_no = m.empno
GROUP BY m.ename
HAVING count(*) =(SELECT MAX(mycount)
from (SELECT COUNT(*) mycount
FROM emp
GROUP BY mgr_no)a);



SELECT *
FROM emp m
WHERE m.empno IN
(SELECT mgr_no
FROM emp)
AND m.sal>
(SELECT avg(e.sal)
FROM emp e
WHERE e.mgr_no = m.empno );


select e.empNo from emp e,Project p,Assigned_to a
where e.empNo=a.empNo and a.pNo=p.pNo and p.ploc in( 'Bengaluru','Hyderabad','Mysuru');






