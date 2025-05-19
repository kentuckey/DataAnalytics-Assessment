SELECT 
    sa.owner_id,
    CASE
		WHEN (uc.first_name = '' OR uc.first_name IS NULL                                    #USES CUSTOMER'S EMAIL WHEN THERE IS NO FIRST NAME AND LAST NAME
        AND uc.last_name = '' OR uc.last_name IS NULL) THEN uc.email                         
        ELSE CONCAT(                                                                         #CONCATENATES THE FIRST AND LAST NAMES, AND CAPITALIZES THE FIRST LETTERS
		UPPER(LEFT(uc.first_name, 1)), LOWER(SUBSTRING(uc.first_name, 2)), ' ', 
        UPPER(LEFT(uc.last_name, 1)), LOWER(SUBSTRING(uc.last_name, 2)) 
	) END AS name_email,
    COUNT(sa.transaction_date) AS total_transactions, 
    COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) AS total_months,               #COUNT THE NUMBER OF UNIQUE MONTHS IN WHICH TRANSACTIONS OCCURED
    ROUND(COUNT(sa.transaction_date) / COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')), 2) AS avg_transactions_per_month,             #AVERAGE TRANSACTION PER MONTH = TOTAL TRANSACTION/TOTAL MONTHS
    CASE
		WHEN COUNT(sa.transaction_date) / COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) >= 10 THEN 'High Frequency'
        WHEN COUNT(sa.transaction_date) / COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) <= 2 THEN 'Low Frequency'
        ELSE 'Medium Frequency'
	END AS frequency_category
FROM savings_savingsaccount AS sa
INNER JOIN users_customuser AS uc
ON uc.id = sa.owner_id
GROUP BY owner_id
ORDER BY name_email