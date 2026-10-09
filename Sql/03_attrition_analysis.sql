/*
Project: HR Attrition Analyzer
File: 03_attrition_analysis.sql

Purpose:
Analyze employee turnover patterns and attrition drivers.

Dataset:
employees
*/


-- =====================================================
-- Q15: Total Employees Who Left
--
-- Business Objective:
-- Understand the total number of employees lost by the organization.
--
-- SQL Analysis:

SELECT COUNT(*) AS total_leavers
FROM employees
WHERE Attrition = 'Yes';

-- =====================================================



-- =====================================================
-- Q16: Overall Employee Attrition Rate
--
-- Business Objective:
-- Calculate the percentage of employees who left the company.
--
-- SQL Analysis:

SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employees;

-- =====================================================



-- =====================================================
-- Q17: Attrition Analysis by Department
--
-- Business Objective:
-- Identify departments experiencing higher employee turnover.
--
-- Required Output:
-- Department
-- Total Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate DESC;


-- =====================================================



-- =====================================================
-- Q18: Attrition Analysis by Job Role
--
-- Business Objective:
-- Identify job roles with higher employee turnover.
--
-- Required Output:
-- Job Role
-- Employee Count
-- Attrition Rate
--
-- SQL Analysis:

SELECT JobRole,COUNT(*) AS Total_Employees,
ROUND(
100.0* SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),
2
) AS Attrition_Rate
FROM employees
GROUP BY JobRole
ORDER BY Attrition_Rate DESC;


-- =====================================================



-- =====================================================
-- Q19: Attrition Comparison Between Overtime Employees
--
-- Business Objective:
-- Understand whether overtime employees experience different
-- attrition patterns compared to non-overtime employees.
--
-- Required Output:
-- Overtime Status
-- Employees
-- Leavers
-- Attrition Rate
--
-- SQL Analysis:

SELECT OverTime,
COUNT(*) AS Total_Employees,
SUM( CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(
CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END
)/ COUNT(*),2 
)AS Attrition_Rate
FROM employees
GROUP BY OverTime
ORDER BY Attrition_Rate DESC; 


-- =====================================================



-- =====================================================
-- Q20: Attrition by Business Travel Category
--
-- Business Objective:
-- Analyze whether travel requirements influence employee turnover.
--
-- SQL Analysis:

SELECT BusinessTravel,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*), 2
) AS Attrition_Rate
FROM employees
GROUP BY BusinessTravel
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q21: Attrition by Education Field
--
-- Business Objective:
-- Understand whether employee educational background
-- influences attrition patterns.
--
-- SQL Analysis:

SELECT EducationField,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition ='Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
) AS Attrition_Rate
FROM employees
GROUP BY EducationField
ORDER BY Attrition_Rate DESC;

-- =====================================================