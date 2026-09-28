```python
"""
HR Analytics — Employee Attrition Analyzer
Step 3: Python EDA — Attrition Patterns and Risk Factors

Power BI is used for the interactive dashboard.
This script generates supporting Python visualizations.
"""

from pathlib import Path

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# ---------------------------------------------------------
# File paths
# ---------------------------------------------------------
BASE_DIR = Path(__file__).resolve().parent

df = pd.read_csv(BASE_DIR / "hr_clean.csv")
df["Attrition_Flag"] = df["Attrition"].map({"Yes": 1, "No": 0})


# =========================================================
# 1. Department x JobRole attrition heatmap
# =========================================================

pivot = (
    df.pivot_table(
        index="JobRole",
        columns="Department",
        values="Attrition_Flag",
        aggfunc="mean"
    )
    * 100
)

plt.figure(figsize=(9, 8))

sns.heatmap(
    pivot,
    annot=True,
    fmt=".1f",
    cmap="Reds",
    cbar_kws={"label": "Attrition Rate (%)"}
)

plt.title("Attrition Rate (%) — Department x Job Role")
plt.ylabel("Job Role")
plt.xlabel("Department")
plt.tight_layout()

plt.savefig(
    BASE_DIR / "plot_department_jobrole_heatmap.png",
    dpi=120
)

plt.close()


# =========================================================
# 2. Salary vs Satisfaction vs Workload
# =========================================================

fig, axes = plt.subplots(1, 3, figsize=(18, 5))


# ---- Salary bands vs attrition ----

df["SalaryBand"] = pd.qcut(
    df["MonthlyIncome"],
    4,
    labels=["Low", "Mid-Low", "Mid-High", "High"]
)

salary_attrition = (
    df.groupby("SalaryBand", observed=True)["Attrition_Flag"]
    .mean()
    * 100
)

salary_attrition.plot(
    kind="bar",
    ax=axes[0],
    color="#4C72B0"
)

axes[0].set_title("Attrition Rate by Salary Band")
axes[0].set_ylabel("Attrition Rate (%)")
axes[0].set_xlabel("Salary Band")


# ---- Job satisfaction vs attrition ----

sat_attrition = (
    df.groupby("JobSatisfaction")["Attrition_Flag"]
    .mean()
    * 100
)

sat_attrition.plot(
    kind="bar",
    ax=axes[1],
    color="#DD8452"
)

axes[1].set_title(
    "Attrition Rate by Job Satisfaction (1=Low, 4=High)"
)

axes[1].set_ylabel("Attrition Rate (%)")
axes[1].set_xlabel("Job Satisfaction")


# ---- OverTime vs attrition ----

ot_attrition = (
    df.groupby("OverTime")["Attrition_Flag"]
    .mean()
    * 100
)

ot_attrition.plot(
    kind="bar",
    ax=axes[2],
    color="#55A868"
)

axes[2].set_title("Attrition Rate by OverTime (Workload)")
axes[2].set_ylabel("Attrition Rate (%)")
axes[2].set_xlabel("OverTime")


plt.tight_layout()

plt.savefig(
    BASE_DIR / "plot_salary_satisfaction_workload.png",
    dpi=120
)

plt.close()


# =========================================================
# 3. Salary Band x OverTime
# =========================================================

combo = (
    df.groupby(
        ["SalaryBand", "OverTime"],
        observed=True
    )["Attrition_Flag"]
    .mean()
    .unstack()
    * 100
)

plt.figure(figsize=(7, 5))

sns.heatmap(
    combo,
    annot=True,
    fmt=".1f",
    cmap="OrRd",
    cbar_kws={"label": "Attrition Rate (%)"}
)

plt.title("Attrition Rate (%) — Salary Band x OverTime")
plt.tight_layout()

plt.savefig(
    BASE_DIR / "plot_salary_overtime_combo.png",
    dpi=120
)

plt.close()


# =========================================================
# Output
# =========================================================

print("Python EDA visualizations saved:")
print("- plot_department_jobrole_heatmap.png")
print("- plot_salary_satisfaction_workload.png")
print("- plot_salary_overtime_combo.png")

print("\nSalary band attrition rates:")
print(salary_attrition)

print("\nOverTime x SalaryBand attrition:")
print(combo)
