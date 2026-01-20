CREATE TABLE transactions (
    transaction_id INT,
    transaction_date DATE,
    description TEXT,
    category TEXT,
    amount NUMERIC,
    transaction_type VARCHAR(10)
);

SELECT * FROM transactions;

SELECT COUNT(*) 
FROM transactions;

SELECT *
FROM transactions
LIMIT 10;

SELECT DISTINCT transaction_type FROM transactions;

SELECT DISTINCT category FROM transactions;


--DATA CLEANING
--TABLE STRUCTURE
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'transactions';

--CHECK FOR MISSING VALUES
SELECT
    COUNT(*) FILTER (WHERE transaction_date IS NULL) AS missing_dates,
    COUNT(*) FILTER (WHERE category IS NULL) AS missing_categories,
    COUNT(*) FILTER (WHERE amount IS NULL) AS missing_amounts,
    COUNT(*) FILTER (WHERE transaction_type IS NULL) AS missing_types
FROM transactions;

--VALIDATING TRANSACTION TYPES
SELECT transaction_type, COUNT(*)
FROM transactions
GROUP BY transaction_type;

--VALIDATING AMOUNT LOGIC
SELECT *
FROM transactions
WHERE amount <= 0;

--CATERGORY CONSISTENCY
SELECT category, COUNT(*)
FROM transactions
GROUP BY category
ORDER BY COUNT(*) DESC;

--SQL METRICS
--MONTHLY INCOME AND EXPENSES
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS total_expense
FROM transactions
GROUP BY month
ORDER BY month;

--MONTHLY SAVING
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(
        CASE 
            WHEN transaction_type = 'Income' THEN amount
            ELSE -amount
        END
    ) AS savings
FROM transactions
GROUP BY month
ORDER BY month;

--SPENDING BY CATEGORY
SELECT
    category,
    SUM(amount) AS total_spent
FROM transactions
WHERE transaction_type = 'Expense'
GROUP BY category
ORDER BY total_spent DESC;

--CREATE MONTHLY INCOME AND EXPENSE VIEW
CREATE VIEW monthly_income_expense AS
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN transaction_type = 'Expense' THEN amount ELSE 0 END) AS total_expense
FROM transactions
GROUP BY month;

SELECT * FROM monthly_income_expense;

--CREATE MONTHLY SAVING VIEW
CREATE VIEW monthly_savings AS
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE -amount END) AS savings
FROM transactions
GROUP BY month;

SELECT * FROM monthly_savings;

--CATERGORY SPENDING VIEW
CREATE VIEW category_spending AS
SELECT
    category,
    SUM(amount) AS total_spent
FROM transactions
WHERE transaction_type = 'Expense'
GROUP BY category;

SELECT * FROM category_spending;

SELECT
    SUM(total_income) - SUM(total_expense) AS calculated_savings
FROM monthly_income_expense;

SELECT
    SUM(savings)
FROM monthly_savings;



SELECT * FROM monthly_income_expense;

SELECT * FROM monthly_savings;

SELECT * FROM category_spending;



