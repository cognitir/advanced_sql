-- without window functions

SELECT productname, AVG(od.unitprice)
FROM order_details od 
JOIN products p ON od.productid = p.productid
GROUP BY productname

-- I’d like to see the sale price of each order compared to the average sales price 
-- for all orders with the same quantity.
SELECT od.orderid, od.quantity, p.productname, od.unitprice, AVG(od.unitprice) 
OVER (PARTITION BY od.quantity) as benchmark
FROM order_details od 
JOIN products p ON od.productid = p.productid;


-- Show me each product with its listed price compared to the average price a 
-- Northwind product sold is listed for (in the product table), and the average price it is sold 
-- for (in the order details table)?

SELECT p.productname, p.unitprice, AVG(p.unitprice) OVER() as listedprice, 
AVG(od.unitprice) OVER() as soldprice FROM products p 
JOIN order_details od ON od.productid = p.productid;


-- running totals:
SELECT o.orderid, o.orderdate, od.unitprice * od.quantity as revenue, sum(unitprice * quantity) OVER (ORDER BY o.orderid) 
FROM order_details od 
JOIN orders o on o.orderid = od.orderid;


-- What is the difference in unit price between each product and the average 
-- unit price of that product’s category?
SELECT productname, unitprice, avg as categoryprice, unitprice - avg as difference FROM
(SELECT productname, unitprice, AVG(unitprice) OVER (PARTITION BY(categoryid))
FROM products) temp ORDER BY difference desc;


-- Which products have suppliers who are currently deemed as low-performing 
-- (ie. on average have less than 10 units stocked)?

SELECT * FROM
(SELECT productname, supplierid, unitsinstock, round(AVG(unitsinstock) OVER (PARTITION BY (supplierid)),1) AS avg_supplier_stock
FROM products) temp
WHERE temp.avg_supplier_stock < 10;
