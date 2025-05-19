# Cowrywise Data Analytics Assessment

This Readme file includes pre-question explanations, explaining my approach to each question, as well as the challenges faced.

## Question 1
### Query to find customers with atleast one funded savings plan and one funded investment plan, sorted by total deposits.
### Explanation: 
The output features the following columns:
- Owner_id 
- Name (Concatenates the first and last names)
- Investment_count (Count the number of customers with an investment plan, considering investment plans are represented by 'is_a_plan = 1'
- Savings_count (Count the number of customers with a savings plan, considering savings plans are represented by 'is_regular_savings = 1')
- Total_deposit (Sums up each customer's total inflows)

The columns were selected or calculated from three different columns and all combined with an INNER JOIN to highlight customers with atleast one savings and investment plan (investment and savings count > 0)

### Challenges:
Calculating the total_deposit and joining it directly with the other columns created inaccurate results for the investment and savings count. As such, a subquery within the second JOIN statement was used to calculate the total deposit for each customer without altering the savings and investment counts.


## Question 2
### Calculate the average number of transactions per customer per month and categorize them.
### Explanation:
The output features the following columns:
- Owner_id
- name_email (Concatenates the first and last name, or uses customer email when the name is NULL)
- Total_transactions (Calculates the number of transactions for each customer by counting their unique transaction dates)
- Total_months (Counting the months between the first and last transaction for each customer)
- Avg_transactions_per_month (Dividing the total transactions by the total months)
- Frequency_category

Each transaction_date specifies a new transaction, so counting each unique transaction date provides the number of transactions for each customer. Similarly, the transaction date is also formatted as year and month, and each distinct value is counted to get the total months. Finally, the average_transaction_per_month is calculated and grouped as low, medium, or high frequency.

### Challenges:
Some customers did not have a first or last name. I used the customer's email in these cases for easier identification


## Question 3
### Find all active accounts (savings or investments) with no transactions in the last year
### Explanation:
The output features the following column:
- Plan_id
- Owner_id
- Account_type
- Last_transaction_date
- Inactivity_days

First, the account type was grouped based on the type; savings for is_regular_savings = 1, Investments for is_a_fund = 1, and Others for accounts that are neither savings or investments, is_regular_savings = is_a_fund = 0.
Next, the inactive days was obtained by subtracting the last transaction date from the current date. Finally, the output was filtered for only inactive days > 365 days

### Challenges:
Highlighting only active customers. For this challenge, the data was also JOINED to the customer table to filter out customers that are inactive (is_account_deleted = is_account_disabled = 1)


## Question 4
### Obtain the account tenure, total transactions, and estimated CLV for each customer.
### Explanation:
The output featured the following columns:

- Customer_id
- Name
- Tenure_months (Format by month and get the date difference between when date_joined and current date)
- Total_transactions
- Estimated_clv

Given that profit per transaction is 0.1 percent of transaction value, each customer's transaction was summed together (total_transaction), then profit per transaction was calculated from the sum (0.1 percent of the total_transaction). With the profit per transaction for each customer, the avg_profit_per_transaction is calculated by dividing it by the number of transactions. 
With the avg_profit_per_transaction, the estimated clv is calculated.


