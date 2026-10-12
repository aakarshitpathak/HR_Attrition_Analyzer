/*
Project: HR Attrition Analyzer
File: 07_window_functions.sql

Purpose:
Use window functions to rank employees, compare employees
within departments, and analyze workforce patterns.

Dataset:
employees
*/


-- =====================================================
-- Q42: Rank Employees by Monthly Income
--
-- Business Objective:
-- Rank employees from highest to lowest based on
-- their monthly income.
--
-- Required Output:
-- Employee Number
-- Department
-- Job Role
-- Monthly Income
-- Income Rank
--
-- SQL Analysis:

SELECT
    Department,
    JobRole,
    MonthlyIncome,
    DENSE_RANK() OVER (
        ORDER BY MonthlyIncome DESC
    ) AS Income_Rank
FROM employees
ORDER BY Income_Rank;

-- =====================================================



-- =====================================================
-- Q43: Rank Employees by Income Within Each Department
--
-- Business Objective:
-- Identify how employees rank in terms of monthly income
-- within their respective departments.
--
-- Required Output:
-- Employee Number
-- Department
-- Monthly Income
-- Department Income Rank
--
-- SQL Analysis:

SELECT
    Department,
    JobRole,
    MonthlyIncome,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS Department_Income_Rank
FROM employees
ORDER BY Department, Department_Income_Rank;

-- =====================================================



-- =====================================================
-- Q44: Top 3 Highest-Paid Employees in Each Department
--
-- Business Objective:
-- Identify the three highest-paid employees within
-- each department.
--
-- Required Output:
-- Employee Number
-- Department
-- Job Role
-- Monthly Income
-- Rank
--
-- SQL Analysis:

SELECT
    Department,
    JobRole,
    MonthlyIncome,
    Department_Monthly_Income AS Income_Rank
FROM (
    SELECT
        Department,
        JobRole,
        MonthlyIncome,
        DENSE_RANK() OVER (
            PARTITION BY Department
            ORDER BY MonthlyIncome DESC
        ) AS Department_Monthly_Income
    FROM employees
) AS t
WHERE Department_Monthly_Income <= 3
ORDER BY Department, Income_Rank;


-- =====================================================



-- =====================================================
-- Q45: Compare Employee Income with Department Average
--
-- Business Objective:
-- Compare each employee's monthly income with the
-- average income of their department.
--
-- Required Output:
-- Employee Number
-- Department
-- Monthly Income
-- Department Average Income
-- Difference from Department Average
--
-- SQL Analysis:

SELECT
    Department,
    JobRole,
    MonthlyIncome,

    ROUND(
        AVG(MonthlyIncome) OVER (
            PARTITION BY Department
        ),
        2
    ) AS Department_Average_Income,

    ROUND(
        MonthlyIncome -
        AVG(MonthlyIncome) OVER (
            PARTITION BY Department
        ),
        2
    ) AS Difference_From_Department_Average

FROM employees
ORDER BY Department, Difference_From_Department_Average DESC;

-- =====================================================



-- =====================================================
-- Q46: Department Attrition Rate Using Window Functions
--
-- Business Objective:
-- Show each department's attrition rate alongside
-- the overall company attrition rate.
--
-- Required Output:
-- Department
-- Department Employees
-- Department Leavers
-- Department Attrition Rate
-- Overall Attrition Rate
--
-- SQL Analysis:

WITH Department_Attrition AS (
    SELECT
        Department,
        COUNT(*) AS Department_Employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Department_Leavers,
        ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*),2
        ) AS Department_Attrition_Rate
    FROM employees
    GROUP BY Department
)

SELECT
    Department,
    Department_Employees,
    Department_Leavers,
    Department_Attrition_Rate,
    ROUND(
        100.0 * SUM(Department_Leavers) OVER ()
        / SUM(Department_Employees) OVER (),
        2
    ) AS Overall_Attrition_Rate
FROM Department_Attrition
ORDER BY Department_Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q47: Employee Income Rank Within Job Role
--
-- Business Objective:
-- Identify how employees rank by monthly income
-- within their specific job roles.
--
-- Required Output:
-- Employee Number
-- Job Role
-- Monthly Income
-- Job Role Income Rank
--
-- SQL Analysis:

SELECT
    JobRole,
    MonthlyIncome,
    DENSE_RANK() OVER (
        PARTITION BY JobRole
        ORDER BY MonthlyIncome DESC
    ) AS JobRole_Income_Rank
FROM employees
ORDER BY JobRole, JobRole_Income_Rank;

-- =====================================================



-- =====================================================
-- Q48: Running Employee Count by Years at Company
--
-- Business Objective:
-- Analyze the cumulative number of employees across
-- increasing levels of company tenure.
--
-- Required Output:
-- Years at Company
-- Employees
-- Cumulative Employees
--
-- SQL Analysis:

SELECT
    YearsAtCompany,
    COUNT(*) AS Total_Employees,
    SUM(COUNT(*)) OVER (
        ORDER BY YearsAtCompany
    ) AS Cumulative_Employees
FROM employees
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;

-- =====================================================



-- =====================================================
-- Q49: Compare Employee Income with Previous Employee
--
-- Business Objective:
-- Compare an employee's monthly income with the income
-- of the previous employee when employees are ordered
-- by monthly income.
--
-- Required Output:
-- Employee Number
-- Monthly Income
-- Previous Employee Income
-- Income Difference
--
-- SQL Analysis:

SELECT MonthlyIncome,
LAG(MonthlyIncome) OVER(
ORDER BY MonthlyIncome DESC
) AS Previous_Employee_Monthly_Income,

MonthlyIncome - LAG(MonthlyIncome) OVER(
ORDER BY MonthlyIncome DESC
) AS Monthly_Income_Difference
FROM employees
ORDER BY MonthlyIncome DESC;

-- =====================================================