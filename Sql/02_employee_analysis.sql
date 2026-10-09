/*
Project: HR Attrition Analyzer
File: 02_employee_analysis.sql

Purpose:
Analyze workforce composition and employee characteristics.

Dataset:
employees
*/


-- =====================================================
-- Q9: Employee Distribution by Department
--
-- Business Objective:
-- Understand how employees are distributed across departments.
--
-- SQL Analysis:

SELECT Department ,COUNT(*) AS department_wise_employees
FROM employees
GROUP BY Department;

-- =====================================================



-- =====================================================
-- Q10: Employee Distribution by Job Role
--
-- Business Objective:
-- Identify which job roles have the largest workforce.
--
-- SQL Analysis:

SELECT JobRole, COUNT(*) AS employee_count
FROM employees
GROUP BY JobRole
ORDER BY employee_count DESC;

-- =====================================================



-- =====================================================
-- Q11: Average Employee Age by Department
--
-- Business Objective:
-- Compare the workforce age profile across departments.
--
-- SQL Analysis:

SELECT Department, AVG(Age) as Average_Age
FROM employees
GROUP BY Department;

-- =====================================================



-- =====================================================
-- Q12: Average Monthly Salary by Department
--
-- Business Objective:
-- Understand salary differences between departments.
--
-- SQL Analysis:

SELECT Department, AVG(MonthlyIncome) as Average_Monthly_Income
FROM employees
GROUP BY Department;

-- =====================================================



-- =====================================================
-- Q13: Average Employee Tenure by Department
--
-- Business Objective:
-- Identify departments with more experienced employees.
--
-- SQL Analysis:

SELECT Department, AVG(YearsAtCompany) as Years_At_Company
FROM employees
GROUP BY Department;

-- =====================================================



-- =====================================================
-- Q14: Highest Salary Offered by Department
--
-- Business Objective:
-- Identify the maximum compensation level available
-- within each department.
--
-- SQL Analysis:

SELECT Department, MAX(MonthlyIncome) AS Highest_Salary
FROM employees
GROUP BY Department;

-- =====================================================