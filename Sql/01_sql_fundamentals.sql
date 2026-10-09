CREATE DATABASE hr_attrition_analyzer;

USE hr_attrition_analyzer;

/*
Project: HR Attrition Analyzer
File: 01_sql_fundamentals.sql

Purpose:
Basic exploration and understanding of employee data.

Dataset:
employees
*/

-- =====================================================

-- Q1: Total Number of Employees
--
-- Business Objective:
-- Understand the total workforce size available in the dataset.
--
-- SQL Analysis:

SELECT COUNT(*) AS total_employees
FROM employees;

-- =====================================================

-- Q2: View Sample Employee Records
--
-- Business Objective:
-- Inspect employee records to understand the structure and
-- available information in the HR dataset.
--
-- SQL Analysis:

SELECT *
FROM employees
LIMIT 10;

-- =====================================================

-- Q3: Identify Different Departments
--
-- Business Objective:
-- Understand which departments exist within the organization.
--
-- SQL Analysis:

SELECT DISTINCT Department
FROM employees;

-- =====================================================

-- Q4: Identify Different Job Roles
--
-- Business Objective:
-- Understand the variety of roles present in the workforce.
--
-- SQL Analysis:

SELECT DISTINCT JobRole
From employees;

-- =====================================================

-- Q5: Count Employees with High Monthly Income
--
-- Business Objective:
-- Identify how many employees belong to the higher salary segment.
--
-- SQL Analysis:

SELECT COUNT(*) AS high_income_employees
FROM employees
WHERE MonthlyIncome > 10000;

-- =====================================================

-- Q6: Employees Working Overtime
--
-- Business Objective:
-- Understand how many employees are currently working overtime,
-- which may help analyze workload and attrition risk.
--
-- SQL Analysis:

SELECT COUNT(*) AS overtime_employees
FROM employees
WHERE Overtime = "Yes"; 

-- =====================================================

-- Q7: Employees Above 40 Years of Age
--
-- Business Objective:
-- Analyze the number of experienced employees in the workforce.
--
-- SQL Analysis:

SELECT COUNT(*) AS employees_over_age_40
FROM employees
WHERE Age > 40;

-- =====================================================

-- Q8: Employees with Long Company Tenure
--
-- Business Objective:
-- Identify employees who have spent more than 10 years
-- with the organization.
--
-- SQL Analysis:

SELECT COUNT(*) AS employees_over_10_years
FROM employees
WHERE YearsAtCompany > 10;

-- =====================================================