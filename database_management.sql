-- copy the results of the query to file
COPY (SELECT * FROM build_info WHERE yr_renovated > 0) 
TO '/Users/yuchen/Desktop/renovated_homes.csv'  DELIMITER ',' CSV HEADER

--copy file to main_home table
COPY main_home FROM '/Users/yuchen/Desktop/main_home_bulk.csv'  DELIMITER ',' CSV HEADER

-- create index to expedite queries
CREATE INDEX orders_index ON orders (shipcountry);

-- Use EXPLAIN ANALYZE to help get a sense of where the bottlenecks are in your queries:
EXPLAIN ANALYZE SELECT * FROM orders WHERE shipcountry = ‘France’;

-- delete a row
DELETE FROM realtors
WHERE id = 2131341

-- single row insert

INSERT INTO 
realtors(id, price, year, month, day) 
VALUES(2131341, 100000, 1900, 10, 10)


-- multiple row insert
INSERT INTO main_home 
(id, price, year, month, day) 
VALUES 
(500, 40000, 2019, 12,25),
(501, 40400, 2019, 12,25);


-- create view
CREATE OR REPLACE VIEW high_freight_orders AS 
SELECT * FROM orders WHERE freight >
	(SELECT percentile_cont(0.5) 
	WITHIN GROUP (ORDER BY
freight) FROM orders)

-- query from view
SELECT * FROM 
fetch_high_freight_orders


-- create materialized view
CREATE MATERIALIZED VIEW discount_correlations AS
SELECT 
o.shipcountry, 
CORR(unitprice, discount) AS price_discount_correlation, COUNT(*) AS order_count  
FROM order_details od JOIN orders o ON o.orderid = od.orderid GROUP BY o.shipcountry 
ORDER BY price_discount_correlation DESC;

-- query from view
SELECT * FROM discount_correlations 

-- refresh view
REFRESH MATERIALIZED VIEW discount_correlations;
