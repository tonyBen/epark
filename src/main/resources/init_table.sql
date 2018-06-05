-- table customer
drop table if exists customer;
create table customer(
	id serial primary key ,  
    account character varying  not null,
    password character varying  not null,
    name character varying  not null,
    company character varying ,
    phone character varying ,
    address character varying ,
    active boolean default true
);
-- customer parks
drop table if exists customer_parks;
create table customer_parks(
	id INTEGER not null, 
	customerid INTEGER not null,
	location character varying ,
	access character varying ,
	active boolean default true
);

-- operation logs 
drop table if exists operation_logs;
create table operation_logs(
	id character varying ,
	customerid INTEGER default 0,
	parkid INTEGER default 0,
	access character varying ,
	start_time timestamp,
	end_time timestamp,
	money double precision
);

-- init account
insert into customer(account,password,name) values('admin','admin','Administor');