
-- with our higher-price orders, do we tend to give more frequent discounts?
SELECT CORR(unitprice, discount) FROM order_details;

-- Are there any countries that we ship to where we tend to give more 
-- frequent discounts for our higher priced orders?
SELECT 
o.shipcountry, 
CORR(unitprice, discount) AS price_discount_correlation, COUNT(*) AS order_count  
FROM order_details od JOIN orders o ON o.orderid = od.orderid GROUP BY o.shipcountry 
ORDER BY price_discount_correlation DESC;

