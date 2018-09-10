select customerid, count, RANK() OVER (order by count desc)
FROM (
	select o.customerid, count(*) 
    FROM orders o JOIN order_details od 
    ON od.orderid = o.orderid group by o.customerid) temp;