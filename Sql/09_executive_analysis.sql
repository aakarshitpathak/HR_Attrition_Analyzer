/*
Project: HR Attrition Analyzer
File: 09_executive_analysis.sql

Purpose:
Generate executive-level HR insights that combine
workforce size, attrition, compensation, and risk factors.

Dataset:
employees

Note:
If using hr_powerbi.csv / model-generated risk data,
those queries can be added here separately.
*/


-- =====================================================
-- Q58: Executive Workforce Overview
--
-- Business Objective:
-- Provide a high-level summary of the organization's
-- workforce and overall attrition.
--
-- Required Output:
-- Total Employees
-- Total Employees Left
-- Overall Attrition Rate
-- Average Monthly Income
-- Average Years at Company
--
-- SQL Analysis:

SELECT
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Overall_Attrition_Rate,
	ROUND(AVG(MonthlyIncome), 2) AS Average_Monthly_Income,
    ROUND(AVG(YearsAtCompany),2) AS Average_Years_At_Company
FROM hr_powerbi;

-- =====================================================


-- =====================================================
-- Q59: Department Attrition Ranking
--
-- Business Objective:
-- Identify departments with the highest attrition
-- and prioritize areas requiring HR attention.
--
-- Required Output:
-- Department
-- Employees
-- Employees Left
-- Attrition Rate
-- Attrition Rank
--
-- SQL Analysis:

WITH Department_Attrition_Ranking AS(
SELECT Department,
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(
100.0*SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END)
/COUNT(*),2
) AS Attrition_Rate
FROM hr_powerbi
GROUP BY Department
)
SELECT Department,
Total_Employees,
Employees_Left,
Attrition_Rate,
DENSE_RANK() OVER(ORDER BY Attrition_Rate DESC) AS Attrition_Rank
FROM Department_Attrition_Ranking
ORDER BY Attrition_Rank;

-- =====================================================



-- =====================================================
-- Q60: Highest-Risk Workforce Segments
--
-- Business Objective:
-- Identify workforce segments with both substantial
-- employee populations and high attrition rates.
--
-- Analyze combinations of:
-- Department
-- Job Role
-- Overtime
--
-- Required Output:
-- Segment
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

WITH Workforce_Segments AS (
SELECT
Department,
JobRole,
OverTime,
COUNT(*) AS Employees,
SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(100.0 * SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END)
/COUNT(*),2
)AS Attrition_Rate
FROM hr_powerbi
GROUP BY
Department,
JobRole,
OverTime
)

SELECT
Department,
JobRole,
OverTime,
Employees,
Employees_Left,
Attrition_Rate
FROM Workforce_Segments
WHERE Employees > 20
AND Attrition_Rate > 20
ORDER BY Attrition_Rate DESC;

-- =====================================================



-- =====================================================
-- Q61: Executive HR Risk Summary
--
-- Business Objective:
-- Summarize the major workforce characteristics
-- associated with employee attrition.
--
-- Analyze:
-- Overtime
-- Job Satisfaction
-- Work-Life Balance
-- Salary Band
--
-- Required Output:
-- Category
-- Employees
-- Employees Left
-- Attrition Rate
--
-- SQL Analysis:

WITH HR_Risk_Summary AS (
SELECT
OverTime,
JobSatisfaction,
WorkLifeBalance,
Salary_Band,
COUNT(*) AS Employees,
SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END) AS Employees_Left,
ROUND(100.0 * SUM(CASE WHEN Attrition_Flag = 1 THEN 1 ELSE 0 END)
/COUNT(*),2
)AS Attrition_Rate
FROM hr_powerbi
GROUP BY
OverTime,
JobSatisfaction,
WorkLifeBalance,
Salary_Band
)

SELECT
OverTime,
JobSatisfaction,
WorkLifeBalance,
Salary_Band,
Employees,
Employees_Left,
Attrition_Rate
FROM HR_Risk_Summary
WHERE OverTime = 'Yes'
AND JobSatisfaction IN(1,2)
AND WorkLifeBalance IN(1,2)
AND Salary_Band = 'Low'
AND Attrition_Rate > 20
ORDER BY Attrition_Rate DESC;

-- =====================================================