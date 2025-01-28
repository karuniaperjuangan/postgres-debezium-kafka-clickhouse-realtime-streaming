import psycopg2
import random
import time
from datetime import datetime

# Database connection
conn = psycopg2.connect(
    dbname="realtime_db",
    user="postgres",
    password="password",
    host="localhost",
    port=5432
)
cursor = conn.cursor()

# Function to generate random data
def generate_random_data():
    user_id = random.randint(1, 100)
    amount = round(random.uniform(10, 500), 2)
    status = random.choice(["pending", "completed", "failed"])
    updated_at = datetime.now()
    return user_id, amount, status, updated_at

# Insert data in a loop
try:
    while True:
        user_id, amount, status, updated_at = generate_random_data()
        cursor.execute("""
            INSERT INTO transactions (user_id, amount, status, updated_at)
            VALUES (%s, %s, %s, %s)
        """, (user_id, amount, status, updated_at))
        conn.commit()
        print(f"Inserted: user_id={user_id}, amount={amount}, status={status}, updated_at={updated_at}")
        time.sleep(1)  # 1-second interval
except KeyboardInterrupt:
    print("Stopping data generation...")
finally:
    cursor.close()
    conn.close()
