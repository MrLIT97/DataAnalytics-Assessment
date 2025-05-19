/* Question 4
For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, Query to calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest
*/

-- Rank user accounts for customers with multiple user accounts
WITH ranked_users AS (
						SELECT 
							CONCAT(u.first_name, ' ', u.last_name) AS name,
							u.id,
							u.created_on,
							ROW_NUMBER() OVER (PARTITION BY CONCAT(first_name, ' ', last_name) ORDER BY created_on DESC) AS rn
							FROM users_customuser u
							INNER JOIN plans_plan p
									ON u.id = p.owner_id
							where u.is_active = 1 AND is_a_fund = 1 or is_regular_savings = 1
), -- CTE to extract active accounts with either of savings plan and investments plan and rank

latest_accounts AS (
						SELECT name, id AS latest_id
						FROM ranked_users
						WHERE rn = 1
), -- CTE to assign the latest user id to customer

transactions AS (
						SELECT owner_id, count(savings_id) as total_transactions, sum(amount) as total_amount
						FROM savings_savingsaccount
						GROUP BY owner_id
), -- CTE to collect transactions by customers

tenure AS (
						SELECT 	id, 
								CONCAT(first_name, ' ', last_name) AS name,
								CASE 
									WHEN proposed_deletion_date IS NULL THEN TIMESTAMPDIFF(MONTH, date_joined, NOW())
									ELSE TIMESTAMPDIFF(MONTH, proposed_deletion_date, date_joined)
								END AS tenure_months
						FROM users_customuser
						GROUP BY id
) -- CTE to collect Customer tenures

SELECT MAX(c.latest_id) as id, 
		b.name, 
        MAX(b.tenure_months) AS tenure_months,
        SUM(a.total_transactions) AS total_transaction, 
		ROUND(SUM((a.total_transactions/b.tenure_months) * 12 * (0.1/100) * a.total_amount)/100, 2) as estimated_clv_₦
FROM tenure b
RIGHT JOIN transactions a
		ON a.owner_id = b.id
JOIN latest_accounts c
		ON c.name = b.name
GROUP BY name
ORDER BY name ASC, estimated_clv_₦ DESC



