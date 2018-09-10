
-- Display all realtors whose first name is Malcolm
SELECT * FROM realtor_info WHERE "first" LIKE 'Malcolm';

-- Display all realtors whose first name ends in an “a” or “e”.
SELECT * FROM realtor_info WHERE "first" LIKE '%a' OR "first" LIKE '%e';

-- Display all realtors who have a .com email address.
SELECT * FROM realtor_info WHERE email LIKE '%.com';

-- Display all realtors whose second to last letter of their last name is an “e”.
SELECT * FROM realtor_info WHERE "last" LIKE '%e_';


--Find realtors with emails that begin with a, c, or x:

SELECT * FROM realtor_info 
WHERE email ~ '^(a|c|x)';

-- equivalent to
SELECT * FROM realtor_info 
WHERE email 
LIKE 'a%' OR 
email LIKE 'c%' OR 
email LIKE 'x%';


-- Find realtors from the limited liability company Sed. However, unfortunately 
-- the person responsible for data entry didn’t enter the company names consistently. 
-- We’ll need to search for a company that has Sed anywhere in the company_name, 
-- sometimes has other descriptors (words) after it, and then ends with LLC.

SELECT * FROM realtor_info
WHERE company ~ 'Sed\s.*LLC';

-- realtors with two vowels back to back in first name
SELECT * FROM realtor_info 
WHERE "first" ~ '[a,e,i,o,u]{2}'

-- Find all employees who have a bachelors in English 
-- (HINT: look at the pattern of the text in the notes column of the employees table)

SELECT * FROM employees 
WHERE notes ~'B[A|S]( degree)? in English'

-- 2. All employees who have car privileges have 45 as the two middle digits in their extension 
-- and an international zip code (ie. SI2 4D9). Find this employee.

SELECT * FROM employees 
WHERE extension ~ '^[0-9]45[0-9]$' 
AND postalcode ~ '.{3}\s.{3}'


--3. Find all realtors who have a valid email registered to an educational institution 
--(LIKE ‘%.edu’ is not sufficient here, since ‘2.edu’ is not a valid email)

SELECT * 
FROM realtor_info 
WHERE email ~ '.+@.+\.edu$'


-- 4. Return just the names of all realtors whose first names contain an “ai”.

SELECT 
unnest(regexp_matches(first, '.+ai.+$')) 
FROM realtor_info
