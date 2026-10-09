/*
Project: HR Attrition Analyzer
File: 04_hr_segmentation.sql

Purpose:
Segment employees into meaningful groups and analyze
attrition patterns across those groups.

Dataset:
employees
*/


-- =====================================================
-- Q22: Employee Distribution by Salary Band
--
-- Business Objective:
-- Divide employees into meaningful salary groups and
-- understand the distribution of employees across them.
--
-- Salary Bands:
-- Below 3000      → Low
-- 3000 - 7000     → Medium
-- 7001 - 10000    → High
-- Above 10000     → Very High
--
-- Required Output:
-- Salary Band
-- Employee Count
--
-- SQL Analysis:

SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
        WHEN MonthlyIncome BETWEEN 7001 AND 10000 THEN 'High'
        ELSE 'Very High'
    END AS Salary_Band,
    COUNT(*) AS Employee_Count
FROM employees
GROUP BY Salary_Band
ORDER BY Employee_Count DESC;

-- =====================================================



-- =====================================================
-- Q23: Attrition by Salary Band
--
-- Business Objective:
-- Determine whether employee attrition varies across
-- different salary bands.
--
-- Required Output:
-- Salary Band
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
        WHEN MonthlyIncome BETWEEN 7001 AND 10000 THEN 'High'
        ELSE 'Very High'
    END AS Salary_Band,
    COUNT(*) AS Employee_Count,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
    100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
    /COUNT(*),2
    ) AS Attrition_Rate
    FROM employees
    GROUP BY Salary_Band
    ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q24: Employee Distribution and Attrition by Age Group
--
-- Business Objective:
-- Understand how employee age groups are distributed
-- and whether attrition differs across age groups.
--
-- Age Groups:
-- Under 25
-- 25 - 34
-- 35 - 44
-- 45 - 54
-- 55+
--
-- Required Output:
-- Age Group
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT
    CASE
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25 - 34'
        WHEN Age BETWEEN 35 AND 44 THEN '35 - 44'
        WHEN Age BETWEEN 45 AND 54 THEN '45 - 54'
        ELSE '55+'
    END AS Age_Group,
    COUNT(*) AS Employee_Count,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
    100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
    /COUNT(*),2
    ) AS Attrition_Rate
    FROM employees
    GROUP BY Age_Group
    ORDER BY Attrition_Rate DESC;
    

-- =====================================================



-- =====================================================
-- Q25: Employee Distribution and Attrition by Tenure Group
--
-- Business Objective:
-- Analyze whether employees at different stages of their
-- career with the company have different attrition rates.
--
-- Tenure Groups:
-- 0 - 2 years
-- 3 - 5 years
-- 6 - 10 years
-- 11 - 15 years
-- 16+ years
--
-- Required Output:
-- Tenure Group
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT 
CASE 
WHEN TotalWorkingYears BETWEEN 0 AND 2 THEN '0 - 2 years'
WHEN TotalWorkingYears BETWEEN 3 AND 5 THEN '3 - 5 years'
WHEN TotalWorkingYears BETWEEN 6 AND 10 THEN '6 - 10 years'
WHEN TotalWorkingYears BETWEEN 11 AND 15 THEN '11 - 15 years'
ELSE '16+ years'
END AS Tenure_Groups,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition ='Yes' THEN 1 ELSE 0 END)AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition ='Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
)AS Attrition_Rate
FROM employees
GROUP BY Tenure_Groups
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q26: Attrition by Job Satisfaction Level
--
-- Business Objective:
-- Determine whether job satisfaction is associated with
-- differences in employee attrition.
--
-- Required Output:
-- Job Satisfaction
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT JobSatisfaction,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
) AS Attrition_Rate
FROM employees
GROUP BY JobSatisfaction
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q27: Attrition by Work-Life Balance Level
--
-- Business Objective:
-- Analyze whether employees with different work-life
-- balance ratings experience different attrition rates.
--
-- Required Output:
-- Work-Life Balance
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT WorkLifeBalance,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
) AS Attrition_Rate
FROM employees
GROUP BY WorkLifeBalance
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q28: Job Roles with Large Employee Populations
--
-- Business Objective:
-- Identify job roles with a significant number of employees
-- for further HR analysis.
--
-- Condition:
-- More than 50 employees
--
-- Required Output:
-- Job Role
-- Employee Count
--
-- SQL Analysis:

SELECT JobRole, 
COUNT(*) AS Employees_Count
FROM employees
GROUP BY JobRole
HAVING Employees_Count > 50;

-- =====================================================



-- =====================================================
-- Q29: Departments with High Attrition
--
-- Business Objective:
-- Identify departments where employee attrition is
-- higher than 15%.
--
-- Required Output:
-- Department
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT Department,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
) AS Attrition_Rate
FROM employees
GROUP BY Department
HAVING Attrition_Rate > 15
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q30: High-Risk Salary Groups
--
-- Business Objective:
-- Identify salary groups that have both a sufficiently
-- large employee population and a relatively high
-- attrition rate.
--
-- Conditions:
-- Employees > 100
-- Attrition Rate > 15%
--
-- Required Output:
-- Salary Band
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Low'
        WHEN MonthlyIncome BETWEEN 3000 AND 7000 THEN 'Medium'
        WHEN MonthlyIncome BETWEEN 7001 AND 10000 THEN 'High'
        ELSE 'Very High'
    END AS Salary_Band,
    COUNT(*) AS Employee_Count,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
    100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
    /COUNT(*),2
    ) AS Attrition_Rate
    FROM employees
    GROUP BY Salary_Band
    HAVING Employee_Count >100 AND Attrition_Rate > 15
    ORDER BY Attrition_Rate DESC;

-- =====================================================