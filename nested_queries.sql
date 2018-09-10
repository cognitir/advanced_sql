
-- Median freight
SELECT percentile_cont(0.5) 
WITHIN GROUP (ORDER BY freight)
FROM orders

-- Average freight
SELECT AVG(freight) FROM orders

-- Exercise: Your finance department wants to find the average sales per order.
SELECT AVG(od.unitprice * od.quantity) as total_sale 
FROM orders o
JOIN order_details od on od.orderid = o.orderid

-- more polished solution
SELECT ROUND(AVG(od.unitprice * od.quantity)::numeric, 2) AS total_sale 
FROM orders o
JOIN order_details od on od.orderid = o.orderid


-- Your finance manager wants to examine all orders with freight costs 
-- that are in the above the median (i.e., the more expensive orders to ship).

SELECT * FROM orders WHERE freight >
	(SELECT percentile_cont(0.5) 
	WITHIN GROUP (ORDER BY
freight) FROM orders)

-- Exercise: Your finance manager wants to examine all orders that have below average sales per order.


SELECT * FROM orders o
JOIN order_details od on od.orderid = o.orderid
WHERE od.unitprice * od.quantity <
(SELECT AVG(od.unitprice * od.quantity) as total_sale 
FROM orders o
JOIN order_details od on od.orderid = o.orderid)
