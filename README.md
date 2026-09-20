# HR Analytics — Employee Attrition Analyzer

Predicts which employees are likely to leave, using the IBM HR Analytics dataset,
and surfaces the operational patterns behind attrition (overtime, salary, satisfaction).

## Why I built this
During my internship at Partnerdesk, I coordinated and mentored 7-10 international
interns. I saw firsthand how workload, unclear compensation policies, and inconsistent
treatment led to disengagement — including a case where I had to escalate a fairness
issue directly to the CEO. This project applies that same lens to real HR data: using
data to surface the patterns that HR teams often only notice after someone has
already decided to leave.

## Dataset
IBM HR Analytics Employee Attrition & Performance dataset (Kaggle) — 1,470 employees,
35 features including department, role, income, satisfaction scores, and tenure.

## What this project does

1. **EDA** — explored attrition patterns across department, overtime status, and
   correlations between numeric features.
2. **Predictive model** — Logistic Regression (class-balanced) predicting attrition
   probability per employee. Random Forest was also trained for comparison and used
   for feature importance.
3. **Department x Role attrition heatmap** — pinpoints exactly where attrition is
   concentrated, ready to drop into Tableau.
4. **Salary x Satisfaction x Workload analysis** — shows how these three factors
   compound.
5. **Per-employee risk score** — instead of a binary Yes/No prediction, every employee
   gets a probability score and a Low/Medium/High risk bucket, which is what an HR
   team could actually act on.

## Key findings

- Overall attrition rate: **16.1%**
- **OverTime employees leave at ~3x the rate** of those who don't (30.5% vs 10.4%)
- **Sales Representatives** have the highest attrition of any role: **39.8%**
- Compounding effect: **low-salary + overtime employees have a 58.5% attrition rate**,
  vs. 7.2% for high-salary employees without overtime
- Top predictive drivers: Monthly Income, Age, Total Working Years, Years at Company,
  OverTime

## Model performance

| Model | Accuracy | Precision | Recall | F1 | ROC-AUC |
|---|---|---|---|---|---|
| Logistic Regression | 0.75 | 0.35 | 0.62 | 0.44 | **0.80** |
| Random Forest | 0.83 | 0.47 | 0.38 | 0.42 | 0.78 |

Logistic Regression was selected as the primary model — despite lower raw accuracy,
it has meaningfully higher recall, which matters more here: in attrition prediction,
missing an employee who's about to leave (false negative) is more costly than
flagging someone who stays (false positive). ROC-AUC was used as the primary metric
over accuracy because the dataset is imbalanced (~84% stay, ~16% leave).

## Files

- `01_eda.py` — exploratory analysis + plots
- `02_model.py` — model training, evaluation, feature importance, risk scoring
- `03_heatmap_dashboard.py` — department heatmap + salary/satisfaction/workload views
- `employee_risk_scores.csv` — final output: every employee scored with risk level
- `tableau_dept_role_attrition.csv` — pivot table ready for Tableau import
- `plot_*.png` — all visualizations

## Tools used
Python, Pandas, NumPy, Scikit-Learn, Matplotlib, Seaborn, Tableau (for the
department heatmap dashboard)

## Next steps / possible extensions
- Try XGBoost / LightGBM for a stronger model
- Build the Tableau dashboard interactively using `tableau_dept_role_attrition.csv`
- Add a simple Streamlit app so HR could upload new employee data and get live risk scores
