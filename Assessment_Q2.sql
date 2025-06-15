/* Question 2
Query to Calculate the average number of transactions per customer per month and categorize them:
		"High Frequency" (≥10 transactions/month)
		"Medium Frequency" (3-9 transactions/month)
		"Low Frequency" (≤2 transactions/month)
*/

-- Categorise Customers Frequency based on monthly transactions
WITH frequency AS (
		SELECT owner_id, 
			name, 
			Monthly_avg,
			CASE 
				WHEN Monthly_avg >= 10 THEN 'High Frequency'
				WHEN Monthly_avg >= 3 AND Monthly_avg <=9 THEN 'Medium Frequency'
				WHEN Monthly_avg <= 2 THEN 'Low Frequency'
		        ELSE 'Unspecified Frequency'
			END AS frequency_category
FROM (
		SELECT owner_id, 
			name, 
			count(*)/count(distinct transaction_month_year) AS Monthly_avg
		FROM (
			SELECT owner_id, 
				CONCAT(u.first_name, ' ', u.last_name) AS name, 
				CONCAT(MONTH(transaction_date), ',', YEAR(transaction_date)) AS transaction_month_year, 
				YEAR(transaction_date) AS transaction_year
			FROM savings_savingsaccount s
			INNER JOIN users_customuser u
				ON u.id = s.owner_id
			WHERE u.is_active = 1
) s GROUP BY owner_id, name -- Get Average monthly transactions for active customer
) a
)

SELECT frequency_category, 
	COUNT(DISTINCT name) AS customer_count, -- Count Distinct name instead of id to avoid customer duplication
        AVG(Monthly_avg) AS avg_transactions_per_month
FROM frequency
GROUP BY frequency_category;
