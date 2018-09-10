
--Which zip codes have the most houses in our database?
SELECT zipcode, COUNT(*) as "Number of Houses" 
FROM location_table
GROUP BY zipcode
ORDER BY COUNT(*) DESC;


-- Please provide a list of all zip codes with more 
-- than 500 houses in the database.
SELECT zipcode, COUNT(*) as "Number of Houses" 
FROM location_table
GROUP BY zipcode
HAVING COUNT(*) > 500
ORDER BY COUNT(*) DESC;


-- What is the total population in all of 
-- the zip codes in our database?
SELECT SUM(population)
FROM zip_code_data;


-- 2. What are the names of the  realtors 
-- who have sold more than 200 houses?
SELECT ri.first, ri.last, COUNT(*)

--We are selecting first and last from the realtor_info 
-- table since we care about the realtors’ names.

FROM realtor_info ri
JOIN house_details hd ON hd.realtor_id = ri.realtor_id
GROUP BY ri.realtor_id
HAVING COUNT(*) > 200
ORDER BY COUNT(*) DESC

-- We have to join house_details to realtor_info since 
-- house_details contains info on the houses sold by realtor, 
-- and realtor_info contains the names of the realtors. 
-- If this question asked only for the realtor_ids, 
-- we wouldn’t need a join!



-- What is the average population of zip 
-- codes from 98001 - 98010?
-- liable to more bugs and inaccuracies
SELECT AVG(population)
FROM zip_code_data
WHERE zip_code <= 98010;

-- better
SELECT AVG(population)
FROM zip_code_data
WHERE zip_code >= 98000 AND zip_code <= 98010;


-- 4. One performance metric realtors are evaluated on is size of 
-- houses sold in our firm. What is the average number of 
-- bedrooms + bathrooms sold by each realtor?

SELECT ri.first, ri.last, AVG(bedrooms + bathrooms)
FROM realtor_info ri
JOIN house_details hd ON hd.realtor_id = ri.realtor_id
GROUP BY ri.realtor_id
ORDER BY AVG(bedrooms + bathrooms) DESC
