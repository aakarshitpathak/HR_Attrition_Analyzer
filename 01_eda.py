"""
HR Analytics — Employee Attrition Analyzer
Step 1: Exploratory Data Analysis (EDA)
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_style("whitegrid")
plt.rcParams["figure.figsize"] = (10, 6)

# ---- Load data ----
df = pd.read_csv("/home/claude/hr_attrition.csv")
print("Shape:", df.shape)
print("\nColumns:\n", df.columns.tolist())
print("\nMissing values:\n", df.isnull().sum().sum(), "total missing values")

# ---- Overall attrition rate ----
attrition_rate = df["Attrition"].value_counts(normalize=True) * 100
print("\nAttrition rate:\n", attrition_rate)

# ---- Drop constant / useless columns ----
# EmployeeCount, StandardHours, Over18 are constant across all rows — no signal
useless_cols = ["EmployeeCount", "StandardHours", "Over18", "EmployeeNumber"]
df_clean = df.drop(columns=useless_cols)
df_clean.to_csv("/home/claude/attrition_project/hr_clean.csv", index=False)
print("\nSaved cleaned dataset -> hr_clean.csv")

# ---- Plot 1: Overall attrition distribution ----
fig, ax = plt.subplots()
df["Attrition"].value_counts().plot(kind="bar", color=["#4C72B0", "#DD8452"], ax=ax)
ax.set_title("Overall Attrition Count (No vs Yes)")
ax.set_xlabel("Attrition")
ax.set_ylabel("Number of Employees")
plt.tight_layout()
plt.savefig("/home/claude/attrition_project/plot_overall_attrition.png", dpi=120)
plt.close()

# ---- Plot 2: Attrition rate by Department ----
dept_attrition = df.groupby("Department")["Attrition"].apply(
    lambda x: (x == "Yes").mean() * 100
).sort_values(ascending=False)
fig, ax = plt.subplots()
dept_attrition.plot(kind="bar", color="#C44E52", ax=ax)
ax.set_title("Attrition Rate (%) by Department")
ax.set_ylabel("Attrition Rate (%)")
plt.tight_layout()
plt.savefig("/home/claude/attrition_project/plot_dept_attrition.png", dpi=120)
plt.close()

# ---- Plot 3: Attrition by OverTime ----
ot_attrition = df.groupby("OverTime")["Attrition"].apply(
    lambda x: (x == "Yes").mean() * 100
)
fig, ax = plt.subplots()
ot_attrition.plot(kind="bar", color="#55A868", ax=ax)
ax.set_title("Attrition Rate (%) by OverTime Status")
ax.set_ylabel("Attrition Rate (%)")
plt.tight_layout()
plt.savefig("/home/claude/attrition_project/plot_overtime_attrition.png", dpi=120)
plt.close()

# ---- Plot 4: Correlation heatmap (numeric features) ----
numeric_df = df_clean.select_dtypes(include=[np.number])
plt.figure(figsize=(14, 10))
sns.heatmap(numeric_df.corr(), cmap="coolwarm", center=0, linewidths=0.3)
plt.title("Correlation Heatmap — Numeric Features")
plt.tight_layout()
plt.savefig("/home/claude/attrition_project/plot_correlation_heatmap.png", dpi=120)
plt.close()

# ---- Plot 5: Salary vs Satisfaction vs Attrition ----
fig, ax = plt.subplots(figsize=(10, 7))
colors = df["Attrition"].map({"Yes": "#DD8452", "No": "#4C72B0"})
ax.scatter(
    df["MonthlyIncome"], df["JobSatisfaction"],
    c=colors, alpha=0.5, s=df["WorkLifeBalance"] * 20
)
ax.set_xlabel("Monthly Income")
ax.set_ylabel("Job Satisfaction (1-4)")
ax.set_title("Salary vs Satisfaction (bubble size = Work-Life Balance, color = Attrition)")
plt.tight_layout()
plt.savefig("/home/claude/attrition_project/plot_salary_satisfaction.png", dpi=120)
plt.close()

print("\nAll EDA plots saved in attrition_project/")
print("\nKey findings:")
print(f"- Overall attrition rate: {attrition_rate['Yes']:.1f}%")
print(f"- Highest attrition department: {dept_attrition.idxmax()} ({dept_attrition.max():.1f}%)")
print(f"- Attrition rate for OverTime=Yes: {ot_attrition['Yes']:.1f}% vs OverTime=No: {ot_attrition['No']:.1f}%")
