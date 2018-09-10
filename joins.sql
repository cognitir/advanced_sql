
-- We will always return every row from house_details 
-- with the LEFT JOIN:
SELECT COUNT(*)
FROM house_details hd
LEFT JOIN realtor_info ri ON hd.realtor_id = ri.realtor_id;


-- We will ONLY return rows from house_details that have 
-- a matching realtor_id with the INNER JOIN:

SELECT COUNT(*)
FROM house_details hd
INNER JOIN realtor_info ri ON hd.realtor_id = ri.realtor_id;
-- 21423

-- this is equivalent to 
SELECT COUNT(*) 
FROM house_details 
WHERE realtor_id IN
(SELECT realtor_id FROM realtor_info)


-- Some houses don’t have realtors (ie. some rows in 
-- house_details have NULL values for realtor_id).
SELECT *
FROM house_details WHERE realtor_id IS NULL;


SELECT COUNT(*)
FROM house_details hd
JOIN realtor_info ri ON hd.realtor_id = ri.realtor_id;
-- 21423

SELECT COUNT(*)
FROM house_details hd
RIGHT JOIN realtor_info ri ON hd.realtor_id = ri.realtor_id;
-- 21428

SELECT COUNT(*)
FROM house_details hd
FULL OUTER JOIN realtor_info ri ON hd.realtor_id = ri.realtor_id;
-- 21441


-- These are all the rows from house_details that have a 
-- matching realtor_id in realtor_info.
SELECT COUNT(*)
FROM house_details hd
INNER JOIN realtor_info ri ON hd.realtor_id = ri.realtor_id;
-- 21423


SELECT COUNT(DISTINCT realtor_id) 
FROM house_details --105

SELECT COUNT(DISTINCT realtor_id) 
FROM realtor_info -- 110

-- The difference here is the number of realtors who 
-- have no house_details associated with them (ie. they have sold no houses).


-- Do we really have 80,964 units in stock 
-- for products with unit prices over $5? 
--find the total number of units in stock for products 
-- over $5 unit price in orders.

SELECT COUNT(*) FROM products 
JOIN order_details od ON od.productid = products.productid 
WHERE od.unitprice > 5;

SELECT COUNT(*) FROM products;

-- When you join one to many tables, keep track of the 
-- row counts, especially when using SUM aggregate functions.
--  You may be inadvertently inflating the metrics you are 
-- reporting on.



-- The business development team wants a data export of 
-- all the data from main_home and their build information, 
-- even the current builds that have not completed.

SELECT *
FROM main_home mh
FULL OUTER JOIN build_info bi ON bi.house_id  = mh.id;

SELECT *
FROM main_home mh
RIGHT JOIN build_info bi ON bi.house_id  = mh.id;

-- The business development team wants to know the 
-- average income at an individual person level for
-- our total addressable market.

-- Incorrect
SELECT AVG(avg_income::numeric) as "Average"
FROM zip_code_data;

-- Correct
SELECT SUM(avg_income::numeric * population) / SUM(population) as "True Average"
FROM zip_code_data;


-- The business development team wants to know the average 
-- income at a zip code level for all the zip codes 
-- where we have houses.

SELECT hd.grade, AVG(avg_income::numeric)
FROM zip_code_data zd
-- We are using INNER JOINs here because we only 
-- care about the incomes when there is a match with 
-- house_details (ie. we have registered houses).

JOIN location_table lt ON zd.zip_code = lt.zipcode
JOIN house_details hd ON hd.house_ids = lt.house_id
GROUP BY hd.grade
ORDER BY hd.grade


-- Use UNION to find all female sales representatives and male employees born before 1960 working for the company.

SELECT * 
FROM employees
WHERE titleofcourtesy LIKE 'Ms.' AND title LIKE 'Sales Rep%'
UNION
SELECT * 
FROM employees
WHERE titleofcourtesy LIKE 'Mr.' AND birthdate < '1960-01-01'


-- 5. USE EXCEPT to find all employees who are 
-- either male or have PhDs, but are not vice presidents.
SELECT * FROM employees WHERE titleofcourtesy IN ('Mr.', 'Dr.')
EXCEPT
SELECT * FROM employees WHERE title ILIKE '%VICE%'
