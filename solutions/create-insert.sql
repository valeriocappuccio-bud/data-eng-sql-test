-- Design a database schema that handles the following data.
-- * Merchants: this is a table of companies that you might buy goods from either online or in person
-- * Transactions: this is a list of credit card transactions for people from the past year

-- create tables
DROP TABLE IF EXISTS merchants;
CREATE TABLE IF NOT EXISTS merchants (
  merchant_id SERIAL PRIMARY KEY,
  merchant_name VARCHAR(255) NOT NULL,
  merchant_url TEXT
);

TRUNCATE merchants CASCADE;
INSERT INTO
  merchants(merchant_id, merchant_name, merchant_url)
VALUES
  (1, 'sony', 'https://www.sony.com'),
  (2, 'apple', 'https://www.apple.com'),
  (3, 'bud', 'https://www.bud.com'),
  (4, 'tesla', 'https://www.tesla.com'),
  (5, 'microsoft', 'https://www.microsoft.com');
SELECT * FROM merchants;

--insert data
DROP TABLE IF EXISTS transactions;
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    merchant_id INT REFERENCES merchants (merchant_id) NOT NULL,
    amount DECIMAL(19, 4) NOT NULL,
    currency VARCHAR(3) DEFAULT 'GBP',
    occurred_at TIMESTAMP default now() - random()*(interval '7 days'),
    description VARCHAR(255)
  );

TRUNCATE transactions;
INSERT INTO
  transactions(customer_id, merchant_id, amount)
VALUES
    ('john', 1, 10),
    ('john', 2, 10),
    ('john', 2, 10),
    ('john', 3, 10),
    ('john', 3, 10),
    ('john', 3, 10),
    ('john', 4, 15),
    ('john', 5, 15),

    ('matt', 1, 20),
    ('matt', 2, 20),
    ('matt', 2, 20),
    ('matt', 3, 20),
    ('matt', 3, 20),
    ('matt', 3, 20),
    ('matt', 4, 25),
    ('matt', 5, 25),

    ('eddy', 1, 30),
    ('eddy', 2, 30),
    ('eddy', 2, 30),
    ('eddy', 3, 30),
    ('eddy', 3, 30),
    ('eddy', 3, 30),
    ('eddy', 4, 35),
    ('eddy', 5, 35)
;
SELECT * FROM transactions;

-- how woud you modify the table if you were to top 5 industries that people spend the most money in?
ALTER TABLE merchants ADD COLUMN IF NOT EXISTS industry varchar(255);
UPDATE merchants SET industry='green' WHERE merchant_id<3;
UPDATE merchants SET industry='blue' WHERE merchant_id>=3;
SELECT * FROM merchants;