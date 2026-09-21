import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import StratifiedKFold, cross_val_predict
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

df = pd.read_csv("hr_attrition_raw.csv")

# Target + constant/ID columns
df["Attrition_Flag"] = (df["Attrition"] == "Yes").astype(int)
drop_cols = ["Attrition", "EmployeeCount", "Over18", "StandardHours", "EmployeeNumber"]
X = pd.get_dummies(df.drop(columns=drop_cols + ["Attrition_Flag"]), drop_first=True)
y = df["Attrition_Flag"]

# Out-of-fold probabilities: every employee is scored by a model that never saw them
model = make_pipeline(StandardScaler(),
                      LogisticRegression(class_weight="balanced", max_iter=2000))
cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
df["Attrition_Probability"] = cross_val_predict(
    model, X, y, cv=cv, method="predict_proba")[:, 1].round(3)

# Buckets (adjust thresholds after checking the printed counts)
df["Risk_Level"] = pd.cut(df["Attrition_Probability"],
                          bins=[0, 0.30, 0.60, 1.0],
                          labels=["Low", "Medium", "High"], include_lowest=True)

# Salary bands (tertiles)
df["Salary_Band"] = pd.qcut(df["MonthlyIncome"], 3, labels=["Low", "Mid", "High"])

out_cols = ["EmployeeNumber", "Age", "Department", "JobRole", "OverTime",
            "MonthlyIncome", "Salary_Band", "JobSatisfaction", "WorkLifeBalance",
            "EnvironmentSatisfaction", "YearsAtCompany", "TotalWorkingYears",
            "Attrition_Flag", "Attrition_Probability", "Risk_Level"]
df[out_cols].to_csv("hr_powerbi.csv", index=False)

print(df["Risk_Level"].value_counts())
print("Rows:", len(df), "| Attrition rate:", round(df["Attrition_Flag"].mean(), 3))
print(df.groupby("Risk_Level", observed=True)["Attrition_Flag"]
        .agg(["count", "mean"]).round(3))