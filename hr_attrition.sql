CREATE DATABASE hr_attrition;

USE hr_attrition;

SELECT * FROM `hr-employee-attrition`;

RENAME TABLE `hr-employee-attrition`
TO employee_attrition;

select * from employee_attrition;

SELECT COUNT(*) FROM employee_attrition;
select count(*) AS TotalEmployee FROM employee_attrition;
describe employee_attrition;

select count(*) FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'hr_attrition'
AND TABLE_NAME = 'employee_attrition';

SELECT * FROM employee_attrition WHERE JobRole IS NULL;
SELECT * FROM employee_attrition WHERE MonthlyIncome IS NULL;
SELECT * FROM employee_attrition WHERE Attrition IS NULL;

SELECT EmployeeNumber, COUNT(*) AS Total 
FROM employee_attrition
GROUP BY EmployeeNUmber
HAVING COUNT(*)>1;

SELECT DISTINCT Department
FROM employee_attrition;

SELECT DISTINCT JobRole
FROM employee_attrition;

SELECT DISTINCT EducationField
FROM employee_attrition;

SELECT COUNT(*) AS EmployeeLeft
FROM employee_attrition
WHERE Attrition = "Yes";

ALTER TABLE employee_attrition
CHANGE COLUMN `ï»¿Age` Age INT;

SELECT ROUND(AVG(Age),2) AS AverageAge
FROM employee_attrition;

SELECT MAX(MonthlyIncome) AS HighestSalary
FROM employee_attrition;
SELECT MIN(MonthlyIncome) AS LowestSalary
FROM employee_attrition;

SELECT Department,
COUNT(*) AS TotalEmployees
FROM employee_attrition
GROUP BY Department;

SELECT Department,
COUNT(*) AS EmployeeLeft
FROM employee_attrition
WHERE Attrition = "Yes"
Group By Department;

SELECT Department,
COUNT(*) AS TotalEmployees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS EmployeeLeft,
ROUND(
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END ) * 100.0 / COUNT(*), 2
) AS AttritionRate
FROM employee_attrition
GROUP BY Department
ORDER BY AttritionRate DESC;

SELECT Gender,
COUNT(*) AS TotalEmployees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) EmployeeLeft
FROM employee_attrition
GROUP BY Gender;

SELECT OverTime,
COUNT(*) AS TotalEmployees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS EmployeeLeft
FROM employee_attrition
GROUP BY OverTime;


SELECT JobRole,
COUNT(*) AS TotalEmployees,
SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS EmployeeLeft
FROM employee_attrition
GROUP BY JobRole
ORDER BY EmployeeLeft DESC;


SELECT Department,
ROUND(AVG(MonthlyIncome),2) AS AverageSalary
FROM employee_attrition
GROUP BY Department
ORDER BY AverageSalary DESC;

SELECT EmployeeNumber,JobRole,Department,MonthlyIncome
FROM employee_attrition
ORDER BY MonthlyIncome DESC
LIMIT 10;

SELECT EmployeeNumber,JobRole,Department,MonthlyIncome
FROM employee_attrition
ORDER BY MonthlyIncome ASC
LIMIT 10;

SELECT Department
,ROUND(AVG(Age),2) AS AverageAge
FROM employee_attrition
GROUP BY Department;

SELECT MaritalStatus,
COUNT(*) AS Employees
FROM employee_attrition
GROUP BY MaritalStatus;

SELECT BusinessTravel,COUNT(*) AS Employees
FROM employee_attrition
GROUP BY BUsinessTravel;


 -- jobsatisfaction distribution
SELECT JobSatisfaction,COUNT(*) AS Employees
FROM employee_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;


-- Work lif balance distribution
SELECT WorkLifeBalance,COUNT(*) AS Employees
FROM employee_attrition
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- ADVANCED SQL

-- CASE satetment
-- group employees by age

SELECT EmployeeNumber,
Age,
CASE
WHEN Age < 30 THEN "Young"
WHEN Age BETWEEN 30 AND 45 THEN "Middle Age"
Else 'Senior'
END AS AgeGroup 
FROM employee_attrition;

-- HAVING CLAUSE
-- Find department with more than 300 employees

SELECT Department,
COUNT(*) AS TotalEmployees
FROM employee_attrition
GROUP BY Department
HAVING COUNT(*) > 300;

-- subquery
-- fine the employees earning more than companies avg salary

SELECT EmployeeNumber,JobRole,MonthlyIncome
FROM employee_attrition
WHERE MonthlyIncome > (SELECT AVG(MonthlyIncome)
FROM employee_attrition);

SELECT AVG(MonthlyIncome)
FROM employee_attrition;

-- common table expression
-- calculate avg salary by department and show employees earning above their department avg

WITH DeptAvg AS
(
SELECT Department, AVG(MonthlyIncome) AS AvgSalary
FROM employee_attrition
GROUP BY Department
)
SELECT e.EmployeeNumber,e.Department,
e.MonthlyIncome,
d.AvgSalary
FROM employee_attrition e
JOIN DeptAvg d
ON e.Department = d.Department
WHERE e.MonthlyIncome > d.AvgSalary;


-- Windows function
-- Rank employees by salary within each department

SELECT EmployeeNumber,
Department,MonthlyIncome,
RANK() OVER
(
PARTITION BY Department 
ORDER BY MonthlyIncome DESC
) AS SalaryRank
FROM employee_attrition;

-- dense rank

SELECT EmployeeNumber,
Department,MonthlyIncome,
DENSE_RANK() OVER
(
PARTITION BY Department 
ORDER BY MonthlyIncome DESC
) AS SalaryRank
FROM employee_attrition;

-- views
-- create view for employees who left

CREATE VIEW AttritionEmployees AS
SELECT * 
FROM employee_attrition
WHERE Attrition = 'Yes';

SELECT * FROM AttritionEmployees;

-- overtime employees view

CREATE VIEW OverTimeEmployees AS
SELECT * FROM employee_attrition
WHERE OverTime = 'Yes';

SELECT * FROM OverTimeEmployees;

-- department wise attrition percentage

SELECT Department,
ROUND(
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
*100.0/COUNT(*),2
) AS AttritionPercentage
FROM employee_attrition
GROUP BY Department
ORDER BY AttritionPercentage DESC;