# GWP – Support Vector Machines

This repository contains code, data preprocessing workflows, and model evaluation scripts for groundwater potential (GWP) classification using Support Vector Machines (SVM). The project demonstrates how machine learning can be applied to hydrogeological datasets to produce reproducible, transparent, and interpretable groundwater mapping results.

---

## 🔹 Key Features

- **Preprocessing**: One-hot encoding of categorical predictors including soil texture, soil colour, geological features, elevation, vegetation attributes, and drainage density.  
- **Class Imbalance Handling**: Implementation of class weights to improve sensitivity for minority zones (High Potential).  
- **Model Training**: SVM classifier with linear kernel, optimized for categorical data.  
- **Evaluation Metrics**: Confusion matrix, accuracy, kappa, sensitivity, specificity, balanced accuracy, prevalence, detection rate, and detection prevalence.  
- **Error Attribution**: Analysis of misclassifications, highlighting causes such as indicator variability, model fitting deviations, and regional geological heterogeneity.  
- **Deployment**: GitHub Actions workflow for reproducible execution of preprocessing and model training scripts.  

---

## 🔹 Purpose

The project demonstrates how machine learning can be applied to groundwater potential mapping, ensuring reproducibility, transparency, and methodological rigor. It is designed for academic research, stakeholder reporting, and practical decision support in water resource management.

---

## 📂 Repository Structure

- `Support vector machines.R` → Main script for preprocessing and SVM training  
- `.github/workflows/deploy.yml` → GitHub Actions workflow for automated runs  
- `README.md` → Project documentation  

---

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/majawabenson844-del/GWP-SUPPORT-VECTOR-MACHINES.git
