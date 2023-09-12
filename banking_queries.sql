/*
Fake Banking Relational Database
Example Queries
Liam O'Neill
*/

-- Aggregate customer deposit account information across multiple tables.

SELECT c.cust_ID, b.branch_name, d.account_number, a.balance
FROM customer AS c JOIN depositor AS d USING(cust_ID)
JOIN account AS a USING(account_number)
JOIN branch AS b USING(branch_name);

-- Customers who are both depositors and borrowers. Displaying their customer ID, bank account number, and loan number

SELECT c.cust_ID, d.account_number, b.loan_number
FROM customer AS c JOIN depositor AS d USING(cust_ID)
JOIN borrower AS b USING(cust_ID);

-- Which customers have a deposit account in the same city that they live?

SELECT a.account_number, d.cust_id, (SELECT branch_city FROM branch AS b
                                    WHERE b.branch_name = a.branch_name),
(SELECT customer_city FROM customer AS c WHERE c.cust_id = d.cust_id) 
FROM account AS a JOIN depositor AS d USING(account_number)
WHERE a.branch_name IN (SELECT b.branch_name FROM branch AS b WHERE b.branch_city IN 
                        (SELECT c.customer_city FROM customer AS c WHERE c.cust_id =
                        d.cust_id));

-- Which customers have at least one loan, but no bank account?

SELECT c.cust_id, c.customer_name FROM customer AS c
WHERE c.cust_id IN (SELECT b.cust_id FROM borrower AS b WHERE b.cust_id = c.cust_id)
AND c.cust_id NOT IN (SELECT d.cust_id FROM depositor AS d WHERE d.cust_id = c.cust_id);

-- Find the customer who has 3 separate deposit accounts at the Milcroft branch.

SELECT c.customer_name FROM customer AS c
JOIN depositor AS d USING(cust_id)
WHERE d.account_number IN (SELECT a.account_number FROM account AS a WHERE a.branch_name LIKE 'Milcroft')
GROUP BY c.customer_name
HAVING COUNT(c.customer_name) = 3;

-- Find all customers who have a loan at the Headon Forest branch.

SELECT c.customer_name, (SELECT branch_name FROM loan AS l WHERE l.loan_number = b.loan_number)
FROM customer AS c JOIN borrower AS b USING(cust_id)
WHERE b.loan_number IN (SELECT l.loan_number FROM loan AS l WHERE l.branch_name =
                        'Headon Forest');

-- Which customers have loans larger than $200,000?

SELECT c.customer_name, b.loan_number FROM customer AS c JOIN borrower AS b USING(cust_id)
WHERE b.loan_number IN (SELECT l.loan_number FROM loan AS l WHERE l.amount::numeric
                        > 200000.00);
