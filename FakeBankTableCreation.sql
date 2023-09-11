/*
Fake Banking Relational Database
Table Creation and Data Import
Liam O'Neill
*/

--- Table Creation

CREATE TABLE branch (
    branch_name VARCHAR(40) CONSTRAINT branch_key PRIMARY KEY,
    branch_city VARCHAR(40) CHECK (branch_city IN ('Burlington')),
    assets MONEY
);

CREATE TABLE customer (
    cust_ID INT CONSTRAINT customer_key PRIMARY KEY,
    customer_name VARCHAR(40) NOT NULL,
    customer_street VARCHAR(40),
    customer_city VARCHAR(40)
);

CREATE TABLE loan (
    loan_number VARCHAR(40) CONSTRAINT loan_key PRIMARY KEY,
    branch_name VARCHAR(40) REFERENCES branch (branch_name) ON DELETE CASCADE ON UPDATE CASCADE,
    amount MONEY DEFAULT '0.00'
);

CREATE TABLE borrower (
    cust_ID INT REFERENCES customer (cust_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    loan_number VARCHAR(40) REFERENCES loan (loan_number) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT borrower_key PRIMARY KEY (cust_ID, loan_number) 
);

CREATE TABLE account (
    account_number INT CONSTRAINT account_key PRIMARY KEY,
    branch_name VARCHAR(40) REFERENCES branch (branch_name) ON DELETE CASCADE ON UPDATE CASCADE,
    balance MONEY NOT NULL
);

CREATE TABLE depositor (
    cust_ID INT REFERENCES customer (cust_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    account_number INT REFERENCES account (account_number) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT depositor_key PRIMARY KEY (cust_ID, account_number)
);

--- Load Data from CSV Files

COPY branch
FROM 'C:\Users\Public\branches.csv'
WITH (FORMAT CSV, HEADER, NULL "null");

COPY customer
FROM 'C:\Users\Public\customers.csv'
WITH (FORMAT CSV, HEADER, NULL "null");

COPY loan
FROM 'C:\Users\Public\loans.csv'
WITH (FORMAT CSV, HEADER, NULL "null");

COPY borrower
FROM 'C:\Users\Public\borrowers.csv'
WITH (FORMAT CSV, HEADER, NULL "null");

COPY account
FROM 'C:\Users\Public\accounts.csv'
WITH (FORMAT CSV, HEADER, NULL "null");

COPY depositor
FROM 'C:\Users\Public\depositors.csv'
WITH (FORMAT CSV, HEADER, NULL "null");