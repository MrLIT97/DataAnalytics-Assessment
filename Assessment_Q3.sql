/* Question 3:
Query to find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).
*/

WITH active_accounts AS (
						SELECT p.*, 
							CASE WHEN is_a_fund = 1 THEN 'Investment'
								ELSE 'Savings'
							END AS type
						FROM adashi_staging.plans_plan p
						INNER JOIN users_customuser u
								ON u.id = p.owner_id
						WHERE u.is_active = 1 AND is_a_fund = 1 OR is_regular_savings = 1
), -- CTE to collect active accounts

no_transactions AS (
					SELECT owner_id, 
							MAX(transaction_date) AS last_transaction_date, 
							DATEDIFF(DATE(NOW()), MAX(transaction_date)) AS inactivity_days
					FROM (
						SELECT owner_id, 
								transaction_date
						FROM savings_savingsaccount
						WHERE DATEDIFF(DATE(NOW()), transaction_date) > 365
						) d
					GROUP BY owner_id
) -- CTE to collect accounts inactivity

SELECT a.id AS plan_id, 
		a.owner_id, 
        a.type, 
        n.last_transaction_date, 
        n.inactivity_days
FROM active_accounts a
INNER JOIN no_transactions n
		ON a.owner_id = n.owner_id