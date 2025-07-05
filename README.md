# Heart Disease Data Analysis in R

This project presents an exploratory and statistical analysis of a heart disease dataset using **R** and several powerful libraries including `dplyr`, `ggplot2`, and `tidyr`. The aim is to investigate relationships between variables and uncover patterns related to heart disease.

## 📁 Dataset
The dataset includes key medical indicators such as:
- Age, Sex
- Resting Blood Pressure (`RestingBP`)
- Cholesterol
- Max Heart Rate (`MaxHR`)
- Fasting Blood Sugar (`FastingBS`)
- Chest Pain Type (`ChestPainType`)
- Presence of Heart Disease (`HeartDisease`)
- ST Depression (`Oldpeak`)

## 🔍 Key Operations

- **Data Loading & Structure Inspection:** Loaded the dataset with `read.csv()` and examined structure with `str()`, `dim()`, and `summary()`.
- **Data Filtering & Transformation:** 
  - Filtered individuals aged over 50 with heart disease.
  - Created a new variable: cholesterol-to-age ratio.
  - Normalized numeric variables using `scale()`.

## 📊 Visualizations

- **Histogram** of Cholesterol values for all and heart disease patients.
- **Scatter Plots**: Age vs MaxHR, RestingBP vs Age.
- **Bar Charts**: Gender distribution, mean MaxHR by gender.
- **Boxplots**: 
  - Cholesterol levels by `ChestPainType`
  - MaxHR by `Sex`
  - MaxHR by Fasting Blood Sugar (`FastingBS`)

## 📈 Statistical Analysis

- **Group Summary Statistics:** 
  - Mean and median `Oldpeak` by `ChestPainType` (visualized with grouped bar plots).
- **ANOVA Tests:**
  - Cholesterol differences across `ChestPainType` groups.
  - MaxHR differences by `Sex` and by `FastingBS` status.
  
### 📌 Key Findings

- **Age vs MaxHR:** An observable decrease in MaxHR with increasing age.
- **Cholesterol by Chest Pain Type:** ASY type shows higher and more variable cholesterol levels.
- **MaxHR by Gender:** Females tend to have higher MaxHR than males (p < 0.001).
- **MaxHR by Fasting Blood Sugar:** High fasting blood sugar is associated with significantly lower MaxHR.

## 📦 Libraries Used
- `dplyr`: Data manipulation
- `ggplot2`: Visualization
- `tidyr`: Data reshaping

## 🔧 Requirements
- R version ≥ 4.0
- Packages: dplyr, ggplot2, tidyr

---

*This analysis provides initial insights into how different health metrics relate to heart disease presence and how factors like gender or chest pain type influence key indicators.*
