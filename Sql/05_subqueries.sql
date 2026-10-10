/*
Project: HR Attrition Analyzer
File: 05_subqueries.sql

Purpose:
Use subqueries to compare employees, departments,
and job roles against company-level benchmarks.

Dataset:
employees
*/


-- =====================================================
-- Q31: Employees Earning Above the Company Average
--
-- Business Objective:
-- Identify employees whose monthly income is higher
-- than the overall average monthly income.
--
-- Required Output:
-- Employee information
-- Monthly Income
--
-- SQL Analysis:

SELECT *
FROM employees
WHERE MonthlyIncome > (
    SELECT AVG(MonthlyIncome)
    FROM employees
);

-- =====================================================



-- =====================================================
-- Q32: Employees Older Than the Company Average
--
-- Business Objective:
-- Identify employees whose age is above the overall
-- average age of the workforce.
--
-- Required Output:
-- Employee information
-- Age
--
-- SQL Analysis:

SELECT*
FROM employees
WHERE Age > (
SELECT AVG(Age)
FROM employees);

-- =====================================================



-- =====================================================
-- Q33: Employees Earning Above Their Department Average
--
-- Business Objective:
-- Identify employees whose monthly income is higher
-- than the average income of their own department.
--
-- Required Output:
-- Employee information
-- Department
-- Monthly Income
-- Department Average Income
--
-- SQL Analysis:

SELECT
    Department,
    MonthlyIncome,
    (
        SELECT AVG(e2.MonthlyIncome)
        FROM employees AS e2
        WHERE e2.Department = e1.Department
    ) AS Department_Average_Income
FROM employees AS e1
WHERE MonthlyIncome > (
    SELECT AVG(e2.MonthlyIncome)
    FROM employees AS e2
    WHERE e2.Department = e1.Department
);

-- =====================================================



-- =====================================================
-- Q34: Highest-Paid Employee(s)
--
-- Business Objective:
-- Identify the employee or employees receiving the
-- highest monthly income in the organization.
--
-- Required Output:
-- Employee information
-- Monthly Income
--
-- SQL Analysis:

SELECT
    Department,
    JobRole,
    MonthlyIncome
FROM employees
WHERE MonthlyIncome = (
    SELECT MAX(MonthlyIncome)
    FROM employees
);

-- =====================================================



-- =====================================================
-- Q35: Highest-Paid Employee(s) in Each Department
--
-- Business Objective:
-- Identify the highest-paid employee or employees
-- within each department.
--
-- Required Output:
-- Department
-- Employee information
-- Monthly Income
--
-- SQL Analysis:

SELECT
    Department,
    JobRole,
    MonthlyIncome
FROM employees AS e1
WHERE MonthlyIncome = (
    SELECT MAX(e2.MonthlyIncome)
    FROM employees AS e2
    WHERE e2.Department = e1.Department
);

-- =====================================================



-- =====================================================
-- Q36: Job Roles with Above-Average Attrition
--
-- Business Objective:
-- Identify job roles whose attrition rate is higher
-- than the overall company attrition rate.
--
-- Required Output:
-- Job Role
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

SELECT JobRole,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) 
/COUNT(*),2
) AS Attrition_Rate
FROM employees
GROUP BY JobRole
HAVING Attrition_Rate > (
SELECT 100.0*SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)
/COUNT(*)
FROM employees)
ORDER BY Attrition_Rate DESC;

-- =====================================================