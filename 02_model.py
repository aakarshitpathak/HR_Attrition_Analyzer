"""
HR Analytics — Employee Attrition Analyzer
Step 2: Predictive Model + Per-Employee Risk Score
"""
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    roc_auc_score, confusion_matrix, classification_report
)
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("/home/claude/attrition_project/hr_clean.csv")

# ---- Encode target ----
df["Attrition_Flag"] = df["Attrition"].map({"Yes": 1, "No": 0})

# ---- Identify categorical columns ----
cat_cols = df.select_dtypes(include="object").columns.tolist()
cat_cols.remove("Attrition")  # keep original for reference

# ---- One-hot encode categoricals (keeps interpretability better than LabelEncoder) ----
df_model = pd.get_dummies(df, columns=cat_cols, drop_first=True)

X = df_model.drop(columns=["Attrition", "Attrition_Flag"])
y = df_model["Attrition_Flag"]

# Keep employee-level reference for the risk score output later
employee_ref = df[["Age", "Department", "JobRole", "MonthlyIncome"]].copy()

X_train, X_test, y_train, y_test, ref_train, ref_test = train_test_split(
    X, y, employee_ref, test_size=0.2, random_state=42, stratify=y
)

# ---- Scale numeric features (helps Logistic Regression) ----
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# =========================================================
# Model 1: Logistic Regression (interpretable baseline)
# =========================================================
log_reg = LogisticRegression(max_iter=2000, class_weight="balanced", random_state=42)
log_reg.fit(X_train_scaled, y_train)
lr_pred = log_reg.predict(X_test_scaled)
lr_proba = log_reg.predict_proba(X_test_scaled)[:, 1]

print("=" * 55)
print("LOGISTIC REGRESSION")
print("=" * 55)
print(f"Accuracy : {accuracy_score(y_test, lr_pred):.3f}")
print(f"Precision: {precision_score(y_test, lr_pred):.3f}")
print(f"Recall   : {recall_score(y_test, lr_pred):.3f}")
print(f"F1-score : {f1_score(y_test, lr_pred):.3f}")
print(f"ROC-AUC  : {roc_auc_score(y_test, lr_proba):.3f}")

# =========================================================
# Model 2: Random Forest (usually stronger, still gives feature importance)
# =========================================================
rf = RandomForestClassifier(
    n_estimators=300, max_depth=6, class_weight="balanced",
    random_state=42, n_jobs=-1
)
rf.fit(X_train, y_train)
rf_pred = rf.predict(X_test)
rf_proba = rf.predict_proba(X_test)[:, 1]

print("\n" + "=" * 55)
print("RANDOM FOREST")
print("=" * 55)
print(f"Accuracy : {accuracy_score(y_test, rf_pred):.3f}")
print(f"Precision: {precision_score(y_test, rf_pred):.3f}")
print(f"Recall   : {recall_score(y_test, rf_pred):.3f}")
print(f"F1-score : {f1_score(y_test, rf_pred):.3f}")
print(f"ROC-AUC  : {roc_auc_score(y_test, rf_proba):.3f}")

# ---- Pick the better model by ROC-AUC (since data is imbalanced, AUC > accuracy) ----
if roc_auc_score(y_test, rf_proba) >= roc_auc_score(y_test, lr_proba):
    best_model, best_proba, best_name = rf, rf_proba, "Random Forest"
else:
    best_model, best_proba, best_name = log_reg, lr_proba, "Logistic Regression"
print(f"\n>> Best model selected: {best_name}")

# =========================================================
# Feature importance (Random Forest) — what drives attrition
# =========================================================
importances = pd.Series(rf.feature_importances_, index=X.columns).sort_values(ascending=False)
top_features = importances.head(15)

plt.figure(figsize=(9, 7))
sns.barplot(x=top_features.values, y=top_features.index, color="#4C72B0")
plt.title("Top 15 Features Driving Attrition (Random Forest)")
plt.xlabel("Importance")
plt.tight_layout()
plt.savefig("/home/claude/attrition_project/plot_feature_importance.png", dpi=120)
plt.close()
print("\nTop 10 drivers of attrition:")
print(top_features.head(10))

# =========================================================
# Confusion matrix for best model
# =========================================================
best_pred = best_model.predict(X_test_scaled if best_name == "Logistic Regression" else X_test)
cm = confusion_matrix(y_test, best_pred)
plt.figure(figsize=(5, 4))
sns.heatmap(cm, annot=True, fmt="d", cmap="Blues",
            xticklabels=["No Attrition", "Attrition"],
            yticklabels=["No Attrition", "Attrition"])
plt.title(f"Confusion Matrix — {best_name}")
plt.ylabel("Actual")
plt.xlabel("Predicted")
plt.tight_layout()
plt.savefig("/home/claude/attrition_project/plot_confusion_matrix.png", dpi=120)
plt.close()

# =========================================================
# Per-employee RISK SCORE output (the key deliverable)
# =========================================================
risk_df = ref_test.copy()
risk_df["Attrition_Probability"] = best_proba
risk_df["Actual_Attrition"] = y_test.map({1: "Yes", 0: "No"}).values

def risk_bucket(p):
    if p >= 0.5:
        return "High"
    elif p >= 0.25:
        return "Medium"
    else:
        return "Low"

risk_df["Risk_Level"] = risk_df["Attrition_Probability"].apply(risk_bucket)
risk_df = risk_df.sort_values("Attrition_Probability", ascending=False).reset_index(drop=True)
risk_df.to_csv("/home/claude/attrition_project/employee_risk_scores.csv", index=False)

print("\nRisk level distribution (test set):")
print(risk_df["Risk_Level"].value_counts())
print("\nSaved per-employee risk scores -> employee_risk_scores.csv")
print("\nTop 10 highest-risk employees:")
print(risk_df.head(10)[["Age", "Department", "JobRole", "MonthlyIncome", "Attrition_Probability", "Risk_Level"]])
