## Question 1. High-Value Customers with Multiple Products

*Scenario:* The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

**Answer:**
In approaching this question, I assessed the data for its quality, during which I discovered that customers have multiple user accounts with distinct user ids. With this knowledge, I approached this question by grouping and assigning latest id to each user to avoid duplication of records

![FAQ1](https://github.com/user-attachments/assets/4562a8b3-a8a4-439d-ae23-e0feda08bc10)

## Question 2. Transaction Frequency Analysis

*Scenario:* The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).

*Task:* Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)

**Answer:**
To answer this, I categorised customers frequency based on monthly transactions by getting average monthly transaction for active users and counting distinct user name instead of id to avoid customer duplication

![FAQ2](https://github.com/user-attachments/assets/68591159-c925-4d58-b1df-33ba0e4a5b2a)

## Question 3. Account Inactivity Alert

*Scenario:* The ops team wants to flag accounts with no inflow transactions for over one year.

*Task:* Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .

**Answer:**
To solve the problem, I collected active users, created a column to specify plan type, filtered to transactions that are greater that 365 from current day and then a logic to calculate inactivity days as the number of days from the last transaction made.

![FAQ3](https://github.com/user-attachments/assets/24fbe0b9-e86f-42be-963b-f0c864cd76d9)

## Question 4. Customer Lifetime Value (CLV) Estimation
*Scenario:* Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).

*Task:* For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
- Account tenure (months since signup)
- Total transactions
- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
- Order by estimated CLV from highest to lowest

**Answer:**
I assigned latest id to users, collected customers tenure as number of months between present date and date customer joined for customers with active account, and number of months between deletion date and date customer joined for customers with deleted account. By applying the logic given for estimated clv, I solved the problem as required.

![FAQ4](https://github.com/user-attachments/assets/41af3afa-cc8d-454c-94e3-482231b70de9)
