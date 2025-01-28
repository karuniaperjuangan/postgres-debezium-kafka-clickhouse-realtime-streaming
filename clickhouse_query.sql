SELECT
    user_id,
    SUM(amount) AS total_amount,
    COUNT(*) AS transaction_count
FROM kafka_transactions
WHERE status = 'completed'
GROUP BY user_id
ORDER BY total_amount DESC;
