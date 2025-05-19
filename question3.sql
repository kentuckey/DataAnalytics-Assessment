SELECT 
	sa.plan_id, 
	sa.owner_id, 
	CASE
		WHEN pp.is_regular_savings = 1 THEN 'Savings'                      #GROUPING CUSTOMER ACCOUNTS
		WHEN pp.is_a_fund = 1 THEN 'Investment'
		ELSE 'Others'
	END AS account_type,
	MAX(sa.transaction_date) AS last_transaction_date,
	DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days       #CALCULATES NUMBER OF DAYS FROM LAST TRANSACTION TO CURRENT DATE
FROM savings_savingsaccount AS sa
INNER JOIN plans_plan AS pp ON sa.plan_id = pp.id
INNER JOIN users_customuser AS uc ON sa.owner_id = uc.id
WHERE uc.is_account_deleted = 0 AND uc.is_account_disabled = 0
GROUP BY sa.plan_id, sa.owner_id
HAVING DATEDIFF(CURDATE(), MAX(transaction_date)) > 365                    #SPECIFIES ONLY INACTIVE DAYS GREATER THAN A YEAR
ORDER BY inactivity_days DESC