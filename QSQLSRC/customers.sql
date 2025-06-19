-- Creating the table for the customers table
create or replace table
    customers (
        custid char(5),
        name char(20),
        city char(20),
        province char(10),
        primary key (custid)
    ) rcdfmt customersf