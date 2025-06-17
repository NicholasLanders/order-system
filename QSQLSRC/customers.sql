-- Creating the table for the customers table
create or replace table
    customers (
        custid char(5),
        name varchar(20),
        city varchar(20),
        province varchar(10),
        primary key (custid)
    ) rcdfmt customersf