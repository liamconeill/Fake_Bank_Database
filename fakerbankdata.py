from faker import Faker
import pandas as pd
import random

fake = Faker()

# Define custom lists for branch names
custom_branch_names = ['TD Headon Forest', 'RBC Headon Forest', 'BMO Milcroft', 'TD Milcroft', ' TD Mountainside',
                       'BMO Brant Hills', 'Tangerine Milcroft']

# Generate fake data for the "branch" table
def generate_branch_data(num_branches):
    data = []
    used_branch_names = set()
    while len(data) < num_branches:
        branch_name = random.choice(custom_branch_names)
        if branch_name not in used_branch_names:
            used_branch_names.add(branch_name)
            data.append({
                'branch_name': branch_name,
                'branch_city': 'Burlington',
                'assets': fake.random_int(min=1000000, max=10000000)
            })
    return pd.DataFrame(data)

# Define custom lists for city names
custom_city_names = ['Burlington', 'Hamilton', 'Oakville', 'Milton']

# Generate random and unique 6-digit customer IDs
def generate_unique_customer_ids(num_customers):
    unique_ids = random.sample(range(100000, 999999), num_customers)
    return unique_ids

# Generate fake data for the "customer" table
def generate_customer_data(num_customers):
    cust_ids = generate_unique_customer_ids(num_customers)
    data = []
    for cust_id in cust_ids:
        data.append({
            'cust_ID': cust_id,
            'customer_name': fake.unique.name(),
            'customer_street': fake.street_address(),
            'customer_city': random.choice(custom_city_names)
        })
    return pd.DataFrame(data)

# Generate random and unique 9-digit loan numbers
def generate_unique_loan_numbers(num_loans):
    unique_numbers = random.sample(range(100000000, 999999999), num_loans)
    return unique_numbers

# Generate fake data for the "loan" table
def generate_loan_data(num_loans, branches):
    loan_numbers = generate_unique_loan_numbers(num_loans)
    data = []
    for loan_number in loan_numbers:
        data.append({
            'loan_number': str(loan_number),
            'branch_name': random.choice(branches['branch_name']),
            'amount': fake.random_int(min=1000, max=100000)
        })
    return pd.DataFrame(data)

# Generate fake data for the "borrower" table
def generate_borrower_data(num_borrowers, customers, loans):
    data = []
    used_combinations = set()  # Keep track of used cust_ID and loan_number combinations
    while len(data) < num_borrowers:
        cust_id = random.choice(customers['cust_ID'])
        loan_number = random.choice(loans['loan_number'])
        combination = (cust_id, loan_number)
        if combination not in used_combinations:
            used_combinations.add(combination)
            data.append({
                'cust_ID': cust_id,
                'loan_number': loan_number
            })
    return pd.DataFrame(data)

# Generate random and unique 9-digit account numbers
def generate_unique_account_numbers(num_accounts):
    unique_numbers = random.sample(range(100000000, 999999999), num_accounts)
    return unique_numbers

# Generate fake data for the "account" table
def generate_account_data(num_accounts, branches):
    account_numbers = generate_unique_account_numbers(num_accounts)
    data = []
    for account_number in account_numbers:
        data.append({
            'account_number': account_number,
            'branch_name': random.choice(branches['branch_name']),
            'balance': fake.random_int(min=10, max=100000)
        })
    return pd.DataFrame(data)

# Generate fake data for the "depositor" table
def generate_depositor_data(num_depositors, customers, accounts):
    data = []
    used_combinations = set()  # Keep track of used cust_ID and account_number combinations
    while len(data) < num_depositors:
        cust_id = random.choice(customers['cust_ID'])
        account_number = random.choice(accounts['account_number'])
        combination = (cust_id, account_number)
        if combination not in used_combinations:
            used_combinations.add(combination)
            data.append({
                'cust_ID': cust_id,
                'account_number': account_number
            })
    return pd.DataFrame(data)

# Define the number of records you want for each table
num_branches = 7
num_customers = 250
num_loans = 175
num_borrowers = 175
num_accounts = 300
num_depositors = 300

# Generate data for each table
branches_data = generate_branch_data(num_branches)
customers_data = generate_customer_data(num_customers)
loans_data = generate_loan_data(num_loans, branches_data)
borrowers_data = generate_borrower_data(num_borrowers, customers_data, loans_data)
accounts_data = generate_account_data(num_accounts, branches_data)
depositors_data = generate_depositor_data(num_depositors, customers_data, accounts_data)

# Save the data to CSV files
branches_data.to_csv('branches.csv', index=False)
customers_data.to_csv('customers.csv', index=False)
loans_data.to_csv('loans.csv', index=False)
borrowers_data.to_csv('borrowers.csv', index=False)
accounts_data.to_csv('accounts.csv', index=False)
depositors_data.to_csv('depositors.csv', index=False)