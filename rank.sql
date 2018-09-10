
-- query to get top customers by orders (rank)
select customerid, count, RANK() OVER (order by count desc)
FROM (
	select o.customerid, count(*) 
    FROM orders o JOIN order_details od 
    ON od.orderid = o.orderid group by o.customerid) temp;

-- query to get top customers by orders (dense rank)
SELECT customerid, count, DENSE_RANK() OVER (order by count desc)
FROM (
	SELECT o.customerid, COUNT(*) 
    FROM orders o JOIN order_details od 
    ON od.orderid = o.orderid GROUP BY o.customerid) temp;

