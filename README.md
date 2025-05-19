# DataAnalytics-Assessment

*Question 1:*
## 1. High-Value Customers with Multiple Products

*Scenario:* The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

### Tables:
- users_customuser
- savings_savingsaccount
- plans_plan

*Answer:*
In approaching this question, I assessed the data for its quality, during which I discovered that customers have multiple user accounts with distinct user ids. With this knowledge, I approached this question by grouping and assigning latest id to each user to avoid duplication of records

## 2. Transaction Frequency Analysis

*Scenario:* The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).

*Task:* Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)

Answer:
To answer this, I categorised

