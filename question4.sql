SELECT 
	DISTINCT sa.owner_id AS customer_id,
    CONCAT(
		UPPER(LEFT(uc.first_name, 1)), LOWER(SUBSTRING(uc.first_name, 2)), ' ',           #CONCATENATES THE FIRST AND LAST NAMES, AND CAPITALIZES THE FIRST LETTERS
        UPPER(LEFT(uc.last_name, 1)), LOWER(SUBSTRING(uc.last_name, 2)) 
	)AS name,
	TIMESTAMPDIFF(MONTH, uc.date_joined, NOW()) AS tenure_months,       #CALCULATES MONTHS SINCE DATE JOINED TO CURRENT DATE
	COUNT(sa.transaction_date) AS total_transactions, 
    
	# ROUND(SUM(sa.confirmed_amount*0.001), 2) AS total_profit_per_transaction -----------CALCULATES AND SUMS EACH CUSTOMER'S PROFIT PER TRANSACTION FOR ALL TRANSACTIONS
	# ROUND(SUM(sa.confirmed_amount*0.001)/COUNT(sa.transaction_date), 2) AS average_profit_per_transaction   -----------CALCULATES THE AVERAGE_PROFIT_PER_TRANSACTION BY DIVIDING TOTAL PROFIT PER TRANSACTION BY TOTAL TRANSACTIONS
	
    ROUND(((COUNT(sa.transaction_date)/TIMESTAMPDIFF(MONTH, uc.date_joined, NOW()))*12*(ROUND(SUM(sa.confirmed_amount*0.001)/COUNT(sa.transaction_date), 2))), 2) AS estimated_clv     #CALCULATES ESTIMATED CLV BASED ON FORMULA (CLV*12*AVERAGE_PROFIT_PER_TRANSACTION)
FROM savings_savingsaccount AS sa
INNER JOIN users_customuser AS uc ON sa.owner_id = uc.id
GROUP BY customer_id
ORDER BY estimated_clv DESC
