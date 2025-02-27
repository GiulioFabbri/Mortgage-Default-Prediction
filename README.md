# Mortgage Default Prediction

## Authors

Giulio Fabbri, Valentina Coppi

## Project Overview

This project aims to predict mortgage defaults using various machine learning models in SAS Studio. 
The dataset used is highly imbalanced, requiring resampling techniques to ensure fair model training.

## Dataset Preparation

- **Balancing the Dataset**: A 50-50 event/non-event sampling was applied to correct for class imbalance.
- **Data Partitioning**:
  - 80% training
  - 10% validation
  - 10% test
- **Duplicate and Missing Values**:
  - No duplicate observations found.
  - Missing values identified in numeric variables (DTI, OCLTV, CSCORE_B, CSCORE_C, NUM_BO, MI_PCT, MI_TYPE).
  - Nominal variables have no missing values.

## Data Preprocessing

- **Target Variable**: WillDefault set as the target.
- **Variable Transformations**:
  - Reject variables converted to inputs.
  - MI_PCT treated as an interval variable.
  - Missing values in MI_PCT imputed to 0.
  - Standardized all numeric variables.
- **Anomaly Detection**: Outliers removed.

## Model Selection

Various models were tested to determine the most accurate one:

### Pipeline 1: Logistic Regression

- Compared two logistic regression models, one with variable selection using clustering.
- The logistic regression with clustering achieved the highest accuracy.

### Pipeline 2: Decision Trees

- Tested Decision Tree models using Gini and Chi-Square criteria.
- The best-performing model: Decision Tree Gini with variable selection.

### Pipeline 3: Gradient Boosting vs. Random Forest

- Gradient Boosting (200 trees) and Random Forest (150 trees, depth 25) were compared.
- Gradient Boosting performed better.

### Pipeline 4: Neural Networks vs. Gradient Boosting

- Neural Networks performed poorly.
- Gradient Boosting with variable selection achieved the highest accuracy.

## Final Model Selection

- **Best Model**: Gradient Boosting with variable selection (85% accuracy).
- Selected for simplicity and high accuracy following Occam's Razor principle.

## Model Insights

- **Key Predictors of Loan Default**:
  - ORIG_RT (Original Interest Rate)
  - Loan Age
  - LastVersusOriginal (Interest Rate Variation)
  - Credit Score
  - State
- **Model Performance**:
  - Misclassification rate decreased but remained stable in validation/testing.
  - Average squared error decreased but showed diminishing returns after ~50 trees.
  - ROC curve showed good accuracy.
  - Lift curve confirmed better predictions compared to a random model.

## Model Interpretability

- **PDP Plot**: ORIG_RT is the most influential factor.
- **ICE Plot**: Other variables also impact predictions beyond ORIG_RT.

## Conclusion

Gradient Boosting with variable selection is the best model due to its high accuracy and reduced dataset complexity.

