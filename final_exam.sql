
-- 1. Emails at AdventureWorks are based on first name (ie. john4@adventure…). 
-- Each time a new person with the same name joins, IT adds 1 to the email integer (john5@adventure…). 
-- The IT and HR coodinator would like to know which first name has been the most commonly assigned 
-- for emails at AdventureWorks (look in the person schema).
SELECT emailaddress, SUBSTRING(emailaddress FROM '[A-Za-z]*([0-9]?[0-9])@') AS number_suffix
FROM person.emailaddress ORDER BY number_suffix DESC


-- 2. AdventureWorks’ workforce planning department has noticed that male employees at the 
-- company are taking fewer vacation days than women. They suspect that lower pay leads to 
-- more vacation and sick days for women, especially single women. Confirm or reject this hypothesis.

-- CORR gives us a double data type, so we need to cast it to numeric first before rounding it!
SELECT 
	emp.gender, 
    emp.maritalstatus, 
    count(*),
    round(avg(vacationhours),1) as avg_vacation_hours,
    round(avg(sickleavehours), 1) as avg_sick_hours,
    round(avg(pay.payfrequency * pay.rate),1) as agv_total_comp,
    round(corr(pay.payfrequency * pay.rate, vacationhours)::numeric,2) as corr_comp_vacations,
    round(corr(pay.payfrequency * pay.rate, sickleavehours)::numeric,2) as corr_comp_sickdays
    FROM humanresources.employee emp JOIN humanresources.employeepayhistory pay 
JOIN (SELECT pay_hist.businessentityid, MAX(modifieddate) 
  FROM humanresources.employeepayhistory pay_hist 
  GROUP BY pay_hist.businessentityid) recent_pay 
  ON recent_pay.businessentityid = pay.businessentityid 
  AND recent_pay.max = pay.modifieddate
on pay.businessentityid = emp.businessentityid GROUP BY emp.gender, emp.maritalstatus;


-- 3. The workforce planning team has been hiring for a “diamond-shaped” workforce, 
-- where most of the employees are mid-level workers. Produce a report showing how many employees are 
-- in each level of the business. The CEO is Level 0- his direct subordinates are Level 1, and so on, 
-- along with average salary of each level. HINT: You’ll likely need to use the organizationnode column 
-- from humanresources.employee.
-- Use REPLACE() and LENGTH()
-- Make sure you know which tables have one-to-many relationships!


SELECT level, count(*), avg(total_comp)
	FROM (SELECT length(replace(emp.organizationnode, '/', '')) as level,
				pay.payfrequency * pay.rate as total_comp
			FROM humanresources.employee emp 
			JOIN humanresources.employeepayhistory pay ON pay.businessentityid = emp.businessentityid
			JOIN (SELECT pay_hist.businessentityid, MAX(modifieddate) FROM humanresources.employeepayhistory pay_hist GROUP BY pay_hist.businessentityid) recent_pay ON recent_pay.businessentityid = pay.businessentityid AND recent_pay.max = pay.modifieddate
			) temp GROUP BY level ORDER by level asc; 


-- 4. Due to recent fair labor laws, all employees must earn at minimum $30 / hour 
-- (rate * payfrequency). Compute the total increase in employee compensation. Then 
-- produce a report showing which department groups benefit the most from this new law in terms of 
-- highest average increase in pay rate (make sure to take into account payfrequency). 
-- Use GREATEST() - this is not an aggregate function!
-- Make sure you know which tables have one-to-many relationships!


SELECT 
		name, 
		groupname, 
        round(SUM(difference),2) as total_change, 
		round(AVG(difference),2) as avg_change
FROM
(SELECT
	emp.businessentityid, dept.name, dept.groupname, dept_hist.departmentid,
	GREATEST(30.0, pay.rate * pay.payfrequency) as new_pay, 
	pay.rate * pay.payfrequency as old_pay,
    GREATEST(30.0, pay.rate * pay.payfrequency)  - pay.rate * pay.payfrequency 
    AS difference
    
    FROM humanresources.employee emp
JOIN humanresources.employeepayhistory pay 
ON pay.businessentityid = emp.businessentityid
JOIN (SELECT pay_hist.businessentityid, MAX(modifieddate) 
      FROM humanresources.employeepayhistory pay_hist 
      GROUP BY pay_hist.businessentityid) recent_pay 
      ON recent_pay.businessentityid = pay.businessentityid 
      AND recent_pay.max = pay.modifieddate
JOIN humanresources.employeedepartmenthistory dept_hist 
ON dept_hist.businessentityid = emp.businessentityid
JOIN humanresources.department dept ON dept.departmentid = dept_hist.departmentid
WHERE dept_hist.enddate is NULL) temp -- enddate is null will filter for only the most recent department history transfers
GROUP BY name, groupname;

-- 5. The SVP of Sales Operations believes that if AdventureWorks paid the lowest projected sales employees 
-- for this fiscal year more money and gave them more vacation time, they would perform better. 
-- Is this true? Produce a report correlating the total number of sales with vacation hours and pay earned.


-- To find correlation between pay and sales year to date
SELECT CORR(sales_hist.salesytd, pay.payfrequency * pay.rate) FROM humanresources.employee emp
JOIN humanresources.employeepayhistory pay 
ON pay.businessentityid = emp.businessentityid
JOIN (SELECT pay_hist.businessentityid, MAX(modifieddate) 
      FROM humanresources.employeepayhistory pay_hist 
      GROUP BY pay_hist.businessentityid) recent_pay 
      ON recent_pay.businessentityid = pay.businessentityid 
      AND recent_pay.max = pay.modifieddate
JOIN sales.salesperson sales_hist ON sales_hist.businessentityid = emp.businessentityid


-- To find correlation between pay and vacation hours
SELECT CORR(sales_hist.salesytd, emp.vacationhours) FROM humanresources.employee emp
JOIN humanresources.employeepayhistory pay 
ON pay.businessentityid = emp.businessentityid
JOIN (SELECT pay_hist.businessentityid, MAX(modifieddate) 
      FROM humanresources.employeepayhistory pay_hist 
      GROUP BY pay_hist.businessentityid) recent_pay 
      ON recent_pay.businessentityid = pay.businessentityid 
      AND recent_pay.max = pay.modifieddate
JOIN sales.salesperson sales_hist ON sales_hist.businessentityid = emp.businessentityid

