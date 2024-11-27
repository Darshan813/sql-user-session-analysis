# SQL Queries for User and Session Analysis

## 📝 Overview
This repository contains SQL queries designed to analyze user login behavior, session activity, and trends over time. The queries address various business and data analysis needs, such as identifying inactive users, calculating session metrics, and generating quarterly insights.

## Login Table
![image](https://github.com/user-attachments/assets/2c7639cc-8c09-432f-ac93-118f4dfc2dfa)

## Users Table
![image](https://github.com/user-attachments/assets/1d33bb3e-d591-4385-b949-e60e1c8ba833)



- **Query 1**: Users who have not logged in for the past 5 months.
- **Query 2**: Quarterly user and session counts with percent change.
- **Query 3**: Users who logged in January 2024 but not in November 2023.
- **Query 4**: Percent change in session counts compared to the previous quarter.
- **Query 5**: Highest session score for each day.
- **Query 6**: Users who logged in every day since their first login.
- **Query 7**: Dates with no logins.

- ## Key Concepts
- **Recursive Common Table Expressions (CTEs)** to generate date ranges.
- **Joins** and filtering techniques to analyze user behavior.
- **Window functions** for rank and lag operations.

