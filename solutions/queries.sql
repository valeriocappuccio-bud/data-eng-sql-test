--- These answers are not necessarily the only good answers

-- How much has been spent in total for merchant 'bud'?
SELECT
    merchant_name,
    SUM(amount) AS spent
FROM transactions JOIN merchants USING (merchant_id)
WHERE merchant_name = 'bud'
GROUP BY merchant_name
;

-- How much does each merchant bring in per day?
SELECT
    DATE(occurred_at),
    merchant_name,
    SUM(amount) AS spent
FROM transactions JOIN merchants USING (merchant_id)
GROUP BY DATE(occurred_at), merchant_name
ORDER BY date, merchant_name
;

-- How many merchants have a spend of over £20 for each day in the last year?
SELECT
    DATE(occurred_at),
    merchant_name,
    SUM(amount) AS spent
FROM transactions JOIN merchants USING (merchant_id)
WHERE DATE(occurred_at) > DATE(NOW() - INTERVAL '1 year')
GROUP BY merchant_name, DATE(occurred_at)
HAVING SUM(amount) > 20;

-- What are the top 5 industries that people spend the most money in?
SELECT industry, SUM(amount) spent
FROM transactions JOIN merchants USING (merchant_id)
GROUP BY industry
ORDER BY spent DESC
LIMIT 5;

-- What indexes would you think about adding to these tables?
-- probably not essential because automatially created since primary key
CREATE INDEX IF NOT EXISTS idx_transactions_transaction_id ON transactions (transaction_id);
-- for simplicity we assumed all transactions are GBP but if they were not, we would want to filter
CREATE INDEX IF NOT EXISTS idx_transactions_currency ON transactions USING hash (currency);
-- we might often query a specific time period
CREATE INDEX IF NOT EXISTS idx_transactions_occurred_at ON transactions (occurred_at);

-- how to specify which type of index?
-- because we make a frequent joint on that
CREATE INDEX IF NOT EXISTS idx_merchants_merchant_id ON merchants (merchant_id);
-- because we often want to filter by merchant name
CREATE INDEX IF NOT EXISTS idx_merchants_merchant_name ON merchants USING hash (merchant_name);

-- ADDED
-- All transactions done with the merchant_id with the biggest spent?
SELECT t.*
FROM transactions t
INNER JOIN (
	SELECT merchant_id, SUM(amount) spent
	FROM transactions
	GROUP BY merchant_id
	ORDER BY spent DESC
	LIMIT 1
) x USING (merchant_id);

-- the following is an alternative (less elegant solution); I was just curious whether would work
SELECT s.*
FROM
(
	SELECT
		*, SUM(amount) OVER(PARTITION BY merchant_id) AS tot_merch
	FROM transactions
) s
WHERE s.tot_merch = (
    SELECT MAX(sum) FROM (
        SELECT SUM(amount)
        FROM transactions
        GROUP BY merchant_id
    ) x
);

-- For each merchant, rank people by how much they spent for that merchant
SELECT
    merchant_name, customer_id,
    RANK() OVER (PARTITION BY merchant_name ORDER BY SUM(amount) DESC)
FROM transactions JOIN merchants USING (merchant_id)
GROUP BY merchant_name, customer_id
;

-- Rank each merchant by person and return them sorted (with a column for rank) by those who spent the most for all merchants.
SELECT
    customer_id, merchant_name,
    RANK() OVER (PARTITION BY customer_id ORDER BY SUM(amount) DESC),
    SUM(amount)
FROM transactions JOIN merchants USING (merchant_id)
GROUP BY merchant_name, customer_id
;
