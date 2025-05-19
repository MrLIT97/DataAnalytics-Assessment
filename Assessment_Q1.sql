/* Question 1
	A query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
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

savings AS (
    SELECT owner_id, COUNT(*) AS savings_count, SUM(amount) AS total_savings
    FROM savings_savingsaccount
    GROUP BY owner_id
), -- CTE to count savings accounts and total savings for users

investments AS (
    SELECT owner_id, COUNT(*) AS investment_count, SUM(amount) AS total_investments
    FROM plans_plan
    GROUP BY owner_id
), -- CTE to count investment accounts and total investment for users

user_accounts AS (
    SELECT 
        CONCAT(first_name, ' ', last_name) AS name,
        id
    FROM users_customuser
) -- CTE to extract user name 

SELECT 
    l.latest_id AS id,
    l.name,
    SUM(COALESCE(s.savings_count, 0)) AS savings_count,
    SUM(COALESCE(i.investment_count, 0)) AS investment_count,
    ROUND(SUM(COALESCE(s.total_savings, 0) + COALESCE(i.total_investments, 0))/100, 2) AS total_deposits_₦
FROM user_accounts u
LEFT JOIN savings s ON u.id = s.owner_id -- Join to get savings records
LEFT JOIN investments i ON u.id = i.owner_id -- Join to get investment records
INNER JOIN latest_accounts l ON l.name = u.name -- Join to get name and latest id
GROUP BY l.name, l.latest_id
HAVING savings_count > 0 AND investment_count > 0 -- Filter to ensure at least one savings plan and one investment plan
ORDER BY total_deposits_₦ DESC;
