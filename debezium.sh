if [ -f .env ]; then
    source .env
else
    echo ".env file not found."
fi

curl -X DELETE http://localhost:8083/connectors/postgres-connector

curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
  "name": "postgres-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "password",
    "database.dbname": "realtime_db",
    "database.server.name": "postgres_server",
    "table.include.list": "public.transactions",
    "plugin.name": "pgoutput",
    "decimal.handling.mode": "double",
    "slot.name": "debezium_slot",
    "publication.name": "debezium_publication",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "topic.prefix": "postgres_server"
  }
}'
