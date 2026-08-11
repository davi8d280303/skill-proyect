-- dialect: PostgreSQL; schema: accounts(id indexed, email indexed, status indexed)
SELECT id, email
FROM accounts
WHERE status = 'active'
ORDER BY id
LIMIT 100;

UPDATE accounts
SET last_login_at = CURRENT_TIMESTAMP
WHERE id = :account_id;

CREATE TABLE invoices (
  invoice_id BIGINT PRIMARY KEY,
  total_amount DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP NOT NULL
);
