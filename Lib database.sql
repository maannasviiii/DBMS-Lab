create database lib;
use lib;

create table students(
id int primary key,
name varchar(50),
dept varchar(50),
year int
);

create table books(
book_id int primary key,
title varchar(50),
author varchar (50),
category varchar(30)
);

create table borrowed(
borrow_id int primary key,
id int,
book_id int,
borrow_date date,
return_date date,
foreign key (id) references students(id),
foreign key(book_id) references books(book_id)
);


insert into students  
values (1, "alice", "CSE", 2),
 (2, "bob", "MEC", 3),
  (3, "carol", "CSE", 1),
   (4, "david", "EEE", 4);
   
   
insert into books
values (101, "DB Systems","Navathe","CS"),
(102, "operating Systems","silerschat","CS"),
(103, "Physics fundamentals","Hilliday","science"),
(104, "modern fiction","orwell","fiction");
   
   
insert into borrowed
values (1,1,101,"2024-01-10","2024-01-20"),
(2,2,103,"2024-02-10",NULL),
(3,3,102,"2024-02-15","2024-03-01"),
(4,1,104,"2024-03-10",NULL);
   

select * from students;
select * from books;
select * from borrowed;
   
   
select * from students 
where dept = "CSE";   
   

select b.title from books b
join borrowed bb on b.book_id=bb.book_id
where bb.return_date IS NULL;
   
select s.name from students s
join borrowed b on s.id=b.id
where borrow_date like"2024-02-%";
   

select s.id, count(s.id) from students s
join borrowed b on s.id= b.id
group by(s.id);


select b.title, b.author, s.name from books b
join borrowed bb on b.book_id = bb.book_id 
join students s on s.id=bb.id;



SELECT b.book_id, COUNT(*)
FROM books b
JOIN borrowed bb ON b.book_id = bb.book_id
GROUP BY b.book_id, b.title;



select s.name from students s
where s.name not in (select s1.name from students s1
join borrowed b on s.id=b.id);
   
   

select category, count(book_id) from books
group by(category);
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   