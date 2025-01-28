-- Kafka table to consume messages from Kafka topic
CREATE TABLE raw_kafka
(
    payload String
)
ENGINE = Kafka
SETTINGS kafka_broker_list = 'kafka:9092',
         kafka_topic_list = 'postgres_server.public.transactions',
         kafka_group_name = 'clickhouse_consumer',
         kafka_format = 'JSONEachRow';

CREATE TABLE kafka_transactions
(
    id UInt64,
    user_id UInt32,
    amount Float64,
    status String,
    updated_at DateTime
)
ENGINE = MergeTree()
ORDER BY (id, user_id);

CREATE MATERIALIZED VIEW kafka_transactions_mv TO kafka_transactions AS
SELECT
    JSONExtractInt(payload, 'after', 'id') AS id,
    JSONExtractInt(payload, 'after', 'user_id') AS user_id,
    JSONExtractString(payload, 'after', 'amount') AS amount,
    JSONExtractString(payload, 'after', 'status') AS status,
    toDateTime64(JSONExtractInt(payload, 'after', 'updated_at') / 1000000, 6) AS updated_at
FROM raw_kafka;

-- AggregatingMergeTree table for pre-aggregated data
CREATE TABLE user_aggregates
(
    user_id UInt32,
    total_amount AggregateFunction(sum, Float64),
    count_events AggregateFunction(count),
    last_update DateTime
)
ENGINE = AggregatingMergeTree()
PARTITION BY toYYYYMM(last_update)
ORDER BY (user_id);

-- Materialized View to populate AggregatingMergeTree
CREATE MATERIALIZED VIEW user_aggregates_mv
TO user_aggregates
AS
SELECT
    user_id,
    sumState(amount) AS total_amount,
    countState() AS count_events,
    max(updated_at) AS last_update
FROM kafka_transactions
GROUP BY user_id;
