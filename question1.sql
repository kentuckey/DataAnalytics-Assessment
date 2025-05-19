SELECT 
	pp.owner_id, 
    CONCAT(                                                                                        #CONCATENATES THE FIRST AND LAST NAMES, AND CAPITALIZES THE FIRST LETTERS
		UPPER(LEFT(uc.first_name, 1)), LOWER(SUBSTRING(uc.first_name, 2)), ' ', 
        UPPER(LEFT(uc.last_name, 1)), LOWER(SUBSTRING(uc.last_name, 2)) 
	)AS name,
    SUM(pp.is_a_fund) AS investment_count, 
    SUM(pp.is_regular_savings) AS savings_count,
    sa.total_deposit
FROM plans_plan AS pp
INNER JOIN users_customuser AS uc ON pp.owner_id = uc.id
INNER JOIN(
	SELECT owner_id, SUM(confirmed_amount) AS total_deposit
    FROM savings_savingsaccount AS sa
    GROUP BY owner_id
) sa ON pp.owner_id = sa.owner_id
GROUP BY pp.owner_id, name
HAVING SUM(is_a_fund) > 0 AND SUM(is_regular_savings) > 0 
ORDER BY total_deposit DESC;