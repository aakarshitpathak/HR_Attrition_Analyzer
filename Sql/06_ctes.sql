/*
Project: HR Attrition Analyzer
File: 06_ctes.sql

Purpose:
Use Common Table Expressions (CTEs) to organize
multi-step HR analysis into readable and reusable queries.

Dataset:
employees
*/


-- =====================================================
-- Q37: Department Attrition Analysis Using a CTE
--
-- Business Objective:
-- Create a reusable department-level attrition analysis
-- containing employee count, leavers, and attrition rate.
--
-- Required Output:
-- Department
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

WITH Department_Attrition AS(
SELECT Department,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
)AS Attrition_Rate
FROM employees
GROUP BY Department
)
SELECT Department,
Total_Employees,
Employees_Left,
Attrition_Rate
FROM Department_Attrition
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q38: Rank Departments by Attrition Rate
--
-- Business Objective:
-- Use a CTE to calculate department attrition rates
-- and then rank departments from highest to lowest.
--
-- Required Output:
-- Department
-- Attrition Rate
-- Attrition Rank
--
-- SQL Analysis:

WITH Department_Attrition_Rate AS(
SELECT Department,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
)AS Attrition_Rate
FROM employees
GROUP BY Department
)
SELECT
    Department,
    Attrition_Rate,
    DENSE_RANK() OVER (
        ORDER BY Attrition_Rate DESC
    ) AS Attrition_Rank
FROM Department_Attrition_Rate
ORDER BY Attrition_Rank;

-- =====================================================



-- =====================================================
-- Q39: Job Role Attrition Analysis Using a CTE
--
-- Business Objective:
-- Create a reusable job-role-level analysis showing
-- employee count, leavers, and attrition rate.
--
-- Required Output:
-- Job Role
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

WITH JobRole_Attrition_Rate AS(
Select JobRole,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
)AS Attrition_Rate
FROM employees
GROUP BY JobRole
)
SELECT
    JobRole,
    Total_Employees,
    Employees_Left,
    Attrition_Rate
FROM JobRole_Attrition_Rate
ORDER BY Attrition_Rate DESC;


-- =====================================================



-- =====================================================
-- Q40: Job Roles Above the Company Attrition Rate
--
-- Business Objective:
-- Use a CTE to identify job roles whose attrition
-- rate is higher than the overall company attrition rate.
--
-- Required Output:
-- Job Role
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

WITH JobRole_Attrition_Rate AS(
SELECT JobRole,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END ) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
)AS Attrition_Rate
FROM employees
GROUP BY JobRole
)
SELECT JobRole,
Total_Employees,
Employees_Left,
Attrition_Rate
FROM JobRole_Attrition_Rate
WHERE Attrition_Rate > (
SELECT 
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END )
/COUNT(*)
FROM employees
)
ORDER BY Attrition_Rate DESC;
-- =====================================================



-- =====================================================
-- Q41: Salary Band Attrition Analysis Using a CTE
--
-- Business Objective:
-- Analyze employee count, average salary, leavers,
-- and attrition rate across salary bands.
--
-- Required Output:
-- Salary Band
-- Employees
-- Average Salary
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

WITH Salary_Band_Attrition_Rate AS(
SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
        WHEN MonthlyIncome BETWEEN 7001 AND 10000 THEN 'High'
        ELSE 'Very High'
    END AS Salary_Band,
    COUNT(*) AS Employee_Count,
	ROUND(AVG(MonthlyIncome), 2) AS Average_Salary,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
    100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
    /COUNT(*),2
    ) AS Attrition_Rate
    FROM employees
    GROUP BY Salary_Band 
)
SELECT Salary_Band,
Employee_Count,
Average_Salary,
Employees_Left,
Attrition_Rate
FROM Salary_Band_Attrition_Rate
ORDER BY Attrition_Rate DESC;

-- =====================================================