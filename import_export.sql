-- copy the results of the query to file
COPY (SELECT * FROM build_info WHERE yr_renovated > 0) 
TO '/Users/yuchen/Desktop/renovated_homes.csv'  DELIMITER ',' CSV HEADER

--copy file to main_home table
COPY main_home FROM '/Users/yuchen/Desktop/main_home_bulk.csv'  DELIMITER ',' CSV HEADER
