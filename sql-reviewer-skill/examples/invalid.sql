DELETE FROM accounts;
DROP TABLE accounts;
SELECT * FROM accounts;
SELECT id FROM accounts;
UPDATE accounts SET status = 'active' WHERE email = NULL;
SELECT * FROM users u CROSS JOIN roles r;
SELECT id FROM users WHERE LOWER(email) = 'x@example.com';
CREATE TABLE payments (payment_id INT, amount FLOAT, customerName VARCHAR(40), customer_name VARCHAR(40));
-- application code: 'SELECT * FROM users WHERE id = ' + user_input
