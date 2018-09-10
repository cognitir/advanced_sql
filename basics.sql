
-- 2. How many rows of data are stored in the 
-- realtor_info table?

SELECT COUNT(*)
FROM realtor_info;

-- 3. Provide all house details rows that are from 
-- the 98002 zip code.

SELECT * 
FROM location_table
JOIN house_details ON house_details.house_ids = location_table.house_id
WHERE zipcode = 98002;

SELECT * 
FROM location_table lt
JOIN house_details hd ON hd.house_ids = lt.house_id
WHERE zipcode = 98002;
