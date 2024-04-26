create database HR_Analytics;
show tables;
select * from hr_1;
select * from hr_2;
select * from hr_merged;

------------------------------------------------------------------------------------------------------------------------------------------------ 
# (	KPI -----1)	Employee count along with Gender 
------------------------------------------------------------------------------------------------------------------------------------------------ 

SELECT 
    (SELECT COUNT(*) FROM hr_merged) AS Total_Employees,
    CONCAT(
        COUNT(CASE WHEN Gender = 'Male' THEN 1 END),
        '--'
        ' (', ROUND(100.0 * COUNT(CASE WHEN Gender = 'Male' THEN 1 END) / COUNT(*), 2), '%)'
    ) AS Male,
    CONCAT(
        COUNT(CASE WHEN Gender = 'Female' THEN 1 END),
        '--'
        ' (', ROUND(100.0 * COUNT(CASE WHEN Gender = 'Female' THEN 1 END) / COUNT(*), 2), '%)'
    ) AS Female
FROM 
    hr_merged;

------------------------------------------------------------------------------------------------------------------------------------------------ 
# (	KPI -----2)	Department wise Coount of people
------------------------------------------------------------------------------------------------------------------------------------------------ 

select Department, sum(EmployeeCount) as Total_Employees
from hr_1
group by Department;


------------------------------------------------------------------------------------------------------------------------------------------------ 
# (	KPI -----3)	-- Count of Employees based on Educational Fields
------------------------------------------------------------------------------------------------------------------------------------------------ 
select EducationField, sum(EmployeeCount) as Total_Employees
from hr_1
group by EducationField;



------------------------------------------------------------------------------------------------------------------------------------------------ 
# (	KPI -----4)	Average Attrition rate for all Departments
------------------------------------------------------------------------------------------------------------------------------------------------ 

SELECT 
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) AS exited_employees,
    100.0 * SUM(CASE WHEN attrition = 'yes' THEN 1 ELSE 0 END) / COUNT(*) AS attrition_rate
FROM 
    hr_1
GROUP BY 
    department;

------------------------------------------------------------------------------------------------------------------------------------------------ 
# (	KPI -----5) Average Hourly rate of Male Research Scientist
------------------------------------------------------------------------------------------------------------------------------------------------ 

SELECT 
    AVG(hourlyrate) AS average_hourly_rate
FROM 
    hr_1
WHERE 
    gender = 'male' 
    AND JobRole = 'research scientist';
    
------------------------------------------------------------------------------------------------------------------------------------------------ 
  # (KPI -----6)   Attrition rate Vs Monthly income stats
------------------------------------------------------------------------------------------------------------------------------------------------ 

SELECT 
    Income_Range,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS ExitedEmployees,
    100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS AttritionRate
FROM (
    SELECT 
        CASE 
            WHEN MonthlyIncome <= 15000 THEN '0 to 15k' 
            WHEN MonthlyIncome > 15000 AND MonthlyIncome <= 30000 THEN '15k to 30k' 
            WHEN MonthlyIncome > 30000 AND MonthlyIncome <= 45000 THEN '30k to 45k' 
            WHEN MonthlyIncome > 45000 AND MonthlyIncome <= 60000 THEN '45k to 60k' 
            ELSE 'Above 60k' 
        END AS Income_Range,
        MonthlyIncome,
        Attrition
    FROM 
        hr_merged
) AS subquery
GROUP BY 
    Income_Range
ORDER BY
    CASE 
        WHEN Income_Range = '0 to 15k' THEN 1 
        WHEN Income_Range = '15k to 30k' THEN 2 
        WHEN Income_Range = '30k to 45k' THEN 3 
        WHEN Income_Range = '45k to 60k' THEN 4 
        ELSE 5 
    END;


------------------------------------------------------------------------------------------------------------------------------------------------ 
 #  (KPI -----7) Average working years for each Department 
 ------------------------------------------------------------------------------------------------------------------------------------------------ 

 SELECT
	department,
    avg(totalworkingyears) as Avg_working_year
from 
	hr_merged
group by
	department;


------------------------------------------------------------------------------------------------------------------------------------------------ 
#   (KPI -----8) Attrition rate by Education field
------------------------------------------------------------------------------------------------------------------------------------------------ 

SELECT 
    EducationField,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS exited_employees,
    100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) AS attrition_rate
FROM 
    hr_merged
GROUP BY 
    EducationField;
  
