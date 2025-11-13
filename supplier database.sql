create database supplier;
use supplier;

CREATE TABLE SUPPLIERS (
    SID INT PRIMARY KEY NOT NULL,
    SNAME VARCHAR(50),
    CITY VARCHAR(50)
);

INSERT INTO SUPPLIERS (SID, SNAME, CITY) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

select * from SUPPLIERS;

CREATE TABLE PARTS (
    PID INT PRIMARY KEY NOT NULL,
    PNAME VARCHAR(50),
    COLOR VARCHAR(20)
);

INSERT INTO PARTS (PID, PNAME, COLOR) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

select * from PARTS;


CREATE TABLE CATALOG (
    SID INT,
    PID INT,
    COST INT,
    FOREIGN KEY (SID) REFERENCES SUPPLIERS(SID),
    FOREIGN KEY (PID) REFERENCES PARTS(PID)
);

INSERT INTO CATALOG (SID, PID, COST) VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

select * from CATALOG;



SELECT DISTINCT P.PNAME
FROM PARTS P
JOIN CATALOG C ON P.PID = C.PID;


SELECT S.SNAME
FROM SUPPLIERS S
WHERE NOT EXISTS (
    SELECT P.PID
    FROM PARTS P
    WHERE NOT EXISTS (
        SELECT *
        FROM CATALOG C
        WHERE C.SID = S.SID AND C.PID = P.PID
    )
);


SELECT S.SNAME
FROM SUPPLIERS S
WHERE NOT EXISTS (
    SELECT P.PID
    FROM PARTS P
    WHERE P.COLOR = 'Red'
    AND NOT EXISTS (
        SELECT *
        FROM CATALOG C
        WHERE C.SID = S.SID AND C.PID = P.PID
    )
);



SELECT P.PNAME
FROM PARTS P
JOIN CATALOG C ON P.PID = C.PID
JOIN SUPPLIERS S ON C.SID = S.SID
WHERE S.SNAME = 'Acme Widget'
AND P.PID NOT IN (
    SELECT C2.PID
    FROM CATALOG C2
    JOIN SUPPLIERS S2 ON C2.SID = S2.SID
    WHERE S2.SNAME != 'Acme Widget'
);



SELECT DISTINCT C1.SID
FROM CATALOG C1
WHERE C1.COST > (
    SELECT AVG(C2.COST)
    FROM CATALOG C2
    WHERE C2.PID = C1.PID
);


SELECT  S.SNAME
FROM PARTS P
JOIN CATALOG C ON P.PID = C.PID
JOIN SUPPLIERS S ON C.SID = S.SID
WHERE C.COST = (
    SELECT MAX(C2.COST)
    FROM CATALOG C2
    WHERE C2.PID = P.PID
);


select s.sname, p.pname, c.cost from parts p
join catalog c on c.pid=p.pid
join suppliers s on s.sid = c.sid
where c.cost = (select MAX(cost) from catalog);



select s.sname from suppliers s
join catalog c ON s.sid = c.sid
where s.sid NOT IN (select distinct c.sid from catalog c
join parts p On c.pid = p.pid
where p.color = "red");


select s.sname , sum(c.cost) from suppliers s 
join catalog c on c.sid = s.sid
group by (s.sname);


select s.sname, count(s.sid) from suppliers s 
join catalog c on s.sid = c.sid
join parts p on  c.pid=p.pid
where c.cost<20 
group by s.sname
having count(s.sid)>=2 ;


select s.sname, p.pname, c.cost from suppliers s 
join catalog c on s.sid = c.sid
join parts p on  c.pid=p.pid
where c.cost = (select MIN(c2.cost) from catalog c2
where c2.pid = p.pid);



create view partsCount AS
Select s.sname, count(distinct( c.pid)) from suppliers s
join catalog c on s.sid = c.sid
group by s.sname;

select * from partsCount;


create view mostExp AS
select s.sname, p.pname, c.cost from suppliers s 
join catalog c on s.sid = c.sid
join parts p on  c.pid=p.pid
where c.cost = (select MaX(c2.cost) from catalog c2
where c2.pid = p.pid);

select * from mostExp;


DELIMITER //
CREATE TRIGGER prevent_low_cost
BEFORE INSERT ON CATALOG
FOR EACH ROW
BEGIN
    IF NEW.COST < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost must be at least ₹1';
    END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER set_default_cost
BEFORE INSERT ON CATALOG
FOR EACH ROW
BEGIN
    IF NEW.COST IS NULL THEN
        SET NEW.COST = 10; -- Default cost value
    END IF;
END;
//
DELIMITER ;




delimiter $$
create trigger costCheck
before insert on catalog 
For each row 
Begin 
if new.cost <1
then SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost must be at least ₹1';
    END IF;

End;
$$
delimiter ;

insert into catalog values (10004, 20001, 300);
insert into catalog values (10002, 20003, 0);

select * from catalog;



delimiter $$
create trigger costDefault
before insert on catalog 
For each row 
Begin 
if new.cost is NULL
then set new.cost = 10;
    END IF;

End;
$$
delimiter ;

insert into catalog values (10004, 20001, NULL);
select * from catalog;





