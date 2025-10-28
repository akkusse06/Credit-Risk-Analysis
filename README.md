# Nova Bank Credit Risk Analytics Portfolio

## Overview
This repository contains **comprehensive credit risk analysis** for **Nova Bank**, a financial institution offering **personal, medical, education, and business loans** across the **USA, UK, and Canada**. The goal is to **balance fair lending access with risk control** using data-driven insights.

- **Too many approvals** → Financial losses  
- **Too strict policies** → Lost customers & exclusion  

This project uses **32,582 real-world loan records** to uncover **who defaults and why**, enabling **smarter, fairer lending decisions**.

---

## Dataset
**File**: [`Credit_Risk_Dataset_Onyx_Data_September_25.xlsx`](Credit_Risk_Dataset_Onyx_Data_September_25.xlsx)  
**Rows**: 32,582 | **Columns**: 29  

### Key Features
| Category       | Columns |
|----------------|--------|
| **Demographics** | `person_age`, `gender`, `marital_status`, `education_level` |
| **Financial**    | `person_income`, `loan_amnt`, `loan_int_rate`, `debt_to_income_ratio` |
| **Credit History** | `cb_person_default_on_file`, `past_delinquencies`, `credit_utilization_ratio` |
| **Loan Details** | `loan_status` (**Target**: 0=Repaid, 1=Default), `loan_grade` (A–G), `loan_intent` |
| **Geography**    | `country`, `state`, `city`, `latitude`, `longitude` |

> **Data Dictionary** included in Excel (Sheet 2)

---

## Analysis Highlights

### 1. Exploratory Data Analysis (EDA)
**Notebook**: [`Analysis.ipynb`](Analysis.ipynb)  
- **Bar charts** showing **average debt-to-income ratio (DTI)** by:
  - Home ownership
  - Loan intent
  - Gender
  - Marital status
  - Education level
  - Country, state, employment type
- **Key Insight**: **Renters** and **medical loan** borrowers have **highest DTI**

---

### 2. Multicollinearity & Correlations
**Notebook**: [`Prediction Program.ipynb`](Prediction Program.ipynb)  
- **Heatmap** of all numeric features
- **105 pairwise correlations** printed with direction
- **Top Findings**:
  | Pair | Correlation | Note |
  |------|-------------|------|
  | `loan_percent_income` ↔ `loan_to_income_ratio` | **1.0000** | **Perfect correlation** → Drop one |
  | `other_debt` ↔ `debt_to_income_ratio` | **0.9987** | Near-perfect |
  | `person_income` ↔ `loan_to_income_ratio` | **-0.8542** | Strong negative |

---

### 3. SQL-Powered Insights
**File**: [`Credit Risk Analytics.pdf`](Credit_Risk_Analytics.pdf)  
**20+ SQL queries** on MySQL schema:

```sql
-- Overall Default Rate
SELECT ROUND(
  (SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2
) AS default_rate_percent
FROM customer_loan_data;
-- Result: ~20.85%
