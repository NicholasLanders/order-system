-- Creating the table for the customers table
create or replace table
    orders (
        orderid char(5),
        custid char(5),
        itemname varchar(20),
        quantity int,
        status varchar(20),
        primary key (orderid),
        foreign key (custid) references customers (custid)
    ) rcdfmt ordersf