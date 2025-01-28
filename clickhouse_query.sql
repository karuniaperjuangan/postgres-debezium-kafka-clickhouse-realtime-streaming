SELECT
    user_id,
    SUM(amount) AS total_amount,
    COUNT(*) AS transaction_count
FROM kafka_transactions
WHERE status = 'completed'
GROUP BY user_id
ORDER BY total_amount DESC;

SELECT
    user_id,
    sumMerge(total_amount) AS total_amount,
    countMerge(count_events) AS count_events
FROM user_aggregates ua 
GROUP BY user_id