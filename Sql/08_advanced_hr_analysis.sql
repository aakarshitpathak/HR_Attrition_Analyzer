/*
Project: HR Attrition Analyzer
File: 08_advanced_hr_analysis.sql

Purpose:
Perform deeper HR analysis by combining aggregation,
conditional logic, subqueries, CTEs, and window functions.

Dataset:
employees
*/


-- =====================================================
-- Q50: Attrition by Job Level and Overtime
--
-- Business Objective:
-- Determine whether overtime is associated with different
-- attrition patterns across employee job levels.
--
-- Required Output:
-- Job Level
-- Overtime Status
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT JobLevel,
OverTime,
COUNT(*) AS Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
) AS Attrition_Rate
FROM employees
GROUP BY JobLevel,OverTime
ORDER BY Attrition_Rate DESC;
 
-- =====================================================



-- =====================================================
-- Q51: Attrition by Job Satisfaction and Overtime
--
-- Business Objective:
-- Identify whether employees with different satisfaction
-- levels experience different attrition rates when
-- overtime status is considered.
--
-- Required Output:
-- Job Satisfaction
-- Overtime Status
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT JobSatisfaction,
OverTime,
COUNT(*) AS Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*),2
) AS Attrition_Rate
FROM employees
GROUP BY JobSatisfaction,OverTime
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q52: Attrition by Age Group and Overtime
--
-- Business Objective:
-- Analyze whether overtime affects attrition differently
-- across employee age groups.
--
-- Required Output:
-- Age Group
-- Overtime Status
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
    OverTime,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
GROUP BY Age_Group, OverTime
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q53: Attrition by Tenure and Overtime
--
-- Business Objective:
-- Determine whether overtime is associated with different
-- attrition rates across employee tenure groups.
--
-- Required Output:
-- Tenure Group
-- Overtime Status
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT
    CASE
        WHEN YearsAtCompany BETWEEN 0 AND 2 THEN '0 - 2 years'
        WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3 - 5 years'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6 - 10 years'
        WHEN YearsAtCompany BETWEEN 11 AND 15 THEN '11 - 15 years'
        ELSE '16+ years'
    END AS Tenure_Group,
    OverTime,
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
GROUP BY Tenure_Group, OverTime
ORDER BY Attrition_Rate DESC;
-- =====================================================



-- =====================================================
-- Q54: High Workload and Low Satisfaction Employees
--
-- Business Objective:
-- Identify employees experiencing both high workload
-- and low job satisfaction and analyze their attrition.
--
-- Conditions:
-- OverTime = 'Yes'
-- JobSatisfaction <= 2
--
-- Required Output:
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT
    COUNT(*) AS Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Attrition_Rate
FROM employees
WHERE OverTime = 'Yes'
  AND JobSatisfaction <= 2;

-- =====================================================



-- =====================================================
-- Q55: Departments with Above-Average Monthly Income
--
-- Business Objective:
-- Identify departments whose average monthly income
-- is higher than the overall company average.
--
-- Required Output:
-- Department
-- Average Monthly Income
--
-- SQL Analysis:

WITH Department_Income AS (
    SELECT
        Department,
        ROUND(AVG(MonthlyIncome), 2) AS Average_Monthly_Income
    FROM employees
    GROUP BY Department
)

SELECT
    Department,
    Average_Monthly_Income
FROM Department_Income
WHERE Average_Monthly_Income > (
    SELECT AVG(MonthlyIncome)
    FROM employees
)
ORDER BY Average_Monthly_Income DESC;

-- =====================================================



-- =====================================================
-- Q56: Departments with High Attrition and Large Workforce
--
-- Business Objective:
-- Identify departments that may represent significant
-- workforce risks due to both high attrition and
-- large employee populations.
--
-- Conditions:
-- Employees > 100
-- Attrition Rate > 15%
--
-- Required Output:
-- Department
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

WITH Department_Attrition AS (
    SELECT
        Department,
        COUNT(*) AS Employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
        ROUND(
            100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) 
			/ COUNT(*),2
        ) AS Attrition_Rate
    FROM employees
    GROUP BY Department
)

SELECT
    Department,
    Employees,
    Employees_Left,
    Attrition_Rate
FROM Department_Attrition
WHERE Employees > 100
  AND Attrition_Rate > 15
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q57: Identify High-Risk Employee Profiles
--
-- Business Objective:
-- Identify employees who match multiple characteristics
-- associated with potential attrition risk.
--
-- Conditions:
-- OverTime = 'Yes'
-- JobSatisfaction <= 2
-- YearsAtCompany <= 5
--
-- Required Output:
-- Employee Number
-- Department
-- Job Role
-- Monthly Income
-- Years at Company
-- Job Satisfaction
-- Overtime
--
-- SQL Analysis:

SELECT
    Department,
    JobRole,
    MonthlyIncome,
    YearsAtCompany,
    JobSatisfaction,
    OverTime
FROM employees
WHERE OverTime = 'Yes'
  AND JobSatisfaction <= 2
  AND YearsAtCompany <= 5
ORDER BY YearsAtCompany, JobSatisfaction;

-- =====================================================