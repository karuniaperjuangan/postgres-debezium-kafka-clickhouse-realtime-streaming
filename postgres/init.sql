-- Initialize the database with a sample table
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample index for faster queries
CREATE INDEX idx_updated_at ON transactions (updated_at);
