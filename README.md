# Fundraising Data Analysis and Target Marketing

## Project Overview
This project demonstrates the use of data analysis and predictive modeling to optimize fundraising efforts. The goal is to process and clean the dataset, extract insights, and build a multiple linear regression model for targeted marketing. Finally, I analyze the potential profit of the marketing strategy.

---

## Steps and Methodology

### Part A: Data Cleaning and Exploratory Data Analysis (EDA)

1. **Handling Missing Values**:
   - Identified missing values in the columns `HV_1`, `Icmed1`, and `Icavg1`.
   - Replaced missing values with:
     - The mean for `HV_1` and `Icmed1`.
     - The median for `Icavg1`.

2. **Dealing with Outliers**:
   - Detected outliers in `HV_1`, `Icmed1`, and `Icavg1` using statistical thresholds.
   - Replaced outliers with appropriate upper or lower bounds.

3. **Correlation Analysis**:
   - Computed correlation coefficients between variables to identify significant relationships.
   - Interpreted correlations to select relevant predictors for the model.

4. **Visualization**:
   - Visualized relationships between `TARGET_D` (response variable) and input variables using histograms and scatter plots.
   - Compared the mean values of `TARGET_D` across categorical variables.

---

### Part B: Building the Predictive Model

1. **Data Preparation**:
   - Split the dataset into 50% training and 50% test subsets.

2. **Model Building**:
   - Constructed a multiple linear regression model using `TARGET_D` as the output variable.
   - Excluded the first two non-relevant columns.

3. **Model Evaluation**:
   - Predicted `TARGET_D` on the test dataset.
   - Calculated actual vs. predicted values and analyzed the performance of the model.

---

### Part C: Targeted Marketing Strategy

1. **Optimizing Profitability**:
   - Population size: 117,000.
   - Cost per letter: Rs. 7.
   - Sent offers to the top three deciles (30%) based on predicted values of `TARGET_D`.
   - Calculated profit by comparing scenarios:
     - Sending letters to the top deciles.
     - Sending letters to the entire population.

2. **Results**:
   - Recommended sending offers to the top three deciles to maximize profit while minimizing marketing costs.

---

### Files in the Repository

- **Code File**:
  - `fundraising_analysis.R`: Contains the full implementation of data cleaning, visualization, modeling, and targeted marketing.

- **Dataset**:
  - `Fundraising_Raw_Data.csv`: The raw dataset used for analysis.

- **Results**:
  - `test_with_prediction.csv`: The test dataset with actual and predicted values and profitability calculations and recommendations.
