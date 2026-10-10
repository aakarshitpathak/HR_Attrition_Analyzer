# HR Analytics — Employee Attrition Analyzer

Predicts which employees are likely to leave, using the IBM HR Analytics dataset, and surfaces the operational patterns behind attrition (overtime, salary, satisfaction) — validated three independent ways: Python/ML, SQL, and Power BI.

## Why I built this

During my internship at Partnerdesk, I coordinated and mentored 7-10 international interns. I saw firsthand how workload, unclear compensation policies, and inconsistent treatment led to disengagement — including a case where I had to escalate a fairness issue directly to the CEO. This project applies that same lens to real HR data: using data to surface the patterns that HR teams often only notice after someone has already decided to leave.

## Dataset

IBM HR Analytics Employee Attrition & Performance dataset (Kaggle) — 1,470 employees, 35 features including department, role, income, satisfaction scores, and tenure.

## What this project does

1. **EDA** — explored attrition patterns across department, overtime status, and correlations between numeric features.
2. **Predictive model** — Logistic Regression (class-balanced) predicting attrition probability per employee. Random Forest was also trained for comparison and used for feature importance.
3. **SQL analysis layer** — 61 queries independently confirming the same attrition drivers using pure SQL, no model involved (see `sql/`).
4. **Per-employee risk score** — every employee gets a probability score and a Low/Medium/High risk bucket, generated via out-of-fold 5-fold cross-validation so no employee is scored by a model trained on their own data.
5. **Power BI dashboard** — a 3-page interactive report turning the model output into an HR-actionable prioritization tool (see `powerbi/`).

## Key findings

- Overall attrition rate: **16.1%**
- **OverTime employees leave at ~3x the rate** of those who don't (30.5% vs 10.4%)
- **Sales Representatives** have the highest attrition of any role: **39.8%**
- Compounding effect: **low-salary + overtime employees have a 58.5% attrition rate**, vs. 7.2% for high-salary employees without overtime
- Top predictive drivers: Monthly Income, Age, Total Working Years, Years at Company, OverTime
- **Risk tiers (5-fold out-of-fold cross-validation):** High-risk tier = 41.9% actual attrition, Medium = 16.2%, Low = 3.9%. The High tier is 24% of headcount but contains ~63% of all leavers.

## Model performance

| Model               | Accuracy | Precision | Recall | F1   | ROC-AUC  |
| ------------------- | -------- | --------- | ------ | ---- | -------- |
| Logistic Regression | 0.75     | 0.35      | 0.62   | 0.44 | **0.80** |
| Random Forest       | 0.83     | 0.47      | 0.38   | 0.42 | 0.78     |

Logistic Regression was selected as the primary model — despite lower raw accuracy, it has meaningfully higher recall, which matters more here: in attrition prediction, missing an employee who's about to leave (false negative) is more costly than flagging someone who stays (false positive). ROC-AUC was used as the primary metric over accuracy because the dataset is imbalanced (~84% stay, ~16% leave). Precision is intentionally low (0.35) — the risk score is a prioritization tool for where to look first, not a verdict on any individual employee.

## SQL analysis layer

The `sql/` folder independently validates every major finding above using pure SQL on the same dataset, with no model involved. 61 queries across 9 files, progressing from basic filtering through subqueries, CTEs, and window functions to management-ready summaries.

| File | Covers |
|---|---|
| `01_sql_fundamentals.sql` | Headcount, filtering, basic conditions |
| `02_employee_analysis.sql` | Workforce breakdown by department/role |
| `03_attrition_analysis.sql` | Core attrition rate by department, role, overtime, education field |
| `04_hr_segmentation.sql` | Salary bands, age groups, tenure groups, high-risk segments |
| `05_subqueries.sql` | Above-average earners, department-relative comparisons |
| `06_ctes.sql` | Reusable attrition summaries, ranked departments |
| `07_window_functions.sql` | `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, `PARTITION BY` |
| `08_advanced_hr_analysis.sql` | Multi-dimension risk combinations (overtime × satisfaction, age × overtime) |
| `09_executive_analysis.sql` | Management-ready summary tables |

See `sql/README.md` for full details and how to run it.

## Power BI dashboard

Three pages: Overview, Where & Why, and Risk Watchlist — built on `hr_powerbi.csv`, the out-of-fold risk-scored output of every employee.

![Overview](Powerbi/Screenshots/page1_overview.png)
![Where and Why](powerbi/screenshots/page2_where_why.png)
![Risk Watchlist](powerbi/screenshots/page3_watchlist.png)

## Files

- `01_eda.py` — exploratory analysis + plots
- `02_model.py` — model training, evaluation, feature importance, risk scoring
- `04_powerbi_export.py` — exports out-of-fold risk scores for all 1,470 employees
- `hr_powerbi.csv` — every employee scored with risk level, feeds the Power BI dashboard
- `sql/` — 61-query SQL analysis layer (see `sql/README.md`)
- `powerbi/HR_Attrition_Dashboard.pbix` — the Power BI report file
- `powerbi/screenshots/` — dashboard page exports
- `plot_*.png` — supporting EDA visualizations from Python

## Tools used

Python, Pandas, NumPy, Scikit-Learn, Matplotlib, Seaborn, SQL (MySQL), Power BI (DAX, Power Query)

## Next steps / possible extensions

- Try XGBoost / LightGBM for a stronger model
- Extend the SQL layer with joins across normalized tables (currently single-table)
- Add a simple Streamlit app so HR could upload new employee data and get live risk scores
