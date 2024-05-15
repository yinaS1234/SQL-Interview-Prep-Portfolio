# SQL-Portfolio by Yina Qiao

## Introduction
Welcome to my SQL Interview Preparation Portfolio! This repository showcases practical SQL skills and knowledge acquired from the ["Learn SQL for Data Science"](https://www.coursera.org/specializations/learn-sql-basics-data-science) course offered by the University of California, Davis. The primary focus is on developing and presenting SQL examples that can be effectively used in job interviews.

In this section, I've created SQL queries and mini-projects based on what I’ve learned from the course. These examples demonstrate how the SQL skills learned can be applied in a practical context.

### Example 3.1: Advanced Rollup Table for Analyzing Weekly Order Trends

- **Problem Statement**: This SQL query is focused on analyzing order trends over a rolling seven-day period using a rollup table. The script aims to provide a deeper understanding of order patterns on a weekly basis, smoothing out day-to-day fluctuations to reveal more consistent trends.
- **SQL Query**: The query starts by selecting dates from a **`dates_rollup`** table. It then joins this with a subquery that calculates the daily count of distinct orders and line items. The join is performed on a condition that aligns the dates within a rolling seven-day window. The use of **`COALESCE`** ensures that days with no orders still show up in the results with zero counts.
- **Result and Explanation**: The result is a table that provides a rolling seven-day summary of orders and line items. This type of analysis is particularly useful for businesses to understand weekly trends, identify patterns, and make data-driven decisions. It demonstrates the ability to perform complex aggregations and temporal analysis using SQL.

### Example 3.2: Generating Data for Personalized Promo Emails

- **Problem Statement**: This SQL script is developed to assist a marketing team in sending personalized emails to users. Imagine a marketing strategy where we aim to re-engage customers by emailing them pictures of items they viewed most recently on our website. The rationale is simple: showing customers what they're already interested in might be the compelling reason they need to return to our site and complete a purchase.
- **SQL Query**: The query uses a window function (**`RANK()`**) to determine each user's most recently viewed item based on event times. It then joins this data with user and item details to compile the necessary information for each promotional email. The focus is on ensuring that the latest item viewed by each user is accurately identified.
- **Result and Explanation**: The final dataset includes user IDs, email addresses, item IDs, names, and categories, crucial for crafting targeted promotional emails. This SQL script not only supports a strategic marketing initiative but also showcases the ability to leverage advanced SQL features like window functions and joins for practical and impactful business solutions.

### Example 3.3: Understanding User Reorder Behaviors for Better Product Recommendations

- **Problem Statement**: Our goal is to enhance product recommendations by exploring user reorder patterns. The key questions we're addressing are: How often do users reorder? Do they show a preference for items in the same category? What is the usual time interval between reorders?
- **SQL Query**: The analysis begins by identifying users who have made purchases and those who have made repeat purchases. We then analyze reordering trends by examining orders by item and category, employing straightforward queries to identify trends and popular items.
- **Result and Explanation**: The analysis uncovers significant trends in user purchasing behaviors. Although reorders are not exceedingly common, there is a noticeable tendency for users to buy multiple items from the same category. This finding suggests a strategy shift towards recommending similar category items during the shopping experience, potentially appealing to a broader range of customers more effectively.

### Example 4.1: Analyzing User Assignments in Software Testing Experiments

- **Problem Statement**: This analysis revolves around understanding how users are assigned to different test groups in software experiments. The focus is on identifying which users are exposed to new features (treatment) and which ones continue with the existing setup (control). The key is to ensure proper user segmentation and accurate data logging for meaningful experiment outcomes.
- **SQL Query**: The query starts by identifying distinct test IDs from a pool of test assignments. It then constructs a table detailing each assignment event, including the event ID, date, user ID, platform used, and the specific test assignment (treatment or control). This setup allows for a comprehensive view of how tests are distributed among users and how they interact with different software features.
- **Result and Explanation**: The outcome is a detailed breakdown of test assignments, revealing how users are distributed across various tests. This information is crucial in understanding user interactions with new features and ensuring that the test groups are appropriately balanced and representative. It forms the basis for analyzing the impact of new features on user behavior and making data-driven decisions about software updates.

### Example 4.2: Evaluating User Behavior Post-Experiment Exposure

- **Problem Statement**: The goal is to create metrics that assess how new software features impact user behavior, specifically in terms of e-commerce engagements like making orders. This involves determining whether users who were exposed to new features (either in the control or treatment group) changed their purchasing behavior as a result.
- **SQL Query**: The script is divided into two main parts. The first part creates a temporary table (**`test_a`**) to aggregate test assignment events, including user IDs and test IDs. The second part of the script then performs left joins with the orders table to calculate key metrics:
    - The first query calculates a binary metric (**`orders_after_assignment_binary`**) indicating whether users placed any orders after their test assignment.
    - The second query expands on this by counting the number of distinct orders (**`orders_cnt_after_assignment`**), the number of distinct items ordered (**`item_cnt_after_assignment`**), and the total revenue generated (**`total_revenue_after_assignment`**) after the test assignment.
- **Result and Explanation**: These queries result in a comprehensive dataset that shows not just whether users engaged with the product post-experiment but also the extent and economic value of this engagement. This data is crucial for understanding the effectiveness of new features in influencing user purchasing decisions, providing valuable insights for future feature development and business strategy.

### Example 4.3: In-depth Analysis of A/B Test Results

- **Problem Statement**: The aim is to analyze the results of an A/B test to understand how different test variants (treatment and control) affected user behavior. This involves calculating various metrics to see if there are any significant differences between the groups, such as the number of users who made an order or viewed an item, and the timing of these actions.
- **SQL Query**:
    - The script begins by creating sub-tables to aggregate test assignment data, focusing on specific metrics like order binary (whether a user made an order post-assignment) and view binary (whether a user viewed an item).
    - It then computes the count of users in each treatment group and aggregates the metrics, such as the number of orders or views, within specified time frames (like 30 days post-assignment).
    - Additionally, for mean value metrics, the script calculates the average and standard deviation to prepare for a comprehensive statistical analysis of the A/B test results.
- **Result and Explanation**: The output provides a detailed comparison between treatment and control groups across various user behavior metrics. This includes binary metrics (like order completion) and continuous metrics (such as the number of orders or views). By analyzing these results, especially in the context of standard deviations and time-bound actions, the effectiveness of the tested feature changes can be evaluated. This analysis is crucial for drawing statistically significant conclusions about the impact of new features on user behavior and informing future development decisions.

### Example 4.4: Comprehensive Data Analysis for A/B Testing

- **Problem Statement**: This script is aimed at conducting an in-depth analysis for an A/B test at an item level, focusing on different aspects like data quality, reformatting data for analysis, and computing key metrics to assess user behavior changes.
- **SQL Query**:
    1. **Data Quality Check**: The initial part of the script performs a quality check to ensure the data includes all necessary elements (like **`event_time`**) for computing metrics such as 30-day view-binary.
    2. **Data Reformatting**: It then reformats the data to align with the testing requirements. This includes restructuring data from multiple test groups (**`test_a`** to **`test_f`**) and assigning relevant attributes like test number and start date.
    3. **Computing Order Binary Metric**: The script calculates a binary metric indicating whether users placed orders within 30 days after the test start date for a specific test (**`item_test_2`**).
    4. **Computing View Item Metrics**: Similar to the order binary, this part calculates a view binary metric for the same 30-day window, assessing whether users viewed items post-test.
    5. **Computing Lift and P-value**: The final part of the script aggregates these metrics and prepares them for statistical analysis to compute lift and p-values, essential for evaluating the effectiveness of the test variants.
- **Result and Explanation**: The result of this script provides a detailed analysis of user behavior in response to different test scenarios, including both order and view metrics. It offers a comprehensive view of how users interact with items in the test groups and enables a statistical evaluation of the test's impact. This analysis is crucial for understanding the effectiveness of different test variants and making data-driven decisions in feature development.



# Example 5.1: Logistic Regression Classifier for Incident Prediction

## Problem Statement
This project focuses on developing a logistic regression model to predict the type of incident (`Call_Type_Group`) for fire department calls. The goal is to preprocess the data, train a machine learning model, and make predictions using both PySpark and Spark SQL.

## Steps and SQL Queries
1. **Data Loading**: Loaded the fire department call data from a Parquet file into a Spark SQL table (`fireCallsClean`).
2. **Data Cleaning**: Cleaned the data by filtering out null values and less frequent call types, creating a temporary view (`fireCallsGroupCleaned`) for analysis.
3. **Feature Selection**: Selected relevant columns (`Call_Type`, `Fire_Prevention_District`, `Neighborhooods_-_Analysis_Boundaries`, `Number_of_Alarms`, `Original_Priority`, `Unit_Type`, `Battalion`, `Call_Type_Group`) to create a new view (`fireCallsDF`).
4. **Data Transformation**: Converted the Spark DataFrame to a pandas DataFrame for preprocessing, using label encoding and train-test splitting for the logistic regression model.
5. **Model Training**: Trained a logistic regression model using Sklearn, integrated within a pipeline with one-hot encoding for categorical features.
6. **Model Evaluation**: Evaluated the model's accuracy on test data and saved the trained pipeline using MLflow.
7. **Model Deployment**: Registered the model as a UDF in Spark SQL to enable parallel predictions on new data.

## Result and Explanation
The project successfully developed a logistic regression classifier to predict incident types with high accuracy. The integration of PySpark and Spark SQL allowed efficient data processing and model deployment, demonstrating the capability to handle large datasets and perform complex machine learning tasks in a distributed environment. This project showcases the use of both PySpark and Spark SQL for end-to-end data analysis and machine learning in a big data context.
