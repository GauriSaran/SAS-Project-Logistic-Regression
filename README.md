# Machine-Learning-Project-Logistic-Regression-to-Predict-Drug-User(Cannabis user)
Predicting whether a subject is Drug (Cannabis) user or not using Logistic Regression
# Project
## Predicting the Drug Usage based on different features of demographic features of a subject.

The goal of this project is to predict usage of drug (Cannabis) using Logistic Regression, a supervised learning classification algorithm based on the data gathered from Drug consumption dataset from UCI machine learning repository: https://archive.ics.uci.edu/ml/machine-learning-databases/00373/drug_consumption.data.
The dataset contains information regarding demographic features and personality traits of those that are drug users and those that are not. This dataset is split in to training and validation dataset to build the model and check model performance for evaluation of the best model for prediction. Following features are used in building the model:
* Demographics: Age, Gender, Education
* Personality Traits: Neuroticism, Extraversion, Openness, Agreeableness, Conscientiousness, Impulsiveness, Sensation

## Project is divided in to following sections:
* Gathering the Data using SAS library
* Data Processing using conditional SAS statements and Proc Surveyselect
* Descriptive Statisctics using SAS procedures such as Proc means, Proc freq
* Data Visualization and Test of Association between Predictor variables and response varibles using SAS procedures such as Proc corr (for determining linear or nonlinear relationship using Spearman and Hoeffding statistic), Proc sgplot, Proc rank (for binning the dataset), Proc freq (for Chi-square test of Association).
* Handling categorical inputs and redundant variables to avoid high dimensionality issues and overfitting using Proc Cluster and Proc Varclus.
* Training and testing the model using Proc logistic using different selection techniques such as Forward and Backward.
* Evaluating the model on validation dataset using score statement in Proc logistic.

## Software Used:
* SAS University Edition

