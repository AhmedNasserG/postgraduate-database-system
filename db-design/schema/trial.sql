CREATE DATABASE PG



CREATE table thesis (id int primary key Identity)

create table report (thesis_number int,report_date datetime, primary key (thesis_number), foreign key (thesis_number) references thesis)
set IDENTITY_INSERT thesis on
insert into thesis(id) values (1)

insert into report values (1,'10/10/2021')

insert into supervise values (1,1)

select * from report 

insert into evaluate values (1, '10/10/2021',1)