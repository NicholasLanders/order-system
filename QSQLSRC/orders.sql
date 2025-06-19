-- Creating the table for the customers table
create or replace table
    orders (
        orderid char(5),
        custid char(5),
        itemname char(20),
        quantity decimal(5, 0),
        status char(20),
        primary key (orderid),
        foreign key (custid) references customers (custid)
    ) rcdfmt ordersf